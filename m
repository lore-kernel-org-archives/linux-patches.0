Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4607CF1F;
	Wed,  3 Jul 2024 11:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005541; cv=none; b=DWeNtjRQl2zPLyLwJm6OeOq0nBIFimaDvHKJERfjs0SP8/ZXs1sJ1zicKgmNOKZjQmvH1yWW/c5vSphtitrKNtoBL6Eybu948Cejal7m1Bn42IX9b4tPc25kgNJtQt6C6JKf3eRGFje59V7HtJsgGeQsdEHQMqWYOBCjuf/28Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005541; c=relaxed/simple;
	bh=/koDuKThRHaXv9148oCZGVLexqe4dqCbg6cIs9H/TUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSw7BmAQoXjV6L/AUNehmMEz7lNhWnjyZ22p6P2BU8ZNRWLHbX6bTWE/R5X0rqxnLsQmJ71Y3L9C2PGwokkL2i4YZQczGIXRhjmmK9C0bmPJuEzR+Q6//1gx+w3MX8reOnxrwMjMaRdu/qaPd57Sjr8sE/tWvkfkTkqE5MUrneU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGbiJ81q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGbiJ81q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B8AC2BD10;
	Wed,  3 Jul 2024 11:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005541;
	bh=/koDuKThRHaXv9148oCZGVLexqe4dqCbg6cIs9H/TUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGbiJ81qiu9KW3TZYU4IALTRO27Efm2pt33juEIPyfnYgJZwfllO11otLWPTtvmPi
	 NKd/zEIxX+MT8c43cQ7IwNHTlYmrf7ZLQxxRex1ijQ+b5LEIj2zUrItSjrGyVcOcOe
	 9HRqWA6W659yXEMlJHELwz+o7dxdKU9a3Qof3LKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Tso <kyletso@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 075/356] usb: typec: tcpm: Ignore received Hard Reset in TOGGLING state
Date: Wed,  3 Jul 2024 12:36:51 +0200
Message-ID: <20240703102915.940785272@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Kyle Tso <kyletso@google.com>

commit fc8fb9eea94d8f476e15f3a4a7addeb16b3b99d6 upstream.

Similar to what fixed in Commit a6fe37f428c1 ("usb: typec: tcpm: Skip
hard reset when in error recovery"), the handling of the received Hard
Reset has to be skipped during TOGGLING state.

[ 4086.021288] VBUS off
[ 4086.021295] pending state change SNK_READY -> SNK_UNATTACHED @ 650 ms [rev2 NONE_AMS]
[ 4086.022113] VBUS VSAFE0V
[ 4086.022117] state change SNK_READY -> SNK_UNATTACHED [rev2 NONE_AMS]
[ 4086.022447] VBUS off
[ 4086.022450] state change SNK_UNATTACHED -> SNK_UNATTACHED [rev2 NONE_AMS]
[ 4086.023060] VBUS VSAFE0V
[ 4086.023064] state change SNK_UNATTACHED -> SNK_UNATTACHED [rev2 NONE_AMS]
[ 4086.023070] disable BIST MODE TESTDATA
[ 4086.023766] disable vbus discharge ret:0
[ 4086.023911] Setting usb_comm capable false
[ 4086.028874] Setting voltage/current limit 0 mV 0 mA
[ 4086.028888] polarity 0
[ 4086.030305] Requesting mux state 0, usb-role 0, orientation 0
[ 4086.033539] Start toggling
[ 4086.038496] state change SNK_UNATTACHED -> TOGGLING [rev2 NONE_AMS]

// This Hard Reset is unexpected
[ 4086.038499] Received hard reset
[ 4086.038501] state change TOGGLING -> HARD_RESET_START [rev2 HARD_RESET]

Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Tso <kyletso@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240520154858.1072347-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5351,6 +5351,7 @@ static void _tcpm_pd_hard_reset(struct t
 		port->tcpc->set_bist_data(port->tcpc, false);
 
 	switch (port->state) {
+	case TOGGLING:
 	case ERROR_RECOVERY:
 	case PORT_RESET:
 	case PORT_RESET_WAIT_OFF:


