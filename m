Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A996D3A1690;
	Sat, 12 Sep 2026 08:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202037; cv=none; b=Q8Rebpy+Vpyr5SeyvRs9GTuFwS8M3RkmCe/BB+SUYWUgORKO8/ajWN9DjBxpr07ESdN80aMTl4VQeS/FZEPYLv0304P0Me8rnWQIdZYujSasSp9Wks0ofvWewhBQOneFOLGD0DcgRnEWxpqoEoxz0ShNLVLfyUOqFlTl6e7L+Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202037; c=relaxed/simple;
	bh=4y0cywiLnvO7V3HQQ/f9NfSjHZ/5UstqNQHxCASv48U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8u1VpoctG9VmJV8kVrkuBvWDDD3n4O0dAebC586JUCzJw/aNegulJqnkoYVgm2VFaGDh3xecEQ8nCOtARsvP244lWUVX7GgIpm0aqdbcnXTt/FkSIH59/pUY4JL28r198DAfriath2YlvN+L+N1OpPc6Ya6RVaSJ5bMxj+Z87M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzgZWGhy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzgZWGhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616C51F000FF;
	Sat, 12 Sep 2026 08:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202036;
	bh=c32bDK9P4In0gRMF5iTOvevYgaQ8r7wbcaTnqVocN5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AzgZWGhyS/4bxSLv6UoO8Zhl+Puy+34KLwiqEUysQnJRiE6wk07uN9JZRTrXw9k1X
	 hav+9ug1peBFIAyqmuzUB2sES4m47KyTcWQq31cRjlWUvzbKEI4WCPteKkYoSMRWeC
	 OpgL+7rHKbWeuEf1kEKA6OgeTUYVri4h/cHH1AHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1120/1815] bpf: Clear buf on error in __bpf_get_task_stack
Date: Sat, 12 Sep 2026 08:47:50 +0200
Message-ID: <20260912065715.313639961@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit f5d242825ca417bb6afe35fde6e8880f97ca43fb ]

Both bpf_get_task_stack and bpf_get_task_stack_sleepable helpers that
use __bpf_get_task_stack have buf defined as ARG_PTR_TO_UNINIT_MEM
argument and we should initialize the buf on every return path.

Adding missing buf memset for __bpf_get_task_stack fail paths. This
provides deterministic buffer contents, which is useful when the buffer
is used directly as a map key.

Fixes: 06ab134ce8ec ("bpf: Refcount task stack in bpf_get_task_stack")
Fixes: b992f01e6615 ("bpf: Guard against accessing NULL pt_regs in bpf_get_task_stack()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-10-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index ebeea95f45f2e..5bfa5998f39ae 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -887,14 +887,17 @@ static long __bpf_get_task_stack(struct task_struct *task, void *buf, u32 size,
 	struct pt_regs *regs;
 	long res = -EINVAL;
 
-	if (!try_get_task_stack(task))
+	if (!try_get_task_stack(task)) {
+		memset(buf, 0, size);
 		return -EFAULT;
+	}
 
 	regs = task_pt_regs(task);
 	if (regs)
 		res = __bpf_get_stack(regs, task, buf, size, flags, may_fault);
+	else
+		memset(buf, 0, size);
 	put_task_stack(task);
-
 	return res;
 }
 
-- 
2.53.0



