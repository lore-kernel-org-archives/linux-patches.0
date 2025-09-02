Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8405231DD91;
	Tue,  2 Sep 2025 13:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820123; cv=none; b=VHuUlkz0+WF9TA6Jad+O26R/QFb++sbXW8RnQO/0tmRYo9bqgdWsPjof3O0xGy9nBNQpbzxfnAsgv0u2nC3CT+7rkCFClkz/Mcq+o2EsfVR/orqyOhsrxk+56+du5IVQO3UHdm1WM4/F9XO7EN6i8lRrHt2YLsN1Z3GyokrWV24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820123; c=relaxed/simple;
	bh=2llmchCwa1HtUk93OV5d5BomCTkpOl8uzeFWuc7U6m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rdIWvt4RlOylCCeJwhYJaihe6CKAjmGOmBpLzBBaU8Fe8PtQWxNS5NALldlNXnaBH7g0VBx6RImvPSovsGwBkzjiyozWmHPfPV/SwinK//V0q006a49NMJn8j/BjNAbn5PftKfki/tU6mvlOGfcGjdH7DprRS6POLYva1OhGnYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ui9YLr6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ui9YLr6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBD1C4CEED;
	Tue,  2 Sep 2025 13:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820123;
	bh=2llmchCwa1HtUk93OV5d5BomCTkpOl8uzeFWuc7U6m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ui9YLr6BXXQD7z2NezQa2zKZZFGl6PuCDjICZozIfKNUCe9kHeHC3ocK1otmxXFoQ
	 wk/PvHU7BGCCoa5q2PmnsL0vIFylT7bsCr3Ax7tr54tzVgrEzEc/LoKfVZRrIBqsV2
	 bWSKjr2V5KLez5rCDgPAmPMe/sn/lw4ANh4xJS/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?V=C3=ADtek=20V=C3=A1vra?= <vit.vavra.kh@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.12 69/95] x86/microcode/AMD: Handle the case of no BIOS microcode
Date: Tue,  2 Sep 2025 15:20:45 +0200
Message-ID: <20250902131942.250686632@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -159,8 +159,28 @@ static int cmp_id(const void *key, const
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
@@ -741,8 +761,6 @@ static struct ucode_patch *cache_find_pa
 	n.equiv_cpu = equiv_cpu;
 	n.patch_id  = uci->cpu_sig.rev;
 
-	WARN_ON_ONCE(!n.patch_id);
-
 	list_for_each_entry(p, &microcode_cache, plist)
 		if (patch_cpus_equivalent(p, &n, false))
 			return p;


