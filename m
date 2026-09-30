Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EFB4D90B7;
	Wed, 30 Sep 2026 17:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790536; cv=none; b=LRgIp+SvGIVgj5uZeyL2nSgvQ6Nty8aCRjFH/33cekMevoGCZC9DX6gl4uzoiBtUb04BMH20vx4wgt8iyljynFb+G1fQ8LyLAKU8uqiwdU94IzRMxO++xx2c+nd9NG9TerOO8HaDNq2Ip06aa8TFGRHqQliTR3sqhA2gSjKaf3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790536; c=relaxed/simple;
	bh=x8BP13166ZeZKxoQ0vGelm/c+QKw39TY97uOBs7Wl/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHdGMBRchlx9C0xah+2OV/26k5/gY/xLzuV/Zt7Kf8RKOSa27aoKr/MuSzuCwBWMk7drzdbj1hZPCuzFvDdNiuUgw+8Mr2j7dIRQyoOSk3oB8xTqqx2eeyAJwIOzx0vzssQQsqyeZF2aZJK9nwT6nrdtkmDjURlE2Zo+frOnMd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6IF5kpF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6IF5kpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073541F000FF;
	Wed, 30 Sep 2026 17:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790534;
	bh=GdxguKbuFE+2PxdPQTlMFLC29pq2d60mD0+Er+LRxCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6IF5kpFM226uTUMw2ztqKsC9ec4cBIiWMubD5tpSaf6sbztByB1qM1ef8EzuAAi0
	 68ITu/1kiyvFO7sASiM0vLlklRoPrjPyUO1I1V9u2iuwJH1XsfuXk2DdSmaNGc0d3x
	 +R9eQLQCi9fW7wocRQdrhUe3WxdeSGLyzeZDR0PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 862/877] rose: disconnect orphaned STATE_2 sockets when device is gone
Date: Wed, 30 Sep 2026 17:29:33 +0200
Message-ID: <20260930152433.339206578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


