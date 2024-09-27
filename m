Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439891E507;
	Fri, 27 Sep 2024 12:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440406; cv=none; b=uQHD2Mn5bYU7AMsjeNecEIXy7Xu6hZ306YmluNR2xbfvDPfXiT3RohJmP8nFj5MFZeMfev55dqF9dvYI6VmSz5WpGe+p7c7jSref2JCfhyMaHQAiBHZPRlfYwLFtm99tVkOidFmHB40HvQY7KVa/J5GRhvA3ovkm1QXRm1Oll2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440406; c=relaxed/simple;
	bh=f3Nks2Pyn5hFwqnjLqhvt6ALQG4XNy31j8PN6kgJ7aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXd3BPhrtipMBRjwgj/OZJG/QNBfCouL+HQepYA0junvWey8FMVwnPdH1ytkFBZXEdunGf6zRUobETNySssD2svuPOOfe8E/U34FfV9AT0V7eRIFA30lPhUIYFwt+VWKfjZ2u5oWfOPjKi6kkY8kHV/loQFq76eabsNOKD1NEek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZxMg/l1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZxMg/l1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B1CC4CEC4;
	Fri, 27 Sep 2024 12:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440405;
	bh=f3Nks2Pyn5hFwqnjLqhvt6ALQG4XNy31j8PN6kgJ7aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZxMg/l1Lx/JP8prVEyHE84U+VcMC1WP2KP8AZtKcY/uTGQ2rZ0KWZmCjzMGPhysd
	 gXv6VR0cptVWE7QyFy1qcjRo30iCP+8RZZ3o8AM4XZl5C6u1vpy0iJhd5OICzayO/N
	 kKk8t6sPk1G5lo9ttBaFM6VNCF4G71dEJPP2Rwx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 6.1 71/73] x86/mm: Switch to new Intel CPU model defines
Date: Fri, 27 Sep 2024 14:24:22 +0200
Message-ID: <20240927121722.696734740@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit 2eda374e883ad297bd9fe575a16c1dc850346075 upstream.

New CPU #defines encode vendor and family as well as model.

[ dhansen: vertically align 0's in invlpg_miss_ids[] ]

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/all/20240424181518.41946-1-tony.luck%40intel.com
[ Ricardo: I used the old match macro X86_MATCH_INTEL_FAM6_MODEL()
  instead of X86_MATCH_VFM() as in the upstream commit.
  I also kept the ALDERLAKE_N name instead of ATOM_GRACEMONT. Both refer
  to the same CPU model. ]
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/init.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -262,21 +262,17 @@ static void __init probe_page_size_mask(
 	}
 }
 
-#define INTEL_MATCH(_model) { .vendor  = X86_VENDOR_INTEL,	\
-			      .family  = 6,			\
-			      .model = _model,			\
-			    }
 /*
  * INVLPG may not properly flush Global entries
  * on these CPUs when PCIDs are enabled.
  */
 static const struct x86_cpu_id invlpg_miss_ids[] = {
-	INTEL_MATCH(INTEL_FAM6_ALDERLAKE   ),
-	INTEL_MATCH(INTEL_FAM6_ALDERLAKE_L ),
-	INTEL_MATCH(INTEL_FAM6_ALDERLAKE_N ),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE  ),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE_P),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE_S),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,      0),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,    0),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_N,    0),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,     0),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,   0),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,   0),
 	{}
 };
 


