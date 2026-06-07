Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F213264F5;
	Sun,  7 Jun 2026 10:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828898; cv=none; b=EqCzWCDbB8PaHhZJOpWR4tC1l7/K2zClMzYZi0kHRn99yMZsviBrHh7EYtjxElaB2nPqzwaC+iRQ1xy3EQn6cyT2FUVvenh5BgSFKnOnBBRvVobsEiz0P4uCHDSVlWC1kN7gvmkIEGPZUpFtO2bm0s1UhzNWnegobLPzjBTrRlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828898; c=relaxed/simple;
	bh=MNpE8nqB/J7uu4MWuQLnHwlBeLgj4jF3luJWEyEjLaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGSsNzJwxhLinFSTrpe+2UGeuuSBtMG8LVI4fFZ+nIo7mLYNmLcyWolkr1grZn41Ve4Lq2u1T91vdwFMLSZrE5ocupN8KMGLtswaXi55g9vjd/6EpJnhZZ373s02eMhqwTsewBlHbdA1u3QHecPe3jJvAqR8E5EFJqoTXfBYVoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQ1mfVc9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQ1mfVc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F5F1F00893;
	Sun,  7 Jun 2026 10:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828896;
	bh=mY+0vVkcwemAPyhfKIgLRL0LYcWXqX6h5qdoZYumkak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQ1mfVc9+GsqaM+dBF0lBZ/ESBZmGKdIMPwMayd9DFu0Xu3qYVEMSlS0tPduN/2MR
	 u0J8G98oXDj2OBpesI2CcKgsjUDuAOqBpRvVaJNaixhe9WqIZN5eiI7masr2u9CTVZ
	 RlYRFlSZB/Gp1IFEkrDmIjp97MN/LZAQVKITC1G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 177/307] USB: serial: omninet: fix memory corruption with small endpoint
Date: Sun,  7 Jun 2026 11:59:34 +0200
Message-ID: <20260607095734.214162872@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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


