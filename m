Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619513770B;
	Tue, 21 Jul 2026 20:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666332; cv=none; b=TTqKaGsi/1HPgcqanAwNIbgZ/O7fZgXHQrlAPutc1nideWxxxvF2U95O9437VU48n+X5pzJtcG1Yom7kWJBcnT/7vC5NBB5gOOjnTlBrXU7ixugwG0yYIEgwVaYtW2jgj0oV0vcE5a4i8EVVbZWkk5SWeEFraoN6BUFXA21sRr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666332; c=relaxed/simple;
	bh=4dAdBu7+o6k2lQ7VK1gtSozeb4LVOLVMJvVP9JX0Wwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlHygW3egADp9asN8jrBSCi2ykIrofdqytKGsT5BWq0kpAB9MW4tD9rmzPFBLdPc+KyuV7cmY7slO8m5GItMRbAttFKUyBxv2Ix+VcNasMpMixZbWNBuveHE0th8nCtNcv/Kj6podESgByDM6D83Z5zAIxxssHF1UOLzDlKmAc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Qx6GBk4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Qx6GBk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76E21F000E9;
	Tue, 21 Jul 2026 20:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666327;
	bh=ecnU2DcHYhUsdDZYCwRtbCKeSy2SXwFbdkBntNUb39I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Qx6GBk4DbEUFQiamZkwfbi4zYTPadw+K7Bf9VieKPuuTIBGWFNwIaOTl1jWQxiWg
	 0B2IWfKXtzusq2ZRTaR1/WxfN7Br2syES734uEPaH3aG4nEukTP55hpGAwzoQJ954Z
	 TGoEFDmQ/bXmMdWtUPC25YD/YNFgL1CGK4eAvl20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0639/1266] perf tools: Add bounds check to cpu__get_node()
Date: Tue, 21 Jul 2026 17:17:56 +0200
Message-ID: <20260721152456.155577013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0e090e8bc33491..75d9f5d6d185d1 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -498,6 +498,10 @@ int cpu__get_node(struct perf_cpu cpu)
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



