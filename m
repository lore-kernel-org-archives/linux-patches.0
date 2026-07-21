Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1481246C4B9;
	Tue, 21 Jul 2026 18:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658549; cv=none; b=k3h5Y8ls6RbxNrUw+nwWSf698oVVLz83gwnXH1pQmkYVOHw4xSARiZTPSJIUt3DmXfSIcF/rcyB/D1Ts06F3AMOmmpYC3mmnJabBj1Hz73y4B5vwFlC6oMfRik1T4DO7kWlXJUDCAjTwldwUnkEX9J7PTM60c28cAnIidN0hHGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658549; c=relaxed/simple;
	bh=Eb+U825Q+HDUjGeEM8v/6RmG2JkWYwpdcRRUend2wA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIqFddQ6adAeLg1izENbjKzbXlSuQNsQ1+7SPkiiv/do8clZvPVhMagBsqpP10NavWndMjBFvVKKZBI+sGKmysBDFjGglINsGnAVc1QZUetkIeW1UYbY/UHhdXeJtMcCMxP/ycsE8nY1ltWeGHQs/PUw3xYWtav7H0sDtaFEOhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JrLOk6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JrLOk6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0071F000E9;
	Tue, 21 Jul 2026 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658548;
	bh=+GDx1VjFrEdItap8b760f+O28qeTxYmH/IOLJpU7xfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0JrLOk6EpMm/+fgOk+psD+A2k4YEnSBv6/YZacxV4W7yRWvUmpCOYYXzZDIcpEP1y
	 eeOh4JM4Ht21QCp/CZ0XONQ8d18bvzBKEkkYnxl/H3pZK6pRCxgS4AibFSbFIPtmP6
	 zQiR3K7rnyiEmmMjo4otkrSYo4OW06UOR8ASqpC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet MEMIS <dev@unknownbbqr.xyz>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.18 1185/1611] tools/power/x86/intel-speed-select: Harden daemon pidfile open
Date: Tue, 21 Jul 2026 17:21:41 +0200
Message-ID: <20260721152542.087207637@linuxfoundation.org>
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


