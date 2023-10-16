Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379111A58C
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfeTIe7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EF8C433C7;
	Mon, 16 Oct 2023 09:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697447129;
	bh=VU/H3JBm9wBiWwSyIrFNF/jNku0wKoatv3vzkzUWzdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfeTIe7owpZRp03wovd1xJ52OU4/nr2jataS//B6BiLY+quRpr+MAnXrhPdJKxy0o
	 rpmGFzzIXCsl0y7aORJMg36ETgUIpe8axakgwpC6PSg8EfsZvBw+n6ekcJwyl3aycT
	 UbT2VCZv9YX4Fr3wuW7vhYnBLmQz7pRjzU/+rmXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 121/131] usb: typec: altmodes/displayport: Signal hpd low when exiting mode
Date: Mon, 16 Oct 2023 10:41:44 +0200
Message-ID: <20231016084003.072906693@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: RD Babiera <rdbabiera@google.com>

commit 89434b069e460967624903b049e5cf5c9e6b99b9 upstream.

Upon receiving an ACK for a sent EXIT_MODE message, the DisplayPort
driver currently resets the status and configuration of the port partner.
The hpd signal is not updated despite being part of the status, so the
Display stack can still transmit video despite typec_altmode_exit placing
the lanes in a Safe State.

Set hpd to low when a sent EXIT_MODE message is ACK'ed.

Fixes: 0e3bb7d6894d ("usb: typec: Add driver for DisplayPort alternate mode")
Cc: stable@vger.kernel.org
Signed-off-by: RD Babiera <rdbabiera@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20231009210057.3773877-2-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -301,6 +301,11 @@ static int dp_altmode_vdm(struct typec_a
 		case CMD_EXIT_MODE:
 			dp->data.status = 0;
 			dp->data.conf = 0;
+			if (dp->hpd) {
+				drm_connector_oob_hotplug_event(dp->connector_fwnode);
+				dp->hpd = false;
+				sysfs_notify(&dp->alt->dev.kobj, "displayport", "hpd");
+			}
 			break;
 		case DP_CMD_STATUS_UPDATE:
 			dp->data.status = *vdo;


