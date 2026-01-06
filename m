Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F6D34029C;
	Tue,  6 Jan 2026 17:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721047; cv=none; b=qSN8c2gShJdSvI5gkz4vX7UXlQ3NwT5KXkDeEjkhbLc9yviomDn5QWGesvE0JsTtBFGkdrUBEo0GFnzlxWBXG0u4yaMOI8TfeYFgUnzV+3x1mhtAo7ZDlVETvPPXlx+w/8m1rFfJgtNiZzjp2FZHO/hAmv4HKXDQvXxBcPcPdfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721047; c=relaxed/simple;
	bh=E12ZlP+gk0S7a61wU0B/m35U0w/ObvTAA7zOP5ENpIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgssCbfEAO2CGOqnI/y9jVLFQcJeDdAZr9BNMWBCVipzGCJYLCs8suSeuLOXAoBPjbRnPg4vzeir3CbHTnsz5DeKxYDTsiWQ4DzdHvwGA1fRovFIibweszyrruYmNoUAzpTHT6EOXSEprbiXRm8kgYK29X2M8D8QmPeLZ4i+lOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1SPlK2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1SPlK2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D9AC19424;
	Tue,  6 Jan 2026 17:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721047;
	bh=E12ZlP+gk0S7a61wU0B/m35U0w/ObvTAA7zOP5ENpIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1SPlK2dc9tMK7quKRxkZQNCGvXmXmQbTYEVY/1SnWmGJ6lp0D6lJuI+n3PKaRmh/
	 wUgOgZgbZs+vpt8ncvzL1w6voKoLspBLLq8dBnO8rtQlrdnZEwoW772khzdN/PoZGf
	 jFTlmijhbZjraXv7uYDI6mEu0/QtJ+nBS/3xsPYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rui Wang <wangrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 418/567] LoongArch: Fix build errors for CONFIG_RANDSTRUCT
Date: Tue,  6 Jan 2026 18:03:20 +0100
Message-ID: <20260106170506.805010613@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 3c250aecef62da81deb38ac6738ac0a88d91f1fc upstream.

When CONFIG_RANDSTRUCT enabled, members of task_struct are randomized.
There is a chance that TASK_STACK_CANARY be out of 12bit immediate's
range and causes build errors. TASK_STACK_CANARY is naturally aligned,
so fix it by replacing ld.d/st.d with ldptr.d/stptr.d which have 14bit
immediates.

Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511240656.0NaPcJs1-lkp@intel.com/
Suggested-by: Rui Wang <wangrui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/switch.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/switch.S
+++ b/arch/loongarch/kernel/switch.S
@@ -25,8 +25,8 @@ SYM_FUNC_START(__switch_to)
 	stptr.d a4, a0, THREAD_SCHED_CFA
 #if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	la	t7, __stack_chk_guard
-	LONG_L	t8, a1, TASK_STACK_CANARY
-	LONG_S	t8, t7, 0
+	ldptr.d	t8, a1, TASK_STACK_CANARY
+	stptr.d	t8, t7, 0
 #endif
 	move	tp, a2
 	cpu_restore_nonscratch a1


