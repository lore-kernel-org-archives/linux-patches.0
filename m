Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6173E1974EB;
	Thu,  6 Jun 2024 14:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683460; cv=none; b=oqjHWWPUZtmwRHwJUuMQCUx1wHFVXxLpkKdSWqEJDvWIeG83us12L8KQ8AadROVNXyOtp44LAu5u0/mJz6YjD2afmC68tTjCdO5qfJOW5sJfcKnH/byVsJhPbNVCic/1FnXUnkuR050Kr4jzDnQoNmgY8hoRsXD9MuI0Q6Fh9ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683460; c=relaxed/simple;
	bh=IS5kNX+JeALvNkTPpSKidmnRh+wrLv/+rNgIyuSTwYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8GDLYquej4aKUJDuKWT+58qfOKTcosgXjG2fSyVjVfuokNfa0VpgTBfQLRZ8vfBVDXBeaIJm2F3dhbM7WLqbo6l1wx9UcgGI3x+CZCUUKqMGUp8IluwuL5cZ4ecYqktQPoVM79Vl3YaKlqxWaxWhK6NteCi1+q/jnx9kU4WDj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6DlcFOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6DlcFOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D207C2BD10;
	Thu,  6 Jun 2024 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683460;
	bh=IS5kNX+JeALvNkTPpSKidmnRh+wrLv/+rNgIyuSTwYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6DlcFOOe7giwxe8d1SAX5Yu4jKjPspL/xazBfglM55ItSktEKq9FxSfNYJfEERND
	 MdJXX9/xAJQ1g7nuTpOyWTLWTVl902WCTRbqAjBgPXeRac/Nvyrkd65aPItIG9fVn3
	 Pz6I6X6EZiHQ7SQJd/OK/wR5Dd2Qme5SU+nOU9B8=
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
Subject: [PATCH 6.1 347/473] perf daemon: Fix file leak in daemon_session__control
Date: Thu,  6 Jun 2024 16:04:36 +0200
Message-ID: <20240606131711.380758386@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6cb3f6cc36d0a..35942256582ab 100644
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



