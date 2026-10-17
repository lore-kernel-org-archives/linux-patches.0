Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0269A35E93B;
	Sat, 17 Oct 2026 17:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256554; cv=none; b=ioCjNU4pfBIxALlfF0jLQg7qv6RUoMefvH4p1oS7ebrYAUNziI7YIspV7vJJsNj3s2JXHnYvS7nryIbkIcEBAMt1lp+YwEYMDAaNGKD41IWEalahPExc+FMv6syC9ZtNCan5gn+Iy4wQhndLAMLsBSJRkc2l8/YLk+4l/igAUWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256554; c=relaxed/simple;
	bh=Xejq3wtjK/U2OjwvRJYm8CXIVkkAd5jm476IZdllmy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoSGrpEFzPZUJXsF3pSMw0gOsWUKC1sc4d+xGwT5IBOWd4w0m6xiizHScr6Sh4bKrbVbaYn4mJO7ebPwPUyaqXz2MsSOLfqPjzKx1CBmffpGWeuB6onaf55b1Lqs/q9mXb03lcGjzQNQGeSiNqfghTq+JATvy9nIZo3IxCm/p2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYeNPS9V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYeNPS9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A7C1F000C4;
	Sat, 17 Oct 2026 17:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256552;
	bh=NRbTzEY6vAbUrQ08uFjUO/m2MsrruqMcC1ZleiPBr3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYeNPS9VaT0M8lGmxGfkuUAcNoM/EPCOgpz8DRE1clixd5u4+inoAn67KZX7kO8DP
	 ktIFitZBNmPQRFrDV7Nwb6yDQFYJjCgSwH4KFArkKucYn3UviVFJAGF9WDac+c2Gii
	 4L+uTZE5L666RAHBU51XOCgv6uQSBdPZahE0WJOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 0274/1674] usb: typec: tipd: fix uninitialized typec_partner_desc in tps6598x_connect()
Date: Sat, 17 Oct 2026 17:42:26 +0200
Message-ID: <20261017160438.151531756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -226,7 +226,7 @@ static void tps6598x_set_data_role(struc
 
 static int tps6598x_connect(struct tps6598x *tps, u32 status)
 {
-	struct typec_partner_desc desc;
+	struct typec_partner_desc desc = { };
 	enum typec_pwr_opmode mode;
 	int ret;
 
@@ -237,7 +237,6 @@ static int tps6598x_connect(struct tps65
 
 	desc.usb_pd = mode == TYPEC_PWR_MODE_PD;
 	desc.accessory = TYPEC_ACCESSORY_NONE; /* XXX: handle accessories */
-	desc.identity = NULL;
 
 	if (desc.usb_pd) {
 		ret = tps6598x_read_partner_identity(tps);


