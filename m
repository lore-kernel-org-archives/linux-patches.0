Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE16B3D382;
	Thu, 30 Nov 2023 16:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baS9F1NY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BC1C433C7;
	Thu, 30 Nov 2023 16:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701362039;
	bh=Xbngd4lGEmR9Fw1SpdlHvBZbSj0lKvrZvBle3TqR/Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baS9F1NYm3SDJfdw8FQ8fv11f10IgJjuWWfcPiCphQXp7SSH5gjahMydvw3ygFP8I
	 S7dFR83vQj8berYmvhN5Uga5PNy4lkJsjamABQn+j+2F3FMrpdNMJBsgdCmiCyFP/f
	 r6iMFbMUKl0fc97sWWDZIr2mO+Vd+ptHCOuuWNlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogeus <heikki.krogerus@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 63/69] usb: typec: tcpm: Skip hard reset when in error recovery
Date: Thu, 30 Nov 2023 16:23:00 +0000
Message-ID: <20231130162135.141506284@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Badhri Jagan Sridharan <badhri@google.com>

commit a6fe37f428c19dd164c2111157d4a1029bd853aa upstream.

Hard reset queued prior to error recovery (or) received during
error recovery will make TCPM to prematurely exit error recovery
sequence. Ignore hard resets received during error recovery (or)
port reset sequence.

```
[46505.459688] state change SNK_READY -> ERROR_RECOVERY [rev3 NONE_AMS]
[46505.459706] state change ERROR_RECOVERY -> PORT_RESET [rev3 NONE_AMS]
[46505.460433] disable vbus discharge ret:0
[46505.461226] Setting usb_comm capable false
[46505.467244] Setting voltage/current limit 0 mV 0 mA
[46505.467262] polarity 0
[46505.470695] Requesting mux state 0, usb-role 0, orientation 0
[46505.475621] cc:=0
[46505.476012] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms [rev3 NONE_AMS]
[46505.476020] Received hard reset
[46505.476024] state change PORT_RESET -> HARD_RESET_START [rev3 HARD_RESET]
```

Cc: stable@vger.kernel.org
Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Acked-by: Heikki Krogeus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20231101021909.2962679-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5350,6 +5350,15 @@ static void _tcpm_pd_hard_reset(struct t
 	if (port->bist_request == BDO_MODE_TESTDATA && port->tcpc->set_bist_data)
 		port->tcpc->set_bist_data(port->tcpc, false);
 
+	switch (port->state) {
+	case ERROR_RECOVERY:
+	case PORT_RESET:
+	case PORT_RESET_WAIT_OFF:
+		return;
+	default:
+		break;
+	}
+
 	if (port->ams != NONE_AMS)
 		port->ams = NONE_AMS;
 	if (port->hard_reset_count < PD_N_HARD_RESET_COUNT)


