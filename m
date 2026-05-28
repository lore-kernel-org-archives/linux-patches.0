Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45E42459DD;
	Thu, 28 May 2026 20:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001302; cv=none; b=Fzzg/5X7R8zY4INS81wklfHt0CzSk3/aHj7mG29pH9oXky52mrCf/Vgv+4HknFKTT0W5LFyQO0Tapta5Mcje7MlWcvLv5VUhEF+m9xqoWS7DQ+tbcLcyBxRr+yGQHqRXX5uYGvPLF0I39d+BXWz0XeznrQTvSIdEzznJIgS8tvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001302; c=relaxed/simple;
	bh=7TvOtYqI1XFXP4vnFScPi+5jwz1rlAjcgQ+735orDSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkMCefteoZhLYuAYZB+w4B+O19Imnx7Q0Rn+h3hw7J3r+7uF8WusWArVwIBIqX8SbKSlxhnP8HmAw3Eiyy/NJWpLStHxKmzRn6W8QU0lIDMQF8SYaFjtrPFytiX3AVfz95NYKrt8q0ufdYMW4elH//dlSVfSNoxPzi67SVBTOqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DC8BEpyx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DC8BEpyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1185F1F00A3A;
	Thu, 28 May 2026 20:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001301;
	bh=yyXPibY07uT3E36hh5Mt/LA27sKdHzvTi3rtixBWKHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DC8BEpyxLV1/oCU42HiyNunJViIGcPYgCU7tdIxMcMofhXZYVxOal/hsv4Dg6i9L3
	 pL0xPOa4YPzhfkHozFL+ipmaACyvrPnrfFV+U9UHZBnr9mJ/RFCm4INjWo/vvds3vR
	 rcqL3gRqku7o0mKcfRrQKLih/bVZ9YnbM2Try1bA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 080/186] batman-adv: fix tp_meter counter underflow during shutdown
Date: Thu, 28 May 2026 21:49:20 +0200
Message-ID: <20260528194931.096886999@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luxiao Xu <rakukuip@gmail.com>

commit 94f3b133168d1c49895e7cc6afbcf1cc0b354602 upstream.

batadv_tp_sender_shutdown() unconditionally decrements the "sending"
atomic counter. If multiple paths (e.g. timeout, user cancel, and
normal finish) call this function, the counter can underflow to -1.

Since the sender logic treats any non-zero value as "still sending",
a negative value causes the sender kthread to loop indefinitely.
This leads to a use-after-free when the interface is removed while
the zombie thread is still active.

Fix this by using atomic_xchg() to ensure the counter only transitions
from 1 to 0 once.

Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
[sven: added missing change in batadv_tp_send]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/tp_meter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -451,7 +451,7 @@ static void batadv_tp_sender_end(struct
 static void batadv_tp_sender_shutdown(struct batadv_tp_vars *tp_vars,
 				      enum batadv_tp_meter_reason reason)
 {
-	if (!atomic_dec_and_test(&tp_vars->sending))
+	if (atomic_xchg(&tp_vars->sending, 0) != 1)
 		return;
 
 	tp_vars->reason = reason;
@@ -885,7 +885,7 @@ static int batadv_tp_send(void *arg)
 				   "Meter: %s() cannot send packets (%d)\n",
 				   __func__, err);
 			/* ensure nobody else tries to stop the thread now */
-			if (atomic_dec_and_test(&tp_vars->sending))
+			if (atomic_xchg(&tp_vars->sending, 0) == 1)
 				tp_vars->reason = err;
 			break;
 		}


