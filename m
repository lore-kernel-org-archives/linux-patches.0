Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC212D7BF;
	Tue,  3 Dec 2024 15:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239103; cv=none; b=D46gVP1w/5d/T4Yvl/sa6xaK8N7S/LvbYD4HKq76XBGxkrGukliBL9R2e3VxsVmMLn3Ws2b/72Cv6wkA2kwVJbLViQJDQw+9C7qUCTQnUCiZ4TkAT5WO0kKeZVLiUW6Uz4flnPPA/+ElSiXpqH503mY0sjUklGSywQnD3ByAf58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239103; c=relaxed/simple;
	bh=ZKLxzRukzjJtX85HY8GsH2YgKXGUUVR4ziJMg500OIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5Xu3g5Psc+YplcX3K31azUhaHaoBMPMzG7tQCaVo8b7xxDdDJh2K3zV9crsl9IiygFZbvGVNrTIIxbNdULJGt+MwowMsT6oz6uU5nvD4Bx4SsuqrOzXoZDtcOyJY1KBpXiquvj4u7kI/bGsT9cAGxMATjoIPczRJZCtIv88zEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Abqw/yHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Abqw/yHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6929C4CECF;
	Tue,  3 Dec 2024 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239103;
	bh=ZKLxzRukzjJtX85HY8GsH2YgKXGUUVR4ziJMg500OIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Abqw/yHd91vPMJB8jW6ogsgJ6AvuPn0dMfl/0QfW5rHndWB+BaC4c6oJpdIvyZsVY
	 WAl9HmeRPwR06rgdk/H6smzv5dg65JlE/uCE037Ih0J//D9h4ky3A5gl6EbAFWXHnM
	 /Iqi8uvQeUjGaXno9ztIKXEPifoF3sSpcTyhW2YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 476/817] rtla/timerlat: Do not set params->user_workload with -U
Date: Tue,  3 Dec 2024 15:40:48 +0100
Message-ID: <20241203144014.450407929@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit fcbc60d7dc4b125c8de130aa1512e5d20726c06e ]

Since commit fb9e90a67ee9 ("rtla/timerlat: Make user-space threads
the default"), rtla-timerlat has been defaulting to
params->user_workload if neither that or params->kernel_workload is set.
This has unintentionally made -U, which sets only params->user_hist/top
but not params->user_workload, to behave like -u unless -k is set,
preventing the user from running a custom workload.

Example:
$ rtla timerlat hist -U -c 0 &
[1] 7413
$ python sample/timerlat_load.py 0
Error opening timerlat fd, did you run timerlat -U?
$ ps | grep timerlatu
7415 pts/4    00:00:00 timerlatu/0

Fix the issue by checking for params->user_top/hist instead of
params->user_workload when setting default thread mode.

Link: https://lore.kernel.org/20241021123140.14652-1-tglozar@redhat.com
Fixes: fb9e90a67ee9 ("rtla/timerlat: Make user-space threads the default")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_hist.c | 2 +-
 tools/tracing/rtla/src/timerlat_top.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index a3907c390d67a..829511a712224 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -1064,7 +1064,7 @@ timerlat_hist_apply_config(struct osnoise_tool *tool, struct timerlat_hist_param
 	 * If the user did not specify a type of thread, try user-threads first.
 	 * Fall back to kernel threads otherwise.
 	 */
-	if (!params->kernel_workload && !params->user_workload) {
+	if (!params->kernel_workload && !params->user_hist) {
 		retval = tracefs_file_exists(NULL, "osnoise/per_cpu/cpu0/timerlat_fd");
 		if (retval) {
 			debug_msg("User-space interface detected, setting user-threads\n");
diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 210b0f533534a..3b62519a412fc 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -830,7 +830,7 @@ timerlat_top_apply_config(struct osnoise_tool *top, struct timerlat_top_params *
 	 * If the user did not specify a type of thread, try user-threads first.
 	 * Fall back to kernel threads otherwise.
 	 */
-	if (!params->kernel_workload && !params->user_workload) {
+	if (!params->kernel_workload && !params->user_top) {
 		retval = tracefs_file_exists(NULL, "osnoise/per_cpu/cpu0/timerlat_fd");
 		if (retval) {
 			debug_msg("User-space interface detected, setting user-threads\n");
-- 
2.43.0



