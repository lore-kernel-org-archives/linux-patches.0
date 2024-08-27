Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4AF1C0DE7;
	Tue, 27 Aug 2024 14:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769720; cv=none; b=L06djGdznXAWd0dplcbqLBjn8M8GxP976e4pcXsP6GyU2+6SocQtsmOTptkgNXND6ZTXIBVPXSx4djets/0Yuybvj5I4miX3kBXUSPcjv2CgJj8O7zlazbCoP0j8TbR8CWp1vpFRmLwyOfZtofPImCuxKlZn1bzjZ4q0Av+BQbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769720; c=relaxed/simple;
	bh=u+yRiao40uebT82Ebady7enYk7/SuZxsMQKF2lxPo+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nor6dhJbsXgNDhRWpprE/qC+UxP9+DbsPqffaw6M9InTrqEIZcKXHKot1aqSWEtWyooyqr0IrFv1JVoJZq2nrt8wo9+w2LbP0P7KV+qrh11JY7Zk0Q4CKqf2k8MIGBgCxPro4phhuWD0qaH8kWqtDjXQjJ9sEFYYEQe42v0j9lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgJFwo3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgJFwo3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9E6C4AF1C;
	Tue, 27 Aug 2024 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769720;
	bh=u+yRiao40uebT82Ebady7enYk7/SuZxsMQKF2lxPo+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgJFwo3KV/oePMUdq2jIC+Q3wOkyUo7Fps3m4NBX+atfDfOYQ8n0Rxdc12yCI4x7S
	 9fEhe6IAkDyM3+IAjT3cwBKM7Tb2DKcFMBbReMinKChZtfGfZHESUCzEXGWjoysKuy
	 6M2unbXFRgRUoifrPCNfzRzLd8eF7PNuWd338SlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 005/341] Revert "usb: typec: tcpm: clear pd_event queue in PORT_RESET"
Date: Tue, 27 Aug 2024 16:33:56 +0200
Message-ID: <20240827143843.610380475@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit 21ea1ce37fc267dc45fe27517bbde926211683df upstream.

This reverts commit bf20c69cf3cf9c6445c4925dd9a8a6ca1b78bfdf.

During tcpm_init() stage, if the VBUS is still present after
tcpm_reset_port(), then we assume that VBUS will off and goto safe0v
after a specific discharge time. Following a TCPM_VBUS_EVENT event if
VBUS reach to off state. TCPM_VBUS_EVENT event may be set during
PORT_RESET handling stage. If pd_events reset to 0 after TCPM_VBUS_EVENT
set, we will lost this VBUS event. Then the port state machine may stuck
at one state.

Before:

[    2.570172] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms [rev1 NONE_AMS]
[    2.570179] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 ms]
[    2.570182] pending state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED @ 920 ms [rev1 NONE_AMS]
[    3.490213] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [delayed 920 ms]
[    3.490220] Start toggling
[    3.546050] CC1: 0 -> 0, CC2: 0 -> 2 [state TOGGLING, polarity 0, connected]
[    3.546057] state change TOGGLING -> SRC_ATTACH_WAIT [rev1 NONE_AMS]

After revert this patch, we can see VBUS off event and the port will goto
expected state.

[    2.441992] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms [rev1 NONE_AMS]
[    2.441999] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 ms]
[    2.442002] pending state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED @ 920 ms [rev1 NONE_AMS]
[    2.442122] VBUS off
[    2.442125] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev1 NONE_AMS]
[    2.442127] VBUS VSAFE0V
[    2.442351] CC1: 0 -> 0, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, disconnected]
[    2.442357] Start toggling
[    2.491850] CC1: 0 -> 0, CC2: 0 -> 2 [state TOGGLING, polarity 0, connected]
[    2.491858] state change TOGGLING -> SRC_ATTACH_WAIT [rev1 NONE_AMS]
[    2.491863] pending state change SRC_ATTACH_WAIT -> SNK_TRY @ 200 ms [rev1 NONE_AMS]
[    2.691905] state change SRC_ATTACH_WAIT -> SNK_TRY [delayed 200 ms]

Fixes: bf20c69cf3cf ("usb: typec: tcpm: clear pd_event queue in PORT_RESET")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240809112901.535072-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4880,7 +4880,6 @@ static void run_state_machine(struct tcp
 		break;
 	case PORT_RESET:
 		tcpm_reset_port(port);
-		port->pd_events = 0;
 		if (port->self_powered)
 			tcpm_set_cc(port, TYPEC_CC_OPEN);
 		else


