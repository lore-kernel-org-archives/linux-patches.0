Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC422135CE;
	Mon, 18 Aug 2025 13:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523426; cv=none; b=O7+fK1KmpG+10YlCCWeSWGJrHm2c+k2LLNAk2n0x+6iRtO/kN1hx/SToGXJ7KnTaDqvNNdKnlACEm+BFTR+iusLxJruKWEW38WypqqowQBJ1qBsLkoLrQvdJbFv8vlxEHzBV8AtpHX6VuHSqBEVi3/ySrFAxye4SMGYv5rwSPpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523426; c=relaxed/simple;
	bh=teFb/4ANSgrXthyLHTaCen/vlpfUHOcNvNK28o1mPpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADSIAQ7XiXxunmR6uqPC8u1DRpuihNEGTc0Ak8nllu1d47CkDEwDP7CqBc1WaueJy52fHz8pHL04He7CJZXSs6cb5YJgxLkd28TSEK9ccZNmR2P5po0vzPXfNH1H1u0w4nX8NF6aKVQS0XtxXWb8yV4nN/INFcDLnAPvGoW7vfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkKGw4mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkKGw4mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD2DC4CEEB;
	Mon, 18 Aug 2025 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523426;
	bh=teFb/4ANSgrXthyLHTaCen/vlpfUHOcNvNK28o1mPpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkKGw4mhtSPnmmcZwEgYpbEBia1oK9p1JUHr5fzR2bDECYjyWi6zGv6FrexceAmgD
	 FX5rv25CwRgtfttZ+ThloHu7TFvRQdJ3bzHtVzlt/bVref5pGb63zNLanl6Hqtj/co
	 3M9/gm8VP3cDnkLYGyVsRMvZXYPIjiBPjJSqGZ8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 168/515] x86/bugs: Avoid warning when overriding return thunk
Date: Mon, 18 Aug 2025 14:42:34 +0200
Message-ID: <20250818124504.839513516@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit 9f85fdb9fc5a1bd308a10a0a7d7e34f2712ba58b ]

The purpose of the warning is to prevent an unexpected change to the return
thunk mitigation. However, there are legitimate cases where the return
thunk is intentionally set more than once. For example, ITS and SRSO both
can set the return thunk after retbleed has set it. In both the cases
retbleed is still mitigated.

Replace the warning with an info about the active return thunk.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250611-eibrs-fix-v4-3-5ff86cac6c61@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0f6bc28db182..82089a464d30 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -70,10 +70,9 @@ void (*x86_return_thunk)(void) __ro_after_init = __x86_return_thunk;
 
 static void __init set_return_thunk(void *thunk)
 {
-	if (x86_return_thunk != __x86_return_thunk)
-		pr_warn("x86/bugs: return thunk changed\n");
-
 	x86_return_thunk = thunk;
+
+	pr_info("active return thunk: %ps\n", thunk);
 }
 
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
-- 
2.39.5



