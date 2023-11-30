Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2729E524C2;
	Thu, 30 Nov 2023 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jT1epUCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA820C433C7;
	Thu, 30 Nov 2023 16:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361670;
	bh=JnXcdVlFU7SQbQQlm5BtNGTEVWSW6SRsLjK+U3SbKKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jT1epUCe3e7UuudVsMC6S5AvhB9ufBYMjrqLILfP182QzJQ0qsiVBS7unm9pBt9pj
	 orRhEjlQL1cBZcVfs94is3/ozivCLLobjYuGyoP1itgFxoLL+T60f8rmtjao0UCUq9
	 SNaRTdrGsPXn2FZOCNxCg7XSYvxFXlUTFwzKIguM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badhri Jagan Sridharan <badhri@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Will McVicker <willmcvicker@google.com>
Subject: [PATCH 6.6 106/112] usb: typec: tcpm: Fix sink caps op current check
Date: Thu, 30 Nov 2023 16:22:33 +0000
Message-ID: <20231130162143.654678478@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Badhri Jagan Sridharan <badhri@google.com>

commit 187fb003c57c964ea61ac9fbfe41abf3ca9973eb upstream.

TCPM checks for sink caps operational current even when PD is disabled.
This incorrectly sets tcpm_set_charge() when PD is disabled.
Check for sink caps only when PD is enabled.

[   97.572342] Start toggling
[   97.578949] CC1: 0 -> 0, CC2: 0 -> 0 [state TOGGLING, polarity 0, disconnected]
[   99.571648] CC1: 0 -> 0, CC2: 0 -> 4 [state TOGGLING, polarity 0, connected]
[   99.571658] state change TOGGLING -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
[   99.571673] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev3 NONE_AMS]
[   99.741778] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 170 ms]
[   99.789283] CC1: 0 -> 0, CC2: 4 -> 5 [state SNK_DEBOUNCED, polarity 0, connected]
[   99.789306] state change SNK_DEBOUNCED -> SNK_DEBOUNCED [rev3 NONE_AMS]
[   99.903584] VBUS on
[   99.903591] state change SNK_DEBOUNCED -> SNK_ATTACHED [rev3 NONE_AMS]
[   99.903600] polarity 1
[   99.910155] enable vbus discharge ret:0
[   99.910160] Requesting mux state 1, usb-role 2, orientation 2
[   99.946791] state change SNK_ATTACHED -> SNK_STARTUP [rev3 NONE_AMS]
[   99.946798] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[   99.946800] Setting voltage/current limit 5000 mV 500 mA
[   99.946803] vbus=0 charge:=1
[  100.027139] state change SNK_DISCOVERY -> SNK_READY [rev3 NONE_AMS]
[  100.027145] Setting voltage/current limit 5000 mV 3000 mA
[  100.466830] VBUS on

Cc: stable@vger.kernel.org
Fixes: 803b1c8a0cea ("usb: typec: tcpm: not sink vbus if operational current is 0mA")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Will McVicker <willmcvicker@google.com>
Link: https://lore.kernel.org/r/20231101012845.2701348-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index b386102f7a3a..bfb6f9481e87 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4273,7 +4273,8 @@ static void run_state_machine(struct tcpm_port *port)
 				current_lim = PD_P_SNK_STDBY_MW / 5;
 			tcpm_set_current_limit(port, current_lim, 5000);
 			/* Not sink vbus if operational current is 0mA */
-			tcpm_set_charge(port, !!pdo_max_current(port->snk_pdo[0]));
+			tcpm_set_charge(port, !port->pd_supported ||
+					pdo_max_current(port->snk_pdo[0]));
 
 			if (!port->pd_supported)
 				tcpm_set_state(port, SNK_READY, 0);
-- 
2.43.0



