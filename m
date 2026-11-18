Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027271;
	b=AsUMxdHFvdA5BiN5C70zLI/dkj+bIouDrILgsZO0VhXLRDhWuzpSCBeoYWNCjthJZbe4
	 hHWw0qGS/DYQxFlXAEjZdBooHijSla7iEyP8dNJnl1AAodzNBX/eF/q6LXQGUw57Hj8CT
	 tvYnFOSb0KQMrRawueE1cbiORz21kGBsDNc4dqqYLFJlUZfIGRLOI1xmYL0DRG5dCYEnF
	 ZgWMrHCmgnbFF/YFwqBFIKsh5WnSpSUVRnDl+VniMuX+hNXP462vEgXv0nj80N1QIzP+4
	 Guh5TQuwAo4hKyjesqxdqToGMm1+lB1XlySzBef2Z8nrPiqAaNy95uU8HjejNyhLtTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sp5n0GroL+iHHQoR8pgiP4+ivnyltLhbAJchHdhZw9Y=;
	b=eopERyq+Ji7YqETOA3b+97CLH0D0S8LK7QM2nHgHrA2k8tg+/SbZ5qg1Diu8S//qgiUH
	 pJqBvvUKFrYUuGwE2+4oDVeyL2MqNC845lv5eHxpThGsLqPqEmSfFbXOq83twaHCZoV5K
	 7eLzZ7FXqwTxoAJv/TAtdH4YgntHoZCyFHf3FNM/KvED3b7ruGERjbhPQJ/9oDPDzhtCk
	 icGc22nYQ9ZZCmqiF/JQLlbWH/5ekR+vt0+buhJnqqTxZUxFR28RG4LSXLQk0R0LQ3DQ8
	 J5VXx0VReJz7+D7EbS+rehYCr9gHjcGvS3Rfs8XeMbA5b4WdR3tH5Hm9oa6IgRcNDSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdnvt9Ov;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBE4606A332;
	Wed, 18 Nov 2026 18:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdnvt9Ov
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E5A1F000C5;
	Wed, 18 Nov 2026 18:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027270;
	bh=sp5n0GroL+iHHQoR8pgiP4+ivnyltLhbAJchHdhZw9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdnvt9OvP2Wu7PsuKxfO252Jyr5nhf7FqY5Ys+t11/KPvhOI4efH9Je75ax/+zPf3
	 agnzfv4M7WkeSA+ctT490zNAbcZJFgIRHMYd7lWg9idt/IXGY/47rc6kVnmIVATZAW
	 ZHKxxBIjkEF2E+f3dp/64WF2fb9kGzN9yrmRn0L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1728/2151] bpf: Fix stale offload->prog pointer after realloc
Date: Wed, 18 Nov 2026 15:57:43 +0100
Message-ID: <20261118150224.799741615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 8e83d53596445fcf5b0385e5fbe8bcd971e06d06 ]

bpf_prog_realloc() moves a program that the rewrites of the verifier make
outgrow its pages.  It updates aux->prog, but not the offload->prog of a
device-bound program.  When the device is unregistered,
__bpf_offload_dev_netdev_unregister() hands the stale pointer to
__bpf_prog_offload_destroy(), which faults on the freed program:

  BUG: unable to handle page fault for address: ffffc90000071050
  RIP: 0010:__bpf_prog_offload_destroy+0x3f/0x310

It takes the right to load a device-bound XDP program, CAP_BPF and
CAP_NET_ADMIN or a BPF token, and a device that can be removed.

Commit a1aa9ef47c29 ("bpf: Fix stale offload->prog pointer after constant
blinding") repaired the other place that replaces a program.  Do the same
here.

Nothing keeps the device while a program is loaded, so it can also be
unregistered at that very moment.  That frees the offload, and it may have
read offload->prog already when the old copy of the program is freed.  In
both places update the pointer under bpf_devs_lock, before the old copy
goes.

Fixes: ab3f0063c48c ("bpf: offload: add infrastructure for loading programs for a specific netdev")
Fixes: 2b3486bc2d23 ("bpf: Introduce device-bound XDP programs")
Fixes: a1aa9ef47c29 ("bpf: Fix stale offload->prog pointer after constant blinding")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-21-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  |  5 +++++
 kernel/bpf/core.c    |  4 ++--
 kernel/bpf/offload.c | 16 ++++++++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8a34e139a1215..51e303b39b949 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -3258,6 +3258,7 @@ int bpf_dev_bound_kfunc_check(struct bpf_verifier_log *log,
 void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id);
 int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr);
 int bpf_prog_dev_bound_inherit(struct bpf_prog *new_prog, struct bpf_prog *old_prog);
+void bpf_prog_dev_bound_moved(struct bpf_prog *prog);
 void bpf_dev_bound_netdev_unregister(struct net_device *dev);
 
 static inline bool bpf_prog_is_dev_bound(const struct bpf_prog_aux *aux)
@@ -3319,6 +3320,10 @@ static inline int bpf_prog_dev_bound_inherit(struct bpf_prog *new_prog,
 	return -EOPNOTSUPP;
 }
 
+static inline void bpf_prog_dev_bound_moved(struct bpf_prog *prog)
+{
+}
+
 static inline void bpf_dev_bound_netdev_unregister(struct net_device *dev)
 {
 }
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c99d3f396fdc0..076d84ee89a92 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -269,6 +269,7 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 		memcpy(fp, fp_old, fp_old->pages * PAGE_SIZE);
 		fp->pages = pages;
 		fp->aux->prog = fp;
+		bpf_prog_dev_bound_moved(fp);
 
 		/* We keep fp->aux from fp_old around in the new
 		 * reallocated structure.
@@ -1524,8 +1525,7 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other)
 	 * know whether fp here is the clone or the original.
 	 */
 	fp->aux->prog = fp;
-	if (fp->aux->offload)
-		fp->aux->offload->prog = fp;
+	bpf_prog_dev_bound_moved(fp);
 	bpf_prog_clone_free(fp_other);
 }
 
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 884f1eeaba2ef..bd4f4184e573b 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -106,6 +106,22 @@ static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
 	return err;
 }
 
+/*
+ * @prog takes the place of a copy that the caller is about to free. Nothing
+ * keeps the netdev while a program is loaded: once the lock is dropped, no
+ * unregistration is left that has got the old copy from offload->prog.
+ */
+void bpf_prog_dev_bound_moved(struct bpf_prog *prog)
+{
+	if (!bpf_prog_is_dev_bound(prog->aux))
+		return;
+
+	down_read(&bpf_devs_lock);
+	if (prog->aux->offload)
+		prog->aux->offload->prog = prog;
+	up_read(&bpf_devs_lock);
+}
+
 static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
 {
 	struct bpf_prog_offload *offload = prog->aux->offload;
-- 
2.53.0



