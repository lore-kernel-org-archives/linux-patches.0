Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5199513A411;
	Tue, 14 May 2024 11:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685883; cv=none; b=DAdiJBGKBaQC3EX7ebGe6SsiZULsELKhGYyTp0vHDseOLnaSRaqkLsJoUBXcgBJ94c0iRMb/N4sFk6S1DeG8KlhBI/cDV73zqPXIj6INjEHTz7Qsw9tm0UPJjU/eFI7bZl/2A7tAvwazn467mKMBNwd0WqjWUdhWc9o72A54al4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685883; c=relaxed/simple;
	bh=bO9zEQQ1ufM5ROwci3GstjHq2HynpcBeXUvb67PlYvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcDiFAZh988fG2ZjE0KZ9WpEGze5unwupBqXZl7fqTUh1Wdoy1RrCUkEShkTdm91//yuIxZz2CPq6AF4MacEBaknBU/9K/eL80qS8OPR7orrhoF9LeGYqez8uDcjmsmppFdf90yAL5jTz9mWvsZp4Pdm+hlS9+PvN59V1vC5+Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFSZUPpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFSZUPpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FD7C2BD10;
	Tue, 14 May 2024 11:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685883;
	bh=bO9zEQQ1ufM5ROwci3GstjHq2HynpcBeXUvb67PlYvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFSZUPpKZEMbkK2vNdbD+ZULsDkaUgrzIc2wEQmd8Ca9qDjOKA8XJjxmGCjmrXgqt
	 m0kny73nJG9h73nexgVOFHsEZ9Q2QuLHh3HVmueSyAA9sAP78EPbs4hVzVHMYmGD7F
	 vNs4CBr6ZB2Cjs540Pt46LhzmhFmu+ehqUPBYabo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 236/301] usb: typec: tcpm: clear pd_event queue in PORT_RESET
Date: Tue, 14 May 2024 12:18:27 +0200
Message-ID: <20240514101041.164945813@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: RD Babiera <rdbabiera@google.com>

commit bf20c69cf3cf9c6445c4925dd9a8a6ca1b78bfdf upstream.

When a Fast Role Swap control message attempt results in a transition
to ERROR_RECOVERY, the TCPC can still queue a TCPM_SOURCING_VBUS event.

If the event is queued but processed after the tcpm_reset_port() call
in the PORT_RESET state, then the following occurs:
1. tcpm_reset_port() calls tcpm_init_vbus() to reset the vbus sourcing and
sinking state
2. tcpm_pd_event_handler() turns VBUS on before the port is in the default
state.
3. The port resolves as a sink. In the SNK_DISCOVERY state,
tcpm_set_charge() cannot set vbus to charge.

Clear pd events within PORT_RESET to get rid of non-applicable events.

Fixes: b17dd57118fe ("staging: typec: tcpm: Improve role swap with non PD capable partners")
Cc: stable@vger.kernel.org
Signed-off-by: RD Babiera <rdbabiera@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240423202715.3375827-2-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4859,6 +4859,7 @@ static void run_state_machine(struct tcp
 		break;
 	case PORT_RESET:
 		tcpm_reset_port(port);
+		port->pd_events = 0;
 		if (port->self_powered)
 			tcpm_set_cc(port, TYPEC_CC_OPEN);
 		else


