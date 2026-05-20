Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A40936EAB8;
	Wed, 20 May 2026 16:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295525; cv=none; b=Qawv4H+KRsWDOv4Y3CIILjw77Thcj0MnRhWLyFv/ZmPi9lFhytdeXc8Pz3bskxWI4C7AuFdHbqhuvBScWD++25dd6PRJmT9mqobeV4rJ+KD/W7i5hpemlY7KeOKYwffohDvkfCBobhuf6kBtpz+9FHdALcpZiITXHzRAK6l1Uhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295525; c=relaxed/simple;
	bh=VcyqYXR+GlfEhIXceWtdfIJHPQWJuhYUjtcxO5CSU5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeOsrHqmunfnPCLq0Wzsz2Qne6VmPy0viIIJjEjAD7+A8gAlykf8BbQLvEB6Ze4KqK+NSmehyfEL4nq/XLrU7K1umFVZHu6t2FgOwLFuulqx3xYC9ASEo1QbNsiimf3wRm9iYs08UyVnSPMZ1KRgbMA6mFVy5tepRCWjb1okxio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbSdkt98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbSdkt98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9136B1F000E9;
	Wed, 20 May 2026 16:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295524;
	bh=MTyeR6MQvZ3tQELBaqufLoIg7vMfDzynaOnhdNhUeP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XbSdkt98s14zAzWpn2P2kqfnD9pfe432O5UDWGGv1sKtrW9Fi9YURZRuWVWIlUD3L
	 Y5/lEJlMY+ZzsJVs0vCue10//AWbvuFUaEy8xLCmoBQJbbhEr5QAQXzHtr3Piu0Nlg
	 V3iXNoAa7RO8Bnjzk8P6yTqgAD/NHB6LNHCt9hU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0452/1146] rtla: Simplify code by caching string lengths
Date: Wed, 20 May 2026 18:11:42 +0200
Message-ID: <20260520162158.429100767@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit f79720e25b793691dcc46e1f1cd64d01578075c2 ]

Simplify trace_event_save_hist() and set_comm_cgroup() by computing
string lengths once and storing them in local variables, rather than
calling strlen() multiple times on the same unchanged strings. This
makes the code clearer by eliminating redundant function calls and
improving readability.

In trace_event_save_hist(), the write loop previously called strlen()
on the hist buffer twice per iteration for both the size calculation
and loop condition. Store the length in hist_len before entering the
loop. In set_comm_cgroup(), strlen() was called on cgroup_path up to
three times in succession. Store the result in cg_path_len to use in
both the offset calculation and size parameter for subsequent append
operations.

This simplification makes the code easier to read and maintain without
changing program behavior.

Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20260309195040.1019085-7-wander@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Stable-dep-of: 4bf4ef5292b9 ("rtla/trace: Fix write loop in trace_event_save_hist()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/trace.c |  6 ++++--
 tools/tracing/rtla/src/utils.c | 11 +++++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/tracing/rtla/src/trace.c b/tools/tracing/rtla/src/trace.c
index b8be3e28680ee..073ec1b567798 100644
--- a/tools/tracing/rtla/src/trace.c
+++ b/tools/tracing/rtla/src/trace.c
@@ -362,6 +362,7 @@ static void trace_event_save_hist(struct trace_instance *instance,
 	mode_t mode = 0644;
 	char path[1024];
 	char *hist;
+	size_t hist_len;
 
 	if (!tevent)
 		return;
@@ -392,9 +393,10 @@ static void trace_event_save_hist(struct trace_instance *instance,
 	}
 
 	index = 0;
+	hist_len = strlen(hist);
 	do {
-		index += write(out_fd, &hist[index], strlen(hist) - index);
-	} while (index < strlen(hist));
+		index += write(out_fd, &hist[index], hist_len - index);
+	} while (index < hist_len);
 
 	free(hist);
 out_close:
diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index 0da3b2470c317..fb067220566a4 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -809,6 +809,7 @@ static int open_cgroup_procs(const char *cgroup)
 	char cgroup_procs[MAX_PATH];
 	int retval;
 	int cg_fd;
+	size_t cg_path_len;
 
 	retval = find_mount("cgroup2", cgroup_path, sizeof(cgroup_path));
 	if (!retval) {
@@ -816,16 +817,18 @@ static int open_cgroup_procs(const char *cgroup)
 		return -1;
 	}
 
+	cg_path_len = strlen(cgroup_path);
+
 	if (!cgroup) {
-		retval = get_self_cgroup(&cgroup_path[strlen(cgroup_path)],
-				sizeof(cgroup_path) - strlen(cgroup_path));
+		retval = get_self_cgroup(&cgroup_path[cg_path_len],
+				sizeof(cgroup_path) - cg_path_len);
 		if (!retval) {
 			err_msg("Did not find self cgroup\n");
 			return -1;
 		}
 	} else {
-		snprintf(&cgroup_path[strlen(cgroup_path)],
-				sizeof(cgroup_path) - strlen(cgroup_path), "%s/", cgroup);
+		snprintf(&cgroup_path[cg_path_len],
+				sizeof(cgroup_path) - cg_path_len, "%s/", cgroup);
 	}
 
 	snprintf(cgroup_procs, MAX_PATH, "%s/cgroup.procs", cgroup_path);
-- 
2.53.0



