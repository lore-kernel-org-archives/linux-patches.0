Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8082210FB;
	Thu, 12 Dec 2024 15:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017877; cv=none; b=OmuI5oH03dBH8mjf6ZVoU9gOa79zZEOnqWuajqukk6GynDQNpMCnrbx5cyCRRQlMEs0r8uFYvnC1VxKwlj15Wyrd9oS1P0G6yXyJ5zYA7DZ1a0UlZr8lOwyUR7TUtmXxDfFHTjk8NMJcHUIpG9jxJ/oV1Y1BUNIimKLcZxa2oW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017877; c=relaxed/simple;
	bh=O+Z1pypRDeaiZEx7pkYSdExqq6P8IjgYRpcDE6dvFxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBH7v62dcmoNkP65vhju4JkcfeTjPBtfOA8+zvxpWYc1NvTd4wSu+NLT2w7BzXqzZheqErcxDq1MBYt+2o48ldDWGfDv/HfG+GWOgL7hH/7A0rzYOOGEtupMHn0ctCqXXN9hmmgOOSb762lrDVpkp98BIozoe3FNw34pEuY8Qws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDsNNARC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDsNNARC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73937C4CED7;
	Thu, 12 Dec 2024 15:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017876;
	bh=O+Z1pypRDeaiZEx7pkYSdExqq6P8IjgYRpcDE6dvFxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDsNNARCNJ4bMW9GzzbaNSRaz+PJT8SVFjPn2SZ37gz/cwxHX9NtxfEKOzsMDXg4Z
	 l3gPawf7OpnE5nQz8wAT+DJoGpMHoiB0QVxjJnnN3NC8rEvQY/DDETs8PWTbj39a0F
	 Z9DwVM+djuNkNZR/Ri2FdIJKNk/QRDj8rK9bM8dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/356] x86/CPU/AMD: WARN when setting EFER.AUTOIBRS if and only if the WRMSR fails
Date: Thu, 12 Dec 2024 15:57:36 +0100
Message-ID: <20241212144250.056404154@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 145c81c68394b..9413fb767c6a7 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1205,7 +1205,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 	 */
 	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled) &&
 	    cpu_has(c, X86_FEATURE_AUTOIBRS))
-		WARN_ON_ONCE(msr_set_bit(MSR_EFER, _EFER_AUTOIBRS));
+		WARN_ON_ONCE(msr_set_bit(MSR_EFER, _EFER_AUTOIBRS) < 0);
 
 	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) &&
 	     cpu_has_amd_erratum(c, amd_erratum_1485))
-- 
2.43.0



