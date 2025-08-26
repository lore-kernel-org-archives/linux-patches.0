Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE089340DA7;
	Tue, 26 Aug 2025 14:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217704; cv=none; b=HdfdtACHUTtLA2uL9J2A7M6XPquD069MPk1816diydnShvF/pvaRx6s8Kj3c7VULstaokSR29i2LhxcwjySfMzWVZFjnpS+QoxEI5whXd5gWwgmyfXCEQ4746ymcdbOj7T9/I+/7jlqSYMO9uCwJea/Nbva5kuDE5dtbV+SZTqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217704; c=relaxed/simple;
	bh=O9zIaMyLrEAMUBAQUA7k78jogbRA5tajuHjkaunrnnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdXv5pINtqLMUgfIfNXgLdYGOy6kfmH0QDAsSRP9L/7to3VHpQxJtxHa1LPyAw9RCWjlPaEL7fI9WhlGRQORKsyiv85zGvJNXv2UoqCjTZtNwL7FO4VoAhlb95muMKylyJPRHJdJlF6fmI5hgWy/0tHBRfY4aLonaPVYAbh7+oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSGmAl6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSGmAl6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82215C4CEF1;
	Tue, 26 Aug 2025 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217703;
	bh=O9zIaMyLrEAMUBAQUA7k78jogbRA5tajuHjkaunrnnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSGmAl6pNS2eBpeAAI5RePIcvzQNJZIm8WBnOs36vfofPxeMOSxML5rWkH2kV0VJV
	 2lp8xgZ64ork/vCDzu8MEsnLLGZ4etAWboUviFJPdr8MAV2PAo29UNeiRc1PV8WjMz
	 Z9DEtMPGh55DEmoqfqnTwEB00PhARJXFx8wXJg38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/523] x86/bugs: Avoid warning when overriding return thunk
Date: Tue, 26 Aug 2025 13:07:34 +0200
Message-ID: <20250826110930.456665016@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7c269dcb7cec..6ff9fd836d87 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -67,10 +67,9 @@ void (*x86_return_thunk)(void) __ro_after_init = &__x86_return_thunk;
 
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



