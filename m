Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041969;
	b=WXIXIkzRoQpPrrhXa5p5vOXtuNIGweTJGUk70IQHJeVgUrq05wRLdSwGDicMPBdM+Hnb
	 6t4+CPf4HES2QnCC+uwlq2vRCUFmWU2LAFDkyuh8uVHU+dnN0IeyEPHWt5WvTxD/uOCKs
	 LAE161YTN+xsRsEtpE59hQ5y/t3tMs1rkt9r/1amuiiBr/TfZXD/ftKcIyYGxBwgHT9gM
	 jVqQydHlU4JuYXOYii2re4zgLrJgQavMkGRsALdzOYUXUjmX7lZu9Ifql7EeXuGtEBZ1p
	 hnIDdr6avaPxrscSY1LELTSjOC900OmAzYbeBN36d1ZuoVw9/5x3jRnL0Y5a0zw9NdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qNY4uVvNORhtN3JLxNI0ynwmZpHecXOOhJH6p/aXckE=;
	b=w/XL/ii+GyDmzfLeUawsJCz7JaxuNmaW6SeHhNFOOaMCv5DlWrrVXsT1bgGXwdBEFTg1
	 ueXkEoUmvv/qoSLPqninRCraKGHIj1+K9tb2QNkuXpsiBBECYsaSsy6YP373ZZxjxi4rj
	 /K6Gx+uaXPVfuzvEhEoug5eaPk06WMUoiMmlsidS7JBIvoqxJR10hyh19L22qhF/9IyoV
	 M5KGiXf/XMuDwL4jYFkRvsPlJxV1bGtlMvBqkbu9t+aw46terKLsFV0ZpJr1j/+GLVeUY
	 XpUFBUw5s3ed6kbsUimhaZLIRv1r6Xc2f1EI1U4oYUsG8rQhc6wnpBCA5q5n2UU0uGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jM9kXQyC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBF5606A320;
	Wed, 18 Nov 2026 22:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jM9kXQyC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937EC1F000C4;
	Wed, 18 Nov 2026 22:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041969;
	bh=qNY4uVvNORhtN3JLxNI0ynwmZpHecXOOhJH6p/aXckE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jM9kXQyC1nn69D5GQZUPPHhlPsPXB4b1OCg+Jy3y+ARhrdPaeEiEasPvNEWJpP15R
	 EX58GgvfIT7CrFkvOI2s3vw2SKdUzb59zaVefpj2wVvEUYCr06iUL+C9wbyRyIpxj5
	 eWbWRX/X5MfGjCrt6MA33aHZcCu+9sjg4xuf3Zf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3003/3318] bpf: Fix stale offload->prog pointer after realloc
Date: Wed, 18 Nov 2026 16:00:25 +0100
Message-ID: <20261118150450.346407726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e3af0e06b4bfd..64fd49b68725c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2865,6 +2865,7 @@ int bpf_dev_bound_kfunc_check(struct bpf_verifier_log *log,
 void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id);
 int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr);
 int bpf_prog_dev_bound_inherit(struct bpf_prog *new_prog, struct bpf_prog *old_prog);
+void bpf_prog_dev_bound_moved(struct bpf_prog *prog);
 void bpf_dev_bound_netdev_unregister(struct net_device *dev);
 
 static inline bool bpf_prog_is_dev_bound(const struct bpf_prog_aux *aux)
@@ -2925,6 +2926,10 @@ static inline int bpf_prog_dev_bound_inherit(struct bpf_prog *new_prog,
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
index 175ef2a64cb13..4ad9435c915d7 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -253,6 +253,7 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 		memcpy(fp, fp_old, fp_old->pages * PAGE_SIZE);
 		fp->pages = pages;
 		fp->aux->prog = fp;
+		bpf_prog_dev_bound_moved(fp);
 
 		/* We keep fp->aux from fp_old around in the new
 		 * reallocated structure.
@@ -1478,8 +1479,7 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other)
 	 * know whether fp here is the clone or the original.
 	 */
 	fp->aux->prog = fp;
-	if (fp->aux->offload)
-		fp->aux->offload->prog = fp;
+	bpf_prog_dev_bound_moved(fp);
 	bpf_prog_clone_free(fp_other);
 }
 
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index ae0c8e7894586..21547b5d63809 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -105,6 +105,22 @@ static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
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



