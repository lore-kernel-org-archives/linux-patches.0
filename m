Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAB02E7BBD;
	Tue,  2 Sep 2025 13:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819677; cv=none; b=ANdbb9Qgz7OIF178VJGPE7yLtlzHsfdj1DNxYiicSSmS71K8ErcsGrimjvL2n3c42efjPhf09r6KpmT2k4FkyfjCvLKbBXFddfgJHoXy/qayjceGG+YqFR+C9il/SCkBo66P7zAEqHnQrmWJClNzIMv7zHOcU/f/9IO3oKOduO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819677; c=relaxed/simple;
	bh=+Uivl8fizqZ7DSmSAGVw+8NbYu5w3onxACNzEmbY94w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qZeOiTHtodEr7OFboRhnirfSUOrsk/yfF0+A1EC86m3nxMFN9q5rHJbIH5I8bw/UWHoxH80SKvrgHIoT55qxWR6Tji73TBWpXkKYJYEKLrSrAhYpHZJOsich6EUMurBq26wbbH+85yXgIwizRVX5EOwLF5u54KKkXw3Dvw+OpFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNr3+KcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNr3+KcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3286FC4CEED;
	Tue,  2 Sep 2025 13:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819677;
	bh=+Uivl8fizqZ7DSmSAGVw+8NbYu5w3onxACNzEmbY94w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNr3+KcHwrVkRMGSBDHvH9cdhT5u+pOHli/9vgyGLM0OPsDoyRt92wunCDbHkIrK4
	 dmPRWjZCGtqCVBkn6NHstooCkqi0C9wo1B+T4fyRSjHBTwmS3AynODiF1Rax0aR+p6
	 0bYO7c4z97znnKPKywOwSg34VJAoh6zfbTXg7xJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?V=C3=ADtek=20V=C3=A1vra?= <vit.vavra.kh@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.16 107/142] x86/microcode/AMD: Handle the case of no BIOS microcode
Date: Tue,  2 Sep 2025 15:20:09 +0200
Message-ID: <20250902131952.379525029@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -171,8 +171,28 @@ static int cmp_id(const void *key, const
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
@@ -749,8 +769,6 @@ static struct ucode_patch *cache_find_pa
 	n.equiv_cpu = equiv_cpu;
 	n.patch_id  = uci->cpu_sig.rev;
 
-	WARN_ON_ONCE(!n.patch_id);
-
 	list_for_each_entry(p, &microcode_cache, plist)
 		if (patch_cpus_equivalent(p, &n, false))
 			return p;


