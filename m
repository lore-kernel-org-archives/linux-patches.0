Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032339;
	b=EcBL/RTNfcrKTq1lZ4oJBy0+WOKOyh/3riCoOKdBOQTBYcOw2RdWQ8yucCtXlXyq+aZu
	 DZaed8mkjxriaqN3ZcQ+WrLMhw6GNWIaqCIkEA7qk39ZEiRIvi0SXEVItvt7UzTUiM5LI
	 +c/GpSBSeMyi32NUy3Iv3TA4pik9vJXAeDrKI18Gd7SEOkTfhEQZwADOJnMffTs7+5Hfz
	 ZqLEOJyQjiHcD7vOwaUBs/+zUKG2i/Of0CdyWYI72YqOF3ewHTRNb9F5k1gtPzxaPSD3o
	 DW/0HrYtjZnwGu4Nx/z1F1LHn7p33Q5tWsK90UV3tvuXtSrjozxp78GutXRwaUUd0FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WKmpJHWwIz7/D4eh5RllKASGUdwbLBmpPgeLLtZpMuU=;
	b=Kw85TJb+3OxfsyDp6Hh00zYNeN9tdDHbb9bTD6urId+lP1pkSAEf0AhtXVC8Ar7h38Mm
	 pkjhVl3LgEdstshYypnzZJdxM/2396VLe5lV7ajwDUBRWbAM8wN/Sls9blJrm5JAqZt1N
	 ZqHJd9Sb1DdvbMoZrL6rbET07GWmNHgwMbSnfOTW1ihR8UtkM3bqWXA1FW5ovfdS0g//x
	 tX3241cmEimdFRJXvLqJ7YXI0NwZhOYAse3T4uClyiRffYehy7rP+01wyK9zgq0zFGzt+
	 PMSga0CQn3cr+KZq5HUOywZyKilYCDHnZMhbV4pzEKOyqMPn28p80v/MduA+t09tTkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wHqdNCK8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C25260A3820;
	Wed, 18 Nov 2026 20:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wHqdNCK8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDF51F000D3;
	Wed, 18 Nov 2026 20:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032339;
	bh=WKmpJHWwIz7/D4eh5RllKASGUdwbLBmpPgeLLtZpMuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wHqdNCK8b5P3zOAjIpGPIE1nLkq7FIJHtTH25LopJlwsIdFf7ORSEDLxyvsH2ryvG
	 hGTR3GA5q1PxlPTkm7bZI7x4RbXNVz/a5lALT4JbThk0WrmsY3rFxueFlJW7wrGQ+i
	 uuJOfBmxFWgfq0EosLcgLCMNpwQ3bG144mAtgWH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1370/1756] bpf: Fix stale offload->prog pointer after realloc
Date: Wed, 18 Nov 2026 15:58:17 +0100
Message-ID: <20261118150103.773887063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c144ae94290fa..e456fe475e017 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -3067,6 +3067,7 @@ int bpf_dev_bound_kfunc_check(struct bpf_verifier_log *log,
 void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id);
 int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr);
 int bpf_prog_dev_bound_inherit(struct bpf_prog *new_prog, struct bpf_prog *old_prog);
+void bpf_prog_dev_bound_moved(struct bpf_prog *prog);
 void bpf_dev_bound_netdev_unregister(struct net_device *dev);
 
 static inline bool bpf_prog_is_dev_bound(const struct bpf_prog_aux *aux)
@@ -3128,6 +3129,10 @@ static inline int bpf_prog_dev_bound_inherit(struct bpf_prog *new_prog,
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
index 6bc3dc998ae11..3387709aca48e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -262,6 +262,7 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 		memcpy(fp, fp_old, fp_old->pages * PAGE_SIZE);
 		fp->pages = pages;
 		fp->aux->prog = fp;
+		bpf_prog_dev_bound_moved(fp);
 
 		/* We keep fp->aux from fp_old around in the new
 		 * reallocated structure.
@@ -1545,8 +1546,7 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other)
 	 * know whether fp here is the clone or the original.
 	 */
 	fp->aux->prog = fp;
-	if (fp->aux->offload)
-		fp->aux->offload->prog = fp;
+	bpf_prog_dev_bound_moved(fp);
 	bpf_prog_clone_free(fp_other);
 }
 
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 1b6f9e7175666..791da915112fb 100644
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



