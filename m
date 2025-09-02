Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632902DCF77;
	Tue,  2 Sep 2025 13:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819674; cv=none; b=rrSXZC9/8ZcgiEwHwcnvNpxEaXYz3wCMSD4acDZ3TY1LfVCL0rQMCbxX2c1QOxNec4I5S2dSpDMSFAIloV84/kKKoPN31wcJusyMCpFOMJcmj6NCUH/R7HBNr2Vsz8w3SXsf1/ZnN1tCRw9k2o9QUqkb7cjzbEyaY/VlJ9gWFmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819674; c=relaxed/simple;
	bh=Kv35xR0gPZHsro3atOc7Weprh++6//TLxo/FC5fDDug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUMdvjEVlDubeNYw3tGQUTzKV10LlnAavqTrXY4EkrAapyAIHheCPHC1WaXMIy66mPo0Mlr2u4acLNzxBFHBBPwNphQCYVNcIh81BcXxH1OW8yi02DdDR+fWnMUWfZkEN43oQ5aKhaPp85e36OvXsoVyQQ1h54iAyoLtSpq4mW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZJ3Yt1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZJ3Yt1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7671C4CEED;
	Tue,  2 Sep 2025 13:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819674;
	bh=Kv35xR0gPZHsro3atOc7Weprh++6//TLxo/FC5fDDug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZJ3Yt1HgE9LoYE8KAtwHVPNFvJOjCL3NruVWHROx+2bJOw7ahf0SezV+uMV4+BlQ
	 hxknGUsXfKJFtRw0Rni2hmJqQuqpZOLkcI/C760hvLCWi1dJNMjeygDKmV35sKtpOy
	 5ZRxQXqqI5MYwulsCdcAGH2ZNXcxjbmJ5bI5YzFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suchit Karunakaran <suchitkarunakaran@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sohil Mehta <sohil.mehta@intel.com>
Subject: [PATCH 6.16 106/142] x86/cpu/intel: Fix the constant_tsc model check for Pentium 4
Date: Tue,  2 Sep 2025 15:20:08 +0200
Message-ID: <20250902131952.341837071@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Suchit Karunakaran <suchitkarunakaran@gmail.com>

commit 24963ae1b0b6596dc36e352c18593800056251d8 upstream.

Pentium 4's which are INTEL_P4_PRESCOTT (model 0x03) and later have
a constant TSC. This was correctly captured until commit fadb6f569b10
("x86/cpu/intel: Limit the non-architectural constant_tsc model checks").

In that commit, an error was introduced while selecting the last P4
model (0x06) as the upper bound. Model 0x06 was transposed to
INTEL_P4_WILLAMETTE, which is just plain wrong. That was presumably a
simple typo, probably just copying and pasting the wrong P4 model.

Fix the constant TSC logic to cover all later P4 models. End at
INTEL_P4_CEDARMILL which accurately corresponds to the last P4 model.

Fixes: fadb6f569b10 ("x86/cpu/intel: Limit the non-architectural constant_tsc model checks")
Signed-off-by: Suchit Karunakaran <suchitkarunakaran@gmail.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250816065126.5000-1-suchitkarunakaran%40gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 076eaa41b8c8..98ae4c37c93e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -262,7 +262,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-	} else if ((c->x86_vfm >= INTEL_P4_PRESCOTT && c->x86_vfm <= INTEL_P4_WILLAMETTE) ||
+	} else if ((c->x86_vfm >= INTEL_P4_PRESCOTT && c->x86_vfm <= INTEL_P4_CEDARMILL) ||
 		   (c->x86_vfm >= INTEL_CORE_YONAH  && c->x86_vfm <= INTEL_IVYBRIDGE)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 	}
-- 
2.51.0



