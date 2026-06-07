Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12F62D3A69;
	Sun,  7 Jun 2026 10:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828312; cv=none; b=ZWL0L93t9emvdLJUFOWWHbD2mKFwBhjc5ujASnPtX5d190PtXT6rmlJasGpgdfJf89q9TBFdJIGNQhJ0hkzZZ2ZED6CGDZmC6Iy2OQxxW1b2+KaEUOi8nOEVX38X3LWl/QNwWIwVzFUDbwm7ZtBQbRqwRl3zmB/GA4Z2ISWwIbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828312; c=relaxed/simple;
	bh=7IFVO1+oV+PEuUddPC3Q+Jnn6xIzGlIO4ESAiWTHxkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGgtduuLwTXColqs90Ljt+D17zuxsl1GchPMQYsbTXEs2d81P5ClifVFBuOLooDjdXRW8ZIP2I0ueZbc3AT1moAwa8GtJSB9mBychmkD5O0T6HOuvEc9hloFEHnVjP019hQGvsCG7s02BK1bUSMh61ZX8UFqNZXYUzAiedRM0R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArLABt+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArLABt+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FCF1F00893;
	Sun,  7 Jun 2026 10:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828311;
	bh=bZ6SgO30G2c1vkT9HSwk41HpgMZ3qK6z4Vgt//JVTxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArLABt+ZQ6YJVbmdcLs/YSvwuplvwMYnelgPCE3qt3j4z06L6PrxCRR9luu22+/CG
	 YmWnB5CUJqtwkrxvU0mBVhG8BV1tFcA5Ax3HVLNlRTr6ta8Oc9ZJjcppuZl2VyGKGA
	 cuAHyMvur5g2YmGTxXJQ16VMp4VlbqokJzmsg9lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.12 128/307] usb: typec: tcpm: validate VDO count in Discover Identity ACK handlers
Date: Sun,  7 Jun 2026 11:58:45 +0200
Message-ID: <20260607095732.459516122@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8fbc349e8383125dd2d8de1c1e926279d398ab17 upstream.

Properly validate the count passed from a device when calling
svdm_consume_identity() or svdm_consume_identity_sop_prime() as the
device-controlled value could index off of the static arrays, which
could leak data.

Assisted-by: gkh_clanker_t1000
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://patch.msgid.link/2026051350-plated-salute-0efe@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1639,6 +1639,9 @@ static void svdm_consume_identity(struct
 	u32 vdo = p[VDO_INDEX_IDH];
 	u32 product = p[VDO_INDEX_PRODUCT];
 
+	if (cnt <= VDO_INDEX_PRODUCT)
+		return;
+
 	memset(&port->mode_data, 0, sizeof(port->mode_data));
 
 	port->partner_ident.id_header = vdo;
@@ -1659,6 +1662,9 @@ static void svdm_consume_identity_sop_pr
 	u32 product = p[VDO_INDEX_PRODUCT];
 	int svdm_version;
 
+	if (cnt <= VDO_INDEX_CABLE_1)
+		return;
+
 	/*
 	 * Attempt to consume identity only if cable currently is not set
 	 */
@@ -1682,7 +1688,7 @@ static void svdm_consume_identity_sop_pr
 	switch (port->negotiated_rev_prime) {
 	case PD_REV30:
 		port->cable_desc.pd_revision = 0x0300;
-		if (port->cable_desc.active)
+		if (port->cable_desc.active && cnt > VDO_INDEX_CABLE_2)
 			port->cable_ident.vdo[1] = p[VDO_INDEX_CABLE_2];
 		break;
 	case PD_REV20:


