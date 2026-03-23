Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9FF25F984;
	Mon, 23 Mar 2026 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282360; cv=none; b=rEsrLFufqr7RRpWebQIKraEzgKnif45cENe6CU9C8K0k1eTRViQkOqxZaceNHbh+OCirUSLNieoYVJs0a4zlSmypKM7Fn/Vv2h/OLqNF94XeYqBgF/HvMpUnoYppGkpsf6XhEo7byDzB29Wi4eH5e4ep5sTLszgn2QYrNPVUX/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282360; c=relaxed/simple;
	bh=Bql2hsYAhf6UVh1hcNHHIAlATWPrFGfKa+OXz2ZSAwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0xjlWPhORVSC83tvedGTTk5iDUEne0+TQiWf81s52pHiG7eleVb+ek06Of9+/T0S/TT9UoelQtOYYah2FHhAY5OaOUsDO+8WiKo/GTTAmevEH0iLagl0eZbbQNLpPql6M6wNwHYW7hun0bzq33oDYFnRKurQ5RlsT2fTgdZJs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3WjOlfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3WjOlfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31628C2BCB0;
	Mon, 23 Mar 2026 16:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282360;
	bh=Bql2hsYAhf6UVh1hcNHHIAlATWPrFGfKa+OXz2ZSAwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3WjOlfUKkCrehNUF5gi3X4v2aiTzmGkxut3fL6fxTM+d9rPlDh+9WyyzwiwJXD96
	 FpOFUoDbP/V/m2msQy4EoV1aXxRxuPmMqAe5Hwc+W3KXJy0woX43kpNJNNwBLcBxt2
	 m2HPfRbjK505tFLsFoHPGckXFSY5H/pv0pqY/OS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Lang Xu <xulang@uniontech.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/481] bpf: Fix a UAF issue in bpf_trampoline_link_cgroup_shim
Date: Mon, 23 Mar 2026 14:41:49 +0100
Message-ID: <20260323134528.371589262@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4c7c6129db90e..17763af54179b 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -732,10 +732,8 @@ int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
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



