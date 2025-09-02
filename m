Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371A5304BA0;
	Tue,  2 Sep 2025 13:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820677; cv=none; b=LyhuFc8W+pjr/8KlSmSbvhIOtqyErctj6MEEHiD7pbEzpVX1AAVEmSPLjti4kdc+CPeuEv3Rb2vDNNux9VTcHZcV8odmMPt5n2F5AdjBVMdivDyCbTId+4dXefP3MX8mI69lHd99Mt5qbV4d/EUyVebxXK1vukA2rNhyP9tPdYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820677; c=relaxed/simple;
	bh=xQ2ic1a67TLQWtfezJ7azFRE6xd5Sy2dtQ/aqlymsns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1GckgSOgZz10iV//tUJQKov+4IKXu7bEy4VeJ5Crz83UC076SW+x8kEI0Q29Enhl0nj+D9XGyyTO8S7iEkvbHzGMh+smzCL8nwkI1O7BEozHD7p7SpuDMBBHzqay/fBWeYJ6LhegSHIWrzjTsrv5GoXCQR1QBzcLs7mY8XKgL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3cKBKhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3cKBKhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD5AC4CEED;
	Tue,  2 Sep 2025 13:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820677;
	bh=xQ2ic1a67TLQWtfezJ7azFRE6xd5Sy2dtQ/aqlymsns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3cKBKhAZWgww4Id1O3Vw7OuJzZGmIvb2jZhYgNcCmLW++MOyYsdp/Tkx79brrddd
	 bqmwox3sdu2i2lZrR+vWMRZVD0JsY2i3fhz4kPgLTmkPAwGsD4bllv6bJFY1XbyiyN
	 w+DA1fxYRsoypQa8CrGHFlD9gld9+vH61jbCNrNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianxiang Peng <txpeng@tencent.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Hui Li <caelli@tencent.com>,
	stable@kernel.org
Subject: [PATCH 5.10 04/34] x86/cpu/hygon: Add missing resctrl_cpu_detect() in bsp_init helper
Date: Tue,  2 Sep 2025 15:21:30 +0200
Message-ID: <20250902131926.788829104@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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
@@ -17,6 +17,7 @@
 #ifdef CONFIG_X86_64
 # include <asm/set_memory.h>
 #endif
+#include <asm/resctrl.h>
 
 #include "cpu.h"
 
@@ -259,6 +260,8 @@ static void bsp_init_hygon(struct cpuinf
 			x86_amd_ls_cfg_ssbd_mask = 1ULL << 10;
 		}
 	}
+
+	resctrl_cpu_detect(c);
 }
 
 static void early_init_hygon(struct cpuinfo_x86 *c)


