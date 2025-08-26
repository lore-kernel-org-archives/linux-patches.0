Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885A24086A;
	Tue, 26 Aug 2025 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215618; cv=none; b=lISuldijt7bCvDATWSUZX/mC02VZNTmNZrjDFT4qapzRg6aaq/3KVqz9Hsjmv0AQdzCPWewP288F7Qvvx4sHSZKNM92ekrCnszi3Cek5Df+b3pu6EbbgZRlFwSBB7ZaEyu7cl9HnQiAf0rCWG4NTnYeprJWjWQ+N91+W2R87Qgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215618; c=relaxed/simple;
	bh=XF2YJwzi/W3HyuGlXws/873VgTnkHZ9mIw9T4ZdDfSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWh/efFjzKtZcoxDb3AG6aqMqLtf4398ZubDEVuY6dbzPYgv+bEZppn7WnCInKoF7kOlAn2OzCqNTLV4qUHLvZze32Ds2kq5Ulpcyj6tWjWh5kM1yBXQYjgq9Df7HYpW5/m+ZFkpYUIJhMtwd96IBDxpF+W5zmosbA9LeEYD5Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9ItBcHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9ItBcHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB0DC4CEF1;
	Tue, 26 Aug 2025 13:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215618;
	bh=XF2YJwzi/W3HyuGlXws/873VgTnkHZ9mIw9T4ZdDfSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9ItBcHYRZYxPIiM2bcTOw+daJgUCg3bADxJuN2VzcOb7DGrSowFyh2EfPJ7N/ARK
	 +By2QpFIQpFORFs/KXIMC+jX5HWvsqcVLSwr/K2WAV/9Ik6lKPZgHRTpp87qlx53xS
	 YuUAuKxaMDr3/RHkJUTT2bSPF1Y7ra91jgw1pwoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	RD Babiera <rdbabiera@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/644] usb: typec: tcpm: apply vbus before data bringup in tcpm_src_attach
Date: Tue, 26 Aug 2025 13:03:13 +0200
Message-ID: <20250826110949.042050449@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: RD Babiera <rdbabiera@google.com>

commit bec15191d52300defa282e3fd83820f69e447116 upstream.

This patch fixes Type-C compliance test TD 4.7.6 - Try.SNK DRP Connect
SNKAS.

tVbusON has a limit of 275ms when entering SRC_ATTACHED. Compliance
testers can interpret the TryWait.Src to Attached.Src transition after
Try.Snk as being in Attached.Src the entire time, so ~170ms is lost
to the debounce timer.

Setting the data role can be a costly operation in host mode, and when
completed after 100ms can cause Type-C compliance test check TD 4.7.5.V.4
to fail.

Turn VBUS on before tcpm_set_roles to meet timing requirement.

Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable <stable@kernel.org>
Signed-off-by: RD Babiera <rdbabiera@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250618230606.3272497-2-rdbabiera@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -3622,17 +3622,6 @@ static int tcpm_src_attach(struct tcpm_p
 
 	tcpm_enable_auto_vbus_discharge(port, true);
 
-	ret = tcpm_set_roles(port, true, TYPEC_STATE_USB,
-			     TYPEC_SOURCE, tcpm_data_role_for_source(port));
-	if (ret < 0)
-		return ret;
-
-	if (port->pd_supported) {
-		ret = port->tcpc->set_pd_rx(port->tcpc, true);
-		if (ret < 0)
-			goto out_disable_mux;
-	}
-
 	/*
 	 * USB Type-C specification, version 1.2,
 	 * chapter 4.5.2.2.8.1 (Attached.SRC Requirements)
@@ -3642,13 +3631,24 @@ static int tcpm_src_attach(struct tcpm_p
 	    (polarity == TYPEC_POLARITY_CC2 && port->cc1 == TYPEC_CC_RA)) {
 		ret = tcpm_set_vconn(port, true);
 		if (ret < 0)
-			goto out_disable_pd;
+			return ret;
 	}
 
 	ret = tcpm_set_vbus(port, true);
 	if (ret < 0)
 		goto out_disable_vconn;
 
+	ret = tcpm_set_roles(port, true, TYPEC_STATE_USB, TYPEC_SOURCE,
+			     tcpm_data_role_for_source(port));
+	if (ret < 0)
+		goto out_disable_vbus;
+
+	if (port->pd_supported) {
+		ret = port->tcpc->set_pd_rx(port->tcpc, true);
+		if (ret < 0)
+			goto out_disable_mux;
+	}
+
 	port->pd_capable = false;
 
 	port->partner = NULL;
@@ -3658,14 +3658,14 @@ static int tcpm_src_attach(struct tcpm_p
 
 	return 0;
 
-out_disable_vconn:
-	tcpm_set_vconn(port, false);
-out_disable_pd:
-	if (port->pd_supported)
-		port->tcpc->set_pd_rx(port->tcpc, false);
 out_disable_mux:
 	tcpm_mux_set(port, TYPEC_STATE_SAFE, USB_ROLE_NONE,
 		     TYPEC_ORIENTATION_NONE);
+out_disable_vbus:
+	tcpm_set_vbus(port, false);
+out_disable_vconn:
+	tcpm_set_vconn(port, false);
+
 	return ret;
 }
 


