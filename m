Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E59DDA9;
	Thu,  2 Jul 2026 16:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010415; cv=none; b=NiZ2LDlCg1xNtEDdlcxncqjmXC8SVw1l4sH3SFCegJ72CcueNE1W49ACYnFZ9noIdcF1xU2fId+YMds3glJm4iR4og7J2owxP0vISrpaLNxIxHlJX9VtRGV9q9QDVCJaGBFSL8YWHj3ub97uE2Bgoky4UL8vD6f2AXocDtau8VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010415; c=relaxed/simple;
	bh=HQWQY+hP1F5RuXp9p1FNhIfluFmpyW7dkBRAU88FJUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ue8YgDN7u6aWo9Bpu1xeodbDYYjWSoBU7Ymgb6qAgcjV5EXZ3x9Zug5R+9SMpadV63NFLUkkv87nxbCK22JSjs1uqC64a4XzkX4h9akfcOX9W7FlzuNXdSf1I7XUBIgG2Ffja6OceBEpZi6kPsdCbjbhkF5GGVP0aNs+chCAEes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBHUwZxp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBHUwZxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447291F00A3A;
	Thu,  2 Jul 2026 16:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010413;
	bh=xgT/52hnwHo83VXxE92rvKTYVQxM0dKh3P4hD6NJCjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBHUwZxp0uWELuNm3df1DzsHVuBHbCKAf+uQQV8RpT6f87rN13lJ9Gm6ttCizScB8
	 2ZqRRfDxVqmTqOGwSGRbFnhC7/mrFdEu9hZtNftUJqDkPwTcERTA9W+/XsbsD2+MF7
	 BXd/xdYEI1WzSy+zp3Ej7BI/MPeROsnEaB/4N774=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/204] batman-adv: tp_meter: keep unacked list in ascending ordered
Date: Thu,  2 Jul 2026 18:19:16 +0200
Message-ID: <20260702155120.740915631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 5aa8651527ea0b610e7a09fb3b8204c1398b9525 upstream.

When batadv_tp_handle_out_of_order inserts a new entry in the list of
unacked (out of order) packets, it searches from the entry with the newest
sequence number towards oldest sequence number. If an entry is found which
is older than the newly entry, the new entry has to be added after the
found one to keep the ascending order.

But for this operation list_add_tail() was used. But this function adds an
entry _before_ another one. As result, the list would contain a lot of
swapped sequence numbers. The consumer of this list
(batadv_tp_ack_unordered()) would then fail to correctly ack packets.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index dfc3374549921f..f350a60e6c76b9 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1325,7 +1325,7 @@ static bool batadv_tp_handle_out_of_order(struct batadv_tp_vars *tp_vars,
 		 * one is attached _after_ it. In this way the list is kept in
 		 * ascending order
 		 */
-		list_add_tail(&new->list, &un->list);
+		list_add(&new->list, &un->list);
 		added = true;
 		break;
 	}
-- 
2.53.0



