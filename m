Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF6639B97E;
	Tue, 21 Jul 2026 21:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669974; cv=none; b=KtLyoXaMWwqM2gXPlLsiuMvqlJOJkdiNNSRaHWm6itibicz7vFJFNP3bDgUFPfhxxXSUr7MHPoZJ5mVh/mmMfzDpGAdSLwlTDdEfQJTDwFt1WoO+z6PujyfDvcsWPJnzjCYl2XcTpVGKVp7c79e1vkeNIWy/a5L22lZJdN0l6y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669974; c=relaxed/simple;
	bh=+UHpM22rsCzo1y7IaT6H0/M111yCetyFmcz7qdtF1Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THsXwshBkIt6TG7m7WqhtQhO/f8VeIPZz0nVwfO+9oZW2Bf6k1ED531O11z3o5pwGcfgmddNXHVh5PivVovypk29HRuuTPfB3ERMIjO/X6vDX77cVP000f+AvJWfw5wP413LcXs71X4gvQToCuV+1LexzG8cdkglLkGzOSJksQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGFwbDk/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGFwbDk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073801F000E9;
	Tue, 21 Jul 2026 21:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669973;
	bh=4BXnikkJ4kpOWw8WL7C/pFAD2WgH8uIrJNWbT6UUCGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGFwbDk/kLjuU7PeqHR/r4Ekjq9bLneMPglTvTl1pAut0wpiwzzmJ9r0nmmJE4sTB
	 3bhT2rnxWyc/w/G7EGaPw5RM6kHJjZKBsU3+opTmxAC7ApreXFkQjyefAQr3hOHE+c
	 7rXf1RGr2/qx/HEx29wsuoV65tqfBZgov1fOD+Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet MEMIS <dev@unknownbbqr.xyz>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.1 0758/1067] tools/power/x86/intel-speed-select: Harden daemon pidfile open
Date: Tue, 21 Jul 2026 17:22:39 +0200
Message-ID: <20260721152441.526957437@linuxfoundation.org>
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
@@ -133,6 +133,7 @@ static void daemonize(char *rundir, char
 {
 	int pid, sid, i;
 	char str[10];
+	struct stat st;
 	struct sigaction sig_actions;
 	sigset_t sig_set;
 	int ret;
@@ -186,11 +187,17 @@ static void daemonize(char *rundir, char
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


