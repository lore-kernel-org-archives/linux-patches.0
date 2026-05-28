Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28422335566;
	Thu, 28 May 2026 20:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998630; cv=none; b=QISoR4IwRMar6d6m+KvUG/1fMWXie4HilsqL5/V6BjBydTRIeSiHiwlXEEZ+voezFLg68x+ow5s5Fduto1WBfzOc8R7LodL1PXtHAu6QQUB03oa5T0Boho4MbQ2ub3P/r/oUe2Ab9v+JHAeeOeQORm+tDuDl7Oa5SfVX8+FsxLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998630; c=relaxed/simple;
	bh=cbfLiWme5DNFChovgxtMPH0WAKBsmr7knVi8qlg9fxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ao10vuBMdFbLxF6YKojgmtH1EfyV8u6pO7BvV+XFo2TZ0Cp6jkqv9DhGSpJCy1YmnCBXeSpgks0QDR5tK0Pkha5woQuHfbRF6MYvtBT0zoC81WKcZPLWflatZhcmCwUsNPx/KuaoqQdmDkw84Bw09GXCUusHlX7DchjB919+aco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gv2LsROZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gv2LsROZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877C81F000E9;
	Thu, 28 May 2026 20:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998629;
	bh=adrgbykrgYW9NDNlBgEkkBwzFNBzrZQ5Zr5o33eZAqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gv2LsROZvwogEpr8KmqQJO8lKHJaLm5QfkCRjA3SSSTgDAo9zaFu3T1uxGt0V6b6l
	 9Gu+/iZInQVzUP3azZtHZpkOolXRvjgQNKoZsgfzbnzTVFEHnlDGK7B8tQl8DUBi33
	 3OiRzviIZLp16VXN2t+1dH3DWyKpZlEM1LoUmfZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 234/461] fprobe: Fix unregister_fprobe() to wait for RCU grace period
Date: Thu, 28 May 2026 21:46:03 +0200
Message-ID: <20260528194653.914877567@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 657b594b2084b39a4bc6d8493aa2140cb00cea49 ]

Commit 4346ba1604093 ("fprobe: Rewrite fprobe on function-graph tracer")
changed fprobe to register struct fprobe to an rcu-hlist, but it forgot
to wait for RCU GP. Thus there can be use-after-free if the fprobe is
released right after unregistering. This can be happened on fprobe
event and sample module code.

To fix this issue, add synchronize_rcu() in unregister_fprobe().

Note that BPF is OK because fprobe is used as a part of
bpf_kprobe_multi_link. This unregisters its fprobe in
bpf_kprobe_multi_link_release() and it is deallocated via
bpf_kprobe_multi_link_dealloc(), which is invoked from
bpf_link_defer_dealloc_rcu_gp() RCU callback.

For BPF, this also introduced unregister_fprobe_async() which does
NOT wait for RCU grace priod.

Link: https://lore.kernel.org/all/177813998919.256460.2809243930741138224.stgit@mhiramat.tok.corp.google.com/

Fixes: 4346ba1604093 ("fprobe: Rewrite fprobe on function-graph tracer")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fprobe.h   |  5 +++++
 kernel/trace/bpf_trace.c |  3 ++-
 kernel/trace/fprobe.c    | 23 +++++++++++++++++++++--
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/fprobe.h b/include/linux/fprobe.h
index 0a3bcd1718f37..be1b38c981d4d 100644
--- a/include/linux/fprobe.h
+++ b/include/linux/fprobe.h
@@ -94,6 +94,7 @@ int register_fprobe(struct fprobe *fp, const char *filter, const char *notfilter
 int register_fprobe_ips(struct fprobe *fp, unsigned long *addrs, int num);
 int register_fprobe_syms(struct fprobe *fp, const char **syms, int num);
 int unregister_fprobe(struct fprobe *fp);
+int unregister_fprobe_async(struct fprobe *fp);
 bool fprobe_is_registered(struct fprobe *fp);
 int fprobe_count_ips_from_filter(const char *filter, const char *notfilter);
 #else
@@ -113,6 +114,10 @@ static inline int unregister_fprobe(struct fprobe *fp)
 {
 	return -EOPNOTSUPP;
 }
+static inline int unregister_fprobe_async(struct fprobe *fp)
+{
+	return -EOPNOTSUPP;
+}
 static inline bool fprobe_is_registered(struct fprobe *fp)
 {
 	return false;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index af7079aa0f36d..a02bd258677ee 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2384,7 +2384,8 @@ static void bpf_kprobe_multi_link_release(struct bpf_link *link)
 	struct bpf_kprobe_multi_link *kmulti_link;
 
 	kmulti_link = container_of(link, struct bpf_kprobe_multi_link, link);
-	unregister_fprobe(&kmulti_link->fp);
+	/* Don't wait for RCU GP here. */
+	unregister_fprobe_async(&kmulti_link->fp);
 	kprobe_multi_put_modules(kmulti_link->mods, kmulti_link->mods_cnt);
 }
 
diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 0afaae4e1a59c..fe4d630aa4460 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -1001,14 +1001,15 @@ static int unregister_fprobe_nolock(struct fprobe *fp)
 }
 
 /**
- * unregister_fprobe() - Unregister fprobe.
+ * unregister_fprobe_async() - Unregister fprobe without RCU GP wait
  * @fp: A fprobe data structure to be unregistered.
  *
  * Unregister fprobe (and remove ftrace hooks from the function entries).
+ * This function will NOT wait until the fprobe is no longer used.
  *
  * Return 0 if @fp is unregistered successfully, -errno if not.
  */
-int unregister_fprobe(struct fprobe *fp)
+int unregister_fprobe_async(struct fprobe *fp)
 {
 	guard(mutex)(&fprobe_mutex);
 	if (!fp || !fprobe_registered(fp))
@@ -1016,6 +1017,24 @@ int unregister_fprobe(struct fprobe *fp)
 
 	return unregister_fprobe_nolock(fp);
 }
+
+/**
+ * unregister_fprobe() - Unregister fprobe with RCU GP wait
+ * @fp: A fprobe data structure to be unregistered.
+ *
+ * Unregister fprobe (and remove ftrace hooks from the function entries).
+ * This function will block until the fprobe is no longer used.
+ *
+ * Return 0 if @fp is unregistered successfully, -errno if not.
+ */
+int unregister_fprobe(struct fprobe *fp)
+{
+	int ret = unregister_fprobe_async(fp);
+
+	if (!ret)
+		synchronize_rcu();
+	return ret;
+}
 EXPORT_SYMBOL_GPL(unregister_fprobe);
 
 static int __init fprobe_initcall(void)
-- 
2.53.0



