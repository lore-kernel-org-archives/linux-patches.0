Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB7835DA40;
	Sat, 12 Sep 2026 18:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238046; cv=none; b=YNd9uhDq89RPtWgdDN04LaivQGSdjhVCmdoxWK4l5IBviOPIZ1vmvvatJPKoDujnhPUnZzcYcJIR/CVdbybPJyE9cct9VSHEtbeDfd6NK1w8fWAwbgO45gQ6ZRyv5mBVjNytSe5TIn4oC2X7+c7GlJ6xrQ5u+G4CHYJGXe6pCHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238046; c=relaxed/simple;
	bh=gNu1ffDwqoM58zKtjOVez5eImGa8lGfpIH8rk0HC+1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7HKhVnMyM8LLUb70uHTRq4GoO68fKdtV34IVbFTpsaBtJ5+vRZyFkiyKOJ4+h0qjqUNl6iS64PR3gXPUqiMaOgenChvI6TED9atJtK76dOdu2xU6wJ+UtAPcD7TVGk6+vIz8clZM0hTvjzXfiSC0Qv7nnTYNk2izQ010t5cVNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVi+y31l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVi+y31l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B729C1F000FF;
	Sat, 12 Sep 2026 18:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238044;
	bh=w/VZkpDU7Xg6ZKToHHXNkzE3cgTFK2Qc3aRb+Az/vHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iVi+y31lOOEWRWk14fUABXhSgqvbY2hJebzsISVqS8O7nACGIJC/BMWnTFAAHhH4F
	 WnVBwZ8v4VxvGuqJZzKoIiQKVC9//YRGvFjpciM6Bf2xpbMe3g/tUUMxS6mtLuVi9e
	 AiAJpaDZal+7SWVsdhlhH7PfPRlM7Zc04S6w27qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 381/935] bridge: mrp: reject zero test interval to avoid OOM panic
Date: Sat, 12 Sep 2026 08:56:51 +0200
Message-ID: <20260912065535.557711885@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit fa6e24963342de4370e3a3c9af41e38277b74cf3 ]

br_mrp_start_test() and br_mrp_start_in_test() accept the user-supplied
interval value from netlink without validation. When interval is 0,
usecs_to_jiffies(0) yields 0, causing the delayed work
(br_mrp_test_work_expired / br_mrp_in_test_work_expired) to reschedule
itself with zero delay. This creates a tight loop on system_percpu_wq
that allocates and transmits MRP test frames at maximum rate, exhausting
all system memory and causing a kernel panic via OOM deadlock.

The same zero-interval issue applies to br_mrp_start_in_test_parse()
for interconnect test frames.

Use NLA_POLICY_MIN(NLA_U32, 1) in the nla_policy tables for both
IFLA_BRIDGE_MRP_START_TEST_INTERVAL and
IFLA_BRIDGE_MRP_START_IN_TEST_INTERVAL, so zero is rejected at the
netlink attribute parsing layer before the value ever reaches the
workqueue scheduling code. This is consistent with how other bridge
subsystems (br_fdb, br_mst) enforce range constraints on netlink
attributes.

Fixes: 20f6a05ef635 ("bridge: mrp: Rework the MRP netlink interface")
Fixes: 7ab1748e4ce6 ("bridge: mrp: Extend MRP netlink interface for configuring MRP interconnect")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260328063000.1845376-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mrp_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
index ce6f63c77cc0a..86f0e75d6e345 100644
--- a/net/bridge/br_mrp_netlink.c
+++ b/net/bridge/br_mrp_netlink.c
@@ -196,7 +196,7 @@ static const struct nla_policy
 br_mrp_start_test_policy[IFLA_BRIDGE_MRP_START_TEST_MAX + 1] = {
 	[IFLA_BRIDGE_MRP_START_TEST_UNSPEC]	= { .type = NLA_REJECT },
 	[IFLA_BRIDGE_MRP_START_TEST_RING_ID]	= { .type = NLA_U32 },
-	[IFLA_BRIDGE_MRP_START_TEST_INTERVAL]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_START_TEST_INTERVAL]	= NLA_POLICY_MIN(NLA_U32, 1),
 	[IFLA_BRIDGE_MRP_START_TEST_MAX_MISS]	= { .type = NLA_U32 },
 	[IFLA_BRIDGE_MRP_START_TEST_PERIOD]	= { .type = NLA_U32 },
 	[IFLA_BRIDGE_MRP_START_TEST_MONITOR]	= { .type = NLA_U32 },
@@ -316,7 +316,7 @@ static const struct nla_policy
 br_mrp_start_in_test_policy[IFLA_BRIDGE_MRP_START_IN_TEST_MAX + 1] = {
 	[IFLA_BRIDGE_MRP_START_IN_TEST_UNSPEC]	= { .type = NLA_REJECT },
 	[IFLA_BRIDGE_MRP_START_IN_TEST_IN_ID]	= { .type = NLA_U32 },
-	[IFLA_BRIDGE_MRP_START_IN_TEST_INTERVAL]	= { .type = NLA_U32 },
+	[IFLA_BRIDGE_MRP_START_IN_TEST_INTERVAL]	= NLA_POLICY_MIN(NLA_U32, 1),
 	[IFLA_BRIDGE_MRP_START_IN_TEST_MAX_MISS]	= { .type = NLA_U32 },
 	[IFLA_BRIDGE_MRP_START_IN_TEST_PERIOD]	= { .type = NLA_U32 },
 };
-- 
2.53.0



