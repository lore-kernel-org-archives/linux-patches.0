Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21BF31618E;
	Wed, 17 Sep 2025 12:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113629; cv=none; b=tznDWEgkbRZaUfrAHZacW27WEnilTZbgjyHqMKIWSs/HmMsqZeniXZGy3M3WyjvBQjWSJnEQl9gzpwfe1cQxcdpJn2sw3wB+ntFFmkRMXv5k/FB4E1NdJdZyWdVxJpHE1yz4TDmFbpdV+BTSZEMBJVVk5E9yV8TxUNDgejWKqCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113629; c=relaxed/simple;
	bh=gHEGUYuzvgUwYuBEVLnJ8AByNWGgvtuH5IHhhu7yEX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIsXwFB7Q5qQL+YHG78QTexnZ9+duupF+SxfxJfCuExgr/c728ND2E93awQwyNL3dq7M6qeWyb++ZVBJCwGq4SUVlEWp+7aNgHK9e4hJHY1IGAg8CRHu3z+OyhOaU6uABuBJ/9okaE4hIuHEVPJiaCVFLDAy4xKGaG6H2OMyr0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6KxFZP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6KxFZP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C531C4CEF5;
	Wed, 17 Sep 2025 12:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113629;
	bh=gHEGUYuzvgUwYuBEVLnJ8AByNWGgvtuH5IHhhu7yEX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6KxFZP5FT8aNor4oaX3aNMqrwmYKB2418BFAkf2KAD2qfDizWosAdkv5eYgBLiZA
	 25kO2zNqk5f8lEh/+rFtKZDhAyLgrB5OPBai7bEfFzLQp6WnA5tjYurvUwDPPXq2iE
	 CDN90KTa/Z+oaBudsjJggg1Qze7RDcp9K+i/3j1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 129/140] usb: typec: tcpm: properly deliver cable vdms to altmode drivers
Date: Wed, 17 Sep 2025 14:35:01 +0200
Message-ID: <20250917123347.467202182@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: RD Babiera <rdbabiera@google.com>

commit f34bfcc77b18375a87091c289c2eb53c249787b4 upstream.

tcpm_handle_vdm_request delivers messages to the partner altmode or the
cable altmode depending on the SVDM response type, which is incorrect.
The partner or cable should be chosen based on the received message type
instead.

Also add this filter to ADEV_NOTIFY_USB_AND_QUEUE_VDM, which is used when
the Enter Mode command is responded to by a NAK on SOP or SOP' and when
the Exit Mode command is responded to by an ACK on SOP.

Fixes: 7e7877c55eb1 ("usb: typec: tcpm: add alt mode enter/exit/vdm support for sop'")
Cc: stable@vger.kernel.org
Signed-off-by: RD Babiera <rdbabiera@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250821203759.1720841-2-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2375,17 +2375,21 @@ static void tcpm_handle_vdm_request(stru
 		case ADEV_NONE:
 			break;
 		case ADEV_NOTIFY_USB_AND_QUEUE_VDM:
-			WARN_ON(typec_altmode_notify(adev, TYPEC_STATE_USB, NULL));
-			typec_altmode_vdm(adev, p[0], &p[1], cnt);
+			if (rx_sop_type == TCPC_TX_SOP_PRIME) {
+				typec_cable_altmode_vdm(adev, TYPEC_PLUG_SOP_P, p[0], &p[1], cnt);
+			} else {
+				WARN_ON(typec_altmode_notify(adev, TYPEC_STATE_USB, NULL));
+				typec_altmode_vdm(adev, p[0], &p[1], cnt);
+			}
 			break;
 		case ADEV_QUEUE_VDM:
-			if (response_tx_sop_type == TCPC_TX_SOP_PRIME)
+			if (rx_sop_type == TCPC_TX_SOP_PRIME)
 				typec_cable_altmode_vdm(adev, TYPEC_PLUG_SOP_P, p[0], &p[1], cnt);
 			else
 				typec_altmode_vdm(adev, p[0], &p[1], cnt);
 			break;
 		case ADEV_QUEUE_VDM_SEND_EXIT_MODE_ON_FAIL:
-			if (response_tx_sop_type == TCPC_TX_SOP_PRIME) {
+			if (rx_sop_type == TCPC_TX_SOP_PRIME) {
 				if (typec_cable_altmode_vdm(adev, TYPEC_PLUG_SOP_P,
 							    p[0], &p[1], cnt)) {
 					int svdm_version = typec_get_cable_svdm_version(


