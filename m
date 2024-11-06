Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73E91D2784;
	Wed,  6 Nov 2024 12:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896164; cv=none; b=QhNa8beZRH+eT1GxsWqClGVyT1K9XhcJgOV9A2cxH8/GePHj/j7AIYqmywVD4q0kv+Gj5UCysB23SZKWuJLm/UIJBkIB8nuc4IKcrjyvf/q0jzMARZAMzyS4MrIx+TMIszDep1Vw1GDjGfPLE7nFf6yc/gOGKhIJMMmwaR2KcKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896164; c=relaxed/simple;
	bh=ZJAx4Xl0X7n13st99tXpspSDLqHcnkTsXf5wWUUiPPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWiqB8iIe0jgyqRcQzVTZIu+Dyweo/AmJfE3blWrpbwH90lr0jMI+3OAgD/gr26atyv3nDDMNrbjFE+Lz9n8iPE1MqYHdS6GnedWOaw9rv7wYj5NSfJ7GG2nntJRTG3fjDQcWL3UtMRIuE9jhWpZoJbyKZfjKu7vQIqkpS4JnmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4uTX0am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4uTX0am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B898C4CECD;
	Wed,  6 Nov 2024 12:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896164;
	bh=ZJAx4Xl0X7n13st99tXpspSDLqHcnkTsXf5wWUUiPPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4uTX0aml2PL7zFskbX/b/2EXotc/oZV+h3WmRDjHTz3WRod0Jb8OJoIUq8MSd/co
	 a8ttU5h7zOUkZ6RgHDcsqrBsoKTuyx/188XiKSM3jw890QV/M/wHntxri+0wkdteA8
	 IsT1V7TUEyFfNABJh+LdZXUCyTZMwZQnw6lrwrJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badhri Jagan Sridharan <badhri@google.com>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.11 110/245] usb: typec: tcpm: restrict SNK_WAIT_CAPABILITIES_TIMEOUT transitions to non self-powered devices
Date: Wed,  6 Nov 2024 13:02:43 +0100
Message-ID: <20241106120321.925291401@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Sunil Dhamne <amitsd@google.com>

commit afb92ad8733ef0a2843cc229e4d96aead80bc429 upstream.

PD3.1 spec ("8.3.3.3.3 PE_SNK_Wait_for_Capabilities State") mandates
that the policy engine perform a hard reset when SinkWaitCapTimer
expires. Instead the code explicitly does a GET_SOURCE_CAP when the
timer expires as part of SNK_WAIT_CAPABILITIES_TIMEOUT. Due to this the
following compliance test failures are reported by the compliance tester
(added excerpts from the PD Test Spec):

* COMMON.PROC.PD.2#1:
  The Tester receives a Get_Source_Cap Message from the UUT. This
  message is valid except the following conditions: [COMMON.PROC.PD.2#1]
    a. The check fails if the UUT sends this message before the Tester
       has established an Explicit Contract
    ...

* TEST.PD.PROT.SNK.4:
  ...
  4. The check fails if the UUT does not send a Hard Reset between
    tTypeCSinkWaitCap min and max. [TEST.PD.PROT.SNK.4#1] The delay is
    between the VBUS present vSafe5V min and the time of the first bit
    of Preamble of the Hard Reset sent by the UUT.

For the purpose of interoperability, restrict the quirk introduced in
https://lore.kernel.org/all/20240523171806.223727-1-sebastian.reichel@collabora.com/
to only non self-powered devices as battery powered devices will not
have the issue mentioned in that commit.

Cc: stable@vger.kernel.org
Fixes: 122968f8dda8 ("usb: typec: tcpm: avoid resets for missing source capability messages")
Reported-by: Badhri Jagan Sridharan <badhri@google.com>
Closes: https://lore.kernel.org/all/CAPTae5LAwsVugb0dxuKLHFqncjeZeJ785nkY4Jfd+M-tCjHSnQ@mail.gmail.com/
Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20241024022233.3276995-1-amitsd@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index fc619478200f..7ae341a40342 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4515,7 +4515,8 @@ static inline enum tcpm_state hard_reset_state(struct tcpm_port *port)
 		return ERROR_RECOVERY;
 	if (port->pwr_role == TYPEC_SOURCE)
 		return SRC_UNATTACHED;
-	if (port->state == SNK_WAIT_CAPABILITIES_TIMEOUT)
+	if (port->state == SNK_WAIT_CAPABILITIES ||
+	    port->state == SNK_WAIT_CAPABILITIES_TIMEOUT)
 		return SNK_READY;
 	return SNK_UNATTACHED;
 }
@@ -5043,8 +5044,11 @@ static void run_state_machine(struct tcpm_port *port)
 			tcpm_set_state(port, SNK_SOFT_RESET,
 				       PD_T_SINK_WAIT_CAP);
 		} else {
-			tcpm_set_state(port, SNK_WAIT_CAPABILITIES_TIMEOUT,
-				       PD_T_SINK_WAIT_CAP);
+			if (!port->self_powered)
+				upcoming_state = SNK_WAIT_CAPABILITIES_TIMEOUT;
+			else
+				upcoming_state = hard_reset_state(port);
+			tcpm_set_state(port, upcoming_state, PD_T_SINK_WAIT_CAP);
 		}
 		break;
 	case SNK_WAIT_CAPABILITIES_TIMEOUT:
-- 
2.47.0



