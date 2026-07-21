Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C323AFAEC;
	Tue, 21 Jul 2026 20:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667119; cv=none; b=r9v/ZEFhOLeIkgjjKt+NUxdP4AjPrU21CkwaKnE+lwrZPmar8YWQSBRPIdqvxBUoysy0PcKKVooJEfRVonZK4K4J9+OGGcbQzjZMXsoiMSB4Xl15fMHiZrd4rL4yHMIptaqsjxmazg2V3v5FZXgGu98GhtOTqk1tm9EoMInIb9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667119; c=relaxed/simple;
	bh=nn97cI9aivX3x9vMWFyk0GckA2dZKBKI8XKULBuqiJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjchIU8/VEjDFG2pLxMflrQAAmwQqrpFCkfET5klZuWYDP0V0IiCqyGxwmy+cXTKPAVdZ+cHSR08vGLlTlOUM3HyRVa5+eEIMXfsNeAISarg62G8ct2PAXSdze6+PGlHjgXs583Ad1/n8hKiXLge89D3pjYKUh7oa68uK7UwLdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMO/yutH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMO/yutH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EFD1F000E9;
	Tue, 21 Jul 2026 20:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667117;
	bh=pPNW1D0OLe6S6/gH70dTh4eBvehnRlvfp2l3r5cvmvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lMO/yutHi0iiXNR4SCI1957RPqClRUPwUDMJn+GBn6UtkbGfrY0++k1/T4tpGX/WY
	 HvkZsAvzDI4dRP06F7OxuDzh7wz9cKCi05npZ94hb/6ioUXeKeutA8cV3MZ5N9UdyQ
	 nNhqvPTFb6xbcRhVzQGziqdvqmtt6XzM3Sata+EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet MEMIS <dev@unknownbbqr.xyz>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.6 0940/1266] tools/power/x86/intel-speed-select: Harden daemon pidfile open
Date: Tue, 21 Jul 2026 17:22:57 +0200
Message-ID: <20260721152502.868338144@linuxfoundation.org>
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
@@ -147,6 +147,7 @@ static void daemonize(char *rundir, char
 {
 	int pid, sid, i;
 	char str[10];
+	struct stat st;
 	struct sigaction sig_actions;
 	sigset_t sig_set;
 	int ret;
@@ -199,11 +200,17 @@ static void daemonize(char *rundir, char
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


