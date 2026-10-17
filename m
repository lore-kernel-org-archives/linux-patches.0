Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ADB3AA9F3;
	Sat, 17 Oct 2026 17:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256855; cv=none; b=o+f7dqKXoZRl+Q2/vK5jbFLPOp3VSD11UjAgAw8YUGZ7f+dLRVlkazu3yJ8DIHFB6znSejByUSTld6hAR1+j0sGDFfUDnvvKf320ocDYyfZ+szeEjXt5iyDIpNc6anES5jhglzSR+I3uSgtILWantdM1te4v9TN7ttCyb7tJi5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256855; c=relaxed/simple;
	bh=d1307RdUS+YraX3tbi29/gU9AO6FEJKyvoQtMHeLaaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PstO+GjdS2Gh7/jDhnzwaKH7+8YttrkuvJfo0W5eXQJdjignRlbuyNyehDdaAkY24SFZOcAqi+D1qbSgzmPTdv/vsIb8SKPYznKqS974bhMwYE5p9m6PDmui1j3JUmlzyDLIB2pJHm3TearIW5/bfaSGTYduL3MvwmsEGeHAbuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdDoquXn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdDoquXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E90C1F000C4;
	Sat, 17 Oct 2026 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256853;
	bh=6b1QdnehTcTnu5gMpX/RluDay5N7Rffr0SzEkHR8/dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WdDoquXnCV5AP40dvdbDczY8kgAHvPU6G3ZhsghU2uKi5X5GHhzH1hEyjukA4uFtz
	 QSs1j/ytqhf80DGpYGiJ7VdmXH9irDjkS18lV5hD96d9lCIIkjH2Zo+r9OSvo7nnc0
	 rxK2bc8/neEs8yxpaYmSM8ujHjbGJuMbJ26K/tnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0372/1674] usb: typec: tcpm: fix debug accessory mode detection for sink ports
Date: Sat, 17 Oct 2026 17:44:04 +0200
Message-ID: <20261017160440.664851777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit f6ec9bb4acc7182b25a793ad094a764e1cb819a7 ]

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

[Backport to 6.12: This tree lacks 8db73e6a42b6 and the associated
sink debug-accessory state-machine support. Retain only the source-debug
macro extraction and source-side call-site updates. Keep
tcpm_port_is_debug() source-only and omit the sink-debug macro and all
sink/audio attachment transitions introduced by the upstream dependency.
This preserves existing detection and state transitions while providing
tcpm_port_is_debug_source() for cd3b9cea675b ("usb: typec: tcpm: constrain
TCPM_SOURCING_VBUS event handling"). No functions are added.]

Stable-dep-of: cd3b9cea675b ("usb: typec: tcpm: constrain TCPM_SOURCING_VBUS event handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -531,9 +531,12 @@ static const char * const pd_rev[] = {
 	 (tcpm_cc_is_source((port)->cc2) && \
 	  !tcpm_cc_is_source((port)->cc1)))
 
-#define tcpm_port_is_debug(port) \
+#define tcpm_port_is_debug_source(port) \
 	(tcpm_cc_is_source((port)->cc1) && tcpm_cc_is_source((port)->cc2))
 
+#define tcpm_port_is_debug(port) \
+	tcpm_port_is_debug_source(port)
+
 #define tcpm_port_is_audio(port) \
 	(tcpm_cc_is_audio((port)->cc1) && tcpm_cc_is_audio((port)->cc2))
 
@@ -3974,7 +3977,7 @@ static void run_state_machine(struct tcp
 			tcpm_set_state(port, SNK_UNATTACHED, PD_T_DRP_SNK);
 		break;
 	case SRC_ATTACH_WAIT:
-		if (tcpm_port_is_debug(port))
+		if (tcpm_port_is_debug_source(port))
 			tcpm_set_state(port, DEBUG_ACC_ATTACHED,
 				       PD_T_CC_DEBOUNCE);
 		else if (tcpm_port_is_audio(port))
@@ -4998,7 +5001,7 @@ static void _tcpm_cc_change(struct tcpm_
 
 	switch (port->state) {
 	case TOGGLING:
-		if (tcpm_port_is_debug(port) || tcpm_port_is_audio(port) ||
+		if (tcpm_port_is_debug_source(port) || tcpm_port_is_audio(port) ||
 		    tcpm_port_is_source(port))
 			tcpm_set_state(port, SRC_ATTACH_WAIT, 0);
 		else if (tcpm_port_is_sink(port))
@@ -5009,7 +5012,7 @@ static void _tcpm_cc_change(struct tcpm_
 		break;
 	case SRC_UNATTACHED:
 	case ACC_UNATTACHED:
-		if (tcpm_port_is_debug(port) || tcpm_port_is_audio(port) ||
+		if (tcpm_port_is_debug_source(port) || tcpm_port_is_audio(port) ||
 		    tcpm_port_is_source(port))
 			tcpm_set_state(port, SRC_ATTACH_WAIT, 0);
 		break;


