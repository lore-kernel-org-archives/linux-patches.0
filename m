Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCF83161AD;
	Thu, 16 Jul 2026 14:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211565; cv=none; b=l/MK5bVbxFY7SqDQpRDFqtL9ReO7OWfT7Y1kqMAMTX8WdqDqf1BAydLr8PNQZ5uUlW8+Ae7FxLrXIMMkQc96Z1bLs+fv/g0mFdKMVVYi8Dh3EzP9662lr1uwYY1z5+qITDbyXEzFYMmG+qs70hYPet8Wdv8IWOT+uS22/OTnRMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211565; c=relaxed/simple;
	bh=Ii980Vpp7Eo2U6oBsHET7RIRbBpuwJ92xx9NdPxiMMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WF2YlXe+wXiq0JK3IedM83Mqmu9iutb0BdbyUFYUGG5Yo3YAM9VRT7+FfIzoLLN7pT+MVnfR1joBnbj0rmTuqhx3Xnl20NXAOAcnGAk1FsFVhBK7fRiYpg23+jzlyptlTeeVcjoTkPjPEzExsnMJlt5IApDxqVc9wLBvaOaZtjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1mOi8FH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1mOi8FH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B363E1F000E9;
	Thu, 16 Jul 2026 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211564;
	bh=/6e/beUcld7PnqpcZkDIlCG1WKQUPpN3e4yNrqmsoWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1mOi8FHrVfth3fCXnvAq9pOoJI5t5AM8FxBMsaV+Vv7ZKpDJ2bcdfbQ13VcyyGCr
	 k7nC3UUhtlA5yvJJ6fnP3arJ1/lpkKjLRjhrOkAxTMMxsMR7FfUjwG5xT7ZlLb9D1i
	 +hVCxtVG8mx5+rfpoXk3WNiZ5xYybfdqpPEQ66Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Neill Kapron <nkapron@google.com>
Subject: [PATCH 6.18 477/480] usb: gadget: f_fs: Initialize epfile->in early to fix endpoint direction checks
Date: Thu, 16 Jul 2026 15:33:44 +0200
Message-ID: <20260716133055.142920450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neill Kapron <nkapron@google.com>

commit 82cfd4739011bdc7e87b5d585703427e89ddfaa5 upstream.

When parsing endpoint descriptors, ffs_data_got_descs() generates the
eps_addrmap which contains the endpoint direction. However, epfile->in
was previously only populated in ffs_func_eps_enable() which executes
upon USB host connection. As a result, early userspace ioctls like
FUNCTIONFS_DMABUF_ATTACH that run before the host connects would see
epfile->in as 0, leading to incorrect DMA directions.

By moving the initialization to ffs_epfiles_create(), epfile->in is
accurate before userspace opens the endpoint files.

Fixes: 7b07a2a7ca02 ("usb: gadget: functionfs: Add DMABUF import interface")
Cc: stable <stable@kernel.org>
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Neill Kapron <nkapron@google.com>
Link: https://patch.msgid.link/20260619040609.4010746-2-nkapron@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2354,6 +2354,7 @@ static int ffs_epfiles_create(struct ffs
 			sprintf(epfile->name, "ep%02x", ffs->eps_addrmap[i]);
 		else
 			sprintf(epfile->name, "ep%u", i);
+		epfile->in = (ffs->eps_addrmap[i] & USB_ENDPOINT_DIR_MASK) ? 1 : 0;
 		epfile->dentry = ffs_sb_create_file(ffs->sb, epfile->name,
 						 epfile,
 						 &ffs_epfile_operations);
@@ -2440,7 +2441,6 @@ static int ffs_func_eps_enable(struct ff
 		ret = usb_ep_enable(ep->ep);
 		if (!ret) {
 			epfile->ep = ep;
-			epfile->in = usb_endpoint_dir_in(ep->ep->desc);
 			epfile->isoc = usb_endpoint_xfer_isoc(ep->ep->desc);
 		} else {
 			break;


