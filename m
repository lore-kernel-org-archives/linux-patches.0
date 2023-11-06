Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A67B18AE4
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 11:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Izn9g4oU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD00EC433C8;
	Mon,  6 Nov 2023 11:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699269820;
	bh=3WFzo4V0jdnxwbdIL0/CbnCsfsdsHmS2qAipHrdk6L8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Izn9g4oUpR59snkPe8gzPWD5AmYjoHe3HCXbn24DJdm3BYGbSxXpreb+/82hflu/w
	 aKDQVTFNkF2KI8XSJwPhqRiLtk/Kv7Uy54f4HH9Q3sY627xCCd6ZDtAhHbiCvuYrQP
	 H8LobuZmFW6uWfDQTO7L37KHo4gWgQLUCeUcJQ6M=
Subject: Patch "can: isotp: isotp_bind(): do not validate unused address information" has been added to the 5.10-stable tree
To: gregkh@linuxfoundation.org,lukas.magel@posteo.net,maxime.jayat@mobile-devices.fr,michal.sojka@cvut.cz,mkl@pengutronix.de,patches@lists.linux.dev,sashal@kernel.org,socketcan@hartkopp.net
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 06 Nov 2023 12:23:22 +0100
In-Reply-To: <20231031092918.2668-10-socketcan@hartkopp.net>
Message-ID: <2023110622-cadmium-chant-6134@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    can: isotp: isotp_bind(): do not validate unused address information

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     can-isotp-isotp_bind-do-not-validate-unused-address-information.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Tue Oct 31 10:30:27 2023
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Tue, 31 Oct 2023 10:29:17 +0100
Subject: can: isotp: isotp_bind(): do not validate unused address information
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, sashal@kernel.org
Cc: linux-can@vger.kernel.org, lukas.magel@posteo.net, patches@lists.linux.dev, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de, michal.sojka@cvut.cz, Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <20231031092918.2668-10-socketcan@hartkopp.net>

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit b76b163f46b661499921a0049982764a6659bfe7 upstream

With commit 2aa39889c463 ("can: isotp: isotp_bind(): return -EINVAL on
incorrect CAN ID formatting") the bind() syscall returns -EINVAL when
the given CAN ID needed to be sanitized. But in the case of an unconfirmed
broadcast mode the rx CAN ID is not needed and may be uninitialized from
the caller - which is ok.

This patch makes sure the result of an inproper CAN ID format is only
provided when the address information is needed.

Link: https://lore.kernel.org/all/20220517145653.2556-1-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1216,7 +1216,8 @@ static int isotp_bind(struct socket *soc
 	struct net *net = sock_net(sk);
 	int ifindex;
 	struct net_device *dev;
-	canid_t tx_id, rx_id;
+	canid_t tx_id = addr->can_addr.tp.tx_id;
+	canid_t rx_id = addr->can_addr.tp.rx_id;
 	int err = 0;
 	int notify_enetdown = 0;
 
@@ -1226,24 +1227,28 @@ static int isotp_bind(struct socket *soc
 	if (addr->can_family != AF_CAN)
 		return -EINVAL;
 
-	/* sanitize tx/rx CAN identifiers */
-	tx_id = addr->can_addr.tp.tx_id;
+	/* sanitize tx CAN identifier */
 	if (tx_id & CAN_EFF_FLAG)
 		tx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
 	else
 		tx_id &= CAN_SFF_MASK;
 
-	rx_id = addr->can_addr.tp.rx_id;
-	if (rx_id & CAN_EFF_FLAG)
-		rx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
-	else
-		rx_id &= CAN_SFF_MASK;
-
-	/* give feedback on wrong CAN-ID values */
-	if (tx_id != addr->can_addr.tp.tx_id ||
-	    rx_id != addr->can_addr.tp.rx_id)
+	/* give feedback on wrong CAN-ID value */
+	if (tx_id != addr->can_addr.tp.tx_id)
 		return -EINVAL;
 
+	/* sanitize rx CAN identifier (if needed) */
+	if (isotp_register_rxid(so)) {
+		if (rx_id & CAN_EFF_FLAG)
+			rx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
+		else
+			rx_id &= CAN_SFF_MASK;
+
+		/* give feedback on wrong CAN-ID value */
+		if (rx_id != addr->can_addr.tp.rx_id)
+			return -EINVAL;
+	}
+
 	if (!addr->can_ifindex)
 		return -ENODEV;
 


Patches currently in stable-queue which might be from stable-owner@vger.kernel.org are

queue-5.10/ext4-avoid-overlapping-preallocations-due-to-overflow.patch
queue-5.10/can-isotp-isotp_bind-do-not-validate-unused-address-information.patch
queue-5.10/can-isotp-set-max-pdu-size-to-64-kbyte.patch
queue-5.10/can-isotp-isotp_bind-return-einval-on-incorrect-can-id-formatting.patch
queue-5.10/ext4-fix-bug-in-ext4_mb_new_inode_pa-due-to-overflow.patch
queue-5.10/can-isotp-add-symbolic-error-message-to-isotp_module_init.patch
queue-5.10/rpmsg-fix-calling-device_lock-on-non-initialized-device.patch
queue-5.10/can-isotp-change-error-format-from-decimal-to-symbolic-error-names.patch
queue-5.10/can-isotp-isotp_sendmsg-fix-tx-state-detection-and-wait-behavior.patch
queue-5.10/rpmsg-constify-local-variable-in-field-store-macro.patch
queue-5.10/can-isotp-add-error-message-if-txqueuelen-is-too-small.patch
queue-5.10/rpmsg-glink-release-driver_override.patch
queue-5.10/driver-platform-add-helper-for-safer-setting-of-driver_override.patch
queue-5.10/can-isotp-check-can-address-family-in-isotp_bind.patch
queue-5.10/rpmsg-fix-kfree-of-static-memory-on-setting-driver_override.patch
queue-5.10/can-isotp-add-local-echo-tx-processing-and-tx-without-fc.patch
queue-5.10/can-isotp-handle-wait_event_interruptible-return-values.patch
queue-5.10/rpmsg-fix-possible-refcount-leak-in-rpmsg_register_device_override.patch
queue-5.10/ext4-add-two-helper-functions-extent_logical_end-and-pa_logical_end.patch
