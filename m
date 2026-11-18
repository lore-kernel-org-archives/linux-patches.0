Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018182;
	b=RvDN9ksDym8IkfGpHrWEzPe7xdg3XrX9/OCCq0u8gt2IRriZaky5NC8aCbrU1I4raHZ0
	 lKia56ydz+SHEHVCzHF+Je7qEQQmDMcb0y4x6/UN9q+3uqDAzXLpjqzzy7IW+Jod2Yt0T
	 2u6zkUoV67guh4ZJLpZwmwZ+BVHxrW/If985ulw3B+1le7hAu6yePmXbx1D/Rw2J1yLvI
	 AWu2vEVQ7aEhxovtnTP7UgNkOwfLrY/B02Z6M8iqwE1JQGg08jd42GipQ3PtXHRghqHnC
	 NfSVdkeWqlFWwK7uokIj3vbccVTIOsNDLua/A3D04VO9614Dodxiu9FfAtFEAA67ozg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/kHln4jl65lESf+29oW14mvkmbLA+0zAgU7vOw3RmKo=;
	b=4urnaDqV2+Q8oaYS9XksFvV9bToyc09BRcLKs2zU5InImXGkxcE+JxLigyVRGtcMhK/F
	 aBd+SIRe+oSHa4QcdNE+eGAmg/VPpfQT53RwHpp1B0H+0nDXVfwq1ViFzN4JezSIrXqCf
	 T0lhSpo4W0czYcOwX/Q3vxplsD+Rj+B6C5DbQipfR0stwtdiZnRKUWlgmrPo5kGpmKD4F
	 yCieTqHLV5YthI3pHhnrR0yZy3l/eFX9byUh5eySonSoOnkD74LH0YMVDBKj8CK4sLA8G
	 vipZs0kG168pAcJOcsuIdsX3PUOPhZl5V60rEc9dWpDzIcV8XBc+lrJ9CMkJ+VZa0lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ndag1r4A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F80D606A32A;
	Wed, 18 Nov 2026 16:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ndag1r4A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A641F000CC;
	Wed, 18 Nov 2026 16:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018182;
	bh=/kHln4jl65lESf+29oW14mvkmbLA+0zAgU7vOw3RmKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndag1r4A7lkplODtt3Y+rt74uWk06uw8FwBdrByGHMT++akETJhX1/5VWsL9QNN9J
	 fHPM7jtfcdL31IDz9w+qFx2NYkcfAz+SCEoIQRuoib99B9WcXQc+gGY+JRhI+pC0Ee
	 IGVUK6vShilFajGhz1dS9B6rqwX45Jp4FFoLqHzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Adrian Tomasov <atomasov@redhat.com>,
	Kris Pan <kris.pan@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1149/2651] net: iterate online nodes in skb_defer_free_flush()
Date: Wed, 18 Nov 2026 15:39:49 +0100
Message-ID: <20261118150329.373713512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kris Pan <kris.pan@intel.com>

[ Upstream commit 56fbbb662795b29f4d12a55cb1b456553a6ec3b0 ]

skb_attempt_defer_free() only queues skbs on the current CPU's node
(numa_node_id() of a running CPU), which is always online, so the
flush loop never needs to visit nodes that are merely possible.

for_each_node() walks node_possible_map.  On machines where the
possible map is much larger than the online map -- e.g. a POWER10
LPAR with 32 possible but 1 online node -- the flush loop touches 31
cold, always-empty per-node lists on every softirq pass.

Use for_each_online_node() to iterate only node_online_map.  Nodes
that go offline are drained by dev_cpu_dead() ("net: flush
skb_defer_nodes in dev_cpu_dead()"), so the flush no longer needs to
visit offline nodes.

Loopback UDP throughput in a QEMU guest with 32 possible / 1 online
nodes (bench_udp, 8 senders, interleaved runs) improves by ~5%.

Fixes: 5628f3fe3b16 ("net: add NUMA awareness to skb_attempt_defer_free()")
Reported-by: kernel test robot <oliver.sang@intel.com>
Suggested-by: Adrian Tomasov <atomasov@redhat.com>
Closes: https://lore.kernel.org/oe-lkp/202512112119.5b9829a-lkp@intel.com
Signed-off-by: Kris Pan <kris.pan@intel.com>
Link: https://patch.msgid.link/20260928014708.3903028-1-kris.pan@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index e0ce0fd728a8b..455ee43c248b1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6972,7 +6972,7 @@ static void skb_defer_free_flush(void)
 	struct skb_defer_node *sdn;
 	int node;
 
-	for_each_node(node) {
+	for_each_online_node(node) {
 		sdn = this_cpu_ptr(net_hotdata.skb_defer_nodes) + node;
 		__skb_defer_free_flush(sdn, 1);
 	}
-- 
2.53.0



