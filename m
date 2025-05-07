Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7124414A4C7;
	Wed,  7 May 2025 18:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643497; cv=none; b=Kx5zXDPk/zju7QSger8XtSlGRp/ByJ+vCEFejh6F9rJfiKCGUQTR4oETJnOx+2rTd5k6VD9FxbB2B/lPDRDiasFKT6YYlYG/c0CKOZA+dItsBFwHeJ0ki33TF6GOAVMBgGn4QQytrh83cscJWizTj01p8pbsNEA0mZrl6geFHZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643497; c=relaxed/simple;
	bh=J3X+MJ3yqwlaOeiKaqAIvlG85wpvZDjoe+PqP91/AsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejoo4VP/fpsZNjwFbEhQAjzc5PleUU89da7nEvh/kgKyQDUnzFCG6Hkd4A1WIJUMSi1ujHCVw/VdhztyaxpEEsqId+FjZTUa9ZAFPXkbD+AHUk1TogiH0HZH6RmfVTG6Yl7ZDVhdNwLKOKk+VpXhzYkA/Ai94Cl3r7/nX+HZuFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVI827RP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVI827RP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF40FC4CEE2;
	Wed,  7 May 2025 18:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643497;
	bh=J3X+MJ3yqwlaOeiKaqAIvlG85wpvZDjoe+PqP91/AsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVI827RPqK+XpHv5w0yaf4YQ5wu31K2S1iUwfDw5PNnDzJFLSqON+b2EdAR/O86L+
	 bvkGnwj4Gtpu2cNRkNK64ahi4PE4NfJhyGgnvIIaKmLXLC+xc7qjgEtasrft09fBHy
	 vOy2YSdsZ7+fMkC7oN8VEAxI4RZI4szziK1nmbkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	James Morse <james.morse@arm.com>,
	Doug Anderson <dianders@chromium.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 07/97] arm64: errata: Add missing sentinels to Spectre-BHB MIDR arrays
Date: Wed,  7 May 2025 20:38:42 +0200
Message-ID: <20250507183807.291872804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

commit fee4d171451c1ad9e8aaf65fc0ab7d143a33bd72 upstream.

Commit a5951389e58d ("arm64: errata: Add newer ARM cores to the
spectre_bhb_loop_affected() lists") added some additional CPUs to the
Spectre-BHB workaround, including some new arrays for designs that
require new 'k' values for the workaround to be effective.

Unfortunately, the new arrays omitted the sentinel entry and so
is_midr_in_range_list() will walk off the end when it doesn't find a
match. With UBSAN enabled, this leads to a crash during boot when
is_midr_in_range_list() is inlined (which was more common prior to
c8c2647e69be ("arm64: Make  _midr_in_range_list() an exported
function")):

 |  Internal error: aarch64 BRK: 00000000f2000001 [#1] PREEMPT SMP
 |  pstate: 804000c5 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 |  pc : spectre_bhb_loop_affected+0x28/0x30
 |  lr : is_spectre_bhb_affected+0x170/0x190
 | [...]
 |  Call trace:
 |   spectre_bhb_loop_affected+0x28/0x30
 |   update_cpu_capabilities+0xc0/0x184
 |   init_cpu_features+0x188/0x1a4
 |   cpuinfo_store_boot_cpu+0x4c/0x60
 |   smp_prepare_boot_cpu+0x38/0x54
 |   start_kernel+0x8c/0x478
 |   __primary_switched+0xc8/0xd4
 |  Code: 6b09011f 54000061 52801080 d65f03c0 (d4200020)
 |  ---[ end trace 0000000000000000 ]---
 |  Kernel panic - not syncing: aarch64 BRK: Fatal exception

Add the missing sentinel entries.

Cc: Lee Jones <lee@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: <stable@vger.kernel.org>
Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: a5951389e58d ("arm64: errata: Add newer ARM cores to the spectre_bhb_loop_affected() lists")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Lee Jones <lee@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20250501104747.28431-1-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/proton-pack.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -891,10 +891,12 @@ static u8 spectre_bhb_loop_affected(void
 	static const struct midr_range spectre_bhb_k132_list[] = {
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_X3),
 		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V2),
+		{},
 	};
 	static const struct midr_range spectre_bhb_k38_list[] = {
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A715),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A720),
+		{},
 	};
 	static const struct midr_range spectre_bhb_k32_list[] = {
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A78),


