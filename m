Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9348622172F;
	Thu, 13 Feb 2025 14:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457582; cv=none; b=TcxLE1Z1BdX2EmxAM7dfglN1//Gn/TAdXmaQCPLGMaFpAv12t71Qp6qZo/hYBFJioPJtyY+5dno+UDxPMJzsXYZbEQjhveRSDoHM1N0fc3WptMuCxOkFhXZFaJxXe5XaZrooyaqc6R4DCKLtye1+/mX0zSdRP9CJ4q8q9dlIvTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457582; c=relaxed/simple;
	bh=upQ1cFNY7z00B63mj0XoVNczQHRPEGGGMPXMR+lOVeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJ2uxDgMbYFD3eWjeuk6JirQaWfql2sD2NJZxETdFLA7jh3QEMeuHYHgHZL1PZ2efVhF5y9eyIDnZrKsgKkt1ltGuuH3L2hYOaOhy8uCaathLmVW6KLgHWFC6+uYLiRtAKNJ19N5SZi4t61K1UVnVLislVj1La5XUvPYtpGfHU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKj1Yt0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKj1Yt0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135DBC4CEE7;
	Thu, 13 Feb 2025 14:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457582;
	bh=upQ1cFNY7z00B63mj0XoVNczQHRPEGGGMPXMR+lOVeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKj1Yt0ybEY+9w/vNsRwlV5jdqCRPkcyACiiFCrVzf+ophEobDRhKg3pQBMnrLRZR
	 TpIW5JoIl7L3N0qRtfR+heDJkKxcfLOeZJOebG0q4kqjabK8UDU7nT8xeu6YRJ/UkG
	 fgMPD9zkA50Hvco4bzWIfhzkaIqt+hy5VpNdQNyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Botha <joe@atomic.ac>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/422] net: sched: Fix truncation of offloaded action statistics
Date: Thu, 13 Feb 2025 15:24:35 +0100
Message-ID: <20250213142441.410807940@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 811b8f534fd85e17077bd2ac0413bcd16cc8fb9b ]

In case of tc offload, when user space queries the kernel for tc action
statistics, tc will query the offloaded statistics from device drivers.
Among other statistics, drivers are expected to pass the number of
packets that hit the action since the last query as a 64-bit number.

Unfortunately, tc treats the number of packets as a 32-bit number,
leading to truncation and incorrect statistics when the number of
packets since the last query exceeds 0xffffffff:

$ tc -s filter show dev swp2 ingress
filter protocol all pref 1 flower chain 0
filter protocol all pref 1 flower chain 0 handle 0x1
  skip_sw
  in_hw in_hw_count 1
        action order 1: mirred (Egress Redirect to device swp1) stolen
        index 1 ref 1 bind 1 installed 58 sec used 0 sec
        Action statistics:
        Sent 1133877034176 bytes 536959475 pkt (dropped 0, overlimits 0 requeues 0)
[...]

According to the above, 2111-byte packets were redirected which is
impossible as only 64-byte packets were transmitted and the MTU was
1500.

Fix by treating packets as a 64-bit number:

$ tc -s filter show dev swp2 ingress
filter protocol all pref 1 flower chain 0
filter protocol all pref 1 flower chain 0 handle 0x1
  skip_sw
  in_hw in_hw_count 1
        action order 1: mirred (Egress Redirect to device swp1) stolen
        index 1 ref 1 bind 1 installed 61 sec used 0 sec
        Action statistics:
        Sent 1370624380864 bytes 21416005951 pkt (dropped 0, overlimits 0 requeues 0)
[...]

Which shows that only 64-byte packets were redirected (1370624380864 /
21416005951 = 64).

Fixes: 380407023526 ("net/sched: Enable netdev drivers to update statistics of offloaded actions")
Reported-by: Joe Botha <joe@atomic.ac>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250204123839.1151804-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 1e6324f0d4efd..24e48af7e8f74 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -851,7 +851,7 @@ static inline int qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 }
 
 static inline void _bstats_update(struct gnet_stats_basic_sync *bstats,
-				  __u64 bytes, __u32 packets)
+				  __u64 bytes, __u64 packets)
 {
 	u64_stats_update_begin(&bstats->syncp);
 	u64_stats_add(&bstats->bytes, bytes);
-- 
2.39.5



