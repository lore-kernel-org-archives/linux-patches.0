Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36301CFEA9;
	Tue, 15 Oct 2024 11:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993069; cv=none; b=QqOE+1nxJXiypW+PViDtGjEfpyGh/Y1HYgYiGm201F1TShQR+djQdsHsgP55yJjLy/YxjO0EzMaeN7jr9mu0poqrXAknDSdoE9Ae3/AHcAjEpaDBiI9tHTA4IQo6xFENSp/Nmv2HoLhiEI4TshZVhETP/IYYaUPB8mYrgxueKkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993069; c=relaxed/simple;
	bh=USzylqLxUMWyapN/SC6FD7nl5sfHKAza5iO2tLbyyQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQGZljIczIJ5nsWB7IDRoDIAYC2n0J0LkG0Aq7VlUnziowsIXdFDbwdwwV4cNMj12CgG916VC0JyQS9/LueA5cb52d8Oemyy/yq+8MnYnAXBesjphSFO0CWpww0ppnnT9lZJ5SguNTwAGxVT95yBzmnhFNndSVwfcza9kP0lbZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXViQaUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXViQaUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E013AC4CEC6;
	Tue, 15 Oct 2024 11:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993069;
	bh=USzylqLxUMWyapN/SC6FD7nl5sfHKAza5iO2tLbyyQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXViQaUHMbmOaYnNgNFEzXtkfRzn2OFbioohoj1DIExSLuHFj2VykAN7Dik+S4X/n
	 YloVMyQzMpuV2nrXP0F6FGxZeX0qUaiFRsltUS0B7TKet6GKgKsS32Sni1rctANSZm
	 VzDj+qlz6wlp9ZrslJ6LEi+80ZZixgnnEYVsdAmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@intel.com>,
	Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 5.15 301/691] powercap: RAPL: fix invalid initialization for pl4_supported field
Date: Tue, 15 Oct 2024 13:24:09 +0200
Message-ID: <20241015112452.289507789@linuxfoundation.org>
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

From: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>

commit d05b5e0baf424c8c4b4709ac11f66ab726c8deaf upstream.

The current initialization of the struct x86_cpu_id via
pl4_support_ids[] is partial and wrong. It is initializing
"stepping" field with "X86_FEATURE_ANY" instead of "feature" field.

Use X86_MATCH_INTEL_FAM6_MODEL macro instead of initializing
each field of the struct x86_cpu_id for pl4_supported list of CPUs.
This X86_MATCH_INTEL_FAM6_MODEL macro internally uses another macro
X86_MATCH_VENDOR_FAM_MODEL_FEATURE for X86 based CPU matching with
appropriate initialized values.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Link: https://lore.kernel.org/lkml/28ead36b-2d9e-1a36-6f4e-04684e420260@intel.com
Fixes: eb52bc2ae5b8 ("powercap: RAPL: Add Power Limit4 support for Meteor Lake SoC")
Fixes: b08b95cf30f5 ("powercap: RAPL: Add Power Limit4 support for Alder Lake-N and Raptor Lake-P")
Fixes: 515755906921 ("powercap: RAPL: Add Power Limit4 support for RaptorLake")
Fixes: 1cc5b9a411e4 ("powercap: Add Power Limit4 support for Alder Lake SoC")
Fixes: 8365a898fe53 ("powercap: Add Power Limit4 support")
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ Ricardo: I only kept TIGERLAKE, ALDERLAKE, and ALDERLAKE_L in
  pl4_support_ids as only these models are enumerated before this
  changeset. ]
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/powercap/intel_rapl_msr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -136,9 +136,9 @@ static int rapl_msr_write_raw(int cpu, s
 
 /* List of verified CPUs. */
 static const struct x86_cpu_id pl4_support_ids[] = {
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_TIGERLAKE_L, X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_ALDERLAKE, X86_FEATURE_ANY },
-	{ X86_VENDOR_INTEL, 6, INTEL_FAM6_ALDERLAKE_L, X86_FEATURE_ANY },
+	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L, NULL),
 	{}
 };
 


