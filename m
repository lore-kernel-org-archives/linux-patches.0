Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55163B6C17;
	Tue, 21 Jul 2026 22:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672966; cv=none; b=tlLzEqWvMdDOHeqBfy8MSaXnCWtCl8CEQeLhuvUw6HHI4g5ZWGLnaEoKPWyHTfcUA+1/W9sgNT9pL+8kElhMmnGgYEZf0Zq/FfoUyVXGj6yLqCfNw1NrsyzgSH4et2S5YeXPchyhKtAgzMhvP4XiJxOj2DSAeEgLMFd39Eeo/Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672966; c=relaxed/simple;
	bh=1iMSnfdfwMh4yCwxN4sSC7o+ijqYp/LrnoB2WE9xK9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n672WcQOp/CQOg/Ddiav0KjgfYivX/+dbOpUTb35FvK8nqyQafDVrQkV3AsAoOLDGs//V/aoEBr/1WPC2khk/azPX5c5no6J8G7EIZX/FeDvbucxHNiBfsVIYXu1NU7Cr2yWlOXOPmYM9AXBGrHrbBxUfGgmoaIPyi6weJiAlY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haL7yuwo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haL7yuwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2745B1F000E9;
	Tue, 21 Jul 2026 22:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672965;
	bh=wq4iLn1d6qCVJd07OKJwSLAx7lTtPvwjY0pfB4GXKYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=haL7yuwom7Zfc9y+wQCm18W+BkQudUE4wDsExiarJY2f5+SAnrimLsoKrVEMpLxwH
	 HX6lCPU4VXIWF9gRFz8G+SlRPlC9IRMnKd7i87H44RNrmDiqkcMrFrPNTSo1n5X8HV
	 NdOMggagV5Cmr9NpwQj8/d0Yvkf5EA9KieTndPaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Neill Kapron <nkapron@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 825/843] usb: gadget: f_fs: Tie read_buffer lifetime to ffs_epfile
Date: Tue, 21 Jul 2026 17:27:40 +0200
Message-ID: <20260721152424.635659922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1292,7 +1292,6 @@ ffs_epfile_release(struct inode *inode,
 
 	ENTER();
 
-	__ffs_epfile_read_buffer_free(epfile);
 	ffs_data_closed(epfile->ffs);
 
 	return 0;
@@ -1957,6 +1956,7 @@ static void ffs_epfiles_destroy(struct f
 
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
+		__ffs_epfile_read_buffer_free(epfile);
 		if (epfile->dentry) {
 			d_delete(epfile->dentry);
 			dput(epfile->dentry);


