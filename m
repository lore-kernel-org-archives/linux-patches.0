Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380243B3C10;
	Sat, 12 Sep 2026 18:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237525; cv=none; b=rbtUUdeszQtDMN+Kacfp3pgVyfwpkk8i32wmoLTwA0TLCKEKCZc4PosLupzdS0JuXwl+cJFuN1TTTNxEULQjkbXxOOWtyMjC6Whxzk3RI5MPzLeuX3q2Ji8I7CRy5qxjWRhitWy0flfYMJV2wd3CGFiSQwJE0r8dFfrnX0K9nvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237525; c=relaxed/simple;
	bh=ZigTyazaqDbvdyOhsJLJaPNXUc3Xn81FUSsKyUreFAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyZqI+iLgCeCmCdcW96bl8Xo7BMjA88PK9zUsgG6wnOY+W014MgyAfYZdeWIGvjojePg3CiGeOGZCUe/gG2EAbnGsPrJk7el2xgJoNvYjKB7TP3lJm7Ue4KR8ys/FoUDolPvhM3dKf+kuPfRuc4jqvwWExV1R1mzOy56gu/NZRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9Vf27WN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9Vf27WN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A17F1F000FF;
	Sat, 12 Sep 2026 18:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237524;
	bh=Ag2Y4j0enBnmKYCjrCb98qHRfbFzIDiHYBU0nqnq+X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9Vf27WNROzc9WXG19jGahtZJgxplUOJrL3YrasmcI/JnzqMkLvCapyFnnOos6y3m
	 nsrecIGe3zkHkyV+adGaw4/RMQConNI+6UpF+sfNJCXQYk8GJEGwBtd3zxcvQpT7pL
	 dpLjsnQQA12kga8dGZoTOFSuLCZlNPuZU27Bf8d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 277/935] batman-adv: bla: prevent CRC corruptions after claim flush
Date: Sat, 12 Sep 2026 08:55:07 +0200
Message-ID: <20260912065533.176065077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 89f3502ff6878798be96461b2eebd64ba3c3874c upstream.

When batadv_bla_del_backbone_claims() tried to remove all claims of a
backbone, it sets the CRC to 0. It assumes that the it had the last
reference of the claims because batadv_claim_release() (which runs after
the last reference was released), is XORing the crc16 of the claim address
with the backbone CRC.

If there would be a parallel holder of any of these references, it could
happen that the backbone CRC is (0 ^ crc16(delayed_released_claim)). Which
is the wrong starting point for the new claims it may receive when the
remote answers the claim request from batadv_bla_send_request().

This reinitializations can be completely dropped to avoid this problem.
batadv_claim_release() will take care of fixing the backbone CRC.

Cc: stable@vger.kernel.org
Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -322,11 +322,6 @@ batadv_bla_del_backbone_claims(struct ba
 		}
 		spin_unlock_bh(list_lock);
 	}
-
-	/* all claims gone, initialize CRC */
-	spin_lock_bh(&backbone_gw->crc_lock);
-	backbone_gw->crc = BATADV_BLA_CRC_INIT;
-	spin_unlock_bh(&backbone_gw->crc_lock);
 }
 
 /**


