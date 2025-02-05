Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675AE155333;
	Wed,  5 Feb 2025 15:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768144; cv=none; b=JtsqJp7/SUXQuKnB1cyj5mgStu7OB71VG9YqZwJi9VTdzoTt+ABOxlPPQMx72XyO7wbUHReCm3fDfTU7VS1ni8Y0i78GLXoCww3JtsL6hdTXiyEf5c2GbwsyKq7AHL9wzGxRBE0XBIuVahz+iqEGKKwOcHLODseEwIOcd+DZQ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768144; c=relaxed/simple;
	bh=In1/mOePGvPIWRMnbPbESVcJH5lJ3hd15MFaL/MbPD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnl6N65X9qgUNzw79/Tb9/76cyOdnRJildsfFoREcXB3f0Xuh6uAMlWRXlFh13nsLQvoBFiZn50DPABBI0dhoEqPaV5w3To1Tawx5NHYisZ9m1uDiMNe23GVFsbvbSuAbeDaMQAeKMnkoFTB/dcj7N6JmMikaPJIqvlX2ZvJoJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8WA5bWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8WA5bWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A4FC4CED1;
	Wed,  5 Feb 2025 15:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768144;
	bh=In1/mOePGvPIWRMnbPbESVcJH5lJ3hd15MFaL/MbPD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8WA5bWyD7/wRCJ/2aKRvyRCwhqWaj0+IDnYTIICJ6gMYuzb2cBsTlW+zCxvQ1PFR
	 5SiAyaYnHyMri+C6io9p3+oiXS9ZLll7yv46uA/4PVCP6rQnvi3+OwnFkmYcbNLsXn
	 //uvyJYWZNZR7OySJZ8BdkQK9AGr+Ya9gTAJdYR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jos Wang <joswang@lenovo.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.12 559/590] usb: typec: tcpm: set SRC_SEND_CAPABILITIES timeout to PD_T_SENDER_RESPONSE
Date: Wed,  5 Feb 2025 14:45:14 +0100
Message-ID: <20250205134516.654717451@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4757,7 +4757,7 @@ static void run_state_machine(struct tcp
 			port->caps_count = 0;
 			port->pd_capable = true;
 			tcpm_set_state_cond(port, SRC_SEND_CAPABILITIES_TIMEOUT,
-					    PD_T_SEND_SOURCE_CAP);
+					    PD_T_SENDER_RESPONSE);
 		}
 		break;
 	case SRC_SEND_CAPABILITIES_TIMEOUT:


