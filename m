Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC34B3D9DCE;
	Fri,  9 Oct 2026 14:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556779; cv=none; b=cIBrN/ZKPXlZrTugJnYshqkdzancksjbTdZpZpe+4fofWyVqtryx7dQlSs7UAsXbKxX0Te/QhS4/ASx7CHx9Htr6rz+fUmyhPmAkyqdkr48VcoAPsPial6BiWLZ6ghkNvqDQKA4G6iTQ0DFFsupFAjlu+HJXpZSa9ai9BC4SEsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556779; c=relaxed/simple;
	bh=NNvl3hjAKUhDsd0pUXveRW0UKHa0UlySDuy8VVrBYMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ervt24ZG6tamtdM+/3QSQx7tq2ZOJBlp8pg/VGwIMBZj68hlVjeNLV2JEYwg2jkT3SBXAJgMDtuiMk+THJnGUVgwZLxaoH902wovVuFiWAqQEJkrveZ/9dA8y2FxmKsGAGEOmogaYFfFiVr3k7Sh/GvyslkgBSA897QNdfgL8DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1PVWWgb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1PVWWgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2766D1F000FF;
	Fri,  9 Oct 2026 14:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556778;
	bh=Wsfsdpsh2XgPuudwQdJSGnE4ccMF+Hi8V0g2oYwyiUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w1PVWWgbHlFyYSL5DFCk81XIeVfGXMFEltIljpyGGsL6tDxE0lLWHyq5LjArpAztC
	 cBwdRO0cBRmL9OJnV1XfyPCN++P60vVwkE0l3n4bUj9wPqPqUwqbR6XwIAxTVQKGZl
	 IDZAlRpDzK341u8PsEgNiAyrcbZ5t0aeeG0iazBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.2 227/428] usb: typec: tcpm: recover after failure to start the frs ams
Date: Fri,  9 Oct 2026 16:09:24 +0200
Message-ID: <20261009140951.101667187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Sunil Dhamne <amitsd@google.com>

commit 90156585765b29304f07b0e4a1c56a969876fcfc upstream.

Reset the port if the tcpm fails to start the FAST_ROLE_SWAP AMS by
initiating error recovery on it.

This helps in cases where some cables (incorrectly) signal an FRS to
an FRS capable port during disconnection. The TCPC autonomously starts
sourcing VBUS on detecting the FRS signal. However, the VBUS sourcing is
left on when the FAST_ROLE_SWAP AMS fails to start (as tcpm_sink_tx_ok
is 0 as CC is open due to the cable disconnect). This is because the
code sets the state to INVALID_STATE without resetting the port state.

Log snippet before changes:
[  101.401960] AMS FAST_ROLE_SWAP start
[  101.401971] Sink TX No Go
[  101.401982] sourcing vbus
[  101.401987] VBUS on
[  101.402159] VBUS on
[  109.257809] CC1: 0 -> 0, CC2: 5 -> 0 [state SNK_READY, polarity 1, disconnected]
[  111.267442] VBUS on

After changes:
[   70.541211] AMS FAST_ROLE_SWAP start
[   70.541220] Sink TX No Go
[   70.541228] state change SNK_READY -> ERROR_RECOVERY [rev3 NONE_AMS]
[   70.541362] VBUS on
[   70.541365] sourcing vbus
[   70.541367] VBUS on
[   70.541374] state change ERROR_RECOVERY -> PORT_RESET [rev3 NONE_AMS]
[   70.541410] disable vbus discharge ret:0
[   70.543028] Setting usb_comm capable false
[   70.544009] Setting voltage/current limit 0 mV 0 mA
[   70.544034] polarity 0
[   70.544239] Requesting mux state 0, usb-role 0, orientation 0
[   70.555550] cc:=0
[   70.555595] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms [rev3 NONE_AMS]
[   70.555697] VBUS off
[   70.555702] VBUS VSAFE0V
[   70.555762] CC1: 5 -> 0, CC2: 0 -> 0 [state PORT_RESET, polarity 0, disconnected]
[   70.587794] VBUS off
[   70.587799] VBUS VSAFE0V
[   70.655672] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 ms]
[   70.655682] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev3 NONE_AMS]
[   70.655686] Start toggling
[   70.656274] CC1: 0 -> 0, CC2: 0 -> 0 [state TOGGLING, polarity 0, disconnected]

Fixes: 0908c5aca31e ("usb: typec: tcpm: AMS and Collision Avoidance")
Cc: stable <stable@kernel.org>
Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260903-frs-error-handling-v1-1-ad0fee541847@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -6915,7 +6915,7 @@ static void tcpm_pd_event_handler(struct
 				port->upcoming_state = FR_SWAP_SEND;
 				ret = tcpm_ams_start(port, FAST_ROLE_SWAP);
 				if (ret == -EAGAIN)
-					port->upcoming_state = INVALID_STATE;
+					tcpm_set_state(port, ERROR_RECOVERY, 0);
 			} else {
 				tcpm_log(port, "Discarding FRS_SIGNAL! Not in sink ready");
 			}


