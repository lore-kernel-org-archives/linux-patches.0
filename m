Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9107A14600E;
	Thu, 11 Apr 2024 10:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831924; cv=none; b=PKhkzq/R8XaByl11jgpFFfH029+wKBH/bQebD/Cm+tsk1Xu+0r31VR2cJsS+sCpE4mpW2QMh4X3LrDRNvcXLSfKTyFyR7gm1hkA5SrPft6RzJalYpleg9YVhgEpifDYDAkwTPrBfaexbWXP0Em/ZU4azLSC58Qp1IpYuAyWFqek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831924; c=relaxed/simple;
	bh=zBRd/BH4VcFknQ3OomHU1llbz7OJH24X+6QCHiHAgf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0KaE6ZuqXyGyyfSFiBjZ61XHMf/H8XNoFFd8daQsIfOhcp6GR6xiEU4L1R0RChRojq1NAgksT7mhaJj8cbkdRGADNqwLhauDN0PvGuqRa6V660na/SxdyWSIzSv1x5trV0GdpRNreKAGkwyHdUfq7tsIsPnvlkG2yxPmLaZ6B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDGkkeiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDGkkeiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EA3C433F1;
	Thu, 11 Apr 2024 10:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831924;
	bh=zBRd/BH4VcFknQ3OomHU1llbz7OJH24X+6QCHiHAgf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDGkkeiJtJU6QOWq1KKM3NzyBpN60c9hGfXRyLb4ukn9xLjpUQqczl/DHZZxhuDLw
	 EoAY4rexnAFpdYb5TxRYCxMIcEwE3+MmNLvPEhUT7sLwjeDvL6qqx+yzEA3IbwIBqk
	 Kriqo0DQ59Nd23qynEARjiTec1t0YvdrbO+qY4Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.10 145/294] x86/mmio: Disable KVM mitigation when X86_FEATURE_CLEAR_CPU_BUF is set
Date: Thu, 11 Apr 2024 11:55:08 +0200
Message-ID: <20240411095440.019256621@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit e95df4ec0c0c9791941f112db699fae794b9862a upstream.

Currently MMIO Stale Data mitigation for CPUs not affected by MDS/TAA is
to only deploy VERW at VMentry by enabling mmio_stale_data_clear static
branch. No mitigation is needed for kernel->user transitions. If such
CPUs are also affected by RFDS, its mitigation may set
X86_FEATURE_CLEAR_CPU_BUF to deploy VERW at kernel->user and VMentry.
This could result in duplicate VERW at VMentry.

Fix this by disabling mmio_stale_data_clear static branch when
X86_FEATURE_CLEAR_CPU_BUF is enabled.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -419,6 +419,13 @@ static void __init mmio_select_mitigatio
 	if (boot_cpu_has_bug(X86_BUG_MDS) || (boot_cpu_has_bug(X86_BUG_TAA) &&
 					      boot_cpu_has(X86_FEATURE_RTM)))
 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
+
+	/*
+	 * X86_FEATURE_CLEAR_CPU_BUF could be enabled by other VERW based
+	 * mitigations, disable KVM-only mitigation in that case.
+	 */
+	if (boot_cpu_has(X86_FEATURE_CLEAR_CPU_BUF))
+		static_branch_disable(&mmio_stale_data_clear);
 	else
 		static_branch_enable(&mmio_stale_data_clear);
 
@@ -495,8 +502,11 @@ static void __init md_clear_update_mitig
 		taa_mitigation = TAA_MITIGATION_VERW;
 		taa_select_mitigation();
 	}
-	if (mmio_mitigation == MMIO_MITIGATION_OFF &&
-	    boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA)) {
+	/*
+	 * MMIO_MITIGATION_OFF is not checked here so that mmio_stale_data_clear
+	 * gets updated correctly as per X86_FEATURE_CLEAR_CPU_BUF state.
+	 */
+	if (boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA)) {
 		mmio_mitigation = MMIO_MITIGATION_VERW;
 		mmio_select_mitigation();
 	}


