Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB002165F0;
	Thu, 12 Dec 2024 15:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016059; cv=none; b=W3RaMSn8AfqJa9+he9Guzcdddf/sQQsKRPABSZnBRdm6rpMyRdJIFcz/7GDg0BQ1GCjbxFF+KBS6sSCunJrCiIsRWk7kU5prpMJ/9EE0SHRK6o0vXbMnM0fuFPUaJHAePxloNIZWyez6meIDC9/ClBLx1Xs5xuvsoK4JEOciDP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016059; c=relaxed/simple;
	bh=biUjPGq3s1SUmj9jpt2+qLOnIaqxEV5gX+Rq3VAEKGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEovyREI1/3VwT8VgXr/93Irw+TOs7OiNXyF7r9rFWg0SdStGV0wST+YVVT/bkq5jnR3IdQtTbk9Kiefk6PsG1xAmLs6gb6T5ZepJLX0Jqp9RmMViwjCR1BFe7t3NPBD5AV+4cE8Oqs/G5Z/gM+Mb5QLk3lHmaaccERcXgPV+do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAKjF/Iw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAKjF/Iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C39C4CECE;
	Thu, 12 Dec 2024 15:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016059;
	bh=biUjPGq3s1SUmj9jpt2+qLOnIaqxEV5gX+Rq3VAEKGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAKjF/IwoGydhd3mGbW7PoJxgnkubxlXs3M4fOdmmlvDIeggzFkfcTdlF/vO/kTYM
	 Ncy/xbj58AvabsPgyhA9JjvUwPS3LercD9XRuUIkYpHU85JNBpJzCAqoC3FMZn8BHC
	 GPUQOxqrdhSj3JLvYYOiwKWK6k2Cp4HzI9gfkUrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/466] x86/CPU/AMD: WARN when setting EFER.AUTOIBRS if and only if the WRMSR fails
Date: Thu, 12 Dec 2024 15:54:49 +0100
Message-ID: <20241212144311.551750511@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 492077668fb453b8b16c842fcf3fafc2ebc190e9 ]

When ensuring EFER.AUTOIBRS is set, WARN only on a negative return code
from msr_set_bit(), as '1' is used to indicate the WRMSR was successful
('0' indicates the MSR bit was already set).

Fixes: 8cc68c9c9e92 ("x86/CPU/AMD: Make sure EFER[AIBRSE] is set")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/Z1MkNofJjt7Oq0G6@google.com
Closes: https://lore.kernel.org/all/20241205220604.GA2054199@thelio-3990X
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index d8408aafeed98..79d2e17f6582e 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1065,7 +1065,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 	 */
 	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled) &&
 	    cpu_has(c, X86_FEATURE_AUTOIBRS))
-		WARN_ON_ONCE(msr_set_bit(MSR_EFER, _EFER_AUTOIBRS));
+		WARN_ON_ONCE(msr_set_bit(MSR_EFER, _EFER_AUTOIBRS) < 0);
 
 	/* AMD CPUs don't need fencing after x2APIC/TSC_DEADLINE MSR writes. */
 	clear_cpu_cap(c, X86_FEATURE_APIC_MSRS_FENCE);
-- 
2.43.0



