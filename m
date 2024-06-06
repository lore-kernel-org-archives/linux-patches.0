Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BDD196C8C;
	Thu,  6 Jun 2024 14:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682952; cv=none; b=DhKGBCP+Z2ZKyFfq+9OlLCyXcEzl+u8gT6SV06oBx9OSdUqhN8We172QK/RexVwvi2XzR7akIyh9jtSocUwYgD49Velahn82zoXF+9gI+nvArJH3MotnzcsfSkO5hP/Lt+N//N1T45OG0EknvVI/xN+5B8X+sCzXIi9Z529yWBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682952; c=relaxed/simple;
	bh=oKj8q/q/3ZMOjknCHwwpC6t5y9sBP7qKsBfEZJ8wXpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9mZxwpVBFs/m39r0LKg9lhAjDlT4AliyULDvpeF+c0Zri/kFHsQoJH73sNQ8Ra9b//JbGvXdvI2yUj4odwgcfvoQrce3ikigvEzevdzPVAvP2nVsceC68OnBX/IZgXf6oWqVaSBeb3tFk9RmMlIEK9WL4clvdGU/lxH0Glow9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9iIeG83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9iIeG83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929E0C2BD10;
	Thu,  6 Jun 2024 14:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682952;
	bh=oKj8q/q/3ZMOjknCHwwpC6t5y9sBP7qKsBfEZJ8wXpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9iIeG83CPLmABBKcvLOUOpJN3ns+NaiUM39oO6xxn707AYLTxNrJZEu4Y6guJ+Ep
	 APJ56LEkxBMMlAxK4U8+9LyUieCJO+N/Nioy0a+Gzajs4SaaJI23XRROgtXf9HgzZ/
	 2Bikj8H2sj8bBS6+t9KVAlAxsZbS8O/UHK5z2edA=
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
Subject: [PATCH 6.9 116/374] perf daemon: Fix file leak in daemon_session__control
Date: Thu,  6 Jun 2024 16:01:35 +0200
Message-ID: <20240606131655.815556934@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



