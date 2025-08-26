Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C3C1FECAB;
	Tue, 26 Aug 2025 11:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208801; cv=none; b=JP7Fb5mRr0kjcfj0GbQH+CyLT/85JR4nmlgDEduwHwZVbxy/qUD4jOU0UVCUWMTsHYhLfsDCcvHDCLO8N2+ggLkTCATUj+LzXd7ADE+B97v4j3EAZkUKYol7cq7jOISF/NYBaN4UzavgYK5UreXkUVgdz7kSZ0q8dyT0QoUCWf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208801; c=relaxed/simple;
	bh=7fLRG5FYxnYQU91J9DfDgvnZocFixz91ni1EsEyDF/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jhfny1yZTJG+S+nK1sy0uFsUL/Y1ZeNqECHfWvXIQt9BXvaj1hTBpsc3J0StW2Wip+K8qm8djAIN0A51pdE7oYOa3d1z66s19JhyX6DAsWR67xWWilh+v48nDO27evsRfgQ7vEXuef+uL9Jn82mhxTP+EgVyhwRmhnap1mVx3N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRQ55H6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRQ55H6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ABAC113CF;
	Tue, 26 Aug 2025 11:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208800;
	bh=7fLRG5FYxnYQU91J9DfDgvnZocFixz91ni1EsEyDF/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRQ55H6GOZJca8d3oqETCw3XhFLLnPtc7LlmfQ3RH0ec2YQIXmEpPkrFJlXD83c4+
	 rIBSmnl8cf126vy1u5Im926GdsU7O7GUlNsBb6doUhpBW3XVQ3eS4BXtI6cI0hEB+8
	 4ahpKuWa2KPALf1CQCXDiuqzFs6VlbL0V9kD9zzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianxiang Peng <txpeng@tencent.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Hui Li <caelli@tencent.com>,
	stable@kernel.org
Subject: [PATCH 6.12 251/322] x86/cpu/hygon: Add missing resctrl_cpu_detect() in bsp_init helper
Date: Tue, 26 Aug 2025 13:11:06 +0200
Message-ID: <20250826110922.127304928@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Tianxiang Peng <txpeng@tencent.com>

commit d8df126349dad855cdfedd6bbf315bad2e901c2f upstream.

Since

  923f3a2b48bd ("x86/resctrl: Query LLC monitoring properties once during boot")

resctrl_cpu_detect() has been moved from common CPU initialization code to
the vendor-specific BSP init helper, while Hygon didn't put that call in their
code.

This triggers a division by zero fault during early booting stage on our
machines with X86_FEATURE_CQM* supported, where get_rdt_mon_resources() tries
to calculate mon_l3_config with uninitialized boot_cpu_data.x86_cache_occ_scale.

Add the missing resctrl_cpu_detect() in the Hygon BSP init helper.

  [ bp: Massage commit message. ]

Fixes: 923f3a2b48bd ("x86/resctrl: Query LLC monitoring properties once during boot")
Signed-off-by: Tianxiang Peng <txpeng@tencent.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Hui Li <caelli@tencent.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/20250623093153.3016937-1-txpeng@tencent.com
Signed-off-by: Tianxiang Peng <txpeng@tencent.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/hygon.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -15,6 +15,7 @@
 #include <asm/cacheinfo.h>
 #include <asm/spec-ctrl.h>
 #include <asm/delay.h>
+#include <asm/resctrl.h>
 
 #include "cpu.h"
 
@@ -116,6 +117,8 @@ static void bsp_init_hygon(struct cpuinf
 			x86_amd_ls_cfg_ssbd_mask = 1ULL << 10;
 		}
 	}
+
+	resctrl_cpu_detect(c);
 }
 
 static void early_init_hygon(struct cpuinfo_x86 *c)


