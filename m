Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63831308F1D;
	Tue,  2 Sep 2025 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820288; cv=none; b=ACPXQVaAMF2/jBl5DxMtazgKEbVbGFvFV8jqCPO25EmkPzysl0FLtbhZMdMuB+pyGiXM7FssIB5OLDOjH06qD6LRakAjjfLutVxF0ftYn0jVFxYrKHyGofMidGXbpoww919OuOG2104cBxWIM6mKU5T/7jEOcUSeaZXlAIIVKkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820288; c=relaxed/simple;
	bh=BQ43NkToucFLLRAP/Y4IyxBQivyHyth6LWDKAdYIyoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HfjKmrKueHvDTUK3/e1I/mu2hiALgpIj0NCnSXwNdRUr5i+Xu5weQw9yJX9gjgorzYmxcmPyWTctccbcPGpGOYS09Kcc2wP/z8i/hSY/UZPxRowZ7ltAc6jWHCj2bCLIB8aDKM2hhLdaNDbarglHgdXOHjGxoWeG6OOMJfovovo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzSlRMBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzSlRMBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBC3C4CEED;
	Tue,  2 Sep 2025 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820288;
	bh=BQ43NkToucFLLRAP/Y4IyxBQivyHyth6LWDKAdYIyoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzSlRMBwp544RIRXdaB5COs01rOjTOiPEG2A8l29+Pb4Bqr3T6v7p0BboT0kXr81P
	 lAScU+BSN/VRlNNgVqVM3cyEzjrwIxCvyOoRHWJ/9F93aQz5397ug+fQ46OXunJjPO
	 EBlo3c/vuYR1ZlfcHmdj0wXneZpXcXBB5OjLtgcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?V=C3=ADtek=20V=C3=A1vra?= <vit.vavra.kh@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.6 57/75] x86/microcode/AMD: Handle the case of no BIOS microcode
Date: Tue,  2 Sep 2025 15:21:09 +0200
Message-ID: <20250902131937.354704854@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit fcf8239ad6a5de54fa7ce18e464c6b5951b982cb upstream.

Machines can be shipped without any microcode in the BIOS. Which means,
the microcode patch revision is 0.

Handle that gracefully.

Fixes: 94838d230a6c ("x86/microcode/AMD: Use the family,model,stepping encoded in the patch ID")
Reported-by: Vítek Vávra <vit.vavra.kh@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -161,8 +161,28 @@ static int cmp_id(const void *key, const
 		return 1;
 }
 
+static u32 cpuid_to_ucode_rev(unsigned int val)
+{
+	union zen_patch_rev p = {};
+	union cpuid_1_eax c;
+
+	c.full = val;
+
+	p.stepping  = c.stepping;
+	p.model     = c.model;
+	p.ext_model = c.ext_model;
+	p.ext_fam   = c.ext_fam;
+
+	return p.ucode_rev;
+}
+
 static bool need_sha_check(u32 cur_rev)
 {
+	if (!cur_rev) {
+		cur_rev = cpuid_to_ucode_rev(bsp_cpuid_1_eax);
+		pr_info_once("No current revision, generating the lowest one: 0x%x\n", cur_rev);
+	}
+
 	switch (cur_rev >> 8) {
 	case 0x80012: return cur_rev <= 0x800126f; break;
 	case 0x80082: return cur_rev <= 0x800820f; break;
@@ -744,8 +764,6 @@ static struct ucode_patch *cache_find_pa
 	n.equiv_cpu = equiv_cpu;
 	n.patch_id  = uci->cpu_sig.rev;
 
-	WARN_ON_ONCE(!n.patch_id);
-
 	list_for_each_entry(p, &microcode_cache, plist)
 		if (patch_cpus_equivalent(p, &n, false))
 			return p;


