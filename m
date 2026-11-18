Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016748;
	b=bUjY9WVswx7vQooo3HTF25ZGzTHCqKcTb1EJB6J/ur5KRd2CUD+s3uHnamdZmhB3JO90
	 Z5aqOh/37oz8BT7y29R+t6Ds3/0QUjip5dwcpee6ty24h1XtAIDZVjH6/KUloJnW+CDwA
	 aFPxMop7EZa0RSydGMcjRcSVeaQejVe7xng2W5CPehR2ls70kH/jKVCDdpthMtJbuN+u1
	 IuaeqLCyoMu1q8uEdXkSm+5xr1+tXBxntq4KvL24gXR1wUSdbyMn2FwPGJ50B6S9pU7xP
	 TEAN7xGzhJJc2QpDcTKEYp1usLfAmFHOYg+DAZ6hJTXxkNeeC/OGMcdv+XflyNBRSaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s9VsOHs/EGYAbpjlyZobjhuQ2VM1fHe8rG1MGYWSSS0=;
	b=3kfTQMrutBrTdoeh0jKRhZigGbOnQ9F1E9Ljuub54PHvysP76RzTRROD/oHN50KM4DAz
	 yhZZB90rEJ1jtG4/ld5xFU73xqk+l3y46phYdeShPGymq8i39vm+EcCzYN5StXrrj2niG
	 xqsEtXooqVkuvFPhP5Mw3466yEfcvjHhX8rXKnwJ0wRo7Z9t4+wd5fKtpok1KvEBlqIl6
	 8Puqwv6UMG858HWSf+/Nwk4CfeVvgqHO0ATrUzaz6Q/kQHbTS9YtCmT7zhW5DE9yTODjn
	 XypGcP0fSZM9IJKU9LUixV8QZ72V4E3DlKQdZXkNppriOMIEJj0Q273tExcoKNGaHTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MRkndlmR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CF3606A320;
	Wed, 18 Nov 2026 15:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MRkndlmR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E0F1F000C4;
	Wed, 18 Nov 2026 15:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016748;
	bh=s9VsOHs/EGYAbpjlyZobjhuQ2VM1fHe8rG1MGYWSSS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRkndlmRhBiR1/rjBhprLNWtc2yMILJXZ1PIEAGsqG185O86mR32aZcrGqqrOtxRA
	 fD2o7q1/6Kc036pk+5Du0jSMJDIun5WO2dxeZKROz6WNjUc1LdhiVlx66B4WdYGsh/
	 XypEbhgSqWTTJL23PNitBpsPVI72joRJeUfrC1kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Hui Su <sh_def@163.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0638/2651] perf synthetic-events: Fix schedstat event lifetime handling
Date: Wed, 18 Nov 2026 15:31:18 +0100
Message-ID: <20261118150310.655983116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit cf3d239189da0bd5122ae38c62f5fefdb744eb86 ]

perf_event__synthesize_schedstat() has two event lifetime issues.

After a successful iteration, event is freed but retains its value. If
the next iteration starts with an unrecognized schedstat record type,
neither synthesizer assigns a new value. The stale pointer then passes
the NULL check, may be passed to process(), and is freed again.

In addition, when user_requested_cpus filters out a synthesized event,
the continue path skips free(event), leaking the event.

Make event local to each loop iteration so it always starts as NULL.
Also avoid the filter continue and unconditionally free each synthesized
event at the end of the iteration.

Fixes: c3030995f23b3d35 ("perf sched stats: Add record and rawdump support")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/synthetic-events.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index 0c150193cca83..2eac2310a01da 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -2817,7 +2817,6 @@ int perf_event__synthesize_schedstat(const struct perf_tool *tool,
 				     struct perf_cpu_map *user_requested_cpus)
 {
 	char *line = NULL, path[PATH_MAX];
-	union perf_event *event = NULL;
 	size_t line_len = 0;
 	char bf[BUFSIZ];
 	__u64 timestamp;
@@ -2858,6 +2857,7 @@ int perf_event__synthesize_schedstat(const struct perf_tool *tool,
 	 * for filtered out cpus.
 	 */
 	for (ch = io__get_char(&io); !io.eof; ch = io__get_char(&io)) {
+		union perf_event *event = NULL;
 		struct perf_cpu this_cpu;
 
 		if (ch == 'c') {
@@ -2872,12 +2872,12 @@ int perf_event__synthesize_schedstat(const struct perf_tool *tool,
 
 		this_cpu.cpu = cpu;
 
-		if (user_requested_cpus && !perf_cpu_map__has(user_requested_cpus, this_cpu))
-			continue;
-
-		if (process(tool, event, NULL, NULL) < 0) {
-			free(event);
-			goto out_free_line;
+		if (!user_requested_cpus ||
+		    perf_cpu_map__has(user_requested_cpus, this_cpu)) {
+			if (process(tool, event, NULL, NULL) < 0) {
+				free(event);
+				goto out_free_line;
+			}
 		}
 
 		free(event);
-- 
2.53.0



