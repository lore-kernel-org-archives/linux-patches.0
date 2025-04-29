Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7684F1C6B4;
	Tue, 29 Apr 2025 17:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948200; cv=none; b=EwWWGRXJu4Ow02csj4fI7MhCshuQ4Y2EeZzi89u4CYtth4F2DQEwuojGB0+8VGFaABcZjgMhN48DnDMQwS5TzKjnfd6mwgR4eI16VozhR2PL48Z3wTNO9xQjSm8IYun/SfGb51avfOtwKyWfbvl7Ony8fxdVzc67c4scwTmQhVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948200; c=relaxed/simple;
	bh=9sxjKxPtk4IZ58at2RlYjnkcnYNpVGPO0eqQHp/jsKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHOqo/SnMtYSpXjXGgUJw/nQlf6k1Ux4Z04HJ0z8ycGH7fhfJSwt9fpBHB63ikBsad4eihiwr1n/sbS/IF/tpljgBB6x2xo7LljeP/6HlJ04G7BVYKrdFzsEFGCQrPWxadpV/du0vOayRNs8H0HkAonj9s/9Sd/zRMp2Xj8jZiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kS+bgddJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kS+bgddJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090C3C4CEE3;
	Tue, 29 Apr 2025 17:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948200;
	bh=9sxjKxPtk4IZ58at2RlYjnkcnYNpVGPO0eqQHp/jsKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kS+bgddJE9EjxQzF/ChILvcxQmNzwhqrc8yYwZC9m1JKId8YA6IHMwEx28Fo9wOzs
	 noWqeP7Ntf481l99aQcz+VMuyiUz31E4Iu1nPZbGkEhaq+AuJOIQwP5VthyePGV+tq
	 3bJcRHbQEbmP5OYYX9JzYUf64kiB2ID3s84hRJ7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/280] x86/bugs: Use SBPB in write_ibpb() if applicable
Date: Tue, 29 Apr 2025 18:42:39 +0200
Message-ID: <20250429161124.042326121@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit fc9fd3f98423367c79e0bd85a9515df26dc1b3cc ]

write_ibpb() does IBPB, which (among other things) flushes branch type
predictions on AMD.  If the CPU has SRSO_NO, or if the SRSO mitigation
has been disabled, branch type flushing isn't needed, in which case the
lighter-weight SBPB can be used.

The 'x86_pred_cmd' variable already keeps track of whether IBPB or SBPB
should be used.  Use that instead of hardcoding IBPB.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/17c5dcd14b29199b75199d67ff7758de9d9a4928.1744148254.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index b7ea3e8e9eccd..58e3124ee2b42 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -18,7 +18,7 @@
 
 SYM_FUNC_START(entry_ibpb)
 	movl	$MSR_IA32_PRED_CMD, %ecx
-	movl	$PRED_CMD_IBPB, %eax
+	movl	_ASM_RIP(x86_pred_cmd), %eax
 	xorl	%edx, %edx
 	wrmsr
 
-- 
2.39.5



