Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214C638A719;
	Tue, 10 Mar 2026 11:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142177; cv=none; b=BM3eHFdPqkiroe+zRbRjwdwXxf7DGydOhJCAgNCsvkp9wq0OTNQuWJ5Kl2JRCiT+w1IcBT3mqhzjnn0N5UMEj70VXdFaQldF1D0u0d3dKyVTs9hTvZULiUhv3SjP+ACBC64ZHKDzTegqxz/DtfdWqBz9CJuXwIFXkcPZNO/h2F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142177; c=relaxed/simple;
	bh=/eLTpfBrPGCP4WRGAbXoPWblVd3TyrkmIy6CQ5MnTa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOaZykV90DOL8Qz2KvSacNuVmInc5T6x0ca//t5nPSDv9MdhpNYleNyi2+UI3UunkgJVLyPxLDcNJxnUgOMX8JF3kDdVNVtRyC4F5rldXe/U4UmMqO+sfHkbkbXHdJHVN08ZyEx2nLDF6g2nsJDzR1i9YNoQ5akbY0QH4ywHDYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CiUYDt0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiUYDt0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55248C2BC86;
	Tue, 10 Mar 2026 11:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142177;
	bh=/eLTpfBrPGCP4WRGAbXoPWblVd3TyrkmIy6CQ5MnTa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiUYDt0FaZqtSetlnhkZ4hsnvcUFLYIhZaGFuJaLXAcAYZ6g4iqpm9WWh1eANJXcU
	 3YWPfUalFTqix4ncwlikrksDGMW/cABQbAws1+NsNEUn0ROnw5ZZ9M5VrYzOxOl2V4
	 NFxXpxGCEdWI0pyv3m0KvvJG2ROPsGQXuY96FoYql6+EeYaCufdkcYCszgkY0fK/wo
	 OUYxVeIdQUCIImellSM88YvDtSxuR7vM5wDcjwodaP3/oyxc2JBER87icBwE5ZWBGn
	 tWOPpoNifJ4rfE979FQcGjZbB+9cMEwaJQrZ+XGZa2ArHDqMIPy902AbukxoWIzofB
	 UiPEwODnyl+vQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lang Xu <xulang@uniontech.com>,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 265/314] bpf: Fix a UAF issue in bpf_trampoline_link_cgroup_shim
Date: Tue, 10 Mar 2026 07:18:44 -0400
Message-ID: <996e84850a9a7ba24582b3c6228b9e86f13d4c79.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 04104397c432e..40f19147f227e 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -751,10 +751,8 @@ int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
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

