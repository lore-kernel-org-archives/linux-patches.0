Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66679142E83;
	Sat, 14 Feb 2026 21:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104368; cv=none; b=KeqrdaF/InGfqHR4RjjbxLbpSziDAaM8M+KcH8+sYuq7TCMnwKtb6JmsAtZc8NbmJK8Wro/acR/+wrvdGTD7S59SKHexrYHVYEJTK71cyjZF6aKFppO4+2SJ2vxWhRI/dpFD99t9g/e5MUbj2Xmy3sED5YrqISO8V101vSB02EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104368; c=relaxed/simple;
	bh=rg3gHK8dA4+JPzitb7VA7CwcRiPGTdd+oWFzHG4lqjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DXGgLggG+sD0+b8uE+DT9GNx934UVKd6Ump1VmRjnfP8ZTOE9eCOX6DT76UX15tnOW1MQAtmfM6w4X9GoIG+pYkvfrGrtq2Ee9rDnWmjxg27YAgYJnPjNSwGVkaHL5b3AcAfl5IiDI3lH7s1ZBGGFZYHd1Ex2woGmS4GbJVgmMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iuYOd4x2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iuYOd4x2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAE5C19422;
	Sat, 14 Feb 2026 21:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104368;
	bh=rg3gHK8dA4+JPzitb7VA7CwcRiPGTdd+oWFzHG4lqjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuYOd4x2HJ2Sad3q8FuPgOUafd+qg3lY9m8T0u4lJcLHbLZGQnUmEA3grt79webGC
	 UbEFCJC2erL6RGwgkfGCGMMyB/q4MiSNBmdR/PihtplAdY8lggJle7N1t/lXcmKu3H
	 jfMx/awLu6xqTNDBKIUrXAwd/cZ2dCoISIbwVDb4mcnuoWEn3HsKyn6isLlxAZNd8S
	 jDoNb9sLO++aAg+4ru/O5zJftr/AFnfEoDp++FG92KVgYFL/B8KxMBS7p2igXnKOME
	 SLySd/hoJKVCkx44K1ab0yOwyBBDCXk19Sz9LIoB+dKmnLovipWwMOKqrlGM0ThWyv
	 s4VnMSrOo33oQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	neil.armstrong@linaro.org,
	liaoyuanhong@vivo.com,
	yelangyan@huaqin.corp-partner.google.com,
	jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.19-5.10] jfs: Add missing set_freezable() for freezable kthread
Date: Sat, 14 Feb 2026 16:23:10 -0500
Message-ID: <20260214212452.782265-45-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit eb0cfcf265714b419cc3549895a00632e76732ae ]

The jfsIOWait() thread calls try_to_freeze() but lacks set_freezable(),
causing it to remain non-freezable by default. This prevents proper
freezing during system suspend.

Add set_freezable() to make the thread freezable as intended.

Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the bug pattern clearly:

- **`jfs_txnmgr.c`** has TWO kthreads (`jfs_lazycommit` and `jfs_sync`)
  that both correctly call `set_freezable()` before their loops and then
  use `freezing(current)` + `try_to_freeze()`.
- **`jfs_logmgr.c`** (`jfsIOWait`) has the same `freezing(current)` +
  `try_to_freeze()` pattern but was **missing** the `set_freezable()`
  call. This is clearly a bug — the thread was intended to be freezable
  (it checks for freeze and tries to freeze) but never marked itself as
  such.

### 3. CLASSIFICATION

This is a **real bug fix**:
- The thread is intended to participate in the kernel's freeze mechanism
  (for suspend/hibernate), evidenced by the `freezing()` check and
  `try_to_freeze()` call.
- Without `set_freezable()`, the thread has `PF_NOFREEZE` set by
  default, so `freezing(current)` always returns false and
  `try_to_freeze()` is a no-op.
- This means the jfsIOWait thread **never freezes during suspend**,
  which can cause suspend failures or issues with filesystem consistency
  during suspend/resume cycles.

### 4. SCOPE AND RISK ASSESSMENT

- **Size**: Single line addition — minimal risk.
- **Scope**: Only affects the jfsIOWait kernel thread in the JFS
  filesystem.
- **Risk**: Extremely low. This is adding the exact same pattern used by
  the other two JFS kthreads. The only behavioral change is that the
  thread will now actually freeze during suspend, which was the original
  design intent.
- **Subsystem**: JFS filesystem — mature and stable. While not as widely
  used as ext4/xfs, it has real users.

### 5. USER IMPACT

Users running JFS filesystems who suspend/hibernate their systems could
be affected by the non-freezable kthread. The impact includes:
- Potential suspend/hibernate failures (the freezer may timeout waiting
  for this thread)
- Possible filesystem consistency issues if the thread continues I/O
  during suspend

### 6. STABILITY INDICATORS

- The fix follows the exact same pattern as the other two JFS kthreads
  in jfs_txnmgr.c
- Signed off by the JFS maintainer (Dave Kleikamp)
- Trivial one-line addition with clear correctness

### 7. DEPENDENCY CHECK

No dependencies. The `set_freezable()` API and the freeze framework have
existed for many kernel versions. This patch applies to any kernel that
has the JFS filesystem with the jfsIOWait thread.

### 8. CONCLUSION

This is a textbook stable backport candidate:
- **Obviously correct**: Adds the same `set_freezable()` call used by
  the other two JFS kthreads
- **Fixes a real bug**: The thread never actually freezes during suspend
  despite being designed to do so
- **Small and contained**: Single line addition
- **No new features**: Just makes existing freeze support work correctly
- **Low risk**: Cannot introduce regressions — it only enables the
  freeze behavior that was already coded but never activated
- **Affects real users**: Anyone using JFS with suspend/hibernate

**YES**

 fs/jfs/jfs_logmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index b343c5ea11592..5b1c5da041630 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2311,6 +2311,7 @@ int jfsIOWait(void *arg)
 {
 	struct lbuf *bp;
 
+	set_freezable();
 	do {
 		spin_lock_irq(&log_redrive_lock);
 		while ((bp = log_redrive_list)) {
-- 
2.51.0

