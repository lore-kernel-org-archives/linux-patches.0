Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D743E3DB4;
	Tue, 21 Jul 2026 20:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664472; cv=none; b=k+3b3/AuaKoGtHB52g6apR+Xk4kowf8/RDVGwzUzovBq9YGPY88jlpWKYbMwvvea1XIpj7NL/5CcAjsHOHNyT+SzoTPnTHacICWIqIRIRn0U/Xi2iyDxsY3VTc+CMrSsQRSHLsMWNh3m4ZZEknDatN9tad0BBBS9v2qjRLZ4/nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664472; c=relaxed/simple;
	bh=CDvFAcTH7z38zJ7eFabEjJXibkoX3yEsM7dekCJBzRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C9LGHZ6lhXcOS9KVEQvGj/lrUw5GABnDa81D4uZSpJPJ678SoilqRtdHpqRABf8hiRqSTPnAsbuIOf2na6UikLlWAtl3L34hEK6T9eOJzsJx+OWxCzApt7xFwKpm3zFm6XZsyMRmZFERGHM3VO3jtxUNdcOwBw/sUv/xOslSiAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rl0tD7UY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rl0tD7UY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2891F000E9;
	Tue, 21 Jul 2026 20:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664469;
	bh=iko77MF5G2oPxuUZBt24vuJ9JBRC/aDU6m+j0U/bqUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rl0tD7UYEGVeb/t1O5FjQknXt1jYekdc4AVoKz6J+kUIgnSao4+ISf83MAcve3xDJ
	 5q0HjnfkaP6YuDyO4hORysKPgx7nwrpCoe3mHwM2EqNqg1fIHjL9aCWPZAUbG5m566
	 ukv30HwWCSze0YgoSSNPBB6Ah+JD/Yzb2eMc279A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Neill Kapron <nkapron@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1213/1276] usb: gadget: f_fs: Tie read_buffer lifetime to ffs_epfile
Date: Tue, 21 Jul 2026 17:27:36 +0200
Message-ID: <20260721152513.213858370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ adjusted context in ffs_epfiles_destroy() since 6.12 lacks the simple_remove_by_name() rework and still uses dentry-based cleanup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1365,7 +1365,6 @@ ffs_epfile_release(struct inode *inode,
 
 	mutex_unlock(&epfile->dmabufs_mutex);
 
-	__ffs_epfile_read_buffer_free(epfile);
 	ffs_data_closed(epfile->ffs);
 
 	return 0;
@@ -2386,6 +2385,7 @@ static void ffs_epfiles_destroy(struct f
 
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
+		__ffs_epfile_read_buffer_free(epfile);
 		if (epfile->dentry) {
 			d_delete(epfile->dentry);
 			dput(epfile->dentry);


