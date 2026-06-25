Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84EC2BE026;
	Thu, 25 Jun 2026 13:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392830; cv=none; b=UTxlNAwvIHB22WOAbijaJ+9Qc6GypeZ9xagYtKwdzCHVLksfqsuF3/1nI010fYIEtkjoTSjlOt3oD/zGIwR7QBOH8g9pIWAYsowWCHyeLQjeNH+DzCxiW+qpYQTZBqVSICKs04c+xVb86TiI8inYv2p9DOxTiWWYZu8TogfYju0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392830; c=relaxed/simple;
	bh=OqqQZlnF2pkILkvxItUEPnh5Fzft478DOLxRbsDxjeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqZwhEbypWs18ukP+7vxO8Yt6WwokELg3mhvSVCMxdVYoq4LoFcwR0RynYO8F0io+fcGqNUC4LTPj5+PW3nkj/vfD5E/K45/OeVOV3IIF1tJiCsTA5EGeMrjiGxInWoYyYnmtT+n36p3XNb11MO9L3MlIUYITZlCI9MCaWt4gy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LoYWma4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LoYWma4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3FC1F000E9;
	Thu, 25 Jun 2026 13:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392829;
	bh=fQTg03OSZ4F0gTo/pWUlRAma1xIXH+A+NEm1C1OA+JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LoYWma4Iv3E90gAX9VGerJsbF+VEpGkticsghlPr4tect2iE+k/Snr6CCea07jPKn
	 CGJMSX/MD7kgDYhw+0n2TYog8lz+f2L1ISLDHCQPYjliFhs1kKkVMs7ynQmIT+xj/D
	 3+qR8SLwP2XLxJEKO96EHNoqLb3b7jhmWplOmRTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 22/60] rose: disconnect orphaned STATE_2 sockets when device is gone
Date: Thu, 25 Jun 2026 14:03:07 +0100
Message-ID: <20260625125648.803663618@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


