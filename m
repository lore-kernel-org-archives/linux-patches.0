Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A244342F719;
	Thu, 16 Jul 2026 14:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212495; cv=none; b=a0Wku4EIuypoxljExR2ZwHXheAaPVUN4NC3hqTzpt7qj7+6KCyZzqDAIcOHk7SbFFMAkkb4YLy0M1bdg4/Q4SjPC8TxdjU7n1Sj35VaKr0SI6HEK+LCKVrocXnpZw5rXO8ue6RMx/0bkRmm8ieup3g8wu8UGAwT1HO8HgxtA3aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212495; c=relaxed/simple;
	bh=+dBk2MROOkkRSBeYatVEFmJTFrXhKYhXg8svSctW3wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXOYu3oZ/pJocscPB68lKJqCnMwC6lXmZCwLLcJHqcpsZOzN+3MIPESLCypGOPDevnH9I/rmDW7xmhNUqqrcfOWdqqcsekekfDlNe48cqpBOeDqBYuQ6cKwKnWUWpgWPx8vsk5RkgrhJAuD1rvfzB5gvdgUf6E5VbZEHujgNEWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izFu1Fpg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izFu1Fpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150721F000E9;
	Thu, 16 Jul 2026 14:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212494;
	bh=JeIYn29MU0T0MBYzlPsLLHll432ZYr4StMKwt0XfnZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izFu1Fpgrrn+VcYqCx5NUH186WsFMnG2ur4UH3YsO7PEWLlwcgxsmcWIdcoe5qwtw
	 8/VCukWoh5jgSpby9YMtTS/WxyDNSpM8BS27NxvcqYjLJEaIccOYmjTNGA0Ltc38Qp
	 k6nxocmqAogIPoI108YkK7HawNu9tqvezz8tm6Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Neill Kapron <nkapron@google.com>
Subject: [PATCH 6.12 349/349] usb: gadget: f_fs: Initialize epfile->in early to fix endpoint direction checks
Date: Thu, 16 Jul 2026 15:34:43 +0200
Message-ID: <20260716133041.111909802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2364,6 +2364,7 @@ static int ffs_epfiles_create(struct ffs
 			sprintf(epfile->name, "ep%02x", ffs->eps_addrmap[i]);
 		else
 			sprintf(epfile->name, "ep%u", i);
+		epfile->in = (ffs->eps_addrmap[i] & USB_ENDPOINT_DIR_MASK) ? 1 : 0;
 		epfile->dentry = ffs_sb_create_file(ffs->sb, epfile->name,
 						 epfile,
 						 &ffs_epfile_operations);
@@ -2451,7 +2452,6 @@ static int ffs_func_eps_enable(struct ff
 		ret = usb_ep_enable(ep->ep);
 		if (!ret) {
 			epfile->ep = ep;
-			epfile->in = usb_endpoint_dir_in(ep->ep->desc);
 			epfile->isoc = usb_endpoint_xfer_isoc(ep->ep->desc);
 		} else {
 			break;


