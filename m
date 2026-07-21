Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61944415F20;
	Tue, 21 Jul 2026 18:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657243; cv=none; b=M3YirmJRXU50uF6fmo5T4vsfFJmO40Ouo7c5MhSZEHR9YQ93oTUl8Q+2ZE8qkzCJytT0bEO+AkdHQKneAjWUmFQ8wW8k5MhuMGx5kP3YL3Qb7lStmOJt3l6k+JywdDqfIOJzB2JX5opaGVxtdf8Q6TYrZAw9QwG1HTmhQjGBRSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657243; c=relaxed/simple;
	bh=UxstyDary3iMGRSdqUH5aA0gyUOTTlAqcb5b/VhlkYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdXzCmA6i1X/IQNiRXEef/keIrAdGo3GyPhzeb7LL6Ty5SIgiZS9LLua0HIa3HKAk6AZpz8rNj8wp0ANigaspwpPH5gMEv9c2heHYsE+Jjzn1Borsg/GdiEH/JKVcVxsyx08jtN0XnKZrOGaOYAVUx2JTkRuAwmi7Zr5cXRXZX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkC8+Mro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkC8+Mro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BDB1F000E9;
	Tue, 21 Jul 2026 18:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657242;
	bh=J8C47prDHC/UhTWE7IbS8ifx1gi6ACwQpldt9YcLdHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkC8+Mro9snXBHstQrvE+BIpioK/UqIBt/lTPqhxRviyHm04Bly+MCA9lQZHuuMlv
	 vKMqfD6q/Q1Jbe4/QziH2yc1P0NGKxT2bfC+Tiw0v6wqz/YeLmQvLSDc33oT6LAvaB
	 TkxoIZz1cKSmYJp2G7IUJpygbMFimMyLXnJrC6bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0689/1611] perf tools: Use scnprintf() in cpu_map__snprint() to prevent overflow
Date: Tue, 21 Jul 2026 17:13:25 +0200
Message-ID: <20260721152530.878143166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 7953a3a9b8e02e98c6e6958f291d0ae22393e46a ]

cpu_map__snprint() accumulates snprintf() return values in ret.
snprintf() returns the number of characters that *would have been
written* on truncation, not the actual count.  When a fragmented CPU
list exceeds the buffer, ret grows past size, causing `size - ret` to
underflow (both are size_t), and subsequent snprintf() calls write
past the end of the caller's stack buffer.

Switch to scnprintf() which returns the actual number of characters
written, making ret accumulation safe by construction.

Fixes: a24020e6b7cf6eb8 ("perf tools: Change cpu_map__fprintf output")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cpumap.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index bbf959b443ab1f..d243eee1154276 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -664,21 +664,21 @@ size_t cpu_map__snprint(struct perf_cpu_map *map, char *buf, size_t size)
 		if (start == -1) {
 			start = i;
 			if (last) {
-				ret += snprintf(buf + ret, size - ret,
-						"%s%d", COMMA,
-						perf_cpu_map__cpu(map, i).cpu);
+				ret += scnprintf(buf + ret, size - ret,
+						 "%s%d", COMMA,
+						 perf_cpu_map__cpu(map, i).cpu);
 			}
 		} else if (((i - start) != (cpu.cpu - perf_cpu_map__cpu(map, start).cpu)) || last) {
 			int end = i - 1;
 
 			if (start == end) {
-				ret += snprintf(buf + ret, size - ret,
-						"%s%d", COMMA,
-						perf_cpu_map__cpu(map, start).cpu);
+				ret += scnprintf(buf + ret, size - ret,
+						 "%s%d", COMMA,
+						 perf_cpu_map__cpu(map, start).cpu);
 			} else {
-				ret += snprintf(buf + ret, size - ret,
-						"%s%d-%d", COMMA,
-						perf_cpu_map__cpu(map, start).cpu, perf_cpu_map__cpu(map, end).cpu);
+				ret += scnprintf(buf + ret, size - ret,
+						 "%s%d-%d", COMMA,
+						 perf_cpu_map__cpu(map, start).cpu, perf_cpu_map__cpu(map, end).cpu);
 			}
 			first = false;
 			start = i;
-- 
2.53.0



