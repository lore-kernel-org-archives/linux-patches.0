Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCD8389DE0;
	Tue, 10 Mar 2026 11:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141999; cv=none; b=r8CpcgNLBCLRCITe2EbrQsp96M+PZZmQa7rd7klrWgL2AT+6NgHpgzGojmpShbWur3kcJEFtImsZ90ADgxBknk5FD/MzAv9AI1jdT3tts4JPDbeLfgKGZQStp+AE/g/zvljEu0EqyuHz4orSinIm36YQVhMtrWY2SGzcZgkFVc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141999; c=relaxed/simple;
	bh=GFgcK4VkevqWO6bPSAfhuXIL+hnYNjslBu/T8I7RFiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xq+jhAyUevz3EEalmyjiuWIn19/hZjhBcWVaBujK/22IyQyBwummLF6+fmC2js2umzDzisbYOlfodUZXQWmIyTuW0gfSC2u4BZIrqQFGd4HBw30yJB2jfaBuB5ITkL28pGfiAXsoqWv1P2WZPfVR/7t49r4h2nevRMkwUNMNXQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFp8fQHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFp8fQHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081BFC2BCAF;
	Tue, 10 Mar 2026 11:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141998;
	bh=GFgcK4VkevqWO6bPSAfhuXIL+hnYNjslBu/T8I7RFiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFp8fQHLOo9iJfXBFgEBeR6ZQQLtJwYat0nCjVtQgliSe1ZdcrYbxzbDVKyhQIJJ5
	 ZQZHVNpx8gGoYYVdnoMVIoijQPgkpnCwzZPeDe2UDtWPt3ynFfUovB6LJrXODn7E1b
	 jKz9qcX3pn6EyszfPSWuf9HdKJGqGIZqx9nzSqQMXO5h7Wjirj2xWpvBccotLq6cZB
	 Z0RyVCRMPlI0DcFsw0NkG5UpZFA5CMkIZFrhL5gW8cVI7CwpqG8wgk8loFcUq3HIxI
	 GFAnTD21CoagG836goxikHVkqnDVVOsQck1bus0Mt/NqIwrS/md1/DkpauV1uFA6L3
	 O7YUJdgft0rnA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/314] LoongArch: Remove unnecessary checks for ORC unwinder
Date: Tue, 10 Mar 2026 07:16:23 -0400
Message-ID: <eb50da6ff027f1fcefec034be2f0029e4b182d23.1773141555.git.sashal@kernel.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 4cd641a79e69270a062777f64a0dd330abb9044a ]

According to the following function definitions, __kernel_text_address()
already checks __module_text_address(), so it should remove the check of
__module_text_address() in bt_address() at least.

int __kernel_text_address(unsigned long addr)
{
	if (kernel_text_address(addr))
		return 1;
	...
	return 0;
}

int kernel_text_address(unsigned long addr)
{
	bool no_rcu;
	int ret = 1;
	...
	if (is_module_text_address(addr))
		goto out;
	...
	return ret;
}

bool is_module_text_address(unsigned long addr)
{
	guard(rcu)();
	return __module_text_address(addr) != NULL;
}

Furthermore, there are two checks of __kernel_text_address(), one is in
bt_address() and the other is after calling bt_address(), it looks like
redundant.

Handle the exception address first and then use __kernel_text_address()
to validate the calculated address for exception or the normal address
in bt_address(), then it can remove the check of __kernel_text_address()
after calling bt_address().

Just remove unnecessary checks, no functional changes intended.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Stable-dep-of: 055c7e75190e ("LoongArch: Handle percpu handler address for ORC unwinder")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/unwind_orc.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/loongarch/kernel/unwind_orc.c b/arch/loongarch/kernel/unwind_orc.c
index e410048489c66..b67f065905256 100644
--- a/arch/loongarch/kernel/unwind_orc.c
+++ b/arch/loongarch/kernel/unwind_orc.c
@@ -360,12 +360,6 @@ static inline unsigned long bt_address(unsigned long ra)
 {
 	extern unsigned long eentry;
 
-	if (__kernel_text_address(ra))
-		return ra;
-
-	if (__module_text_address(ra))
-		return ra;
-
 	if (ra >= eentry && ra < eentry +  EXCCODE_INT_END * VECSIZE) {
 		unsigned long func;
 		unsigned long type = (ra - eentry) / VECSIZE;
@@ -383,10 +377,13 @@ static inline unsigned long bt_address(unsigned long ra)
 			break;
 		}
 
-		return func + offset;
+		ra = func + offset;
 	}
 
-	return ra;
+	if (__kernel_text_address(ra))
+		return ra;
+
+	return 0;
 }
 
 bool unwind_next_frame(struct unwind_state *state)
@@ -512,9 +509,6 @@ bool unwind_next_frame(struct unwind_state *state)
 		goto err;
 	}
 
-	if (!__kernel_text_address(state->pc))
-		goto err;
-
 	return true;
 
 err:
-- 
2.51.0

