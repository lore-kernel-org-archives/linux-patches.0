Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6AC156256;
	Mon, 14 Oct 2024 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919682; cv=none; b=eIklTHFy/GJk2fJ4hJi8tqNNIpHscAziShApcwDhvA3ayLCVVAjsGjrUMARqVdWowmvbEWIcPPeSQ1J/D8WwnTNQvNwlDHjRLGUYGdnTpc4WvXtQcTPs+UlxCDC8RbgTk1+TJwweULV0OfMikyVlgJiGt6dEeAfNxxCwhUz5JSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919682; c=relaxed/simple;
	bh=+qy+RpVfqMDgR9vdbPVcMRfhdsGu4kMVshP1hMdt3W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzavzK8mpDq2j9bOV46byRI0XaeoC9AEa5oe2vN5YB9sgYHtODSlQ3WtEjZNl4ZZ6XtnkTLy2TtYZChI5A0ub7U/oUoBCrxAzXrwVA6ROGW1v2BPhBlyyXnY0OFu47BNa3XBfItZVIWJq+9vV/Uq6HeWkwUGBNSnRtQjxgd3eaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLSpWA5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLSpWA5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6090FC4CEC3;
	Mon, 14 Oct 2024 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919682;
	bh=+qy+RpVfqMDgR9vdbPVcMRfhdsGu4kMVshP1hMdt3W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLSpWA5e6S3+57AoBYUlyYXDv47k334aGIDF6wJ9fZWD6iDJB4mZniAuI/m58WzXM
	 R7O9NiRslm3pdab7zSEUt481DJl9t7ebbrnP4959xiLR8zg/joIdW+ww/rrBVGKOkD
	 mW7OLnie42zNjIAjn0xq/8M8i18Gi2wCnsaA83lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Aditya Gupta <adityag@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Disha Goel <disgoel@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 678/798] libsubcmd: Dont free the usage string
Date: Mon, 14 Oct 2024 16:20:32 +0200
Message-ID: <20241014141244.707363001@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Aditya Gupta <adityag@linux.ibm.com>

[ Upstream commit 1a5efc9e13f357abc396dbf445b25d08914c8060 ]

Currently, commands which depend on 'parse_options_subcommand()' don't
show the usage string, and instead show '(null)'

    $ ./perf sched
	Usage: (null)

    -D, --dump-raw-trace  dump raw trace in ASCII
    -f, --force           don't complain, do it
    -i, --input <file>    input file name
    -v, --verbose         be more verbose (show symbol address, etc)

'parse_options_subcommand()' is generally expected to initialise the usage
string, with information in the passed 'subcommands[]' array

This behaviour was changed in:

  230a7a71f92212e7 ("libsubcmd: Fix parse-options memory leak")

Where the generated usage string is deallocated, and usage[0] string is
reassigned as NULL.

As discussed in [1], free the allocated usage string in the main
function itself, and don't reset usage string to NULL in
parse_options_subcommand

With this change, the behaviour is restored.

    $ ./perf sched
        Usage: perf sched [<options>] {record|latency|map|replay|script|timehist}

           -D, --dump-raw-trace  dump raw trace in ASCII
           -f, --force           don't complain, do it
           -i, --input <file>    input file name
           -v, --verbose         be more verbose (show symbol address, etc)

[1]: https://lore.kernel.org/linux-perf-users/htq5vhx6piet4nuq2mmhk7fs2bhfykv52dbppwxmo3s7du2odf@styd27tioc6e/

Fixes: 230a7a71f92212e7 ("libsubcmd: Fix parse-options memory leak")
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Aditya Gupta <adityag@linux.ibm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Disha Goel <disgoel@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240904061836.55873-2-adityag@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/subcmd/parse-options.c | 8 +++-----
 tools/perf/builtin-kmem.c        | 2 ++
 tools/perf/builtin-kvm.c         | 3 +++
 tools/perf/builtin-kwork.c       | 3 +++
 tools/perf/builtin-lock.c        | 3 +++
 tools/perf/builtin-mem.c         | 3 +++
 tools/perf/builtin-sched.c       | 3 +++
 7 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/lib/subcmd/parse-options.c b/tools/lib/subcmd/parse-options.c
index d943d78b787ed..9fa75943f2ed1 100644
--- a/tools/lib/subcmd/parse-options.c
+++ b/tools/lib/subcmd/parse-options.c
@@ -633,10 +633,11 @@ int parse_options_subcommand(int argc, const char **argv, const struct option *o
 			const char *const subcommands[], const char *usagestr[], int flags)
 {
 	struct parse_opt_ctx_t ctx;
-	char *buf = NULL;
 
 	/* build usage string if it's not provided */
 	if (subcommands && !usagestr[0]) {
+		char *buf = NULL;
+
 		astrcatf(&buf, "%s %s [<options>] {", subcmd_config.exec_name, argv[0]);
 
 		for (int i = 0; subcommands[i]; i++) {
@@ -678,10 +679,7 @@ int parse_options_subcommand(int argc, const char **argv, const struct option *o
 			astrcatf(&error_buf, "unknown switch `%c'", *ctx.opt);
 		usage_with_options(usagestr, options);
 	}
-	if (buf) {
-		usagestr[0] = NULL;
-		free(buf);
-	}
+
 	return parse_options_end(&ctx);
 }
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 40dd52acc48ae..c74c0da7c8052 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -2048,6 +2048,8 @@ int cmd_kmem(int argc, const char **argv)
 
 out_delete:
 	perf_session__delete(session);
+	/* free usage string allocated by parse_options_subcommand */
+	free((void *)kmem_usage[0]);
 
 	return ret;
 }
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 7d9ec1bac1a25..ba6654862883f 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1651,5 +1651,8 @@ int cmd_kvm(int argc, const char **argv)
 	else
 		usage_with_options(kvm_usage, kvm_options);
 
+	/* free usage string allocated by parse_options_subcommand */
+	free((void *)kvm_usage[0]);
+
 	return 0;
 }
diff --git a/tools/perf/builtin-kwork.c b/tools/perf/builtin-kwork.c
index 25cba0d61736c..4b612a41cdc10 100644
--- a/tools/perf/builtin-kwork.c
+++ b/tools/perf/builtin-kwork.c
@@ -1831,5 +1831,8 @@ int cmd_kwork(int argc, const char **argv)
 	} else
 		usage_with_options(kwork_usage, kwork_options);
 
+	/* free usage string allocated by parse_options_subcommand */
+	free((void *)kwork_usage[0]);
+
 	return 0;
 }
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 28fa76ecc0822..27bbc513aeb94 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -2007,6 +2007,9 @@ int cmd_lock(int argc, const char **argv)
 		usage_with_options(lock_usage, lock_options);
 	}
 
+	/* free usage string allocated by parse_options_subcommand */
+	free((void *)lock_usage[0]);
+
 	zfree(&lockhash_table);
 	return rc;
 }
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index fbd05617c2ddd..ac2e17c093941 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -514,5 +514,8 @@ int cmd_mem(int argc, const char **argv)
 	else
 		usage_with_options(mem_usage, mem_options);
 
+	/* free usage string allocated by parse_options_subcommand */
+	free((void *)mem_usage[0]);
+
 	return 0;
 }
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index b70bc7f3ad5b3..e440a00b1613e 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3725,5 +3725,8 @@ int cmd_sched(int argc, const char **argv)
 		usage_with_options(sched_usage, sched_options);
 	}
 
+	/* free usage string allocated by parse_options_subcommand */
+	free((void *)sched_usage[0]);
+
 	return 0;
 }
-- 
2.43.0



