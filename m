Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC5A273D6C;
	Tue,  5 Aug 2025 13:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399511; cv=none; b=YEzN0Ck6KAcvUJJPptDlmd4d3i70U4kIadxC8b2w7rTkn1X14Cyxt5IinvjzNhn+TDWrMv6CMajiC1GEAJOCJvYBPwlgFdD6+lvi+LrmXn90iGJ/s3iwabrCNChLKKpMygzNFTO1RVVS/uZHaFK7zHp8CGeQQA66e5rDCSB25K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399511; c=relaxed/simple;
	bh=PPnXgEutaQ4qB1mw4M4MoqHg4W5+iTeMyKlv84ojGMY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ChRT4CHvWNGX+FOXDUjWnxTHD6WMbbOFzPnrjkP+BFb0pEk2gGdennIR/GoKqlVCLBxhrQp/H37P84Bw8vPA3Fmid4kyybXvih2HXUiIYkeEdL1ZjsyrZ3pqLGIz+4vd746YggfSKuLvOI0rNiaenpxjjJ7UkcHtl4wcb3xikMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oY9z4Tb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oY9z4Tb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057DDC4CEF0;
	Tue,  5 Aug 2025 13:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399510;
	bh=PPnXgEutaQ4qB1mw4M4MoqHg4W5+iTeMyKlv84ojGMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oY9z4Tb1wNLB6/t/2YvKHleTBDYQ2ulpKhxezNvnPE+21BrDcvqn00JbX/GRezKAA
	 jy9I5SaDqJh38/F7fahYBY6zOvnbggnz7Zt/tqPLwZknxR2Xm2W/eNK2RdCrSFiPqF
	 06jhRu3iBLywhL5tJFk/4+yxYMV3BVsZSYzd2rw2ddZ7Zn9E+j9UP5spPXnp6TWjLD
	 vwvzmWgR+HSV9pzQnHq8tBAldIjit1nTPrj38Qz3ddcRRLYerWVDHatqIk/Hxv2yew
	 ff3vTOO57lS+LaH4mZ+bU5Ex3zQLplCLw0vcsb4/NzIf2xQumbh7pRqmmnO4m6hXaM
	 rOfctIsB7zJQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	cmeiohas@nvidia.com,
	michaelgur@nvidia.com,
	kalesh-anakkur.purayil@broadcom.com,
	mbloch@nvidia.com,
	parav@nvidia.com,
	qianqiang.liu@163.com,
	phaddad@nvidia.com
Subject: [PATCH AUTOSEL 6.16-5.10] RDMA/core: reduce stack using in nldev_stat_get_doit()
Date: Tue,  5 Aug 2025 09:09:30 -0400
Message-Id: <20250805130945.471732-55-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 43163f4c30f94d2103c948a247cdf2cda5068ca7 ]

In the s390 defconfig, gcc-10 and earlier end up inlining three functions
into nldev_stat_get_doit(), and each of them uses some 600 bytes of stack.

The result is a function with an overly large stack frame and a warning:

drivers/infiniband/core/nldev.c:2466:1: error: the frame size of 1720 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]

Mark the three functions noinline_for_stack to prevent this, ensuring
that only one copy of the nlattr array is on the stack of each function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20250620113335.3776965-1-arnd@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Being Fixed

The commit fixes a **real compilation error** that occurs on s390
architecture with gcc-10 and earlier compilers. The error message shows:
```
drivers/infiniband/core/nldev.c:2466:1: error: the frame size of 1720
bytes is larger than 1280 bytes [-Werror=frame-larger-than=]
```

This is a build failure that prevents the kernel from compiling on s390
systems, which is a significant issue affecting users.

## Nature of the Fix

The fix is extremely minimal and safe:
1. **Three functions are marked with `noinline_for_stack`**:
   - `res_get_common_doit()`
   - `stat_get_doit_default_counter()`
   - `stat_get_doit_qp()`

2. **No functional changes**: The code logic remains identical - only
   the compiler optimization behavior is modified to prevent inlining.

3. **Stack usage optimization**: Each function uses ~600 bytes of stack
   (likely from large `struct nlattr` arrays). When inlined into
   `nldev_stat_get_doit()`, this causes cumulative stack usage of 1720
   bytes, exceeding s390's 1280-byte limit.

## Code Analysis

Looking at
`/home/sasha/linux/drivers/infiniband/core/nldev.c:2438-2466`, the
`nldev_stat_get_doit()` function calls three helper functions:
- Line 2450: `stat_get_doit_default_counter()`
- Line 2454: `stat_get_doit_qp()`
- Line 2457: `res_get_common_doit()`

Each function declares `struct nlattr *tb[RDMA_NLDEV_ATTR_MAX]` which is
a large stack array. The `noinline_for_stack` attribute ensures these
arrays aren't all allocated on the same stack frame.

## Stable Tree Criteria

This commit meets multiple stable tree criteria:
1. **Fixes a real bug**: Build failure on s390 architecture
2. **Minimal change**: Only adds compiler hints, no logic changes
3. **Low regression risk**: Cannot introduce functional regressions
4. **Architecture-specific fix**: Critical for s390 builds
5. **Clear problem/solution**: Well-documented issue with
   straightforward fix

## Additional Considerations

- The fix is platform-agnostic despite being triggered on s390, making
  it safe for all architectures
- Similar patterns (`noinline_for_stack`) are used throughout the kernel
  for stack optimization
- The commit message clearly documents the problem and solution
- No new features or architectural changes are introduced

This is an ideal stable backport candidate - it fixes a real compilation
issue with zero functional risk.

 drivers/infiniband/core/nldev.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index a872643e8039..e9b7a6419291 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1469,10 +1469,11 @@ static const struct nldev_fill_res_entry fill_entries[RDMA_RESTRACK_MAX] = {
 
 };
 
-static int res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
-			       struct netlink_ext_ack *extack,
-			       enum rdma_restrack_type res_type,
-			       res_fill_func_t fill_func)
+static noinline_for_stack int
+res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+		    struct netlink_ext_ack *extack,
+		    enum rdma_restrack_type res_type,
+		    res_fill_func_t fill_func)
 {
 	const struct nldev_fill_res_entry *fe = &fill_entries[res_type];
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
@@ -2263,10 +2264,10 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }
 
-static int stat_get_doit_default_counter(struct sk_buff *skb,
-					 struct nlmsghdr *nlh,
-					 struct netlink_ext_ack *extack,
-					 struct nlattr *tb[])
+static noinline_for_stack int
+stat_get_doit_default_counter(struct sk_buff *skb, struct nlmsghdr *nlh,
+			      struct netlink_ext_ack *extack,
+			      struct nlattr *tb[])
 {
 	struct rdma_hw_stats *stats;
 	struct nlattr *table_attr;
@@ -2356,8 +2357,9 @@ static int stat_get_doit_default_counter(struct sk_buff *skb,
 	return ret;
 }
 
-static int stat_get_doit_qp(struct sk_buff *skb, struct nlmsghdr *nlh,
-			    struct netlink_ext_ack *extack, struct nlattr *tb[])
+static noinline_for_stack int
+stat_get_doit_qp(struct sk_buff *skb, struct nlmsghdr *nlh,
+		 struct netlink_ext_ack *extack, struct nlattr *tb[])
 
 {
 	static enum rdma_nl_counter_mode mode;
-- 
2.39.5

