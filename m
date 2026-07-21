Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FED38910F;
	Tue, 21 Jul 2026 18:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660317; cv=none; b=UtjMypGD1eEFd/ViI0yVjXtGBcC7qEc08y11vOnqh/2Pvgv8//1ihJ3hnjKIlpNzJ2Oii6uHqAvGL6KSjwS7jrlVs2G1QL5ZL2+ICaLaoesGplWZhPj2RreHTnvBbB9woZar77SZ+Im2/fFSBQn50a0ujDb2ycwK0Xe+dA4NxKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660317; c=relaxed/simple;
	bh=ahoeWRsXQCpDXM85tW/+COb7zcL1qJp6XsBF4rqvIK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2XoYJnnavZA7sDzKuGY1vKDkq8Mi7Zp9lfz0rKYFn5bVLaL9PQdXLxPqZHgX+xua6DBodp4yWT06TGc3D5+xp7txKF1JpPy3F+bakyxGhsMfjL7UmFs3o3oUDNUj8iJE2WRrHezpbuxYheTKQdCuZR4u6PnL6fXxTm6vAuEqDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIsdCYK3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIsdCYK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEB41F000E9;
	Tue, 21 Jul 2026 18:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660316;
	bh=52jv0+T2PD4itjo7MHIfhvgIG37VhxvkmSoQUJY/5r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIsdCYK3jp+NF1vNxNbHjmKfwMf0IQXpmZHq2Gsjcfzv2x+/+Y5r7K9ZR7CYcqhOn
	 0ymODx47e40wIWbCnSOSalAo0IWpK0ek+5jr0Uo0/8XPektRToNtxPuNjCW2gbKRR/
	 6aH32035OKXKgs+ZpGPEcfmbmyUrkSof5IMeZrJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0935/2077] perf tools: Add bounds check to cpu__get_node()
Date: Tue, 21 Jul 2026 17:10:08 +0200
Message-ID: <20260721152614.869227059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 1e7921d7227de5da0dfc167943092c823ec7e49b ]

cpu__get_node() accesses cpunode_map[cpu.cpu] without checking against
max_cpu_num, the allocation size of cpunode_map.  Callers such as
builtin-kmem.c:evsel__process_alloc_event() pass sample->cpu from
perf.data events, which may exceed the host's CPU count when analyzing
cross-machine recordings.

Add a bounds check against max_cpu_num before indexing, returning -1
for out-of-range values.  This is a central fix that protects all
callers.

Fixes: 86895b480a2f ("perf stat: Add --per-node agregation support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cpumap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 11922e1ded844a..19783c83765726 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -548,6 +548,10 @@ int cpu__get_node(struct perf_cpu cpu)
 		return -1;
 	}
 
+	/* cpunode_map allocated for max_cpu_num entries; input may be untrusted */
+	if (cpu.cpu < 0 || cpu.cpu >= max_cpu_num.cpu)
+		return -1;
+
 	return cpunode_map[cpu.cpu];
 }
 
-- 
2.53.0



