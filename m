Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E2D26B0B4;
	Thu, 13 Feb 2025 15:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460325; cv=none; b=eiWK+cyv1UiqR7ycVbPqDHXrE/FZNYZe/J1sp8HByqieCwHHXa1tKHlLCWOqk+Az2+aygSc4VOy/KFs3JfINDlWCIFK80THmPNOEjfRhPVaHEHBa8Gl4+b3Y6TGJG/XkdbFAWTrkmbfk1eX5ZMIHwRMWY9m5SvSsuFAFo61vMus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460325; c=relaxed/simple;
	bh=3RyDq+JerK7ZncAsAzRNjI/EIM/9rLuEVKkid3hFNTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2gHgadLdpv2P09jJSbzhKHFPWD/vKy23P8D8OpU31PmSQQcrSnyUoJ/uVN9edZkun99njxCb5VfxruyMVdUTquQbmior5wtN8U53PWRD1YJyt13Tgm5qPJcO1kD8ucV6n/T/2sBwRcI6pfskuKhGbTbj2+u6ElcplkzDVA0ETo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IR3Ae2kg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IR3Ae2kg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EB0C4CED1;
	Thu, 13 Feb 2025 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460325;
	bh=3RyDq+JerK7ZncAsAzRNjI/EIM/9rLuEVKkid3hFNTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IR3Ae2kgYayDbuIrADBkhra5JSlWYmqnYz1zHz2VS+XljWo7k6T31kOVm1CV1zz+w
	 QgfLuv8rYcqvXWVKT8rGZ581W2QMRG0dj1ez/ektBtA5AXdoC4uiYGIo9LJriK+6o+
	 FLQ0RY9PbmdTS1aeB/ilYlNCFpU/r9+I45kdJLnA=
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
Subject: [PATCH 6.6 079/273] net: sched: Fix truncation of offloaded action statistics
Date: Thu, 13 Feb 2025 15:27:31 +0100
Message-ID: <20250213142410.465760529@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 326d3a322c109..4ec2a948ae3db 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -849,7 +849,7 @@ static inline int qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 }
 
 static inline void _bstats_update(struct gnet_stats_basic_sync *bstats,
-				  __u64 bytes, __u32 packets)
+				  __u64 bytes, __u64 packets)
 {
 	u64_stats_update_begin(&bstats->syncp);
 	u64_stats_add(&bstats->bytes, bytes);
-- 
2.39.5



