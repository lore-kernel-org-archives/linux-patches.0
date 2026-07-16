Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F6F42A172;
	Thu, 16 Jul 2026 13:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209842; cv=none; b=sir2pxBds+3BT47Pxtzwj7KIBORJ/GTlpLIEvF1AlfzLN5vkD+3HEs+vhTdZHnsG0y3K5uOIJA2zhcB4ielQdVPVTY6bYCHJQzofhhJbS3VpqbVQV5fbmqudmGDnyxZcf9Yz5tQTX0N2HMUQtfWyHJ2n30irgWZJNo8GpW7dVd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209842; c=relaxed/simple;
	bh=KV7cO7ly27NLTPrsA5aljKqKt/A8NbN6XQ4PgZDAybQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FF65J5tFFSPr5pSg7tgPIyr9RMKYSCwU+BEWDmgxZTqKZrn63z6ikCZjWTtbBT0BogbDKPMF6dgJVNoimbiA3SFpiGQFuI7QrGTY8sShtvwwwAlqFyS4S+mQ8dCy6/vajfR/7q0iYU99ne2KIjO9WXw0R1YoHw3eRr4FmhPibgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRDQ9dsu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRDQ9dsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF751F000E9;
	Thu, 16 Jul 2026 13:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209841;
	bh=bMr6/7MyArv04JdoujiP5GHGCFHk13PcTePf/LXedE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rRDQ9dsuwCDzWWBzuiw2x7S1A02/ZDKcj6+/6NyBCdusMd7cTY8a33VEdDcUUWXW5
	 UNL+AxHez1DXl60RgXYdH8teitIUJrA7SxpvJyLflOH+Ea6Gtr2Qw//csAYDMrnC7O
	 lFw70QUYFsR3cOdbDQa6wmqQENtYmr2OtySD9s6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Neill Kapron <nkapron@google.com>
Subject: [PATCH 7.1 338/518] usb: gadget: f_fs: Initialize epfile->in early to fix endpoint direction checks
Date: Thu, 16 Jul 2026 15:30:06 +0200
Message-ID: <20260716133055.208123874@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2367,6 +2367,7 @@ static int ffs_epfiles_create(struct ffs
 			sprintf(epfile->name, "ep%02x", ffs->eps_addrmap[i]);
 		else
 			sprintf(epfile->name, "ep%u", i);
+		epfile->in = (ffs->eps_addrmap[i] & USB_ENDPOINT_DIR_MASK) ? 1 : 0;
 		err = ffs_sb_create_file(ffs->sb, epfile->name,
 					 epfile, &ffs_epfile_operations);
 		if (err) {
@@ -2456,7 +2457,6 @@ static int ffs_func_eps_enable(struct ff
 		ret = usb_ep_enable(ep->ep);
 		if (!ret) {
 			epfile->ep = ep;
-			epfile->in = usb_endpoint_dir_in(ep->ep->desc);
 			epfile->isoc = usb_endpoint_xfer_isoc(ep->ep->desc);
 		} else {
 			break;


