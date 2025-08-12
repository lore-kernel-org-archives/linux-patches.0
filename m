Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04482CA9;
	Tue, 12 Aug 2025 18:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024584; cv=none; b=KH1BXBAZGWPB5faFKHCL9RePKvPpVMKcx6DYjCUyGitDpp1lUE1WaX00TE6NzW81cX1IDge59hQ+q1SO/BOfcVqeP2aNVPR6CDwRvaFWeDCzd2klI21qF2yS+ikVe+8N99/jIcJUZU8HVfeA3MS2+CB9glCfff6TC3bbxLOlihI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024584; c=relaxed/simple;
	bh=Vtwr/Wy/CDFSoj2PBMtTabubBOV/eFfKWu8XE19ju00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTMkd0hg2DtU/d0wuoZq0S3egGNA8p6REgZ5x9YNtYJslKnmDiIUQ4+qnM8djjl52FrgRL2PwGuGjTxdlulSGxUUTkuNRswI+C2zSOh0cEdB4QJVzFX02ITRhC25sVhiwDQRNQNuzr4ZhRmTBBVUHCcCU+UC3HqfOfAQplHEAYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5bOtgdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5bOtgdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59ACAC4CEF0;
	Tue, 12 Aug 2025 18:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024583;
	bh=Vtwr/Wy/CDFSoj2PBMtTabubBOV/eFfKWu8XE19ju00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5bOtgdAiEsJQGJ5h36F6WVMG5jzPql24+pMN1nHIqRtzaMYrk/E87tJ1Euca89D+
	 Itsf/H7QFDiZprrZcmbZTrbkOH9RThJYc8StXygYajAd5hNgUlDjXsWYR4eAjnO2Mz
	 2PWHJHgWEEDj1pQiaDlCsEmxBpmawOKSLqjjYHUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 415/627] tools subcmd: Tighten the filename size in check_if_command_finished
Date: Tue, 12 Aug 2025 19:31:50 +0200
Message-ID: <20250812173435.071662729@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 478272d1cdd9959a6d638e9d81f70642f04290c9 ]

FILENAME_MAX is often PATH_MAX (4kb), far more than needed for the
/proc path. Make the buffer size sufficient for the maximum integer
plus "/proc/" and "/status" with a '\0' terminator.

Fixes: 5ce42b5de461 ("tools subcmd: Add non-waitpid check_if_command_finished()")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250717150855.1032526-1-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/subcmd/run-command.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/lib/subcmd/run-command.c b/tools/lib/subcmd/run-command.c
index 0a764c25c384..b7510f83209a 100644
--- a/tools/lib/subcmd/run-command.c
+++ b/tools/lib/subcmd/run-command.c
@@ -5,6 +5,7 @@
 #include <ctype.h>
 #include <fcntl.h>
 #include <string.h>
+#include <linux/compiler.h>
 #include <linux/string.h>
 #include <errno.h>
 #include <sys/wait.h>
@@ -216,10 +217,20 @@ static int wait_or_whine(struct child_process *cmd, bool block)
 	return result;
 }
 
+/*
+ * Conservative estimate of number of characaters needed to hold an a decoded
+ * integer, assume each 3 bits needs a character byte and plus a possible sign
+ * character.
+ */
+#ifndef is_signed_type
+#define is_signed_type(type) (((type)(-1)) < (type)1)
+#endif
+#define MAX_STRLEN_TYPE(type) (sizeof(type) * 8 / 3 + (is_signed_type(type) ? 1 : 0))
+
 int check_if_command_finished(struct child_process *cmd)
 {
 #ifdef __linux__
-	char filename[FILENAME_MAX + 12];
+	char filename[6 + MAX_STRLEN_TYPE(typeof(cmd->pid)) + 7 + 1];
 	char status_line[256];
 	FILE *status_file;
 
@@ -227,7 +238,7 @@ int check_if_command_finished(struct child_process *cmd)
 	 * Check by reading /proc/<pid>/status as calling waitpid causes
 	 * stdout/stderr to be closed and data lost.
 	 */
-	sprintf(filename, "/proc/%d/status", cmd->pid);
+	sprintf(filename, "/proc/%u/status", cmd->pid);
 	status_file = fopen(filename, "r");
 	if (status_file == NULL) {
 		/* Open failed assume finish_command was called. */
-- 
2.39.5



