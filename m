Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC2142BEBE;
	Thu, 16 Jul 2026 13:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209845; cv=none; b=IpNs7z/SpunLR6vdDFuOnnE95o5MpX4ZhHJzEfP8fRQu5PmWavxevEnwtDQf0RvUDNSglZWB0AnNJPGrEDp6BDmRIsH0mqoV+mhz5lJjGH/Ql/7JtCTceKIOLvekpMh/RLlA0R4JQVESjaAzcJ65un17CmKogEaEgfFm/iKaYPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209845; c=relaxed/simple;
	bh=fSet7o1ECWC91GgpluaXSWlDc1Kb+jp9wSOK7Lo+e00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ct1cFA96/VmgJgl1A0wgnuyZnk1Y0bwSfFeXOSU1eSuxfz/5HECA1s+Pnz5Av922kxMr41rLuqrMcaJBvYAD+amX7vc9+nRQAewTWI1PTSIaA6DqD6HUJHdxVI4VAq5TZ/CzC/ovG3z2DHnuwwBSbPUXRWj7Pnd0mP8nBUbBddc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kb1KlG8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kb1KlG8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F761F00A3A;
	Thu, 16 Jul 2026 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209844;
	bh=MnfTulu8CFve1iPPtNSck+kq3WHSvVaQeyP2SKJ7acU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kb1KlG8py1hHSDdxyaI9kCpqARBE2kGkApteVm3UqoQy9id5FPY47E9LqNLps4tm+
	 dTqdwGWuE61bkWJJOVqr5hQpJHRCmAcfDeW78mYhi4Btnlmt7vu5vnzVsYthZj7iFH
	 kz0Q6/QcU+J7x4Yl20ZJXMDmfBR5zfjAILCcCNUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Neill Kapron <nkapron@google.com>
Subject: [PATCH 7.1 339/518] usb: gadget: f_fs: Tie read_buffer lifetime to ffs_epfile
Date: Thu, 16 Jul 2026 15:30:07 +0200
Message-ID: <20260716133055.230028229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neill Kapron <nkapron@google.com>

commit 8bdcf96eb135aebacac319667f87db034fb38406 upstream.

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
---
 drivers/usb/gadget/function/f_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1375,7 +1375,6 @@ ffs_epfile_release(struct inode *inode,
 
 	mutex_unlock(&epfile->dmabufs_mutex);
 
-	__ffs_epfile_read_buffer_free(epfile);
 	ffs_data_closed(epfile->ffs);
 
 	return 0;
@@ -2393,6 +2392,7 @@ static void ffs_epfiles_destroy(struct s
 
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
+		__ffs_epfile_read_buffer_free(epfile);
 		simple_remove_by_name(root, epfile->name, clear_one);
 	}
 


