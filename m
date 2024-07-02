Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4561BC08A;
	Tue,  2 Jul 2024 17:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940471; cv=none; b=iZOaktwCXsuX4Wp+8Zw6ix7oQfqaccq0+I7kMM9MEEc9pO55/27sZ6NJsONPBA298tyWN+YD7oUROpfyjJxAVoFkXXgPYXqljD9hXC/6deAitOM99KTtEmvB44EvT73rNmW8Up/aL0HZliZ2hXGEqka57gO0esrtMLgaHGrlZsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940471; c=relaxed/simple;
	bh=+Qs/Zrc/+BDzjhrBC2HsbEg0A7sHkrbHsNOLXcXaMoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PxFXrJFbbSBKHu0FClN/t+0l7sIN7Etjgg/tAYDmnf1grKMm/e/BojkbNyFMAu3NJ0gLR++TXCPq/PPl/VunYkxmBXQzyVepj9we9dHwpF9pMhmnx5d7fyd4yvktw/6Yu9eJuB2cFlYnz06c4S9vqCn70NFeFwQBuNksqn+VSNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KokWHo1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KokWHo1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5C8C116B1;
	Tue,  2 Jul 2024 17:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940471;
	bh=+Qs/Zrc/+BDzjhrBC2HsbEg0A7sHkrbHsNOLXcXaMoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KokWHo1F87eQCVNbGGUYbkHCMzcZZ/kbAqzmk/+yQb/BAzThXSN8s60B9MahpqWds
	 Ey6Q5fdZI9eGGVlu0D8QAnJeBpVS7PfEvZFFWtc/dfy4cHDEGQorZM+QgFpFF+aXAV
	 OcHC9VszozfIvYTefYxbLAVHtZKCvJQQYNKn9mDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexander=20H=C3=B6lzl?= <alexander.hoelzl@gmx.net>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.9 165/222] net: can: j1939: recover socket queue on CAN bus error during BAM transmission
Date: Tue,  2 Jul 2024 19:03:23 +0200
Message-ID: <20240702170250.284127309@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 9ad1da14ab3bf23087ae45fe399d84a109ddb81a upstream.

Addresses an issue where a CAN bus error during a BAM transmission
could stall the socket queue, preventing further transmissions even
after the bus error is resolved. The fix activates the next queued
session after the error recovery, allowing communication to continue.

Fixes: 9d71dd0c70099 ("can: add support of SAE J1939 protocol")
Cc: stable@vger.kernel.org
Reported-by: Alexander Hölzl <alexander.hoelzl@gmx.net>
Tested-by: Alexander Hölzl <alexander.hoelzl@gmx.net>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20240528070648.1947203-1-o.rempel@pengutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1681,6 +1681,8 @@ static int j1939_xtp_rx_rts_session_acti
 
 		j1939_session_timers_cancel(session);
 		j1939_session_cancel(session, J1939_XTP_ABORT_BUSY);
+		if (session->transmission)
+			j1939_session_deactivate_activate_next(session);
 
 		return -EBUSY;
 	}


