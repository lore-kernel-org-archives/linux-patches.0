Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B687318ED6;
	Tue, 31 Mar 2026 17:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976999; cv=none; b=SKexBvjR0Re1TAsMLv1baY8z9YThEkBZObG239Ev4dMGjPnrZjfU7/dIl8DfykOEav4iOhXj1AX7GhwQVABVSwvjZSOYKFu/X+v7DxHi5sozHsDNzld3ukO1p1qwSiXQcibcgASpOPmWUq7aoebZ4KfDfmHcozqhfJ3F8euyHC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976999; c=relaxed/simple;
	bh=JsgLCGep0KSmh8eyULhV32dkOwJQO3fzVOVUrmm+qa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcbOo05JTlqIvOWkBgtTVspwHVgUR4l1js5w989AFt7JJShUfPlGyAe0E7mdezemSNs41JCQjyfCPu/E583CKkjZlm9WDrq8iYgwYwakH73wzyOiN8xjmxkQpV24TgCp8SwFQHJCBstdNjqd3R60azW7y1tnA74/3k1VmXlqmYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RK030S+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RK030S+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD046C19423;
	Tue, 31 Mar 2026 17:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976999;
	bh=JsgLCGep0KSmh8eyULhV32dkOwJQO3fzVOVUrmm+qa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RK030S+FeDgeBo2iKHo2pli1UroBLKLmytBuFnRkkn3CjeJQEbimWhd26uQLjAguy
	 Ovg4xC8EOxGciIlxQXatcIu/R6tQmIZa2DhUWOFAc/GT9sw4PEdeHAoVo3akNH53h/
	 bSW3XPh346RgQvN4ZOz5eh5UTzebHKakaXPd/M+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 277/309] mm/damon/stat: monitor all System RAM resources
Date: Tue, 31 Mar 2026 18:23:00 +0200
Message-ID: <20260331161803.757453674@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/stat.c |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -145,12 +145,44 @@ static int damon_stat_damon_call_fn(void
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
+static int damon_stat_set_monitoring_region(struct damon_target *t,
+		unsigned long addr_unit)
+{
+	struct damon_addr_range addr_range;
+	struct damon_stat_system_ram_range_walk_arg arg = {};
+
+	walk_system_ram_res(0, ULONG_MAX, &arg, damon_stat_system_ram_walk_fn);
+	if (!arg.walked)
+		return -EINVAL;
+	addr_range.start = arg.res.start;
+	addr_range.end = arg.res.end + 1;
+	if (addr_range.end <= addr_range.start)
+		return -EINVAL;
+	return damon_set_regions(t, &addr_range, 1, DAMON_MIN_REGION);
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
@@ -188,7 +220,7 @@ static struct damon_ctx *damon_stat_buil
 	if (!target)
 		goto free_out;
 	damon_add_target(ctx, target);
-	if (damon_set_region_biggest_system_ram_default(target, &start, &end))
+	if (damon_stat_set_monitoring_region(target, ctx->addr_unit))
 		goto free_out;
 	return ctx;
 free_out:


