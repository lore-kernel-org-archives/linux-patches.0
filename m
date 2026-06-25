Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8818326FD9B;
	Thu, 25 Jun 2026 13:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393042; cv=none; b=VeYwkvOtL++4ev5SbcYTBlCSxHGn6mQ8rcWIgDTtqCxLs3tckwAiyQGy+9VX3bgjZ6T+72JfMvGQwtK9mQ1PettJJrx61joVFETQZ9jISsf8J2dXdU4rHUnxlSr475XIHvRh6KhwuaUlzA1MCpQGKM/3fkJOc5sBbALeHfDv+pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393042; c=relaxed/simple;
	bh=q3rvcvO49zKEAduwEqvG/v+ZAAptUFH6NoGIgeFXiJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emsPMnP7OvPqib+bsVXUDPtjPnIs2M/SEQYFwLedgyaL8XuTjit/FowxBOkAI46PGudAaMeuL0P/KAesoo/vciBr3XKs7zj9zgA8BX52Qx039gWDjdJGSNa+5nR/mB86bjQphCT4pv6uPK7h8ehy+ypLoZXRTy6IgZt3yhOWI0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EusIQ3o7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EusIQ3o7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC711F000E9;
	Thu, 25 Jun 2026 13:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393041;
	bh=a3nshOad5VLjaNUQbjuBqIh76hWkIgelB167FJ4FYj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EusIQ3o7pyoNPCcBrbRELXpQi/c+9ZWdOooVPpCP3z7lRBECdArtiXMMmDuW/vLxX
	 Hzwok+OPC4U70SQPOsjLxwb3rGa6hyL6U/WnDaK1uh3jM4Y75D8Bp76ebiEJiShyWK
	 Qsecub4XFKZIajXLAca/TOMrmb1+zRttprSk8Y2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 7.0 24/49] rose: disconnect orphaned STATE_2 sockets when device is gone
Date: Thu, 25 Jun 2026 14:03:36 +0100
Message-ID: <20260625125640.909268242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit d4f4cf9f09a3f5fafa8f09110a7c1b5d10f2f261 upstream.

When ax25stop brings down ROSE interfaces, sockets in ROSE_STATE_2
(awaiting CLEAR CONFIRM) whose device pointer is already NULL are not
reached by rose_kill_by_device() and wait for T3 (up to 180s) before
self-cleaning via rose_timer_expiry().  This keeps the rose module
usecount at 1, blocking rmmod for the full T3 duration.

In rose_heartbeat_expiry(), detect ROSE_STATE_2 sockets with no device,
cancel T3, release the neighbour reference, and call rose_disconnect()
+ sock_set_flag(SOCK_DESTROY).  The next heartbeat tick (<=5s) then
destroys the socket via the existing ROSE_STATE_0/SOCK_DESTROY path,
allowing clean module unload within 10s instead of up to 180s.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_timer.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -139,6 +139,20 @@ static void rose_heartbeat_expiry(struct
 		}
 		break;
 
+	case ROSE_STATE_2:
+		/* Device gone before CLEAR CONFIRM arrived: stop waiting for T3
+		 * and disconnect now instead of blocking rmmod for up to 180s. */
+		if (!rose->device) {
+			rose_stop_timer(sk);
+			if (rose->neighbour) {
+				rose_neigh_put(rose->neighbour);
+				rose->neighbour = NULL;
+			}
+			rose_disconnect(sk, ENETDOWN, -1, -1);
+			sock_set_flag(sk, SOCK_DESTROY);
+		}
+		break;
+
 	case ROSE_STATE_3:
 		/*
 		 * Check for the state of the receive buffer.


