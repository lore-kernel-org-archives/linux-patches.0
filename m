Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F403BB126;
	Tue, 12 May 2026 17:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608353; cv=none; b=OEmk+TQvewR8lMx61+KZ4bUPUtEer1/oQPyeyqlYfFc+zy1d2JXarhhucWovP2jhTKTrgwo8y3c+g61nQK9w015nEub5SdUAyyu8x3DWio2I4qM7o1GbdgCSFkvnMwduUAS0QQzJ/uq/flIRSi5YgPzbTHuQ5Ziwg0KTBGAzeK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608353; c=relaxed/simple;
	bh=LFx6/PeTl3wLa7Jl7Ed8BLbZNA2J297lY+vzOSlvOgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pG4LglOX3HVRK2SdkpqK9ALyZNe6v9+XPEGxslNvldT453elkbtuDOxXBX8hbM707PPKLdA0ptwSQRMBjaxDHtqbd3O28+TY4DwYy3CEWMqi6h1xPHXqJwa4jXZZsRUCaJOrggI+sQMYfCGXAaR1G15K1FvS9CUjel4zc4/vq88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSed/4Qu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSed/4Qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6ADDC2BCB0;
	Tue, 12 May 2026 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608353;
	bh=LFx6/PeTl3wLa7Jl7Ed8BLbZNA2J297lY+vzOSlvOgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSed/4QuNLkj7+YynDVEwKBuDDwZ7DMiAGCMWoV7wPbLMXOYHsss011tIWE9kVYpu
	 50UoQO86FrRb6AkKP9eMYOt4YRwFGVQsVLvg9GtpLuXDvi01kiKJjsqTqU+KgkDUBE
	 r6Q9QvxHujKKrSJGMuL1zunmRn6EWrFDBU3W2HyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Amit Sunil Dhamne <amitsd@google.com>
Subject: [PATCH 6.18 047/270] usb: typec: tcpm: fix debug accessory mode detection for sink ports
Date: Tue, 12 May 2026 19:37:28 +0200
Message-ID: <20260512173939.442266139@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit f6ec9bb4acc7182b25a793ad094a764e1cb819a7 upstream.

The port in debug accessory mode can be either a source or sink. The
previous tcpm_port_is_debug() function only checked for source port.

Commit 8db73e6a42b6 ("usb: typec: tcpm: allow sink (ufp) to toggle into
accessory mode debug") changed the detection logic to support both roles,
but left some logic in _tcpm_cc_change() unchanged, This causes the state
machine to transition to an incorrect state when operating as a sink in
debug accessory mode. Log as below:

[  978.637541] CC1: 0 -> 5, CC2: 0 -> 5 [state TOGGLING, polarity 0, connected]
[  978.637567] state change TOGGLING -> SRC_ATTACH_WAIT [rev1 NONE_AMS]
[  978.637596] pending state change SRC_ATTACH_WAIT -> DEBUG_ACC_ATTACHED @ 180 ms [rev1 NONE_AMS]
[  978.647098] CC1: 5 -> 0, CC2: 5 -> 5 [state SRC_ATTACH_WAIT, polarity 0, connected]
[  978.647115] state change SRC_ATTACH_WAIT -> SRC_ATTACH_WAIT [rev1 NONE_AMS]

It should go to SNK_ATTACH_WAIT instead of SRC_ATTACH_WAIT state.

To fix this, add tcpm_port_is_debug_source() and tcpm_port_is_debug_sink()
helper to explicitly identify the power mode in debug accessory mode.
Update the state transition logic in _tcpm_cc_change() to ensure the state
machine transitions comply with Type-C specification. Also update the logic
in run_state_machine() to keep consistency.

Fixes: 8db73e6a42b6 ("usb: typec: tcpm: allow sink (ufp) to toggle into accessory mode debug")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Amit Sunil Dhamne <amitsd@google.com>
Link: https://patch.msgid.link/20260424074009.2979266-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -634,9 +634,14 @@ static const char * const pd_rev[] = {
 	 (tcpm_cc_is_source((port)->cc2) && \
 	  !tcpm_cc_is_source((port)->cc1)))
 
+#define tcpm_port_is_debug_source(port) \
+	(tcpm_cc_is_source((port)->cc1) && tcpm_cc_is_source((port)->cc2))
+
+#define tcpm_port_is_debug_sink(port) \
+	(tcpm_cc_is_sink((port)->cc1) && tcpm_cc_is_sink((port)->cc2))
+
 #define tcpm_port_is_debug(port) \
-	((tcpm_cc_is_source((port)->cc1) && tcpm_cc_is_source((port)->cc2)) || \
-	 (tcpm_cc_is_sink((port)->cc1) && tcpm_cc_is_sink((port)->cc2)))
+	(tcpm_port_is_debug_source(port) || tcpm_port_is_debug_sink(port))
 
 #define tcpm_port_is_audio(port) \
 	(tcpm_cc_is_audio((port)->cc1) && tcpm_cc_is_audio((port)->cc2))
@@ -4799,7 +4804,7 @@ static void run_state_machine(struct tcp
 			tcpm_set_state(port, SNK_UNATTACHED, PD_T_DRP_SNK);
 		break;
 	case SRC_ATTACH_WAIT:
-		if (tcpm_port_is_debug(port))
+		if (tcpm_port_is_debug_source(port))
 			tcpm_set_state(port, DEBUG_ACC_ATTACHED,
 				       port->timings.cc_debounce_time);
 		else if (tcpm_port_is_audio(port))
@@ -5057,7 +5062,7 @@ static void run_state_machine(struct tcp
 			tcpm_set_state(port, SRC_UNATTACHED, PD_T_DRP_SRC);
 		break;
 	case SNK_ATTACH_WAIT:
-		if (tcpm_port_is_debug(port))
+		if (tcpm_port_is_debug_sink(port))
 			tcpm_set_state(port, DEBUG_ACC_ATTACHED,
 				       PD_T_CC_DEBOUNCE);
 		else if (tcpm_port_is_audio(port))
@@ -5077,7 +5082,7 @@ static void run_state_machine(struct tcp
 		if (tcpm_port_is_disconnected(port))
 			tcpm_set_state(port, SNK_UNATTACHED,
 				       PD_T_PD_DEBOUNCE);
-		else if (tcpm_port_is_debug(port))
+		else if (tcpm_port_is_debug_sink(port))
 			tcpm_set_state(port, DEBUG_ACC_ATTACHED,
 				       PD_T_CC_DEBOUNCE);
 		else if (tcpm_port_is_audio(port))
@@ -5950,10 +5955,10 @@ static void _tcpm_cc_change(struct tcpm_
 
 	switch (port->state) {
 	case TOGGLING:
-		if (tcpm_port_is_debug(port) || tcpm_port_is_audio(port) ||
+		if (tcpm_port_is_debug_source(port) || tcpm_port_is_audio(port) ||
 		    tcpm_port_is_source(port))
 			tcpm_set_state(port, SRC_ATTACH_WAIT, 0);
-		else if (tcpm_port_is_sink(port))
+		else if (tcpm_port_is_debug_sink(port) || tcpm_port_is_sink(port))
 			tcpm_set_state(port, SNK_ATTACH_WAIT, 0);
 		break;
 	case CHECK_CONTAMINANT:
@@ -5961,9 +5966,11 @@ static void _tcpm_cc_change(struct tcpm_
 		break;
 	case SRC_UNATTACHED:
 	case ACC_UNATTACHED:
-		if (tcpm_port_is_debug(port) || tcpm_port_is_audio(port) ||
+		if (tcpm_port_is_debug_source(port) || tcpm_port_is_audio(port) ||
 		    tcpm_port_is_source(port))
 			tcpm_set_state(port, SRC_ATTACH_WAIT, 0);
+		else if (tcpm_port_is_debug_sink(port))
+			tcpm_set_state(port, SNK_ATTACH_WAIT, 0);
 		break;
 	case SRC_ATTACH_WAIT:
 		if (tcpm_port_is_disconnected(port) ||
@@ -5985,7 +5992,7 @@ static void _tcpm_cc_change(struct tcpm_
 		}
 		break;
 	case SNK_UNATTACHED:
-		if (tcpm_port_is_debug(port) || tcpm_port_is_audio(port) ||
+		if (tcpm_port_is_debug_sink(port) || tcpm_port_is_audio(port) ||
 		    tcpm_port_is_sink(port))
 			tcpm_set_state(port, SNK_ATTACH_WAIT, 0);
 		break;


