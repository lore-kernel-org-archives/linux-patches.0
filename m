Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFF338910F;
	Tue, 21 Jul 2026 18:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659604; cv=none; b=MRWyqTEn2EsxiwMyuoylIGP7cQ+kraUucTLTyTzlUmI4XRYFdZDe/3B5jZ1vwZ0/gSN6JxIAHqi1qJCqqTVl6hPXAXFs4GGBa/SBCZJCU4zAc2ouyrFNTWW1Gn2/gN/cdM+JZJ7kqEs7CIk6gYouuy3fEpusaKbjPoC51NS2AQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659604; c=relaxed/simple;
	bh=tTHCIJSI7bHjQ6jpA/31aysmlCmxh3Ch/0rD4E6GfYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uIdQaSfh5EknqcoA0GRW7dfJQyBYZY0WmERkjigU9Xuk3gqOxSc3fi0CIptQPIPlY9Ig659GNh/kQZXTO0+Ox7/hwpd8zxuse1c7IwKpa3TBf+xiicPpdp0CyJHFdtnIUZbjACHrYPKk1Sm+AF4Wbf7aSAsZnZqxDVlEegu65cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGg0YSLr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGg0YSLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53C31F000E9;
	Tue, 21 Jul 2026 18:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659603;
	bh=Emlq+awp+iJhu+uPDTiV5QAeqWpkOgv7i5yspK8Pots=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGg0YSLrZi3AquwKRq8gTj4utJTM8N/8R13iJrA2oQA06+EMXSglVNxxlfbPuHNop
	 0Ol7TUJMhMZy2tzYMVmYqbSdn76o0kdHnJbpvhvy3CSM86Cldv6hMj8k2wwIV29PVV
	 f8KztLv2C3KYKEbX2EQ+UUja3bmbU6g3RB/emMhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Neill Kapron <nkapron@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1584/1611] usb: gadget: f_fs: Tie read_buffer lifetime to ffs_epfile
Date: Tue, 21 Jul 2026 17:28:20 +0200
Message-ID: <20260721152551.100084953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neill Kapron <nkapron@google.com>

[ Upstream commit 8bdcf96eb135aebacac319667f87db034fb38406 ]

Currently, ffs_epfile_release unconditionally frees the endpoint's
read_buffer when a file descriptor is closed. If userspace explicitly
opens the endpoint multiple times and closes one, the read_buffer is
destroyed. This can lead to silent data loss if other file descriptors
are still actively reading from the endpoint.

By tying the lifetime of the read_buffer to the ffs_epfile structure itself
(which is destroyed when the functionfs instance is torn down in
ffs_epfiles_destroy), we eliminate the brittle dependency on open/release
calls while correctly matching the conceptual lifetime of unread data on
the hardware endpoint.

Fixes: 9353afbbfa7b ("usb: gadget: f_fs: buffer data from ‘oversized’ OUT requests")
Cc: stable <stable@kernel.org>
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Neill Kapron <nkapron@google.com>
Link: https://patch.msgid.link/20260619040609.4010746-3-nkapron@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1353,7 +1353,6 @@ ffs_epfile_release(struct inode *inode,
 
 	mutex_unlock(&epfile->dmabufs_mutex);
 
-	__ffs_epfile_read_buffer_free(epfile);
 	ffs_data_closed(epfile->ffs);
 
 	return 0;
@@ -2370,6 +2369,7 @@ static void ffs_epfiles_destroy(struct s
 
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
+		__ffs_epfile_read_buffer_free(epfile);
 		simple_remove_by_name(root, epfile->name, NULL);
 	}
 


