Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210967;
	b=g430f5cM9dBLRMQHOdpIU9TgLlkbaRwkgTLZ5DqkqGtgQz0rsetkHVYuulsC9vFy8Lzj
	 zyGql7blmo57w3mCinV9sZRr00bX7xkJl3w51GXSId43gwxTzq+5aHO+KapKPzUdityG4
	 jBWtWFOKmmHB/gcaavDogrGRm3r/4iOefMJuvLMsv7Y6FUsakhOGhO4SkVC3l8KRoyeDI
	 +p1ZNT6wZ/+LY7OYiT3gj4mOoOw67HauFXGCOFrQzzRNx2BZg5QdxDcpRyTsKrZG24ZHs
	 OBHsNLO/faiCaN5uRn0G4a9+GYYvqefQ7uV+ZO+5MWi+6T+KK7jqfJeHtfRdlnf6tVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qJV/RNvaBK89HmxNXLV5qNGH9p5NqQA4EuZFUAWiJZE=;
	b=jn0LENcMCrnBnkOORZonvJJteNVNtwR03ntzvD8ME7A02fej02TQ1J4WYSELOWnH+Y0w
	 dEULNjv3DleaC9bVet7Ri8UUGAo6jg/+HSPwMmyXM/hYQmMplpVeYl2xhzp2bwEJb9bfH
	 Ran8GB+oYFSV/5mTTFZvfmM16dfP3abF1AZfh9KKn+bZFweLGmXi9/tPUVmIlx0XyJP3w
	 UIX0cFJ11qEaslXUxMu795x09IzEFW12kbVyJWomudM/NteiRciXUDMJS7tzAGN4Jxbw8
	 H6V0PKoBZ1imUe8J7Kl54LVZe/rvL2xvu0e8Zar5ZEq3W5AglReoaWcdZpqhnT22X2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nizdbw+J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE52606A31A;
	Wed, 28 Oct 2026 18:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nizdbw+J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4351F01828;
	Wed, 28 Oct 2026 18:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210967;
	bh=qJV/RNvaBK89HmxNXLV5qNGH9p5NqQA4EuZFUAWiJZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nizdbw+JNv/QdXuCN48LQoIke8JBJUMHWYBLFDVcUcqm+Yd6E0Nu7m4TiIozRfwpU
	 lFihfk3IjHVPUJSysDzv/0udS1djMtccxGx0tWk6Bsl9C8Q21G2lUNw+3DL/rc4IBe
	 PlXE4otyljYyVdCMn4mIe+LBCaGxUzyeL7wG5ghM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 211/571] usb: typec: tipd: fix uninitialized typec_partner_desc in tps6598x_connect()
Date: Wed, 28 Oct 2026 17:55:58 +0100
Message-ID: <20261028170013.009273398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

commit c4b27b3605788bbf9e4251f3cd4ab94645ab036f upstream.

tps6598x_connect() passes a stack-allocated typec_partner_desc to
typec_register_partner() after initializing only usb_pd, accessory and
identity.

typec_register_partner() copies attach and deattach from the descriptor
into the partner. With those fields left unset, garbage function pointers
may be stored and later invoked from typec_partner_link_device() when a USB
device is linked to the port. Uninitialized pd_revision and usb_capability
similarly leak stack data through partner sysfs.

Zero-initialize the descriptor so optional callbacks remain NULL and the
remaining fields are zero.

Fixes: 0a4c005bd171 ("usb: typec: driver for TI TPS6598x USB Power Delivery controllers")
Cc: stable <stable@kernel.org> # 5.15+
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20260906131942.83153-2-radhey.shyam.pandey@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -218,7 +218,7 @@ static void tps6598x_set_data_role(struc
 
 static int tps6598x_connect(struct tps6598x *tps, u32 status)
 {
-	struct typec_partner_desc desc;
+	struct typec_partner_desc desc = { };
 	enum typec_pwr_opmode mode;
 	u16 pwr_status;
 	int ret;
@@ -234,7 +234,6 @@ static int tps6598x_connect(struct tps65
 
 	desc.usb_pd = mode == TYPEC_PWR_MODE_PD;
 	desc.accessory = TYPEC_ACCESSORY_NONE; /* XXX: handle accessories */
-	desc.identity = NULL;
 
 	if (desc.usb_pd) {
 		ret = tps6598x_read_partner_identity(tps);


