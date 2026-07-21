Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967FC36DA1D;
	Tue, 21 Jul 2026 21:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669314; cv=none; b=UJoNxVNYdN85Oeweg8Mk51kr8e6ARefpHyqbazFS+OfRJ3KUpI7mQzsjjw4WqBzOHFZRu+PYOSiprNTGcru5VcAiRzdfdcSq4zT3IGH8gUl2fkLNh/X1g+jmkr/5f2wFEcXLGeiD8gv3HkVHUp+SzpczQVWNy3bypBGunFNlpQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669314; c=relaxed/simple;
	bh=smuAyTFuzEk6k7bKbu52kPKBkzilocS8HP1G810aU6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ge6tU5IgBbdbKhGrlA5QcWQyB4z0qjYGcAoETGvpN7JMie73wkoc7BCF6OJvZetzT8x0kNQ21YjugWI339BpYBU78WJVjTTrm86txfLMrC+0ZA0l3s5GgOfQDRUiHCQ0rEHMXXnwj8VLzJg/3luFA3/rmOyUL05Q5yUA4IfD6pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWBUYefp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWBUYefp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EA21F000E9;
	Tue, 21 Jul 2026 21:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669303;
	bh=omb7jTYVfSGtsM/nfBOPzFzxMHQ2/wNrp6klblE+prQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YWBUYefp3J/7LiQ3v9jtHhQiavMtl2UWqRZ53Bmdw5thZ6LPB9ZL3fZ3WKOgf+b7J
	 l9I/u6QU4WNLxsvtKtCdVGUl/iQ476XKoZQbPIivrD4SW65rJzOwLV5ZopzgBSGU/1
	 w9kneEYwNYODLoSGLXY53KSOBKGnVE+KDQFdRK8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0503/1067] perf tools: Add bounds check to cpu__get_node()
Date: Tue, 21 Jul 2026 17:18:24 +0200
Message-ID: <20260721152435.868795038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8486ca3bec75ff..370bc498b7a2e4 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -486,6 +486,10 @@ int cpu__get_node(struct perf_cpu cpu)
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



