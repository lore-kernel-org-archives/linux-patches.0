Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4748B2AD00;
	Sun,  7 Jun 2026 10:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827649; cv=none; b=lv3I6iflhK4xyayz4VSZ0VDl+CCtpQQlvxrKBXKA3Cmhww8EHoyycp69g00UIXTwnlIcFZr+NMggw2HSrT7LD1hA5Y3wRIDu5iXHuAXVg4VUf8+wgzoR3fB9e0J+s1+jnHUns4sfMGqGL0GB8r6vX+afppERGuwdX62p1uKhB6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827649; c=relaxed/simple;
	bh=kdcowrrhMi0/DKnJ56P7dWDtN7MJzMOGQLEwylFe9Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NG+fhnVBIQ4oAqVCBD/DUbEPTB+tHOTOazJ7AM8vo8Q4jPkZ8/qnubFsk1W9+QPE9qZURjx6VgYtFiqkY6gRKcCkPCvtxxUfrS7q8iBLo8L12Jla9sS8LaDDei6+hXIr/A5bI1zroh4WiPD4igMjUl9zHrqkwXGoH8pAoAS4/4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuDy2qja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuDy2qja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894911F00893;
	Sun,  7 Jun 2026 10:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827648;
	bh=IdbxRyF3bYJVJWaQAjAbnFbASDm/tDt1jTyLcJGO4dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuDy2qjaOCaNbIaFcRVu/3ypJYagyLrX5BlQ4A5Op1oX98r1p0zQKcaZ3KJ3W2Snn
	 XO7Mgid7dlGQ3vWvYPnwP8d1hkgpPA1Wo+QeR8ccivfOqpVKsBn1yKvxjobafkOPR4
	 3kEzlrAa9CEMsgaQyP+o82mtGFXLYbV3Z+BIc6g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 111/332] ipv6: fix possible infinite loop in fib6_select_path()
Date: Sun,  7 Jun 2026 11:58:00 +0200
Message-ID: <20260607095732.191538558@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 9c7da87c2dc860bb17ca1ece942495d28b1ce3b9 ]

Found while auditing the same pattern Sashiko reported in
rt6_fill_node() [1]. Apply the same fix as
commit f8d8ce1b515a ("ipv6: fix possible infinite loop in fib6_info_uses_dev()").

Writers holding tb6_lock can list_del_rcu(&first->fib6_siblings)
without waiting for RCU readers; first->fib6_siblings.next then
still points into the old ring and this softirq-side walker never
reaches &first->fib6_siblings as its terminator. fib6_purge_rt()
always WRITE_ONCE()s first->fib6_nsiblings to 0 before
list_del_rcu(), so an inside-loop check is a reliable detach signal.

[1] https://sashiko.dev/#/patchset/20260526020227.4857-1-jiayuan.chen%40linux.dev

Fixes: d9ccb18f83ea ("ipv6: Fix soft lockups in fib6_select_path under high next hop churn")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260527053133.180695-2-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 398e873072bbfb..9a45ecdd7b853c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -481,6 +481,9 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 		const struct fib6_nh *nh = sibling->fib6_nh;
 		int nh_upper_bound;
 
+		if (!READ_ONCE(first->fib6_nsiblings))
+			break;
+
 		nh_upper_bound = atomic_read(&nh->fib_nh_upper_bound);
 		if (hash > nh_upper_bound)
 			continue;
-- 
2.53.0



