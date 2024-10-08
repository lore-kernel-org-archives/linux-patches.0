Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BC017B4EC;
	Tue,  8 Oct 2024 12:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389968; cv=none; b=EQglHH+YQo/TCE2R8ZqbTiRpVDo0QwasdVv6ymJkOJWlAeSBXshb769iSNGBdghX59ys8VkMAiqIPqCr3qQW0w7Jdg9006zQttqCfo1h2AVePqbATnybY4UcuX9p7Y/CujrKmojZqA2h49tekT357VyFQmU4M/8cz8qeHdFfaqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389968; c=relaxed/simple;
	bh=YiBVQFaJbCNm5GSHObQ5aZ3pemkRW6AC9KIJVzx2KLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kDj4whiaWysia236aBfW0MCv4tkGmxpxuliQIa0E/TlK/Qm19EpLYqfbr5xeJQU+aRdH3hBhK+wwzfnJI9IJN1JNf4fVJNhCVFyPvyafZhT8gt4OZkugjgEeV5uEea9lf0UaM8Nio9UGrEqEnyc8L4f8n408ZZcYETeHZVuGU1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oeHg36sV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oeHg36sV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682EEC4CED5;
	Tue,  8 Oct 2024 12:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389967;
	bh=YiBVQFaJbCNm5GSHObQ5aZ3pemkRW6AC9KIJVzx2KLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeHg36sV0xYLvluL7rudHShsEKeLGytqo2CffV/AH+/cvdk5ysPe+eSTDurtZttCD
	 odl8wh9IluhTkyYQo0JhI0Hk54WMPfcZQCvLkXCGETyZwAAoeS/WQ27xk1U6A3JsBK
	 PbJ9ZrAvYlUXhdtkpk6UgqUT42r4+03q+DuGa85Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 123/482] can: netlink: avoid call to do_set_data_bittiming callback with stale can_priv::ctrlmode
Date: Tue,  8 Oct 2024 14:03:06 +0200
Message-ID: <20241008115653.146556674@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Mätje <stefan.maetje@esd.eu>

[ Upstream commit 2423cc20087ae9a7b7af575aa62304ef67cad7b6 ]

This patch moves the evaluation of data[IFLA_CAN_CTRLMODE] in function
can_changelink in front of the evaluation of data[IFLA_CAN_BITTIMING].

This avoids a call to do_set_data_bittiming providing a stale
can_priv::ctrlmode with a CAN_CTRLMODE_FD flag not matching the
requested state when switching between a CAN Classic and CAN-FD bitrate.

In the same manner the evaluation of data[IFLA_CAN_CTRLMODE] in function
can_validate is also moved in front of the evaluation of
data[IFLA_CAN_BITTIMING].

This is a preparation for patches where the nominal and data bittiming
may have interdependencies on the driver side depending on the
CAN_CTRLMODE_FD flag state.

Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
Link: https://patch.msgid.link/20240808164224.213522-1-stefan.maetje@esd.eu
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/netlink.c | 102 +++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index dfdc039d92a6c..01aacdcda2606 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -65,15 +65,6 @@ static int can_validate(struct nlattr *tb[], struct nlattr *data[],
 	if (!data)
 		return 0;
 
-	if (data[IFLA_CAN_BITTIMING]) {
-		struct can_bittiming bt;
-
-		memcpy(&bt, nla_data(data[IFLA_CAN_BITTIMING]), sizeof(bt));
-		err = can_validate_bittiming(&bt, extack);
-		if (err)
-			return err;
-	}
-
 	if (data[IFLA_CAN_CTRLMODE]) {
 		struct can_ctrlmode *cm = nla_data(data[IFLA_CAN_CTRLMODE]);
 		u32 tdc_flags = cm->flags & CAN_CTRLMODE_TDC_MASK;
@@ -114,6 +105,15 @@ static int can_validate(struct nlattr *tb[], struct nlattr *data[],
 		}
 	}
 
+	if (data[IFLA_CAN_BITTIMING]) {
+		struct can_bittiming bt;
+
+		memcpy(&bt, nla_data(data[IFLA_CAN_BITTIMING]), sizeof(bt));
+		err = can_validate_bittiming(&bt, extack);
+		if (err)
+			return err;
+	}
+
 	if (is_can_fd) {
 		if (!data[IFLA_CAN_BITTIMING] || !data[IFLA_CAN_DATA_BITTIMING])
 			return -EOPNOTSUPP;
@@ -195,48 +195,6 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 	/* We need synchronization with dev->stop() */
 	ASSERT_RTNL();
 
-	if (data[IFLA_CAN_BITTIMING]) {
-		struct can_bittiming bt;
-
-		/* Do not allow changing bittiming while running */
-		if (dev->flags & IFF_UP)
-			return -EBUSY;
-
-		/* Calculate bittiming parameters based on
-		 * bittiming_const if set, otherwise pass bitrate
-		 * directly via do_set_bitrate(). Bail out if neither
-		 * is given.
-		 */
-		if (!priv->bittiming_const && !priv->do_set_bittiming &&
-		    !priv->bitrate_const)
-			return -EOPNOTSUPP;
-
-		memcpy(&bt, nla_data(data[IFLA_CAN_BITTIMING]), sizeof(bt));
-		err = can_get_bittiming(dev, &bt,
-					priv->bittiming_const,
-					priv->bitrate_const,
-					priv->bitrate_const_cnt,
-					extack);
-		if (err)
-			return err;
-
-		if (priv->bitrate_max && bt.bitrate > priv->bitrate_max) {
-			NL_SET_ERR_MSG_FMT(extack,
-					   "arbitration bitrate %u bps surpasses transceiver capabilities of %u bps",
-					   bt.bitrate, priv->bitrate_max);
-			return -EINVAL;
-		}
-
-		memcpy(&priv->bittiming, &bt, sizeof(bt));
-
-		if (priv->do_set_bittiming) {
-			/* Finally, set the bit-timing registers */
-			err = priv->do_set_bittiming(dev);
-			if (err)
-				return err;
-		}
-	}
-
 	if (data[IFLA_CAN_CTRLMODE]) {
 		struct can_ctrlmode *cm;
 		u32 ctrlstatic;
@@ -284,6 +242,48 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 			priv->ctrlmode &= cm->flags | ~CAN_CTRLMODE_TDC_MASK;
 	}
 
+	if (data[IFLA_CAN_BITTIMING]) {
+		struct can_bittiming bt;
+
+		/* Do not allow changing bittiming while running */
+		if (dev->flags & IFF_UP)
+			return -EBUSY;
+
+		/* Calculate bittiming parameters based on
+		 * bittiming_const if set, otherwise pass bitrate
+		 * directly via do_set_bitrate(). Bail out if neither
+		 * is given.
+		 */
+		if (!priv->bittiming_const && !priv->do_set_bittiming &&
+		    !priv->bitrate_const)
+			return -EOPNOTSUPP;
+
+		memcpy(&bt, nla_data(data[IFLA_CAN_BITTIMING]), sizeof(bt));
+		err = can_get_bittiming(dev, &bt,
+					priv->bittiming_const,
+					priv->bitrate_const,
+					priv->bitrate_const_cnt,
+					extack);
+		if (err)
+			return err;
+
+		if (priv->bitrate_max && bt.bitrate > priv->bitrate_max) {
+			NL_SET_ERR_MSG_FMT(extack,
+					   "arbitration bitrate %u bps surpasses transceiver capabilities of %u bps",
+					   bt.bitrate, priv->bitrate_max);
+			return -EINVAL;
+		}
+
+		memcpy(&priv->bittiming, &bt, sizeof(bt));
+
+		if (priv->do_set_bittiming) {
+			/* Finally, set the bit-timing registers */
+			err = priv->do_set_bittiming(dev);
+			if (err)
+				return err;
+		}
+	}
+
 	if (data[IFLA_CAN_RESTART_MS]) {
 		/* Do not allow changing restart delay while running */
 		if (dev->flags & IFF_UP)
-- 
2.43.0



