Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650241D9A50;
	Wed, 19 Feb 2025 09:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956887; cv=none; b=cyRmfsV/C3MtgyQBA15Q9J+qcB14Hw+iu3dCcMN2yIqLTZatVvWzOZvMWTh5dzuT2C9lZrmC+NPO6Us5F6BUVTUd2OXg6hUwMpmCABWDSaPldpTfEKYvHHaeRblPBfiv1NWvsirgXDj8LxPwvta1FPP/vQ5HP4Fh55CYUal/gAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956887; c=relaxed/simple;
	bh=NtOHSxboRtP7r1IO6fqai7qVgmPHYw9fVCGkOvE6ueE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqME6i0qy0HoQ1dKbl+8NLTivD7HXwHglPKxeq4hzi/geC5lGXmXMGqielMgHBJyEpLbHi9Gr9CGvg0oJBBNfdOFIep6NtVTIL1InBLUKT69tr0lAdV1mw1xQTHsNaSgxKNzE9bcVkYAGPNS30In15hgUlWfqP3RZqXUdEarRBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imoMcrfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imoMcrfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2339C4CED1;
	Wed, 19 Feb 2025 09:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956887;
	bh=NtOHSxboRtP7r1IO6fqai7qVgmPHYw9fVCGkOvE6ueE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imoMcrfPp1OuIiHqcfoPdHEeWsn1on2+24LnXHX+PIeMpm9YVQ+bglnNMwByup+7R
	 QfqGldq7gNQY+tYRdR6lD/92KDApUI7Z/5FsYR370vDx8yvcxIlzX+frdkXf0TW7QZ
	 dNyHy+ZAYXL4skUuSy7RCUTyjeS0TujjeyGRIfto=
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
Subject: [PATCH 6.1 334/578] net: sched: Fix truncation of offloaded action statistics
Date: Wed, 19 Feb 2025 09:25:38 +0100
Message-ID: <20250219082706.157516942@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 743acbc43c851..80f657bf2e047 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -817,7 +817,7 @@ static inline int qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 }
 
 static inline void _bstats_update(struct gnet_stats_basic_sync *bstats,
-				  __u64 bytes, __u32 packets)
+				  __u64 bytes, __u64 packets)
 {
 	u64_stats_update_begin(&bstats->syncp);
 	u64_stats_add(&bstats->bytes, bytes);
-- 
2.39.5



