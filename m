Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC001CFEA9;
	Tue, 15 Oct 2024 11:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993073; cv=none; b=eN5qbMaC2ZoTvwDE/aId6iWz46bZvm4YGTTgWWMaYBl6wpBsQeQdZcnXOAiYwFVchTAjMt7324pUS8EjO4X1X9J9hOJjkV4438mmgeUCtKLlFmx62fDj3FtLv41LedDOmwYwWdVnlE1tl+egXxIiRORnZ8BllkCpRhnu73gwz/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993073; c=relaxed/simple;
	bh=6OZSnKzuMNI9r6/yz7fPhEGb4k4F3yaqr1lC/n6azWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgufEjQIQoM9nfSW0fcyaInfWgBRcUvdaKddq4vcbaNtP9erhG4gJc5ETD5iYefV6qhKfsjFYHry3YfHTwEFXATJuxq43fM3EV4Rh+UsDBLtLWz4qe/xrfbw3WHaE1fWVKmfSF1M7pLmlzxZbWtXrSkyv+jj/Yahyc5qSDOVE2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GStDipRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GStDipRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F76FC4CEC6;
	Tue, 15 Oct 2024 11:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993072;
	bh=6OZSnKzuMNI9r6/yz7fPhEGb4k4F3yaqr1lC/n6azWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GStDipRmceblrNigVcatVWQBb/TcM+MGSamWzjhC48neBi4A6Ix+9i5WW+3pkzDaK
	 MNN+akflR1KpzBWhDxSq8BP+aD+5KZPhLIrh8xBmf69fd/8VeVANRnCiCp2FT5e5as
	 iDXntx1cd1P9Qc6sPFS1/73ZxNALO5A2j8HDdWdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 5.15 302/691] x86/mm: Switch to new Intel CPU model defines
Date: Tue, 15 Oct 2024 13:24:10 +0200
Message-ID: <20241015112452.328974782@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/init.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -263,21 +263,17 @@ static void __init probe_page_size_mask(
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
 


