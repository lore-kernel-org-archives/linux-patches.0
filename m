Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5698815E8B;
	Mon, 30 Dec 2024 15:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573983; cv=none; b=gTilqk8ZpIRZqZBe4wJTleE5LrQgy43AK7pNtFogTnT5ozkwjcCijTGPKzinxYLd6hm4U/kkHflaTyoztYK0KvXSnMD/YMZd6SWU1peEQFoMvlHQoDwcUbREL9hkRtrWcGLMBqB8lmT27/b46zMe0YX/acEdzq8XrfFyxZ8YhUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573983; c=relaxed/simple;
	bh=UKwlkDLuwRa4P8DvExBrWjl2cM/x0zFEaPAusYkRMrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7z0KWSM6EFsE2rcJswiV/KG32Lz6UhPtscxUhmZYdYvNYG+UDX4G+71RD+l6LTpmKQxU4KiUPpetcmUGk5c16EkLnPvhR7EIirgyXsSCJR7FmUhAWeQMK5UyXNZoSHq4PyTRb/gUZOz2QlFITpLMIULm2nyQBah1ZfATThS7rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CY5rb9Sl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CY5rb9Sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07F6C4CED0;
	Mon, 30 Dec 2024 15:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573983;
	bh=UKwlkDLuwRa4P8DvExBrWjl2cM/x0zFEaPAusYkRMrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CY5rb9Sl354Bq9y51S+1+6WlNEm6DOPAOPTaOubz5UMm1Jt5RILD9pA5ya6uXbnGp
	 WtwwFg7PNiIIZEQT/NshW3cZpodFC1XoyL4Tvnn8wsSsQOMqKhf6SSFxTWUdVU8ehV
	 Yqj0apkbaomGFP8IrCsv1Lz+pbDPk8x0iIA5L0pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 67/86] x86/cpu: Add Lunar Lake to list of CPUs with a broken MONITOR implementation
Date: Mon, 30 Dec 2024 16:43:15 +0100
Message-ID: <20241230154214.261926487@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit c9a4b55431e5220347881e148725bed69c84e037 ]

Under some conditions, MONITOR wakeups on Lunar Lake processors
can be lost, resulting in significant user-visible delays.

Add Lunar Lake to X86_BUG_MONITOR so that wake_up_idle_cpu()
always sends an IPI, avoiding this potential delay.

Reported originally here:

	https://bugzilla.kernel.org/show_bug.cgi?id=219364

[ dhansen: tweak subject ]

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/a4aa8842a3c3bfdb7fe9807710eef159cbf0e705.1731463305.git.len.brown%40intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 78f34ff32c9b..97259485c111 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -666,7 +666,9 @@ static void init_intel(struct cpuinfo_x86 *c)
 	     c->x86_vfm == INTEL_WESTMERE_EX))
 		set_cpu_bug(c, X86_BUG_CLFLUSH_MONITOR);
 
-	if (boot_cpu_has(X86_FEATURE_MWAIT) && c->x86_vfm == INTEL_ATOM_GOLDMONT)
+	if (boot_cpu_has(X86_FEATURE_MWAIT) &&
+	    (c->x86_vfm == INTEL_ATOM_GOLDMONT ||
+	     c->x86_vfm == INTEL_LUNARLAKE_M))
 		set_cpu_bug(c, X86_BUG_MONITOR);
 
 #ifdef CONFIG_X86_64
-- 
2.39.5



