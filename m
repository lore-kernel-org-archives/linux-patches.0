Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019892EE262;
	Tue, 31 Mar 2026 16:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975242; cv=none; b=RwjoTexPeHT9i/2G8z++zZxV3z1yBCgcaLUE5uLf3dM+MCIB706202yzwtZ/wp+25ZMtwsZwYJYJMj4ZVZUdH6/DPCYhZiM8ojzQP6ajcj798US0cqeuJNo2f0vc2r4aekfgHi7UY/GNQluJsOoGCJDbxR31DeuikGjLDmTwmJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975242; c=relaxed/simple;
	bh=kbfQuAl3N1lfLutqryqSqgS3vPX0IRhV9Xw+2PM+3Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8ziiY+grSHwGrCkuqn7A3+WIHE9v8BVCZlekU0N7skvGD8OKmNXc7J/IkYvWYssoAWqVNUYAtyJa+ku1agVEoZJo64MkokQXhn620YhPj5e7JWneTtYiYyJqHKcE/YR7yF/USSEDRwRbxNXiVo4MV9540bEUhujooPk4yqtIK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7axSOlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7axSOlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB92C19423;
	Tue, 31 Mar 2026 16:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975241;
	bh=kbfQuAl3N1lfLutqryqSqgS3vPX0IRhV9Xw+2PM+3Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7axSOlX2/q7f37aNXHjnFvJsC3hLiOrxunJvwp9JVsudLDg8p6a8aPlQhCBvf+aW
	 VtFEQgBCXy+It4Wjbvjhdg7+Oc0YufivB4wwEUPFktoQSvowHIYeLXfGwb8R0N2L39
	 Wten+d4oW8Nsa+PgDsMZMTFrWhKeA3kKCWYNq4Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 218/342] mm/damon/stat: monitor all System RAM resources
Date: Tue, 31 Mar 2026 18:20:51 +0200
Message-ID: <20260331161806.997574910@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 84481e705ab07ed46e56587fe846af194acacafe upstream.

DAMON_STAT usage document (Documentation/admin-guide/mm/damon/stat.rst)
says it monitors the system's entire physical memory.  But, it is
monitoring only the biggest System RAM resource of the system.  When there
are multiple System RAM resources, this results in monitoring only an
unexpectedly small fraction of the physical memory.  For example, suppose
the system has a 500 GiB System RAM, 10 MiB non-System RAM, and 500 GiB
System RAM resources in order on the physical address space.  DAMON_STAT
will monitor only the first 500 GiB System RAM.  This situation is
particularly common on NUMA systems.

Select a physical address range that covers all System RAM areas of the
system, to fix this issue and make it work as documented.

[sj@kernel.org: return error if monitoring target region is invalid]
  Link: https://lkml.kernel.org/r/20260317053631.87907-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260316235118.873-1-sj@kernel.org
Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/stat.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -145,12 +145,59 @@ static int damon_stat_damon_call_fn(void
 	return 0;
 }
 
+struct damon_stat_system_ram_range_walk_arg {
+	bool walked;
+	struct resource res;
+};
+
+static int damon_stat_system_ram_walk_fn(struct resource *res, void *arg)
+{
+	struct damon_stat_system_ram_range_walk_arg *a = arg;
+
+	if (!a->walked) {
+		a->walked = true;
+		a->res.start = res->start;
+	}
+	a->res.end = res->end;
+	return 0;
+}
+
+static unsigned long damon_stat_res_to_core_addr(resource_size_t ra,
+		unsigned long addr_unit)
+{
+	/*
+	 * Use div_u64() for avoiding linking errors related with __udivdi3,
+	 * __aeabi_uldivmod, or similar problems.  This should also improve the
+	 * performance optimization (read div_u64() comment for the detail).
+	 */
+	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
+		return div_u64(ra, addr_unit);
+	return ra / addr_unit;
+}
+
+static int damon_stat_set_monitoring_region(struct damon_target *t,
+		unsigned long addr_unit, unsigned long min_region_sz)
+{
+	struct damon_addr_range addr_range;
+	struct damon_stat_system_ram_range_walk_arg arg = {};
+
+	walk_system_ram_res(0, -1, &arg, damon_stat_system_ram_walk_fn);
+	if (!arg.walked)
+		return -EINVAL;
+	addr_range.start = damon_stat_res_to_core_addr(
+			arg.res.start, addr_unit);
+	addr_range.end = damon_stat_res_to_core_addr(
+			arg.res.end + 1, addr_unit);
+	if (addr_range.end <= addr_range.start)
+		return -EINVAL;
+	return damon_set_regions(t, &addr_range, 1, min_region_sz);
+}
+
 static struct damon_ctx *damon_stat_build_ctx(void)
 {
 	struct damon_ctx *ctx;
 	struct damon_attrs attrs;
 	struct damon_target *target;
-	unsigned long start = 0, end = 0;
 
 	ctx = damon_new_ctx();
 	if (!ctx)
@@ -188,8 +235,8 @@ static struct damon_ctx *damon_stat_buil
 	if (!target)
 		goto free_out;
 	damon_add_target(ctx, target);
-	if (damon_set_region_biggest_system_ram_default(target, &start, &end,
-							ctx->min_region_sz))
+	if (damon_stat_set_monitoring_region(target, ctx->addr_unit,
+				ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:


