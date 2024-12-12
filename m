Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFF1212D6A;
	Thu, 12 Dec 2024 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016515; cv=none; b=iMLwdI1dPWJThXchg00RtcaHVAXPoqMnKBuxUEOAxDPN+wujNH1kZDe7Sm6A4CgGX/YNJRC00LqWNRH2IMqQ7W89sn8WRRf389Aj26OfVqNiY3xLa7dGZv21y7YWRAvmJT/cthz9W5Qm5iBZ1R7a52rPxiMtdimn2vBZqHmr/us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016515; c=relaxed/simple;
	bh=3ljR3H2VnuxQyp5T4zHF+YTSvDxMv+XGY9QUVF39xqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RisYdLekYVngJ8qSU2kaezhZgp0SZM9x+uftcoSKtYIQgVQ7chGhF4CM7J/QsA+9K4vEN9N4ibjEr9iz+nppOeWXOyJBTeTmJmG9Js0TSDlT2N0+Prbju8dYfcAqb32yjNI0RnVX5liQmpdnb297YKxmnOAjm5akfonuE/Equ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNfl+yH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNfl+yH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BE9C4CED4;
	Thu, 12 Dec 2024 15:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016515;
	bh=3ljR3H2VnuxQyp5T4zHF+YTSvDxMv+XGY9QUVF39xqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNfl+yH8FXncpPKm5abImr1PsF/aiYiFO3elq+alFGaj1Dx8gLTXHDNPUmhaB4t53
	 7vfjxXK0goKeAo2+VRkUEcLJiTG1ohl2HVIqi6KYL0zVzgIP3FtExG2ipmoLwemjeg
	 spSvpo+DyTS9FbAurqoJ7lM7bauNFPG+cf981XxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 193/466] x86/cpu: Add Lunar Lake to list of CPUs with a broken MONITOR implementation
Date: Thu, 12 Dec 2024 15:56:02 +0100
Message-ID: <20241212144314.419843609@linuxfoundation.org>
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

From: Len Brown <len.brown@intel.com>

commit c9a4b55431e5220347881e148725bed69c84e037 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/intel.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -586,7 +586,9 @@ static void init_intel(struct cpuinfo_x8
 	     c->x86_vfm == INTEL_WESTMERE_EX))
 		set_cpu_bug(c, X86_BUG_CLFLUSH_MONITOR);
 
-	if (boot_cpu_has(X86_FEATURE_MWAIT) && c->x86_vfm == INTEL_ATOM_GOLDMONT)
+	if (boot_cpu_has(X86_FEATURE_MWAIT) &&
+	    (c->x86_vfm == INTEL_ATOM_GOLDMONT ||
+	     c->x86_vfm == INTEL_LUNARLAKE_M))
 		set_cpu_bug(c, X86_BUG_MONITOR);
 
 #ifdef CONFIG_X86_64


