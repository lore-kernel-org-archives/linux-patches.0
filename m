Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048566;
	b=xMU/w4nBs8jcuy938Y+bQYqwij+ORyvvyKCYdyKJOWD+o11wmQjF2k8RRPrWBx3BKcwG
	 Zlawfeb+ISMJ91h6MmPcH5OPm78qSri5YSkqqNP8CNqtEwFsEGzKLcfSciY1/RkBx+0dM
	 oFjPNZZzupbs3KW0NY8ebYXBLzh/7wJXhM92oN3ATGh/qD2xC9pnUOv0nM+PqoXGTFnYf
	 IJ7JZMomEBVZl/w2Jhoxf5Qs6kaoWqkE9QS+att9gfXOEbAZXExjyHgwdQcmUehW/Abte
	 gHNCbG1028fcP8RP/4gj5wyqnxJOyWgpOIOfhTgSjxzRtdWqY5euNbNYlgzp/Z69eGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7uO0zIVcjJyFUHhEqg9yIGWAniOzlFrTQ5HNRHge6/k=;
	b=MfWp4StC0uFn2fKjst39EM11Y3uQxaLasX9KjK3Y5ThgjOppYBJ91zKVWviwUn4lT+H1
	 SY0f2r02RwpOIPxYv4Ac2nIglbbxP9+hFvcaMK5Kf+y0wQFG0pn9VE1D0AffI1l2wgnOd
	 iS/TmVno404tIxIrxlBx05MhE627SktoR5Qfe8DlaVJFMjbJ/LzqFahjqI++qVjiSr88J
	 QiAw2nrFKNvI1rZMc47y1V7UOa18dgVcCXFMDVijCgg5hMMVXR+jtKNVqBoHSpmBDyVlX
	 BitV6mYj2fz+bVCy94VCkJGZ35KJ5IdZyuM1rCBKnfyPvPOoSsLT+UJN9STiYbuvQBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d5OnpXz7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B16606A32C;
	Thu, 19 Nov 2026 00:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d5OnpXz7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3B41F000C4;
	Thu, 19 Nov 2026 00:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048566;
	bh=7uO0zIVcjJyFUHhEqg9yIGWAniOzlFrTQ5HNRHge6/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5OnpXz7rxfi1yl8sZhQt3VvDztCua4KKwdvNcpmfZQwgVkFMG/KPEYUSPxXw2aYE
	 R6OR+kxE7OUg3wZYUntHARj6OHt5hAWKn/PIbbRFt9wVufzleZdJ9ktcwmqQM7Q9jb
	 ffHPIvGnYiA8PMlyrSGNxdTdw4U8Acfqz+ym1qj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Leo Yan <leo.yan@linux.dev>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2041/2857] perf mem: Fix size tracking for mem_lvls in perf_script__meminfo_scnprintf()
Date: Wed, 18 Nov 2026 15:51:15 +0100
Message-ID: <20261118150314.902565514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Falcon <thomas.falcon@intel.com>

[ Upstream commit 06d5ce78e4fea2cf0738da903aa248a81101c155 ]

When printing memory info in perf script, the entire size of the
buffer is passed to perf_mem__lvl_scnprintf() instead of the remaining
size. Pass the remaining buffer size instead.

This issue was detected by sashiko during an internal code review.

Fixes: fdefc3750e847a91 ("perf mem: Print memory operation type")
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Leo Yan <leo.yan@linux.dev>
Assisted-by: Sashiko:gemini-3.1-pro-preview
Signed-off-by: Thomas Falcon <thomas.falcon@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/mem-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/mem-events.c b/tools/perf/util/mem-events.c
index b3a91093069a5..4b1172f922ff3 100644
--- a/tools/perf/util/mem-events.c
+++ b/tools/perf/util/mem-events.c
@@ -508,7 +508,7 @@ int perf_script__meminfo_scnprintf(char *out, size_t sz, struct mem_info *mem_in
 	i += scnprintf(out, sz, "|OP ");
 	i += perf_mem__op_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|LVL ");
-	i += perf_mem__lvl_scnprintf(out + i, sz, mem_info);
+	i += perf_mem__lvl_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|SNP ");
 	i += perf_mem__snp_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|TLB ");
-- 
2.53.0



