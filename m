Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AF0306B1E;
	Wed, 17 Sep 2025 12:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113134; cv=none; b=ZFjiDi1QJKwzTZ5uvVo8RIgX8cUif3hg1fX6tMYyUb8bMDLjJkHP+rWpbb8rSwUQzkUPrfu+Fp+h8ZSADywuaENg6ZcNcSQVW2SaEBw6kIu5wj73RV/qzv78w2Jp8b3GXEHk7Kp5SD5KLd4e+Wo3OJ5LdMu9ApXs+gYdBcfLuC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113134; c=relaxed/simple;
	bh=j/HlKQmgVgZYcHs2AkkJF7f4deNFJy7+fv/pqHQYR4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9UlYJuFkhIluWpVmgzkVINuaLGuFHxQ/Ep1+RalHAWqmFyudjUci3EpcDAXgetifdcXpXRa6PkYxNjmZG9HR9oq91uDRZ1+7M+vJhP51a/m7iupDDwJgmAsQ8wTkhX0GETDbI1E1CmaztlHyzZ6JkJNKfE5GbNc663KjOI9mQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UyoV2RZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UyoV2RZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E10C4CEF0;
	Wed, 17 Sep 2025 12:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113133;
	bh=j/HlKQmgVgZYcHs2AkkJF7f4deNFJy7+fv/pqHQYR4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UyoV2RZuh+FIm26R/+W3wzhDqDA/mOfJiLBnN9uXMN9NO+2Pjs4ht7+Fc19NkMPRB
	 TAHRF18ku0Bt/+IvDqXvNbc1GSrkvjOeVIKv55nzTDW08NI8EuXpnOu07AD8m8h71x
	 BovueV75zGBHwU2cdO1cMe6+Kn5koW2dPi/HWX6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.16 181/189] usb: typec: tcpm: properly deliver cable vdms to altmode drivers
Date: Wed, 17 Sep 2025 14:34:51 +0200
Message-ID: <20250917123356.306924764@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2426,17 +2426,21 @@ static void tcpm_handle_vdm_request(stru
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


