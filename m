Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02A244C93;
	Sun,  1 Sep 2024 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209265; cv=none; b=SmY9UEhO5ERBAIaw1EzsJRePSUzqNKto4wJmYc9iq5doWlVu3z66dq3QYAEE3c2eOpx4Sq8utjv2Xo/v6oEulhWsi7/ASRdvhrkPevIuRC+DalODdhFHaphARit+2UAr4Wu8S9zuBBHnrjBI2pDfc5CDPDZ/lz42d99LJmflWlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209265; c=relaxed/simple;
	bh=JX1KRNIcpzHi53TQUoGoe9rRQE7GzdGqCbPIILYM6eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVj2OYOT/byaoa/d25YdQQSi/l9VWE+CrU+TXYhu2Kr2vzxX7Pcu+NtHaiTEKGWYHAILli3y2f31PBHHXe+8kcomRHWHL6tcQyhtSc5KUhcRu3RzUrq+eqDA1xo7C/zDAOKTwVbLfWiPO4QqWB90yPPXWs3SnZwOgY2SdLcCkAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zlb0Mg+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zlb0Mg+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669A0C4CEC3;
	Sun,  1 Sep 2024 16:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209264;
	bh=JX1KRNIcpzHi53TQUoGoe9rRQE7GzdGqCbPIILYM6eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zlb0Mg+J9cWI4NCzwrXIlgFMuWhRfLvxrrz4LDeGbFTR1Aha4eIATE7n8dAO0CL2X
	 X8QG+aViUkTaZhM8RS/xQooQ3yI66iV7VY5D9xgCw4d1ION8cVWIaCXsn9VHb44R+K
	 0LMjG8A5Yadkojcue9GlMp2M2rFovGWVsU03qNN8=
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
Subject: [PATCH 6.1 21/71] usb: typec: fix up incorrectly backported "usb: typec: tcpm: unregister existing source caps before re-registration"
Date: Sun,  1 Sep 2024 18:17:26 +0200
Message-ID: <20240901160802.689035616@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

In commit cfcd544a9974 ("usb: typec: tcpm: unregister existing source
caps before re-registration"), quilt, and git, applied the diff to the
incorrect function, which would cause bad problems if exercised in a
device with these capabilities.

Fix this all up (including the follow-up fix in commit 4053696594d7
("usb: typec: tcpm: fix use-after-free case in
tcpm_register_source_caps") to be in the correct function.

Fixes: 4053696594d7 ("usb: typec: tcpm: fix use-after-free case in tcpm_register_source_caps")
Fixes: cfcd544a9974 ("usb: typec: tcpm: unregister existing source caps before re-registration")
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
@@ -2397,7 +2397,7 @@ static int tcpm_register_source_caps(str
 {
 	struct usb_power_delivery_desc desc = { port->negotiated_rev };
 	struct usb_power_delivery_capabilities_desc caps = { };
-	struct usb_power_delivery_capabilities *cap;
+	struct usb_power_delivery_capabilities *cap = port->partner_source_caps;
 
 	if (!port->partner_pd)
 		port->partner_pd = usb_power_delivery_register(NULL, &desc);
@@ -2407,6 +2407,11 @@ static int tcpm_register_source_caps(str
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
@@ -2420,7 +2425,7 @@ static int tcpm_register_sink_caps(struc
 {
 	struct usb_power_delivery_desc desc = { port->negotiated_rev };
 	struct usb_power_delivery_capabilities_desc caps = { };
-	struct usb_power_delivery_capabilities *cap = port->partner_source_caps;
+	struct usb_power_delivery_capabilities *cap;
 
 	if (!port->partner_pd)
 		port->partner_pd = usb_power_delivery_register(NULL, &desc);
@@ -2430,11 +2435,6 @@ static int tcpm_register_sink_caps(struc
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


