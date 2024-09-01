Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3685928387;
	Sun,  1 Sep 2024 16:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208088; cv=none; b=W38p7YAVzNtWGoSCux5DhvqYf6+7qjZpqQ8FhldGs7Ci4tp93NCL5VwudgGcLSPiRHJheBvrVW479EseNlA69t8C7bnTTn8n3wsEy38oJZcSckc9Dh0tpaDFU6DuO4HBEE7DlrZ93YRzy4uIhhbP2JFuFh6BSwSfpADbDbafBaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208088; c=relaxed/simple;
	bh=zV312t+dQD1y6UUXZJ/zC/vTeZjq/2IOFZ4Wznj1I0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOGy/T01URO4W5A80AM/Bv0J3sU8MQXRzbKZrC6YINnaJxW92NHfH0ixFDF2TN1nfBADxejuSt2WaI/Ml/RG92SiKudJRPg4FV8PLKdbHLCul9a2JM2ydm11dV2S6Xn8eF4GguM635VhrpKJXJr8NYCoNQ96gNjHEuVJsLPvArA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SH+A8PVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SH+A8PVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A899C4CEC3;
	Sun,  1 Sep 2024 16:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208088;
	bh=zV312t+dQD1y6UUXZJ/zC/vTeZjq/2IOFZ4Wznj1I0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SH+A8PVtCtNvPkxWh0uojdKYNUG3KNkx2oduH8elf2Jwv8O8SHkdMLYgjxpXfQ07V
	 mQo+Rca9Y/wBTw6ckFngM+LyqttRBxUTEy4YeYaHB+Y7DFnDkbHpAhZqdfWkQQaFSP
	 rB+J6xhelooltScfgfkl6t4RWCzNrq6xCiKXRaGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Yo <charlesyo@google.com>,
	Kyle Tso <kyletso@google.com>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Ondrej Jirman <megi@xff.cz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.6 28/93] usb: typec: fix up incorrectly backported "usb: typec: tcpm: unregister existing source caps before re-registration"
Date: Sun,  1 Sep 2024 18:16:15 +0200
Message-ID: <20240901160808.419602012@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

In commit b16abab1fb64 ("usb: typec: tcpm: unregister existing source
caps before re-registration"), quilt, and git, applied the diff to the
incorrect function, which would cause bad problems if exercised in a
device with these capabilities.

Fix this all up (including the follow-up fix in commit 04c05d50fa79
("usb: typec: tcpm: fix use-after-free case in
tcpm_register_source_caps") to be in the correct function.

Fixes: 04c05d50fa79 ("usb: typec: tcpm: fix use-after-free case in tcpm_register_source_caps")
Fixes: b16abab1fb64 ("usb: typec: tcpm: unregister existing source caps before re-registration")
Reported-by: Charles Yo <charlesyo@google.com>
Cc: Kyle Tso <kyletso@google.com>
Cc: Amit Sunil Dhamne <amitsd@google.com>
Cc: Ondrej Jirman <megi@xff.cz>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2403,7 +2403,7 @@ static int tcpm_register_source_caps(str
 {
 	struct usb_power_delivery_desc desc = { port->negotiated_rev };
 	struct usb_power_delivery_capabilities_desc caps = { };
-	struct usb_power_delivery_capabilities *cap;
+	struct usb_power_delivery_capabilities *cap = port->partner_source_caps;
 
 	if (!port->partner_pd)
 		port->partner_pd = usb_power_delivery_register(NULL, &desc);
@@ -2413,6 +2413,11 @@ static int tcpm_register_source_caps(str
 	memcpy(caps.pdo, port->source_caps, sizeof(u32) * port->nr_source_caps);
 	caps.role = TYPEC_SOURCE;
 
+	if (cap) {
+		usb_power_delivery_unregister_capabilities(cap);
+		port->partner_source_caps = NULL;
+	}
+
 	cap = usb_power_delivery_register_capabilities(port->partner_pd, &caps);
 	if (IS_ERR(cap))
 		return PTR_ERR(cap);
@@ -2426,7 +2431,7 @@ static int tcpm_register_sink_caps(struc
 {
 	struct usb_power_delivery_desc desc = { port->negotiated_rev };
 	struct usb_power_delivery_capabilities_desc caps = { };
-	struct usb_power_delivery_capabilities *cap = port->partner_source_caps;
+	struct usb_power_delivery_capabilities *cap;
 
 	if (!port->partner_pd)
 		port->partner_pd = usb_power_delivery_register(NULL, &desc);
@@ -2436,11 +2441,6 @@ static int tcpm_register_sink_caps(struc
 	memcpy(caps.pdo, port->sink_caps, sizeof(u32) * port->nr_sink_caps);
 	caps.role = TYPEC_SINK;
 
-	if (cap) {
-		usb_power_delivery_unregister_capabilities(cap);
-		port->partner_source_caps = NULL;
-	}
-
 	cap = usb_power_delivery_register_capabilities(port->partner_pd, &caps);
 	if (IS_ERR(cap))
 		return PTR_ERR(cap);


