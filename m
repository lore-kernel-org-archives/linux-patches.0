Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C1719DF4C;
	Wed, 23 Apr 2025 14:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419887; cv=none; b=ApXOUudEetpY7YFeGvraBR+QxpqRm9NNviVIa1txUubhwt4U5KGVHpDQdFA75szDwXzySF3OWVqQJh43w5zoNvqd0zRKbo0quP6gqZU2I+CgfsuSc1PHChcjfdpvE2ToV0Zu9jiju78tsp6X9IS/IHYAgsuhIpMOdcXawHlMY1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419887; c=relaxed/simple;
	bh=WLoMfyowHOjZYcNh7ABO1tdAtw34kpfvCtg2y2VWHYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKOU/ZUv06AWDkY6PGn+HhgMNxh3zK7FI6nLa39jau6fgq1vnq0QYaRNojVqRFZDItyQCyVbhZuz0lHvKt/tNJOkTV3adBfA3J02eGl6MqgiB0FpBeAV1Du/Z7xDtkp6MCWQVQ0k5a2XUn6TnD0ocnjPx+uddKoTt/4NHomKLuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQB5PVjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQB5PVjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F07C4CEE2;
	Wed, 23 Apr 2025 14:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419887;
	bh=WLoMfyowHOjZYcNh7ABO1tdAtw34kpfvCtg2y2VWHYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQB5PVjSGLuuu+mb7Hb9q+5UiALHN6kL7QljKtPVqWCGnpa7Qhfz2FoOMDPii4nHQ
	 LN908rHkWH8TX4v1qa6qaP1kKv3vVHOsFoc3lSvIyAWvizdXwu3yBHITGMnVTToqGw
	 s/S1+UtqEStqMkrVlXgRSxjKVHcWcN4HI0ZRZWv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chun-Tse Shao <ctshao@google.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 039/241] perf tools: Remove evsel__handle_error_quirks()
Date: Wed, 23 Apr 2025 16:41:43 +0200
Message-ID: <20250423142622.110255163@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 2b70702917337a8d6d07f03eed961e0119091647 ]

The evsel__handle_error_quirks() is to fixup invalid event attributes on
some architecture based on the error code.  Currently it's only used for
AMD to disable precise_ip not to use IBS which has more restrictions.

But the commit c33aea446bf555ab changed call evsel__precise_ip_fallback
for any errors so there's no difference with the above function.  To
make matter worse, it caused a problem with branch stack on Zen3.

The IBS doesn't support branch stack so it should use a regular core
PMU event.  The default event is set precise_max and it starts with 3.
And evsel__precise_ip_fallback() tries with it and reduces the level one
by one.  At last it tries with 0 but it also failed on Zen3 since the
branch stack is not supported for the cycles event.

At this point, evsel__precise_ip_fallback() restores the original
precise_ip value (3) in the hope that it can succeed with other modifier
(like exclude_kernel).  Then evsel__handle_error_quirks() see it has
precise_ip != 0 and make it retry with 0.  This created an infinite
loop.

Before:

  $ perf record -b -vv |& grep removing
  removing precise_ip on AMD
  removing precise_ip on AMD
  removing precise_ip on AMD
  removing precise_ip on AMD
  removing precise_ip on AMD
  removing precise_ip on AMD
  removing precise_ip on AMD
  removing precise_ip on AMD
  removing precise_ip on AMD
  removing precise_ip on AMD
  removing precise_ip on AMD
  removing precise_ip on AMD
  ...

After:

  $ perf record -b true
  Error:
  Failure to open event 'cycles:P' on PMU 'cpu' which will be removed.
  Invalid event (cycles:P) in per-thread mode, enable system wide with '-a'.
  Error:
  Failure to open any events for recording.

Fixes: c33aea446bf555ab ("perf tools: Fix precise_ip fallback logic")
Tested-by: Chun-Tse Shao <ctshao@google.com>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250410010252.402221-1-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9cd78cdee6282..c99eb9ff17ed6 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2556,25 +2556,6 @@ static bool evsel__detect_missing_features(struct evsel *evsel, struct perf_cpu
 	return false;
 }
 
-static bool evsel__handle_error_quirks(struct evsel *evsel, int error)
-{
-	/*
-	 * AMD core PMU tries to forward events with precise_ip to IBS PMU
-	 * implicitly.  But IBS PMU has more restrictions so it can fail with
-	 * supported event attributes.  Let's forward it back to the core PMU
-	 * by clearing precise_ip only if it's from precise_max (:P).
-	 */
-	if ((error == -EINVAL || error == -ENOENT) && x86__is_amd_cpu() &&
-	    evsel->core.attr.precise_ip && evsel->precise_max) {
-		evsel->core.attr.precise_ip = 0;
-		pr_debug2_peo("removing precise_ip on AMD\n");
-		display_attr(&evsel->core.attr);
-		return true;
-	}
-
-	return false;
-}
-
 static int evsel__open_cpu(struct evsel *evsel, struct perf_cpu_map *cpus,
 		struct perf_thread_map *threads,
 		int start_cpu_map_idx, int end_cpu_map_idx)
@@ -2720,9 +2701,6 @@ static int evsel__open_cpu(struct evsel *evsel, struct perf_cpu_map *cpus,
 	if (evsel__precise_ip_fallback(evsel))
 		goto retry_open;
 
-	if (evsel__handle_error_quirks(evsel, err))
-		goto retry_open;
-
 out_close:
 	if (err)
 		threads->err_thread = thread;
-- 
2.39.5



