Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B718F1DA314;
	Wed, 19 Mar 2025 14:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394942; cv=none; b=n3TM+EI3riwbCaqDrD2renbBrj/fQSnVmanfzE2XOakC0wWiRds4gr9o24NP3NdjToNnR2CyCGlT1QdGlPkkXwq66EfDcFCmK87Qcpziqf8+rZKnjf/UXOY8AurcZ90wEt6EpU3AFmFCGyBqPZ9ZfuyLnqFjeGMrQjdAMapns0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394942; c=relaxed/simple;
	bh=gu+GxRtE8PZ3JSfiC8J2EbW8/n/sSTy9WtcIP4vJnxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtOxxhrXs5wFD3MbXrqogEMeU35o2oHuRZLIQKbz5t0K7X3Q1bVRKYg3SVSyPLBXSts5q6W+i+7kVqzf4VgwFuQEUPTywnFWw4wbJuZ53UI3INowR6gJNwNh169QFandDvPyvtFrUsHp8C6+O3aYoLO/uBeTXalvfhm3qRf3TQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vfz8YRs8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vfz8YRs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325A2C4CEE4;
	Wed, 19 Mar 2025 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394941;
	bh=gu+GxRtE8PZ3JSfiC8J2EbW8/n/sSTy9WtcIP4vJnxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vfz8YRs81zkLKKikDnNNm+13Ln5hRAYQj6p1krf+lLuAcKbYiPCqDHEAPdeLIUUBN
	 tzWBHE05UcrPoLjCjgiYIfmsZ8v9CTjerex6RwOokrRKwh5NP3DVPNoEXpj4GUAAFJ
	 uYnI4fTz8hbTYTQcJDC7NKFic69CPqRLOfZvbjcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Sunil Dhamne <amitsd@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.13 162/241] usb: typec: tcpm: fix state transition for SNK_WAIT_CAPABILITIES state in run_state_machine()
Date: Wed, 19 Mar 2025 07:30:32 -0700
Message-ID: <20250319143031.734487196@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Sunil Dhamne <amitsd@google.com>

commit f2865c6300d75a9f187dd7918d248e010970fd44 upstream.

A subtle error got introduced while manually fixing merge conflict in
tcpm.c for commit 85c4efbe6088 ("Merge v6.12-rc6 into usb-next"). As a
result of this error, the next state is unconditionally set to
SNK_WAIT_CAPABILITIES_TIMEOUT while handling SNK_WAIT_CAPABILITIES state
in run_state_machine(...).

Fix this by setting new state of TCPM state machine to `upcoming_state`
(that is set to different values based on conditions).

Cc: stable@vger.kernel.org
Fixes: 85c4efbe60888 ("Merge v6.12-rc6 into usb-next")
Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250310-fix-snk-wait-timeout-v6-14-rc6-v1-1-5db14475798f@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5067,16 +5067,16 @@ static void run_state_machine(struct tcp
 		 */
 		if (port->vbus_never_low) {
 			port->vbus_never_low = false;
-			tcpm_set_state(port, SNK_SOFT_RESET,
-				       port->timings.sink_wait_cap_time);
+			upcoming_state = SNK_SOFT_RESET;
 		} else {
 			if (!port->self_powered)
 				upcoming_state = SNK_WAIT_CAPABILITIES_TIMEOUT;
 			else
 				upcoming_state = hard_reset_state(port);
-			tcpm_set_state(port, SNK_WAIT_CAPABILITIES_TIMEOUT,
-				       port->timings.sink_wait_cap_time);
 		}
+
+		tcpm_set_state(port, upcoming_state,
+			       port->timings.sink_wait_cap_time);
 		break;
 	case SNK_WAIT_CAPABILITIES_TIMEOUT:
 		/*


