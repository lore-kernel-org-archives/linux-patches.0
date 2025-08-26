Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B056434F49D;
	Tue, 26 Aug 2025 14:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216992; cv=none; b=ebyZXdZDVgq1Pj2dw1I3a9YKS2q2sXZKdpun45IuuqFj+jsnELGxyFp14DWnxS40XxrgXZJ//UZBC1he7e/A6gX3VF3sZaW6QSDibHtcKGmrIDIerVID4B8QNQFLuHTpgL4CImDwNYmtPq1qjYB0aiElVZppn4Azk/VDcprhxhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216992; c=relaxed/simple;
	bh=1NV3RSgeR7Kp9hoJNkyGXwpiajxI3hqjBRYZpxBlSlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0easFNHN4npHLH6fjniUJpYAJk/TQf5ML7OLb8N4zxozbi09OpiJGRyIaknNQsmTDlJYtOoOOqRtbNDY6BWKKOUAE0FZlP2XMznEoajUvBCnfCaUpjn48dceHeBifRJrjwOJ+d7INd2Igw6zJMao3O98xoyA3f1ee5AEB3DhN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAweuX2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAweuX2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445ABC19422;
	Tue, 26 Aug 2025 14:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216992;
	bh=1NV3RSgeR7Kp9hoJNkyGXwpiajxI3hqjBRYZpxBlSlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAweuX2V0jdK1G6wZWASJbIboPb8KHsZh1H4/hUzKte3ydirfzzgC/8Wmnm+D+BbJ
	 tYghxFom3RwhdAR3+DQIM+juY6dLU+FGuhja9soLfvNp1yQYMiPOx7hdvQup/aSeJC
	 mmEwRt+Y5zJtPX0tKAlTuoE67LxwugxccUR1MhfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianxiang Peng <txpeng@tencent.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Hui Li <caelli@tencent.com>,
	stable@kernel.org
Subject: [PATCH 5.15 619/644] x86/cpu/hygon: Add missing resctrl_cpu_detect() in bsp_init helper
Date: Tue, 26 Aug 2025 13:11:50 +0200
Message-ID: <20250826111001.894416321@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -14,6 +14,7 @@
 #include <asm/cacheinfo.h>
 #include <asm/spec-ctrl.h>
 #include <asm/delay.h>
+#include <asm/resctrl.h>
 
 #include "cpu.h"
 
@@ -239,6 +240,8 @@ static void bsp_init_hygon(struct cpuinf
 			x86_amd_ls_cfg_ssbd_mask = 1ULL << 10;
 		}
 	}
+
+	resctrl_cpu_detect(c);
 }
 
 static void early_init_hygon(struct cpuinfo_x86 *c)


