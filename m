Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342A72D3A69;
	Sun,  7 Jun 2026 10:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828651; cv=none; b=QMeqR69FyhD1tfh8yQ3yx9d9l7wx9cEjmtPuPH09ViZPF84y2aSF41LASRMtpcxFa6rSWKH6bkGfdQ9OqoDL0pqVyJPdiPUNY5OabQiwjHu6xUEqRRFrwmnBFeGUSkGuvKrsLIpvGHvMg6vJjjFSLkMAapwJY5/HvTKUcdzybwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828651; c=relaxed/simple;
	bh=oSnUttzP8pY6pVE+MtfbIZf920FTRoVTwdCR5YrghhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puL5suvP2wlCgfCiGgWj/ateBZHxIx35RowK6U85tKY0wNbuUSfPtpUK+yeIb2heZowo/eGhrr3dzqmz7+VuXUoGYgTl/wKTdzdR+MXSW+PagXTV58EunLe4BJt+M3nh8/0NYo0zdXvQv1acTs0xBCqm4wruS1rSFmWNMeqKiDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYb/3WWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYb/3WWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389971F00893;
	Sun,  7 Jun 2026 10:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828649;
	bh=gyuR+EuvzNuqeEqTktt2uRJanoULfmfdrWeKUJdGtJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYb/3WWZyH/1j1zFbEI/clQqL5zZPDbsx7kEVLQysfaPYXWZyIOfFT0fYST/kbnaU
	 D7g53q91uF6ZYlQfy6fVipVpgE8ZTt4A9Prd9xmDH0m/YkLIa4cBauY2+ZuBz059Ie
	 3NvxtkNBbckNmL4J1/SOcmm5Nohpl1vMvQoZX4L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.0 200/332] USB: serial: omninet: fix memory corruption with small endpoint
Date: Sun,  7 Jun 2026 11:59:29 +0200
Message-ID: <20260607095735.399243168@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 60df93d30f9bdd27db17c4d80ed80ef718d7226b upstream.

Make sure that the bulk-out buffers are at least as large as the
hardcoded transfer size to avoid user-controlled slab corruption should
a malicious device report a smaller endpoint max packet size than
expected.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/omninet.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -30,6 +30,10 @@
 /* This one seems to be a re-branded ZyXEL device */
 #define BT_IGNITIONPRO_ID	0x2000
 
+#define OMNINET_HEADERLEN	4
+#define OMNINET_BULKOUTSIZE	64
+#define OMNINET_PAYLOADSIZE	(OMNINET_BULKOUTSIZE - OMNINET_HEADERLEN)
+
 /* function prototypes */
 static void omninet_process_read_urb(struct urb *urb);
 static int omninet_prepare_write_buffer(struct usb_serial_port *port,
@@ -54,6 +58,7 @@ static struct usb_serial_driver zyxel_om
 	.description =		"ZyXEL - omni.net usb",
 	.id_table =		id_table,
 	.num_bulk_out =		2,
+	.bulk_out_size =	OMNINET_BULKOUTSIZE,
 	.calc_num_ports =	omninet_calc_num_ports,
 	.port_probe =		omninet_port_probe,
 	.port_remove =		omninet_port_remove,
@@ -130,10 +135,6 @@ static void omninet_port_remove(struct u
 	kfree(od);
 }
 
-#define OMNINET_HEADERLEN	4
-#define OMNINET_BULKOUTSIZE	64
-#define OMNINET_PAYLOADSIZE	(OMNINET_BULKOUTSIZE - OMNINET_HEADERLEN)
-
 static void omninet_process_read_urb(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;


