Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F42831A04A;
	Mon, 18 Aug 2025 12:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521858; cv=none; b=mHAHw1d7m1I4ariYdorMNov+lMf9qezgkLJHY/NSanipLKbqA56phwFYrY0ezXRqe/UaE+UnSQOYR6jkvx176LESvCmdMdogkPV/sHgQtnP10IrLB3qr8GVJt7EDSYeyUPQcVZXl4qWahyL/ay2+SmpS7cUytGFS677RqrxFkBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521858; c=relaxed/simple;
	bh=qEi5C86ktpXL1L1E4KezxwRmpwynOzPFR2Uf4t62n40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgcbRigNdycWPiPyu97h4ifUktipKrU31fbBdM2iqGVcI8QzLuzlyljGuLS4FjOU8CpekqjcE1+yrsvgamK5gOOsvT9WbBmNacxeHc1lvpi/WQd3ZuPqR/bWs8mrm9VX7RUhMT+S64og0lIGVxqCA5/PUmXb/Nnq8n2Vfzhf2ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/jz6B67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/jz6B67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67763C4CEF1;
	Mon, 18 Aug 2025 12:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521857;
	bh=qEi5C86ktpXL1L1E4KezxwRmpwynOzPFR2Uf4t62n40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/jz6B67I9y8EZXR/rLGRbsc04dBzMbVB1fMwaMYI0JT/ylAau0kNlBJ+Yjy1jOTB
	 JDKbEaAdTSl88Qsn6cjp/iIBoYokxX5gMJ5OyeOMMzDjDDYM9KjjgjrtEgdwd9DsY4
	 x+Xp2MKNWWTYf522CqWSDlqWrJybjo5vGDiHrF9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/444] x86/bugs: Avoid warning when overriding return thunk
Date: Mon, 18 Aug 2025 14:42:48 +0200
Message-ID: <20250818124454.239274796@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index c2c7b76d953f..31b4b73e5405 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -71,10 +71,9 @@ void (*x86_return_thunk)(void) __ro_after_init = __x86_return_thunk;
 
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



