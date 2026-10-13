Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6171A9FA8;
	Tue, 13 Oct 2026 12:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895076; cv=none; b=g2eqKSS4L5brWDExk/98lHCDuhj0QwiqJ1kjKom9j7cDNy+DOIz20TCYBP1kjdxsJc6P4m0oex89anUMqiII7iIoMu+iUPGR0YW2U+vTk/FLaS9LyWKCr6VOWC/5wDf6lvKdDV/YL+Duna5HEp+ecwh9Gk0rExjX+Mh/qT96k3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895076; c=relaxed/simple;
	bh=j78MpLB2sHFhrojqvWAwRdXkoV2kJ3+byntFeLAT92U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P39PxbvlJdz2s8DC+8wrv3mQT9ALbgkqExJfB7mdA2z0uZsbxa5YAdfhwmIKwpL8QVOg56BDb952mt0h7lcrOdG5uCUKpk92SSg6QrxAEI4ioqgzGzxuiiV7q/J82PnIizdFV2+R5Dk8n1/nVEDz5r9wI41bDW1SPnJa8NolBkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ecnay2hb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ecnay2hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A0B1F000FF;
	Tue, 13 Oct 2026 12:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895075;
	bh=6Wk83Na992VcwFsrsnk+zJZ274ubqnoJV5LlzGi2tzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ecnay2hbV31d8FIIz5h2qGeqr5Lm3dYsZPRXxGvJQc7GWn4DCJB7f+D+li1EcpP9S
	 /6OsH+sQ9Eos4PQ5yBw4RlNW+IxRdxHg7Y3xGZc4yxjqHEzclQKXC/jHyy6LDUi3qM
	 TmhfKIyK7mk50X9+N7y3jGrq0Al+MAKRIA3c7RVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 153/497] usb: typec: tipd: fix uninitialized typec_partner_desc in tps6598x_connect()
Date: Tue, 13 Oct 2026 13:35:20 +0200
Message-ID: <20261013112911.517985583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -268,7 +268,7 @@ static void tps6598x_set_data_role(struc
 
 static int tps6598x_connect(struct tps6598x *tps, u32 status)
 {
-	struct typec_partner_desc desc;
+	struct typec_partner_desc desc = { };
 	enum typec_pwr_opmode mode;
 	int ret;
 
@@ -279,7 +279,6 @@ static int tps6598x_connect(struct tps65
 
 	desc.usb_pd = mode == TYPEC_PWR_MODE_PD;
 	desc.accessory = TYPEC_ACCESSORY_NONE; /* XXX: handle accessories */
-	desc.identity = NULL;
 
 	if (desc.usb_pd) {
 		ret = tps6598x_read_partner_identity(tps);


