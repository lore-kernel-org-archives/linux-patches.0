Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9E123314A;
	Mon, 10 Mar 2025 17:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629149; cv=none; b=sLa7SS6Bfnr0mkwi9/hDIGAou2zPSeuFNDRMJp7rwrUPP+2AIOTVpAy/r0aQaorpqKSknT9YSpTRYxe3J5CtEL65g7u3JDlRBbIZ9Z5sGtLpOm25k2/Me5Oqexf/a8Winkq0LHCtoIJwPNPZr+qCYMOxa2cKCXGThplsxE8Dfgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629149; c=relaxed/simple;
	bh=UKYCoCKCrNIOts4UL8CpcWHAjQDY5natngj4grisNwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWVqUna1UijmqFZAJvK5iEONeH+QNTeXfuIEzN4GriJ0zsEcwA4BfYD+GLYujtG8WeMuPRlJMm7H+C02MT33wHBM+1OzK8L/Zjb71vxDvKFz8giPcA/bg3vKfTR4fZAjZWcoxyDzL3e1rvtE0IakJ1jXqcw28hAfQ0auttk8+YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgAT/3Y4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgAT/3Y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FAEC4CEE5;
	Mon, 10 Mar 2025 17:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629149;
	bh=UKYCoCKCrNIOts4UL8CpcWHAjQDY5natngj4grisNwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgAT/3Y4+o5MHmFmBhcw3Mrdv1mDSaRI6i62iT9vdAb0JArn5+0xAvM/yNhQCJQLy
	 1ygPQ5SissSNul1RvXPHf1XJQ0tvoUJ7uEXYTII3JwZLXthg62kzWVxOmjD6WMpYe3
	 WVh9IPenQdIuQFRhmKX5R5fM3WYzMXveOPUMH9jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jos Wang <joswang@lenovo.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 5.15 195/620] usb: typec: tcpm: set SRC_SEND_CAPABILITIES timeout to PD_T_SENDER_RESPONSE
Date: Mon, 10 Mar 2025 18:00:41 +0100
Message-ID: <20250310170553.329810550@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jos Wang <joswang@lenovo.com>

commit 2eb3da037c2c20fa30bc502bc092479b2a1aaae2 upstream.

As PD2.0 spec ("8.3.3.2.3 PE_SRC_Send_Capabilities state"), after the
Source receives the GoodCRC Message from the Sink in response to the
Source_Capabilities message, it should start the SenderResponseTimer,
after the timer times out, the state machine transitions to the
HARD_RESET state.

Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable@vger.kernel.org
Signed-off-by: Jos Wang <joswang@lenovo.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20250105135245.7493-1-joswang1221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4042,7 +4042,7 @@ static void run_state_machine(struct tcp
 			port->caps_count = 0;
 			port->pd_capable = true;
 			tcpm_set_state_cond(port, SRC_SEND_CAPABILITIES_TIMEOUT,
-					    PD_T_SEND_SOURCE_CAP);
+					    PD_T_SENDER_RESPONSE);
 		}
 		break;
 	case SRC_SEND_CAPABILITIES_TIMEOUT:


