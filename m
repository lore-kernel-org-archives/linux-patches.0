Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3632E9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B092FC433C8;
	Sun, 13 Aug 2023 21:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962007;
	bh=aIAslW0Qwgv0Q2y2TmmNJQ3DmyCq/L3L9npSPOqOtxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWnaRlkp7aR5UZLQpNM3sjNXojcKMIDfM0Y8C29X24JGQvQBmY6PKMCCqEDbP1IEZ
	 NJpXwObFvxNZbuyE15vCHqTMpmiDpjmfBGrtkRZ3UCwvjZgZCh2vnjh3TYPoUGVrBn
	 hxzE6ZQ0XYY3hmZKQwZ57bvsYP1FAiqUGWcndNM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.4 078/206] usb: typec: tcpm: Fix response to vsafe0V event
Date: Sun, 13 Aug 2023 23:17:28 +0200
Message-ID: <20230813211727.311938907@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Badhri Jagan Sridharan <badhri@google.com>

commit 4270d2b4845e820b274702bfc2a7140f69e4d19d upstream.

Do not transition to SNK_UNATTACHED state when receiving vsafe0v event
while in SNK_HARD_RESET_WAIT_VBUS. Ignore VBUS off events as well as
in some platforms VBUS off can be signalled more than once.

[143515.364753] Requesting mux state 1, usb-role 2, orientation 2
[143515.365520] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RESET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[143515.632281] CC1: 0 -> 0, CC2: 3 -> 0 [state SNK_HARD_RESET_SINK_OFF, polarity 1, disconnected]
[143515.637214] VBUS on
[143515.664985] VBUS off
[143515.664992] state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RESET_WAIT_VBUS [rev3 HARD_RESET]
[143515.665564] VBUS VSAFE0V
[143515.665566] state change SNK_HARD_RESET_WAIT_VBUS -> SNK_UNATTACHED [rev3 HARD_RESET]

Fixes: 28b43d3d746b ("usb: typec: tcpm: Introduce vsafe0v for vbus")
Cc: <stable@vger.kernel.org>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230712085722.1414743-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5348,6 +5348,10 @@ static void _tcpm_pd_vbus_off(struct tcp
 		/* Do nothing, vbus drop expected */
 		break;
 
+	case SNK_HARD_RESET_WAIT_VBUS:
+		/* Do nothing, its OK to receive vbus off events */
+		break;
+
 	default:
 		if (port->pwr_role == TYPEC_SINK && port->attached)
 			tcpm_set_state(port, SNK_UNATTACHED, tcpm_wait_for_discharge(port));
@@ -5394,6 +5398,9 @@ static void _tcpm_pd_vbus_vsafe0v(struct
 	case SNK_DEBOUNCED:
 		/*Do nothing, still waiting for VSAFE5V for connect */
 		break;
+	case SNK_HARD_RESET_WAIT_VBUS:
+		/* Do nothing, its OK to receive vbus off events */
+		break;
 	default:
 		if (port->pwr_role == TYPEC_SINK && port->auto_vbus_discharge_enabled)
 			tcpm_set_state(port, SNK_UNATTACHED, 0);


