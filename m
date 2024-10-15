Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB73E1C07FF;
	Tue, 15 Oct 2024 13:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997533; cv=none; b=o2AmMvFhIkyyptiCcUok16DPKh1TT0VjVnxCNjIywvZQLw0jNFD9gc7gvWgP+3TK7PWKX18nZ7515m73zqHf9MYKJlIg9fvvwP84TO/gaBNv0IrB5OqQWTukh1takQALsOVe+lHpNVigZUMQxzq+8ujtZ47ArHCIwmi/dOCcV2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997533; c=relaxed/simple;
	bh=K6sVb9CE3BKTpxsiygy56jcqSTlx9GFADwZ1/dmssxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4usu7C5Vy+VAaTUwoCI/C9PQgfqNr9jWkLRHU7QtLzRS1iFRKw78RKQYw/BjO+R8JLRdhQ9h0vrdygcVW0/kZ8SdlvEDOsgXowUB4jBrAyiTcVWI1ulfik9pXapffNgO9EzGfe8S2lU4JlcQZ1/rPjv1iGMNRh0RN6bFfavRdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtsvSaHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtsvSaHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40697C4CECF;
	Tue, 15 Oct 2024 13:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997532;
	bh=K6sVb9CE3BKTpxsiygy56jcqSTlx9GFADwZ1/dmssxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtsvSaHijOXsEGPO8Mi8MFxvIzhFQr8gdG+p+BxBJaLnhtLkujndWIwi4DgaGxSOO
	 4wWhs7KG3wgF2SRxbR9+J+PP+6BGaLpvTWdnWZOAW3Av7Ak4Gxb6O93O3jQWqdHSc+
	 mOvWJi6S3qQIS7br1rf2IkrLnttMoFr6HoGf2/CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 5.10 211/518] x86/mm: Switch to new Intel CPU model defines
Date: Tue, 15 Oct 2024 14:41:55 +0200
Message-ID: <20241015123925.136181052@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
@@ -257,21 +257,17 @@ static void __init probe_page_size_mask(
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
 


