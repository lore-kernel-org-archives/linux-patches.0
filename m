Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAFF3385A5;
	Sat, 12 Sep 2026 12:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216912; cv=none; b=n/B/3q4Uj6oY128WRMGTBPeGW5pDRz8uBOj3yPItwxUBg7II6Rg456eQwPsVM5sVEFpvEyj4Cionb+1RnuDlTRteQYn+gap28pKuzyyMSDmDPBpApznxMfEeMXAZukEQSwd5nyeX0Gr2I8GLKOY+L6Sw9yznfxMJV/c+E+yQCT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216912; c=relaxed/simple;
	bh=Ft5PLd5mXnkWC3atrzKfr342N8ftwDQmxrw48WzsqyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snRqCIKswhcVRfbHohQaEKaHIFazyuuwljVjhLCbX2J6EpmJ1E+7ZPGhPpy/SAjTfqq36/GMO082hfvfqNEndpWXy5Y5/b1d77DD6J+ZP+oKRe+eNevsDYYHk/+GSjIdFl47X3jdD4hXuQjcy/fzy22HrehjfxGfeoeUn3cBmiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6PsMdzA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6PsMdzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BAE1F0089A;
	Sat, 12 Sep 2026 12:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216909;
	bh=GRVjhsmp5nKV2vm5bIwtoQpmc8iJ1rTPKHUN4Q+NT4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6PsMdzACdlKfgHPTtcQHdRGKje87vMfNQlXcgG8u+l62PCdv3Lf3AEE6ZoY/xncx
	 wIUQeaFf4B5QR64XwBH0yrO1eMSdFNGfcwjcOPgFoPi6Iij/uiNv6Omwtb3ZvOFayT
	 vFwYaDUMvboKyEf30Dh6c1VQ6tpny2NtA1Iaqvbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0831/1376] perf machine: Use snprintf() for guestmount path construction
Date: Sat, 12 Sep 2026 08:54:17 +0200
Message-ID: <20260912065626.064071429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit fe63d3bca288c5bb983304efd5fc3a5ff3183403 ]

machines__findnew() and machines__create_guest_kernel_maps() use
sprintf() to build paths by prepending symbol_conf.guestmount.
Both write into PATH_MAX stack buffers, but guestmount comes from
user configuration and is not length-checked.  A guestmount path
at or near PATH_MAX causes a stack buffer overflow.

Switch to snprintf() with sizeof() to prevent overflow.  The
subsequent access()/fopen() calls will fail on a truncated path.

Fixes: a1645ce12adb6c9c ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: cc6abe0012bf ("perf machine: Check snprintf truncation in machines__findnew()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 9bd5dd9ddc81c..03fd3dcd4c986 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -289,7 +289,7 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
 	if ((pid != HOST_KERNEL_ID) &&
 	    (pid != DEFAULT_GUEST_KERNEL_ID) &&
 	    (symbol_conf.guestmount)) {
-		sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
+		snprintf(path, sizeof(path), "%s/%d", symbol_conf.guestmount, pid);
 		if (access(path, R_OK)) {
 			static struct strlist *seen;
 
@@ -1215,9 +1215,9 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 					 namelist[i]->d_name);
 				continue;
 			}
-			sprintf(path, "%s/%s/proc/kallsyms",
-				symbol_conf.guestmount,
-				namelist[i]->d_name);
+			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
+				 symbol_conf.guestmount,
+				 namelist[i]->d_name);
 			ret = access(path, R_OK);
 			if (ret) {
 				pr_debug("Can't access file %s\n", path);
-- 
2.53.0



