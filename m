Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42005167DB7;
	Wed, 30 Jul 2025 09:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868394; cv=none; b=k82H5VZ8E6zbQQEt5AS0rphRnd+DoF9DLr8mqM3MbbHXC7/7T0XeUOpWZBD2JPH3pcNZjatruZnEtJy+L0fueuD+tVSZzKJpYVO+MC2IUtLCbr4MA+VdU1kuSKOVSH+K8DEPr/B7c/k9JprZ6Asob6sj9YicNQ+O0MKnuJll4dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868394; c=relaxed/simple;
	bh=kdFkfnNqACTUlcAa6ZJOT8kpb+W6usGjaYbMjOmjDOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBskfUtKFkoI21UEIgNqeM87mXFrEjsWz14OH41cBF4+H2EIbxPMV96BOnMn3zA7L2PcZK6Df3Li7gF/e+ulP5ua7Dmhwgif/sjljvUi3bhF2gJQmPzH88PxETXwwWYAjBtf/cDzSz6jhhVcLpDpTS25Fi2AZssqw9HZGCiom3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdgvPX0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdgvPX0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED81C4CEF5;
	Wed, 30 Jul 2025 09:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868394;
	bh=kdFkfnNqACTUlcAa6ZJOT8kpb+W6usGjaYbMjOmjDOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdgvPX0gVzG0zH0JEZ0XUIj3N+U8i2He6GnaC/Q1yHn9aLoK8kLsS0bw6oII2MTkt
	 OGeOkjGzDxV68tLOSxo9+IGl2qr1RSX+J8Bjl2rZ4GbEDZVcW/TFFvGQwQbnfriIyh
	 3pfGI7EumNA9hflGTPq0TeZWo8LDzyMB/1vjybPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	RD Babiera <rdbabiera@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 51/76] usb: typec: tcpm: apply vbus before data bringup in tcpm_src_attach
Date: Wed, 30 Jul 2025 11:35:44 +0200
Message-ID: <20250730093228.824405902@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


