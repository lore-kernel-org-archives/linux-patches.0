Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF58400982;
	Thu, 16 Jul 2026 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211142; cv=none; b=f2QwD4QwaMLA++Mm3+KG3KJWQHmt5ovpQyqjDKXozCempt/xvhk4bHAWQ2rYptJrqrw56b9qQfioARDjGalC8rNssJTUWTPGwnxUD1KK6a4eCzWHh1+XcCHbdkdDX5m9qKaujYLwE9mmNU8nXCT//w1Bv3UXMq+hvSzLhkYNbVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211142; c=relaxed/simple;
	bh=8m7A7ZEfR7cCfAy8EYED9l9hQ5eORMTfiI0Thv/Kj+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kY/cvjmjHi+Og8QvU1uELgpiL6ShFyeyezO7wIlL9Ndhk8w95Qm+wxfZnhokZqHX5z5D51fK07AsP29gApKBNOnyEKZDZ5OVKWvwhaUELWdrYAt4QcBLP4vnsj5yEsdF9Pt+Z77CsVj7koPE44r/zQpc3mPbeYTSmb3xqcWRbuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbyQWnwc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbyQWnwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649F01F000E9;
	Thu, 16 Jul 2026 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211140;
	bh=qr56oAZqIQoLUDwjGkC125cL4GH9EzvhjnezllYrDw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbyQWnwcwPdhi/o2/IH8d/hp/QeGBCIgNtuzru4McYsKTLVXeFrpA+VBV/kNxDwof
	 NOTnE/SFSkwbURsZuirakM5WczhUp+nu3lsQIYxdaL/eztAu+xmBRQTOGperhcV+2Q
	 b/vDV4ne/UFXL6b5zTgreesGLRD4f83H0aIqFOn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 314/480] usb: typec: tcpm: Validate SVID index in svdm_consume_modes()
Date: Thu, 16 Jul 2026 15:31:01 +0200
Message-ID: <20260716133051.614132809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1840,6 +1840,11 @@ static void svdm_consume_modes(struct tc
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


