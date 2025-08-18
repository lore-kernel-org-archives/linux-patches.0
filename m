Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E14335BBE;
	Mon, 18 Aug 2025 13:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525181; cv=none; b=VCipSwpiaBLanvLxQAqWjEO6did30Yd17W+EfUqzZaupttv3Uue/7FlO2000G/xCnIVslfGLsPGIfU50uV5mqPXuLOzA8bEFcyd4+u8psvuF6kV/8cIBRWRtoXQokqI4NX8bb9phVjmCsnEWvD0CyxzQu0r6fpkm0J2ZyeD+KyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525181; c=relaxed/simple;
	bh=iswyeFkY355NdISNPb+LD4vaCFf83HzKtnlgso6/Etc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uH78tNNia9hfWIKU0kp4vs6YQa1kY0p4y8nGX9BEJSm4h42coGd0mtaBmBc0i2Llrs8cfPebTyLoBhVmFmRTwjThSy05ykV/FlyzFZTGvQrz5AdWnG5kZGD0YPrBN4+SbxYV7rgCzZ9/XL1/BrRb2s49f1PJux+tdMCuyt8QpZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEtfn0qj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEtfn0qj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65CCC4CEEB;
	Mon, 18 Aug 2025 13:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525181;
	bh=iswyeFkY355NdISNPb+LD4vaCFf83HzKtnlgso6/Etc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEtfn0qjpytr1sW/XrjaWrg4vyy0BrUk1JEDUUh0VwbYeCQjjxJiX+ySdW4oEqU7z
	 ux9JTCmE3iqAOYYpx47uoNGuEo049WcS9N/ppxuEKXAD3a2msTwW2vYTfqdAAFV85c
	 wHFEBOirJmAqjGA/hU6DNLWyLVYSneqy1LnJAZC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 184/570] x86/bugs: Avoid warning when overriding return thunk
Date: Mon, 18 Aug 2025 14:42:51 +0200
Message-ID: <20250818124512.899707186@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f2721801d8d4..d19972d5d729 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -115,10 +115,9 @@ void (*x86_return_thunk)(void) __ro_after_init = __x86_return_thunk;
 
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



