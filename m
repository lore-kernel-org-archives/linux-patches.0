Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344F43176EE;
	Sat, 12 Sep 2026 19:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242213; cv=none; b=CfG4lOYd72EKCSwbQUbGvDONLXR10CVYe84oMMWcHhc7XC0K+iZ1zpRhvOHgHwT3xqf5JEhvJ4IoLHHN/1l32/WL8I3DlDq7IJp/1OeV5rskVkmWUzAgWNe3KZ5wEvnI9DMorKbgcnCxUwojDLNQ7Efv1fKOjVBYP2eOgVBWOr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242213; c=relaxed/simple;
	bh=JRC79qRhjzyKxE4DjcXX0JNpZM3dV1gvZQlMn6JWaec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCqU0heM0mq6xFQbMZ+WLWB6PsZ51nF6XU0OVyN7ClIijMOz88bGZgak3AbKhGq5eLYSY0al0UVkQXzmCuIq3+Y1aa1a1iJqKY3PEIAU7GAwnYXTBWoOWdIomcNckVF2EBtk3LAAmyMpLppAikSuR9P5yej1/qzYhtFZLqKOw6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Al+c790c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Al+c790c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977FB1F000FF;
	Sat, 12 Sep 2026 19:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242212;
	bh=/hLFrIG3LTn203/U2GCJ8Ec7lj6YyxglXMVqXk7SPo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Al+c790cIozWdopKyDVBuXPfYy5Iyguw0qPSTT5HkUFU/dEHjr/qYVd9O5D9WCkuS
	 dmmtAHWhVgu3qZUdhVTYVp8Yaj7VXPNTGOrx9M5NcjQ2MvJydJsff3m1FKHxb9Ilvu
	 axav7ZNgfjZW3Q1YvKLUxFXk5ewPtpM4eQ+BAovc=
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
Subject: [PATCH 5.10 324/798] bridge: mrp: reject zero test interval to avoid OOM panic
Date: Sat, 12 Sep 2026 08:59:12 +0200
Message-ID: <20260912065524.589307281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2a2fdf3500c5b..95f265e9cf294 100644
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



