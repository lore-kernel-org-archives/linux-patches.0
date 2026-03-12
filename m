Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7CD2D2491;
	Thu, 12 Mar 2026 20:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347139; cv=none; b=dywyPEeHz9fGEoYlskReGfPNSZTaPRg9qz+uBWk757QDPQN6soVfN6pjSvTcWlfKqkNYzvJQOaQ/ctkJFfLuxzftLCIW35Ke0ysHdzMsPfzRYNUHjdf2S3bnkFjcmS2k7NKylc/Cxr25Icpp7YX6T8Py/4D3e9EVwYOVmd2RdFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347139; c=relaxed/simple;
	bh=r7stgMsONLjSiy2lCIhbGcfiGjfJ9FC18WlfD2tQzCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUEC/rbUdjoGGOPAWUwZa1xWgN5LN1jjmrJrFATCeAcD4OnZ9zfrYLRauHIUsPrZ+ehU9xm+QKpep1d5+qusjhlxvNcWAyMaAJXdjky8oqpdervIINMuvxlTq3gaxEywsfay+caBy11n3DwUM2EK1x8SAYDBKzAd/OF117p84iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1GPgvDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1GPgvDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68B6C4CEF7;
	Thu, 12 Mar 2026 20:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347139;
	bh=r7stgMsONLjSiy2lCIhbGcfiGjfJ9FC18WlfD2tQzCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1GPgvDgxJUhDy9zNlTyQiM9EaGum8fY7tmT60pbEs/NVeHhQczx40cm3M7S98e5Q
	 ZjJfhl+gas5tZQtNo0NnA1/259aKWx5xivlDWGXmMbgkBqZHkNC/AYRurMvk9ggipO
	 5USIaCpROWjVlNqLeVOYPFwtIGnXI6NjIhk8tJ04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Lang Xu <xulang@uniontech.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/265] bpf: Fix a UAF issue in bpf_trampoline_link_cgroup_shim
Date: Thu, 12 Mar 2026 21:10:01 +0100
Message-ID: <20260312201026.049583995@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lang Xu <xulang@uniontech.com>

[ Upstream commit 56145d237385ca0e7ca9ff7b226aaf2eb8ef368b ]

The root cause of this bug is that when 'bpf_link_put' reduces the
refcount of 'shim_link->link.link' to zero, the resource is considered
released but may still be referenced via 'tr->progs_hlist' in
'cgroup_shim_find'. The actual cleanup of 'tr->progs_hlist' in
'bpf_shim_tramp_link_release' is deferred. During this window, another
process can cause a use-after-free via 'bpf_trampoline_link_cgroup_shim'.

Based on Martin KaFai Lau's suggestions, I have created a simple patch.

To fix this:
   Add an atomic non-zero check in 'bpf_trampoline_link_cgroup_shim'.
   Only increment the refcount if it is not already zero.

Testing:
   I verified the fix by adding a delay in
   'bpf_shim_tramp_link_release' to make the bug easier to trigger:

static void bpf_shim_tramp_link_release(struct bpf_link *link)
{
	/* ... */
	if (!shim_link->trampoline)
		return;

+	msleep(100);
	WARN_ON_ONCE(bpf_trampoline_unlink_prog(&shim_link->link,
		shim_link->trampoline, NULL));
	bpf_trampoline_put(shim_link->trampoline);
}

Before the patch, running a PoC easily reproduced the crash(almost 100%)
with a call trace similar to KaiyanM's report.
After the patch, the bug no longer occurs even after millions of
iterations.

Fixes: 69fd337a975c ("bpf: per-cgroup lsm flavor")
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Closes: https://lore.kernel.org/bpf/3c4ebb0b.46ff8.19abab8abe2.Coremail.kaiyanm@hust.edu.cn/
Signed-off-by: Lang Xu <xulang@uniontech.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/279EEE1BA1DDB49D+20260303095217.34436-1-xulang@uniontech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/trampoline.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index dbe7754b4f4e1..894cd6f205f5f 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -749,10 +749,8 @@ int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
 	mutex_lock(&tr->mutex);
 
 	shim_link = cgroup_shim_find(tr, bpf_func);
-	if (shim_link) {
+	if (shim_link && !IS_ERR(bpf_link_inc_not_zero(&shim_link->link.link))) {
 		/* Reusing existing shim attached by the other program. */
-		bpf_link_inc(&shim_link->link.link);
-
 		mutex_unlock(&tr->mutex);
 		bpf_trampoline_put(tr); /* bpf_trampoline_get above */
 		return 0;
-- 
2.51.0



