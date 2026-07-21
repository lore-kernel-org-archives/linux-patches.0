Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC61432E74;
	Tue, 21 Jul 2026 19:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662556; cv=none; b=jv7t60/lvumUuAwGuZAlaNBNDDWlZwzcsmmDJt43jVOEnFD6Fj1+stpVykaSD2rR1i/fXyi29W4EnEN/e08kfDm64fyubKI2BLCePQOHnfUUwmTH2P0A8Cyn01iLJR0MZrCG8B0/5SzZ4TumrDuB4B7WD5s2xrwTJC2AJ4bsn7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662556; c=relaxed/simple;
	bh=tEhwC3bNbE4wVE1ze77NYvvOZ4sc/6lcZByAlNxtMYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUyFqLx01IdW3uJKUC23O/Ye3bdnRuvg0qs4theEU5h+uqtPcs+mgNAgJZAJm6oohVYLRqj0pIq0HMDTXwYvRFOhjl10f9QENKDjXjedOQZO3zhkXdPeLAYMA1eAFf6LlMGlTN2s7roT8T91Aq6iQ/fOUNRmvMcOt659YE92vpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sd3gNJdm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sd3gNJdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0671F000E9;
	Tue, 21 Jul 2026 19:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662554;
	bh=co4HWv3KmkNRYZXwkLKMYI42jacTttuxaZmj5V33n3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sd3gNJdmfYV3LDz6tm/HUwy+HTs8fcYPAgFQTTd/Rgx/W1v0aQHopIXL0RvcKjVIO
	 PuONIiT2oMYJTE8ttQo4DrRfURUO1TmzHt2W931pqQDohJryb+0VL4+XnCeLmiZWlB
	 gwDiTTxM30gOFC7HfF1QyFv01fijC7UmzNiPjLfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0462/1276] perf tools: Add bounds check to cpu__get_node()
Date: Tue, 21 Jul 2026 17:15:05 +0200
Message-ID: <20260721152456.441394252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 27094211edd8a8..7cafa6672d4fb4 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -522,6 +522,10 @@ int cpu__get_node(struct perf_cpu cpu)
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



