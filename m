Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE30684E07;
	Tue, 14 May 2024 10:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683684; cv=none; b=fqom4Foy9ub0wsdJox2Y1S8Wns2ih1VKw8rtHAv3UYqP6L5jSAvo6hXRPLNsu+YQ6caMCWidQQu59uBm/IQ5nU6ha4W1dm5v8uMRNFtaEMpEHnX5C4vCCKwW0/iyYZxjJy5vsFQLUuUnOOhTn897DAAW1mx/xHhMqQIQuwFcRDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683684; c=relaxed/simple;
	bh=NIAKor24Xmg9FhbGlTNSaoFhxtM3V0IR21u9OaWRvT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbTjYd+aoVBm5H1aZBtSA37ndUxgG7vJfRLo86bHczbH/RYLHwMLunD4FSddfeYWRsaRbOiMCciNym+CZM/ZcPiVjxd/UbAyYaU2sSE0+YLcFiEhPor6uICALrbz69yAmCL4HwCbXgbBGlWH+3+Y36shWUHvANV5Yuzqs989fB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaoNZaSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaoNZaSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4148BC2BD10;
	Tue, 14 May 2024 10:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683683;
	bh=NIAKor24Xmg9FhbGlTNSaoFhxtM3V0IR21u9OaWRvT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaoNZaSjEc7a8i2nzX91lYLOXlv95N1TU+wK2LYGN0jCrcRVAy3Kv6g1vO/nANcdf
	 8X9g7yzmVm8E/vMupP6pvgUnOSGkRdjiMTGiWrRSAKeZRiPiqpOT6UkEBV73Qie3rZ
	 uZqGWrc/vIJqTfNMeYI9TDIYbUpSfFQJdmAhogPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.8 256/336] usb: typec: tcpm: clear pd_event queue in PORT_RESET
Date: Tue, 14 May 2024 12:17:40 +0200
Message-ID: <20240514101048.282182559@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4873,6 +4873,7 @@ static void run_state_machine(struct tcp
 		break;
 	case PORT_RESET:
 		tcpm_reset_port(port);
+		port->pd_events = 0;
 		if (port->self_powered)
 			tcpm_set_cc(port, TYPEC_CC_OPEN);
 		else


