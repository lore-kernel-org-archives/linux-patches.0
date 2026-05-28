Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54E0301472;
	Thu, 28 May 2026 20:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999868; cv=none; b=YeZOhWO8hpO9KnjgI0FMb5MntDytlS4OqvAav6Y0XyG0Mr0OLd9oTwAvyxr9pA6xAqGBFNMeHYGjcA/+Nci6sgvbp1nm82+sB4MCOcvOFNrUkyFmB+QLw2CtjXDm9lIKm7bABd8JFyE7PgNz6Q1EyjLgqKMiOoPfGl26diVTTQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999868; c=relaxed/simple;
	bh=G5AVtHPMJZbWltYybFH+05eQhfPwLF49nOaBPcizVCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWUnSxxK1He+6UesmtEr1vCQ3FQHA8j4e+hqXW2ZJwXVZqh7/j7FK52wz3GJakHTfSpHhvWIPGNVocxzOtwn0UqFtE3vSXbpSRvtOxRTyrhQ6SdKtRx/i8oBbux8eGLUNVJL0Mj5+msh2R0ChC4BwBeaNt/x09qD+kfUP9MDDsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0y6ShgHH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0y6ShgHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2A11F00A3C;
	Thu, 28 May 2026 20:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999866;
	bh=ZnMNWOx+c4sWsbKjVkmWL/G1N961kvFZziK3VcF9c04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0y6ShgHHuZeXi/iiHxhkqXv+Cnrcb4r/gwDFDj2et7+ZEE6ng1U5Ur+EA4BaNWm2z
	 RmT6nXCRqDyybh1Ig8Lo5fvKU3cJ2NfD927ai9RB3cUJQpgWB500X0ZFFmV3CtV6PR
	 Yh8vrXToGIWRXzNCrWIcCq5c3OMqolHgey2bVDWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 219/377] fprobe: Fix unregister_fprobe() to wait for RCU grace period
Date: Thu, 28 May 2026 21:47:37 +0200
Message-ID: <20260528194644.735541777@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 70f1292b7ddbd..88f470b31375a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2371,7 +2371,8 @@ static void bpf_kprobe_multi_link_release(struct bpf_link *link)
 	struct bpf_kprobe_multi_link *kmulti_link;
 
 	kmulti_link = container_of(link, struct bpf_kprobe_multi_link, link);
-	unregister_fprobe(&kmulti_link->fp);
+	/* Don't wait for RCU GP here. */
+	unregister_fprobe_async(&kmulti_link->fp);
 	kprobe_multi_put_modules(kmulti_link->mods, kmulti_link->mods_cnt);
 }
 
diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 6419c8d772731..b9346f4efa6dc 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -1000,14 +1000,15 @@ static int unregister_fprobe_nolock(struct fprobe *fp)
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
@@ -1015,6 +1016,24 @@ int unregister_fprobe(struct fprobe *fp)
 
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



