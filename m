Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E98269B0E;
	Tue,  8 Apr 2025 11:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111502; cv=none; b=kZaDVpj3IQCKx1lg8J+pB5tX63I5dCGCw6Pw7WxuNQp5xrNDIRZ4suDW4Ws+QoEjN7JVmGp+bAECh1cYoQkQxttKylxsbBXXv5oIMQf/NEb5PzA/RB5OL48txDZXPaTr6CegHnip70z5p+6m9NfGYYEBUEDQdjXwqBs/57mo4Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111502; c=relaxed/simple;
	bh=la99yFmYfgL+KaC5CWMcu3teG505t5lMEaR4b7uptD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oiq64uOrAn6QdCOLpYKhsQ9/2luA8Xh/WPNRjuluH3DF548eVFhmWnDMQvn0VIMHa22ERTPmeodc+C0AF8P10hu8NwojWWkJnIkGG6BGb6BflVGvEH/Vtigqlxx7tSC79rWplifl6agZLN9J+q/k4krjkSQZzqUESU5EyNfCAz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5AILMz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5AILMz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62371C4CEE5;
	Tue,  8 Apr 2025 11:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111501;
	bh=la99yFmYfgL+KaC5CWMcu3teG505t5lMEaR4b7uptD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5AILMz2w/bACA4tHLeQmt9Cahu6qDcpF92H4xPujBrjXfu8zzrdKu5LdStXwI4bl
	 dKTy0lQKS28fzx5mzsiN5PigMHIiIxNA2X3jJ3K+690UOsEJFOXS/wlpRGLfQcjYRz
	 s7RRKPerqQBfYPxcdiiBxMdoVrpp1GWs/YH3CFMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	thomas.falcon@intel.com,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 453/731] perf tools: Add skip check in tool_pmu__event_to_str()
Date: Tue,  8 Apr 2025 12:45:50 +0200
Message-ID: <20250408104924.816113311@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit ee8aef2d232142e5fdfed9c16132815969a0bf81 ]

Some topdown related metrics may fail on hybrid machines.

 $ perf stat -M tma_frontend_bound
 Cannot resolve IDs for tma_frontend_bound:
 cpu_atom@TOPDOWN_FE_BOUND.ALL@ / (8 * cpu_atom@CPU_CLK_UNHALTED.CORE@)

In the find_tool_events(), the tool_pmu__event_to_str() is used to
compare the tool_events. It only checks the event name, no PMU or arch.
So the tool_events[TOOL_PMU__EVENT_SLOTS] is set to true, because the
p-core Topdown metrics has "slots" event.
The tool_events is shared. So when parsing the e-core metrics, the
"slots" is automatically added.

The "slots" event as a tool event should only be available on arm64. It
has a different meaning on X86. The tool_pmu__skip_event() intends
handle the case. Apply it for tool_pmu__event_to_str() as well.

There is a lack of sanity check in the expr__get_id(). Add the check.

Closes: https://lore.kernel.org/lkml/608077bc-4139-4a97-8dc4-7997177d95c4@linux.intel.com/
Fixes: 069057239a67 ("perf tool_pmu: Move expr literals to tool_pmu")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: thomas.falcon@intel.com
Link: https://lore.kernel.org/r/20250207152844.302167-1-kan.liang@linux.intel.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/expr.c     | 2 ++
 tools/perf/util/tool_pmu.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/expr.c b/tools/perf/util/expr.c
index c221dcce66660..6413537442aa8 100644
--- a/tools/perf/util/expr.c
+++ b/tools/perf/util/expr.c
@@ -215,6 +215,8 @@ int expr__add_ref(struct expr_parse_ctx *ctx, struct metric_ref *ref)
 int expr__get_id(struct expr_parse_ctx *ctx, const char *id,
 		 struct expr_id_data **data)
 {
+	if (!ctx || !id)
+		return -1;
 	return hashmap__find(ctx->ids, id, data) ? 0 : -1;
 }
 
diff --git a/tools/perf/util/tool_pmu.c b/tools/perf/util/tool_pmu.c
index 4fb0975784794..3a68debe71437 100644
--- a/tools/perf/util/tool_pmu.c
+++ b/tools/perf/util/tool_pmu.c
@@ -62,7 +62,8 @@ int tool_pmu__num_skip_events(void)
 
 const char *tool_pmu__event_to_str(enum tool_pmu_event ev)
 {
-	if (ev > TOOL_PMU__EVENT_NONE && ev < TOOL_PMU__EVENT_MAX)
+	if ((ev > TOOL_PMU__EVENT_NONE && ev < TOOL_PMU__EVENT_MAX) &&
+	    !tool_pmu__skip_event(tool_pmu__event_names[ev]))
 		return tool_pmu__event_names[ev];
 
 	return NULL;
-- 
2.39.5



