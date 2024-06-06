Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B011A197521;
	Thu,  6 Jun 2024 14:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683650; cv=none; b=qTHfrejZ4fOrELQJjDeOi+GphpQQuPTmg5jBQXoc2ENoRUwCnwxsjse5tbw3JoQPtci7fXVHSmZvLoNiug893+qbHCW9U8eAwyN7hGKOocjZCzPpIpltf/M5JAQ8xOs5mcmLXQkYfmiNPZhI2WyTVyAwiM7DspgyxVX1V3ObbTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683650; c=relaxed/simple;
	bh=jITht7BmQF9Cog5XtMVT7J0I5cBICVwIp7+dB+RsVF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLn6yQosSABC4y2M7urrnY5MwgZNluv7Mh6eDQH+eKIR2kTFsD/PRJi0puiAkxgZmQgOvy8WvNuCaVKVcWu6zN9NALcuYO7muDHnThfhAkaOiY7YuvLQzirqspr/TGgMHUtBntwE4fQapyhsUVHESenBtANkwl50IrmqguQrde4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6eY4Ovi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6eY4Ovi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFD7C2BD10;
	Thu,  6 Jun 2024 14:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683650;
	bh=jITht7BmQF9Cog5XtMVT7J0I5cBICVwIp7+dB+RsVF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6eY4OviHKskomn31ZDbVTiGg4LkGyn3erD8GMXkTgU7lnJ+RGnvdl9uOgURGlhET
	 bn4+ka3oxgXeg59P6qtrbhPHFt0orMv+vJS93288tZjMY12yZ3SC8u9GRStPifirlr
	 SiNJHLmfPqsWAofMTJcOnecT3Ao6WS9sSHnHE2gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 521/744] perf daemon: Fix file leak in daemon_session__control
Date: Thu,  6 Jun 2024 16:03:13 +0200
Message-ID: <20240606131749.151476773@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit 09541603462c399c7408d50295db99b4b8042eaa ]

The open() function returns -1 on error.

The 'control' and 'ack' file descriptors are both initialized with
open() and further validated with 'if' statement.

'if (!control)' would evaluate to 'true' if returned value on error were
'0' but it is actually '-1'.

Fixes: edcaa47958c7438b ("perf daemon: Add 'ping' command")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240510003424.2016914-1-samasth.norway.ananda@oracle.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-daemon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-daemon.c b/tools/perf/builtin-daemon.c
index 83954af36753a..de76bbc50bfbc 100644
--- a/tools/perf/builtin-daemon.c
+++ b/tools/perf/builtin-daemon.c
@@ -523,7 +523,7 @@ static int daemon_session__control(struct daemon_session *session,
 		  session->base, SESSION_CONTROL);
 
 	control = open(control_path, O_WRONLY|O_NONBLOCK);
-	if (!control)
+	if (control < 0)
 		return -1;
 
 	if (do_ack) {
@@ -532,7 +532,7 @@ static int daemon_session__control(struct daemon_session *session,
 			  session->base, SESSION_ACK);
 
 		ack = open(ack_path, O_RDONLY, O_NONBLOCK);
-		if (!ack) {
+		if (ack < 0) {
 			close(control);
 			return -1;
 		}
-- 
2.43.0



