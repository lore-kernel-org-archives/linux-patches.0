Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EC124A06D;
	Tue, 13 Oct 2026 12:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895070; cv=none; b=CbIk8JCho4Rwwrwxrnc4DRKXzoGhw7KchN8YYh4dGrqDmu4VQzs3Pb0llpw2VHLW1bt9M9+hc4eCtpSLjTFq6CY1UGqmWwcedL5mB4P/dKACWoUrqdUvLRz/R447fdDtHlz+AqrKpEjwIUtccZ8AnH/Co6MMh4/rdclZEBX63EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895070; c=relaxed/simple;
	bh=NAWULQWfbzU/6UPih0jk3ruBb5KfYKIwd9f3VOSuj8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7HlW102x1vpw0ogBkznzmjB2c1N3qckU9eUQOBt9mg0+5izT47D6dNjVBVtFG6wGhAoZVcoje8vMBfPpvSG0uKrki17jJreuJEquXQPQGJRVMiaI5Dv7Gis+zuQz9GFdAlLQW8Ahq2toVXXn+3Q4l4rpqUiXg2XRW/iZ/M4LpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nuQVbSC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nuQVbSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51871F000FF;
	Tue, 13 Oct 2026 12:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895069;
	bh=mcIExbEx5L4px7paMNwNakczg7a5mNP8kHwbMwC3/zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2nuQVbSCuEP6YrqtKeYdJ64PY6v6LWu4MsBkDLlWcorJ/Ld9CjaKIeMhAEnV/l84p
	 u+LjGjFuFZKQUprGSqpg05DZXmOpFBAut1iYu3bpYLxAZzXDZtVyl+Ftod1iIeUnHg
	 DLsueIzYh78onTyQtby95MbCn8eKpiSU4f/DLsnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 151/497] usb: typec: tcpm: recover after failure to start the frs ams
Date: Tue, 13 Oct 2026 13:35:18 +0200
Message-ID: <20261013112911.470583219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -6379,7 +6379,7 @@ static void tcpm_pd_event_handler(struct
 				port->upcoming_state = FR_SWAP_SEND;
 				ret = tcpm_ams_start(port, FAST_ROLE_SWAP);
 				if (ret == -EAGAIN)
-					port->upcoming_state = INVALID_STATE;
+					tcpm_set_state(port, ERROR_RECOVERY, 0);
 			} else {
 				tcpm_log(port, "Discarding FRS_SIGNAL! Not in sink ready");
 			}


