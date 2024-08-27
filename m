Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FF81BFE04;
	Tue, 27 Aug 2024 15:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770915; cv=none; b=HH8SAU3TnmMjGat1L1HaA1GM4seMDcSRdBVCxK0bK6uH+Sdt9g/fI43444WB9Ns7hv05+SRLARX/7XEnRTET3RZYvQSa24VvDa5+CobuLkEQK2/01fSDB1oB5ESXexaaTF+mqV7E4+g6jmJO2y9mmSyRl34Xz/H6OsYyKaJEmp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770915; c=relaxed/simple;
	bh=8nhgT07aqdGVt0XNg0js9di5znO2TjEo6FkUr4ii+mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOMUf2AhpoFdYNFq/6Q341gWSs+zdq99yWt/dZ0P6qjOg/zwp2nczmXsYilhTFfAlb2+r48doFS01jLSg92JhNpMCWnEdKbWxu4eNMdBs5l5LraKqm5rDhek7k56QjoAb+ESjV3wzR5T1nKjlsZUrc8D9o86VJSwnVTEGLktwgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSnrKgDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSnrKgDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF36C4DDF7;
	Tue, 27 Aug 2024 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770915;
	bh=8nhgT07aqdGVt0XNg0js9di5znO2TjEo6FkUr4ii+mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSnrKgDiyZXsGWTQ+XQGvKntnY2qo534iXe8uEX8uYicIsEeItM1s4Zd1zyZGp3Is
	 3b2QN/yGgGIYLDXTK/v6f9XZ0kNdqXkbmSqbKH7J7GMJG8dTJUgmG23PdU02gNInE3
	 9V4bu7+NgkK2gK55q6NdVlOJDWScNPtqLNMRw9eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.10 007/273] Revert "usb: typec: tcpm: clear pd_event queue in PORT_RESET"
Date: Tue, 27 Aug 2024 16:35:31 +0200
Message-ID: <20240827143833.660860444@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5630,7 +5630,6 @@ static void run_state_machine(struct tcp
 		break;
 	case PORT_RESET:
 		tcpm_reset_port(port);
-		port->pd_events = 0;
 		if (port->self_powered)
 			tcpm_set_cc(port, TYPEC_CC_OPEN);
 		else


