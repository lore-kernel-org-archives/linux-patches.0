Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A9E437858;
	Thu, 16 Jul 2026 14:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212230; cv=none; b=jKn6CvCM10zKXGkSnrrZfGOZrM5o4jHP/gSh4c6tO6NoAs47Oi4nJ6NHZx4h/SidP/rV98szPGFNcZN/x3zx3747QcY10WwtPuG9X+ROdSd4Xg7gPiJvoOAGMWgschkvqDadhzM4TD00/mzBRTF7y58eeyI2dtofQrgxKehL6S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212230; c=relaxed/simple;
	bh=80kpiNJmHsFB9sLTdCnwK84a8xj03Otyc6Dtm59L2dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NE8kbhBe7VV71jtgSnTbg58Ll4J8FX91ARK3Vw29sxmrYIXCNm06QOAfkldUlkPzPEPkO57g/zZE9pqnLJOTsvZ3y9Pd5hilUHvbrTBhupS5Jc2uRGu3/psDafkMyjNMoItWh2PCL/EGlDQ/V5JaUIpRxeuz1mvXQvMbv1+XiKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmCdf7Cw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmCdf7Cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0441F00A3D;
	Thu, 16 Jul 2026 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212229;
	bh=Hz24gNynC2xAOpp7CbtsAEpYORsTPF5CJV8UaL2OV10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmCdf7Cw92EBLtRe/u1JZ6xn3LuZKWs8m9hM9PjHqkCCPAYsly4Fq0lRGmn88QZqM
	 1pRx3E1zL1aUEaRVwa/AjBYJi0Zihf3Ml40WeVpoWbyJKm9i9XQe9alX+jSnvxgtIj
	 H15fsm8/T8BD51bqqMma/MjIDkD8PC2Wkr4DRHKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 249/349] usb: typec: tcpm: Validate SVID index in svdm_consume_modes()
Date: Thu, 16 Jul 2026 15:33:03 +0200
Message-ID: <20260716133038.926123468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Badhri Jagan Sridharan <badhri@google.com>

commit 7b681dd5fbf60b24a13c14661e5b7735759fb491 upstream.

In svdm_consume_modes(), the SVID value is read from pmdata->svids using
pmdata->svid_index as an array index without bounds validation:

    paltmode->svid = pmdata->svids[pmdata->svid_index];

If pmdata->svid_index is driven beyond SVID_DISCOVERY_MAX (16), it results
in an out-of-bounds read of the pmdata->svids array. Because pd_mode_data
is embedded inside struct tcpm_port, indexing past svids reads into
adjacent fields. In particular:
- At index 16, it reads the altmodes count.
- At index 18 and beyond, it reads into altmode_desc[], which contains
  partner-supplied SVDM Discovery Modes VDOs.

By injecting a chosen SVID into altmode_desc[0].vdo and driving svid_index
to 20, the partner can force paltmode->svid to be loaded with an arbitrary,
partner- chosen SVID, which is then registered via
typec_partner_register_altmode().

Fix this by validating that pmdata->svid_index is non-negative and strictly
less than pmdata->nsvids before accessing the pmdata->svids array inside
svdm_consume_modes().

Assisted-by: Antigravity:gemini-3.5-flash
Fixes: 4ab8c18d4d67 ("usb: typec: Register a device for every mode")
Cc: stable <stable@kernel.org>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: RD Babiera <rdbabiera@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260622220803.305750-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1784,6 +1784,11 @@ static void svdm_consume_modes(struct tc
 		return;
 	}
 
+	if (pmdata->svid_index < 0 || pmdata->svid_index >= pmdata->nsvids) {
+		tcpm_log(port, "Invalid SVID index %d", pmdata->svid_index);
+		return;
+	}
+
 	for (i = 1; i < cnt; i++) {
 		if (pmdata->altmodes >= ALTMODE_DISCOVERY_MAX) {
 			/* Already logged in svdm_consume_svids() */


