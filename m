Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997CA3F20EA;
	Tue, 17 Mar 2026 16:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765998; cv=none; b=gasHKg244Nhk76jxezJMBstKn6JHvYbOcU+jDZ6rnSEJvkXRkiFukkoIDSejOYVU21rjDwgcyiKilSRgUEi4xbwB8ug/dX3whz/fC02FFhrAZY0G7L2l4GYmgpDAj+2rGryIVTSq2+/u8jZoVwSD/LXud8HuyeLWqH/5Av/0iy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765998; c=relaxed/simple;
	bh=3qGey2JqZsu30LFIzIse/O+QxZqX+NsyBin6oxJPkCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjXJ2cLunjRbNRcEOv2bXMnCO1XHFTfCKwr4sickwGDhj/B5QkVorUDt7IMTYhYf/s63zTWD4RwhdQ5DOxcgeBe34ieJR7OG6o1riaAr8mzkfzasUMduOo8MkFTKHq0nxox1hIl0UE+QoAc4oWNcwwvcKWcidcvFk1AHnGKC1mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGtf4aUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGtf4aUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4A1C4CEF7;
	Tue, 17 Mar 2026 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765998;
	bh=3qGey2JqZsu30LFIzIse/O+QxZqX+NsyBin6oxJPkCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGtf4aUHIKPWk/R+GLhLVU0znF092ku5kvUrmZpnzXjptVfIix4nXaLcagDy5E7GL
	 iWqSsB7Ft8Cy3MPGIiyw9/TVbO7IVqU6OrDz2vWh41+OxP4DlE4fSOel5FND7JR1uT
	 +CC9m7cx3LSCGhVF0KGYlK0mkskKy+TFqE+N/4rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.19 147/378] xhci: Fix NULL pointer dereference when reading portli debugfs files
Date: Tue, 17 Mar 2026 17:31:44 +0100
Message-ID: <20260317163012.422365698@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit ae4ff9dead5efa2025eddfcdb29411432bf40a7c upstream.

Michal reported and debgged a NULL pointer dereference bug in the
recently added portli debugfs files

Oops is caused when there are more port registers counted in
xhci->max_ports than ports reported by Supported Protocol capabilities.
This is possible if max_ports is more than maximum port number, or
if there are gaps between ports of different speeds the 'Supported
Protocol' capabilities.

In such cases port->rhub will be NULL so we can't reach xhci behind it.
Add an explicit NULL check for this case, and print portli in hex
without dereferencing port->rhub.

Reported-by: Michal Pecio <michal.pecio@gmail.com>
Closes: https://lore.kernel.org/linux-usb/20260304103856.48b785fd.michal.pecio@gmail.com
Fixes: 384c57ec7205 ("usb: xhci: Add debugfs support for xHCI Port Link Info (PORTLI) register.")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260304223639.3882398-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-debugfs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-debugfs.c b/drivers/usb/host/xhci-debugfs.c
index 890fc5e892f1..ade178ab34a7 100644
--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -386,11 +386,19 @@ static const struct file_operations port_fops = {
 static int xhci_portli_show(struct seq_file *s, void *unused)
 {
 	struct xhci_port	*port = s->private;
-	struct xhci_hcd		*xhci = hcd_to_xhci(port->rhub->hcd);
+	struct xhci_hcd		*xhci;
 	u32			portli;
 
 	portli = readl(&port->port_reg->portli);
 
+	/* port without protocol capability isn't added to a roothub */
+	if (!port->rhub) {
+		seq_printf(s, "0x%08x\n", portli);
+		return 0;
+	}
+
+	xhci = hcd_to_xhci(port->rhub->hcd);
+
 	/* PORTLI fields are valid if port is a USB3 or eUSB2V2 port */
 	if (port->rhub == &xhci->usb3_rhub)
 		seq_printf(s, "0x%08x LEC=%u RLC=%u TLC=%u\n", portli,
-- 
2.53.0



