Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15173EFD04;
	Tue, 21 Jul 2026 17:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654233; cv=none; b=oePVFY8FsC0nE17xSlwvddeusSv8yAQ23VraU4V2v+1g89estAdenyu/XeLTSdeYZag71+TAnZYiJbE+Y5b0JAbRFlJSZujx0fffPVJm6WIqPESVrIhHLoab746ycOJCByZHACpBH00MD52btDdMmwbRUfgFREQ/Fybw8RyM8o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654233; c=relaxed/simple;
	bh=YB0MZLQml61rPShyQBYx5Yo3QiK2D3Z7H5JnFSkzVV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMslokAUOQ3ViGqQxKWXMr7er60dC1Xjg5q7Xtk1pmDZACHSI++Y5cBGjvki7Ev9cgwDhghm7UWPG1xQCw6x/YU4BZ1PH71ZumAlCkK9r0rp6z9jKsbQaniTCltmwICC2iH50w7ErRoKOS+wpbRg1ZZJdsxFvr72s+P8NvJz6Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tb3ac1Aj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tb3ac1Aj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F3D1F000E9;
	Tue, 21 Jul 2026 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654232;
	bh=Uth/6ncGcD7quZA2CSgRbeDmrk9BGZG+PML8FNYyeZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tb3ac1Aj0Nxn8V4O8Bk+zYuwl/tScLm2DcfBRdKXqXsfHVY5USFzlsAla5XwBMiHH
	 Lr3jAdDrPEaQxC5BrLakQVh1d0IypCeLXFtwANlKK5GtTINgAcqubolw2761px7E51
	 ifyCAnwGrTVzLQCMTPXD6I73kMRgejFs4Fd8mWM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet MEMIS <dev@unknownbbqr.xyz>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 7.1 1628/2077] tools/power/x86/intel-speed-select: Harden daemon pidfile open
Date: Tue, 21 Jul 2026 17:21:41 +0200
Message-ID: <20260721152631.154593874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


