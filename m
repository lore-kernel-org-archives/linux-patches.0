Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646A7305E2D;
	Tue, 12 Aug 2025 19:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026317; cv=none; b=JXJlutDfdJBE11HhabFCXOl+rkWpNx9EJE/A4jHDgJRAiYAg0b43yClNYbCKcxvpkuiwbKMhGbCf7dnUPWjBTNNtSEXwMmHGeVTRePxAt/07OY0xGbV3TLE+I11eKOlDv6iaCOa0oxf+vc4ed+N4J4od0bqb4pOP+4bniGUJ8Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026317; c=relaxed/simple;
	bh=s90TNxF5VrnZMPwRXJWm07yhrSZeKGPpSiekrvbrU9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISsAciqrYxrwbUhwz+0EK5b50RMi0JOAzRabp9p8MngpSYohf4lmOPrBUGigBvulFLAt4gtR+1XlggbKMJvg/Nmp8B4Ncyu1gwvonsVRLRH0d1lAtKqSHBoiSZ9ZA8OpZSbbJOfkg1Bv5wFWP/sDYtZRH6kVFaFzJ1P40kY44Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzjV6sHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzjV6sHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C810AC4CEF0;
	Tue, 12 Aug 2025 19:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026317;
	bh=s90TNxF5VrnZMPwRXJWm07yhrSZeKGPpSiekrvbrU9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzjV6sHXpLyuw+8eAV41D3UNeoPimsxcofBwSYw8VY6fcTCcYHj9bFt0dRmZPMvQD
	 JyNMrXpynpFp/RSM2jPHNhEyYYEC6/gUdvEBbkWkMFZW72Ud5GixewGZRI+l1hIrUg
	 u71y0iDaw68ZvXOayqD5asIOx9fkeVxPEmo/ziqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 302/480] tools subcmd: Tighten the filename size in check_if_command_finished
Date: Tue, 12 Aug 2025 19:48:30 +0200
Message-ID: <20250812174409.886083065@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



