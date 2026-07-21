Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8C446C4BD;
	Tue, 21 Jul 2026 19:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663625; cv=none; b=GfL4lHbPhWYporP1JRYv+B4ltSMAyTXPiOQAv8dqDZgQoNA2z06H76HHHzPvZ96FrqkD7rRLTJtLbMNEfP9RqZiIFO2BBsIYx/K4YLnEagr6Hb4aZBZrCN0KxEbSxykq4pUoAZh8tvxXg3Ajx8Puu/cWP9eA2EuAZZU1Ju4x7UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663625; c=relaxed/simple;
	bh=L08l/4CldW3hJZhyQ/1Sg+F0nwjlzCSi8wqahho6gUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hqwte9tG0HtHIQvHIgWnqSnOEZ+lYslva12/KazOgdSU65wUdiFh/D5/UqGOUtrtGBgYNce/p0BV3e3QjM4qB2sNxwmA1PSXQ8aBISJ3xGD8qMHszmTGjgyEZZXp9Z9DRvtmM8IsmCzbvIfw9LnfTlXo+sqc/1RcADDX+kZKm80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNQFLn+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNQFLn+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D591F000E9;
	Tue, 21 Jul 2026 19:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663623;
	bh=VUUVThmRqbzfwtYDqPHlUT6ZUDd49g0ekTr1AcrIQeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PNQFLn+jgo8sRSkdLvlukNUNzL8CZUKSpKJZ0A9GdY75DjYlT0LEZ6j5sBpfAtPMG
	 DqM438BMQJWk5wWaohuu1DyrJ2r6aYV8ZJJDRaHsMOxL7p01QSeKXEDY7f0hs03r5d
	 JRAw4M903jroi/0IYUAJ4VUNp9mL9hRw3xq++ruY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet MEMIS <dev@unknownbbqr.xyz>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.12 0876/1276] tools/power/x86/intel-speed-select: Harden daemon pidfile open
Date: Tue, 21 Jul 2026 17:21:59 +0200
Message-ID: <20260721152505.656079204@linuxfoundation.org>
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

From: Ali Ahmet MEMIS <dev@unknownbbqr.xyz>

commit 607af438e6430893a822964c841a1994b33acccc upstream.

Avoid symlink-based pidfile clobbering by opening the pidfile with
O_NOFOLLOW and validating it with fstat() before locking/writing.

The daemon currently uses a fixed pidfile path under /tmp. A local
unprivileged user can pre-create a symlink at that path and cause a
root-run daemon instance to write into an attacker-chosen file.

Fixes: 7fd786dfbd2c ("tools/power/x86/intel-speed-select: OOB daemon mode")
Signed-off-by: Ali Ahmet MEMIS <dev@unknownbbqr.xyz>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/power/x86/intel-speed-select/isst-daemon.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/power/x86/intel-speed-select/isst-daemon.c
+++ b/tools/power/x86/intel-speed-select/isst-daemon.c
@@ -148,6 +148,7 @@ static void daemonize(char *rundir, char
 {
 	int pid, sid, i;
 	char str[10];
+	struct stat st;
 	struct sigaction sig_actions;
 	sigset_t sig_set;
 	int ret;
@@ -200,11 +201,17 @@ static void daemonize(char *rundir, char
 	if (ret == -1)
 		exit(EXIT_FAILURE);
 
-	pid_file_handle = open(pidfile, O_RDWR | O_CREAT, 0600);
+	pid_file_handle = open(pidfile, O_RDWR | O_CREAT | O_NOFOLLOW, 0600);
 	if (pid_file_handle == -1) {
 		/* Couldn't open lock file */
 		exit(1);
 	}
+
+	if (fstat(pid_file_handle, &st) == -1)
+		exit(1);
+
+	if (!S_ISREG(st.st_mode))
+		exit(1);
 	/* Try to lock file */
 #ifdef LOCKF_SUPPORT
 	if (lockf(pid_file_handle, F_TLOCK, 0) == -1) {


