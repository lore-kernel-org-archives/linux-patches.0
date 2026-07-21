Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144ED395D99;
	Tue, 21 Jul 2026 20:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666389; cv=none; b=JgQaJ3xZabu6fTO7phdY2j6iTMsG+Vktin+blEnXfRZ8Ys8ftwVleWaHyJJmAgrwIxwR2dmpb+TPULeTIBh5TerqUHeXOclAHEOGB36FuNC+OojDPMPP+qNNAUuyKlbvMZm6J1EGd/oUXnUkNtaydPcAPRYPswld1b5ozftfTJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666389; c=relaxed/simple;
	bh=dP++mNBuCAZYU+9z500IXuphOgWmwcLG704xc8qd34o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAMM95je0RE/H2T2QHZApTcYbXPwXut3e3YncJjQEW/ClOq86bRzbG0QxG0x+exzmbantyL5v5W+Pn+rgIaK8TMGARrVnOoXN3RazUMJunvpU13+2Cu92MEA4rS6YVfr0z51Sp7t7OAUwXpRZ/UHrlyCJH2G7RYGxr4BJQVQ4wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=se4mzrs+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="se4mzrs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D051F000E9;
	Tue, 21 Jul 2026 20:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666388;
	bh=oJjM5llFZgdhwe+vJe72B/U3WwfEil880W/0YQ7uq/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=se4mzrs+fW+03iJTWiXwKHga0Uocbz1AIm7igy4JxR0ZAZESYSw4a03A2SsfTu29N
	 jZQPul/xV8kOsKbmSeHQ9oqN88o8ZjEzJWobT32s5/qohsNUbbAxiATrQgrZn6DbeH
	 dT6J4RoYaOX2eHj3+QthIRyyJJqIJeZdw7Q24qHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0664/1266] perf tools: Use scnprintf() in cpu_map__snprint() to prevent overflow
Date: Tue, 21 Jul 2026 17:18:21 +0200
Message-ID: <20260721152456.717842106@linuxfoundation.org>
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
index de4a710e242146..c5126cdbd7dd70 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -601,21 +601,21 @@ size_t cpu_map__snprint(struct perf_cpu_map *map, char *buf, size_t size)
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



