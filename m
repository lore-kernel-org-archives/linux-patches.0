Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C3733769A;
	Mon, 18 Aug 2025 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526322; cv=none; b=oHZ3pVgVrTa27COq1PC+E65GRqUft8mxWkya8shny/1ZZpbEWe8u5s3uD9MBdLq2CH7c77jjYZTVtC/toSgg56ek+e4W72jr1s3PbfdVO1Cf1c9tIq3k/KetUsQso5/hSMdHIV6G5/2CvyNiyxpfz/L0qoVNzLeQemiXJH/Ppug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526322; c=relaxed/simple;
	bh=rsVn11esHPP0gQ8fas8gbdHr8gasH5Pv9Ifu2XWpok0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJSZpn209f3whgn84PfO3Gp7iLZ+ZApflfUkowW56bnno56MXhxYPa6aSuCd24FnrHcmOA8LD1lIeFxx+ZOG0JqfCk6AzmGES4B3TweBH8yAK2186b4JREwbedPYPbX/reUYrdKbpmV6VVSWWx50kDB5VA9L0UKhjcxUAT4eWLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOxWXz5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOxWXz5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E29C4CEEB;
	Mon, 18 Aug 2025 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526322;
	bh=rsVn11esHPP0gQ8fas8gbdHr8gasH5Pv9Ifu2XWpok0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOxWXz5ZRDNqFiMJHb//UPF1X54Gnt1Grqc0Cf8kMxutir0W83V+mmSoEnL6h6qeJ
	 xptCLEEh2tEAPzCLdnogm5MyKP6ADu/Rv1dWEtCc7KuNkAMm58Vd727Jw8ruBPsy5a
	 vATUVvZq4vOUfcZFQkouIfqAvd07RjowER0HUM5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 489/570] samples/damon/wsse: fix boot time enable handling
Date: Mon, 18 Aug 2025 14:47:56 +0200
Message-ID: <20250818124524.716489015@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 0ed1165c37277822b519f519d0982d36efc30006 upstream.

Patch series "mm/damon: fix misc bugs in DAMON modules".

>From manual code review, I found below bugs in DAMON modules.

DAMON sample modules crash if those are enabled at boot time, via kernel
command line.  A similar issue was found and fixed on DAMON non-sample
modules in the past, but we didn't check that for sample modules.

DAMON non-sample modules are not setting 'enabled' parameters accordingly
when real enabling is failed.  Honggyu found and fixed[1] this type of
bugs in DAMON sample modules, and my inspection was motivated by the great
work.  Kudos to Honggyu.

Finally, DAMON_RECLIAM is mistakenly losing scheme internal status due to
misuse of damon_commit_ctx().  DAMON_LRU_SORT has a similar misuse, but
fortunately it is not causing real status loss.

Fix the bugs.  Since these are similar patterns of bugs that were found in
the past, it would be better to add tests or refactor the code, in future.


This patch (of 6):

If 'enable' parameter of the 'wsse' DAMON sample module is set at boot
time via the kernel command line, memory allocation is tried before the
slab is initialized.  As a result kernel NULL pointer dereference BUG can
happen.  Fix it by checking the initialization status.

Link: https://lkml.kernel.org/r/20250706193207.39810-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250706193207.39810-2-sj@kernel.org
Link: https://lore.kernel.org/20250702000205.1921-1-honggyu.kim@sk.com [1]
Fixes: b757c6cfc696 ("samples/damon/wsse: start and stop DAMON as the user requests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/wsse.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -89,6 +89,8 @@ static void damon_sample_wsse_stop(void)
 		put_pid(target_pidp);
 }
 
+static bool init_called;
+
 static int damon_sample_wsse_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -114,7 +116,15 @@ static int damon_sample_wsse_enable_stor
 
 static int __init damon_sample_wsse_init(void)
 {
-	return 0;
+	int err = 0;
+
+	init_called = true;
+	if (enable) {
+		err = damon_sample_wsse_start();
+		if (err)
+			enable = false;
+	}
+	return err;
 }
 
 module_init(damon_sample_wsse_init);


