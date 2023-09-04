Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFACC142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3916C433C7;
	Mon,  4 Sep 2023 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852591;
	bh=rg9q7wSAjmz/OvJ8mP4PQ0lWi/AzkmK+8SrOZn2vdZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDxTcaNfh3ieIVVA+m8pDcL9WjEJCO8Nu1YHoNDT9CF+kCZlyTVdBz145EEOdiRph
	 b5f/0UNncMCxDZHKZkFnUlrSCCEAri/uOufziLwg7HGMO6wbEWsRJJWvil1Tqa2u5R
	 moeikNZufpDKlewoK2LpMMS2ZwwGOJgpJePMuKBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 23/28] tcpm: Avoid soft reset when partner does not support get_status
Date: Mon,  4 Sep 2023 19:30:54 +0100
Message-ID: <20230904182946.300865181@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182945.178705038@linuxfoundation.org>
References: <20230904182945.178705038@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Badhri Jagan Sridharan <badhri@google.com>

commit 78e0ea4277546debf7e96797ac3b768539cc44f6 upstream.

When partner does not support get_status message, tcpm right now
responds with soft reset message. This causes PD renegotiation to
happen and resets PPS link. Avoid soft resetting the link when
partner does not support get_status message to mitigate PPS resets.

[  208.926752] Setting voltage/current limit 9500 mV 2450 mA
[  208.930407] set_auto_vbus_discharge_threshold mode:3 pps_active:y vbus:9500 ret:0
[  208.930418] state change SNK_TRANSITION_SINK -> SNK_READY [rev3 POWER_NEGOTIATION]
[  208.930455] AMS POWER_NEGOTIATION finished

// ALERT message from the Source
[  213.948442] PD RX, header: 0x19a6 [1]
[  213.948451] state change SNK_READY -> GET_STATUS_SEND [rev3 GETTING_SOURCE_SINK_STATUS]
[  213.948457] PD TX, header: 0x492
[  213.950402] PD TX complete, status: 0
[  213.950427] pending state change GET_STATUS_SEND -> GET_STATUS_SEND_TIMEOUT @ 60 ms [rev3 GETTING_SOURCE_SINK_STATUS]

// NOT_SUPPORTED from the Source
[  213.959954] PD RX, header: 0xbb0 [1]

// sink sends SOFT_RESET
[  213.959958] state change GET_STATUS_SEND -> SNK_SOFT_RESET [rev3 GETTING_SOURCE_SINK_STATUS]
[  213.959962] AMS GETTING_SOURCE_SINK_STATUS finished
[  213.959964] AMS SOFT_RESET_AMS start
[  213.959966] state change SNK_SOFT_RESET -> AMS_START [rev3 SOFT_RESET_AMS]
[  213.959969] state change AMS_START -> SOFT_RESET_SEND [rev3 SOFT_RESET_AMS]

Cc: stable@vger.kernel.org
Fixes: 8dea75e11380 ("usb: typec: tcpm: Protocol Error handling")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230820044449.1005889-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2689,6 +2689,13 @@ static void tcpm_pd_ctrl_request(struct
 			port->sink_cap_done = true;
 			tcpm_set_state(port, ready_state(port), 0);
 			break;
+		/*
+		 * Some port partners do not support GET_STATUS, avoid soft reset the link to
+		 * prevent redundant power re-negotiation
+		 */
+		case GET_STATUS_SEND:
+			tcpm_set_state(port, ready_state(port), 0);
+			break;
 		case SRC_READY:
 		case SNK_READY:
 			if (port->vdm_state > VDM_STATE_READY) {


