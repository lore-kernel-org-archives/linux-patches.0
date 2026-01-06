Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C6F357715;
	Tue,  6 Jan 2026 17:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721533; cv=none; b=YQhO5MuGDA5tgaqMlZlw7bfgtJEEoQPa76C6H1WESpXY7x+yLiphpdeCNwv4gSmxtxFQqogREm7zecyRqqMUyuztVqjDaOsVzAARCvHUBvhHr2na0Be+RXNinIXIwTsILuHO8cnOwcom8i5CSB5iOQ6STvObnc4CUv8kLeUEdBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721533; c=relaxed/simple;
	bh=OryrbP5bn7SZvic1a1ew20hVsW7gNY2j5fdw9Emw1K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omEofXqzgsyxrjiCHdaFvebq0I2OBuwwbVkz0icAQwsaYpCySf6ad19gpEEO/6WeLERXYvH/U/rpmVCEp0iY6sB/dhZrzd84ekzHomEiIc/meIMe1gCGNmTDAK3Tou9ujETB+ssiSVp2Xd+7YdpWcCN0KaORcK8ywAZDFrYhiF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lu/lFy//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lu/lFy//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8E5C16AAE;
	Tue,  6 Jan 2026 17:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721533;
	bh=OryrbP5bn7SZvic1a1ew20hVsW7gNY2j5fdw9Emw1K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lu/lFy//0H1IEJS4IQV7JqrcVeym9WdpFrCNWzx7ZBObAXp2AfZgQMqG/imIVupG7
	 xLfOT84SVyOrHMkNPRrr1eNiN75/YIQnqYz0ToBCoibD9C++VIXW1pwzZLDtBtebUC
	 fvx9B/PhJddsSvBXfOtzLsgr2NmyjYCBU4OeWytE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 6.12 532/567] x86/microcode/AMD: Select which microcode patch to load
Date: Tue,  6 Jan 2026 18:05:14 +0100
Message-ID: <20260106170511.076481554@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 8d171045069c804e5ffaa18be590c42c6af0cf3f upstream.

All microcode patches up to the proper BIOS Entrysign fix are loaded
only after the sha256 signature carried in the driver has been verified.

Microcode patches after the Entrysign fix has been applied, do not need
that signature verification anymore.

In order to not abandon machines which haven't received the BIOS update
yet, add the capability to select which microcode patch to load.

The corresponding microcode container supplied through firmware-linux
has been modified to carry two patches per CPU type
(family/model/stepping) so that the proper one gets selected.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Waiman Long <longman@redhat.com>
Link: https://patch.msgid.link/20251027133818.4363-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |  104 +++++++++++++++++++++++-------------
 1 file changed, 67 insertions(+), 37 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -174,50 +174,61 @@ static u32 cpuid_to_ucode_rev(unsigned i
 	return p.ucode_rev;
 }
 
+static u32 get_cutoff_revision(u32 rev)
+{
+	switch (rev >> 8) {
+	case 0x80012: return 0x8001277; break;
+	case 0x80082: return 0x800820f; break;
+	case 0x83010: return 0x830107c; break;
+	case 0x86001: return 0x860010e; break;
+	case 0x86081: return 0x8608108; break;
+	case 0x87010: return 0x8701034; break;
+	case 0x8a000: return 0x8a0000a; break;
+	case 0xa0010: return 0xa00107a; break;
+	case 0xa0011: return 0xa0011da; break;
+	case 0xa0012: return 0xa001243; break;
+	case 0xa0082: return 0xa00820e; break;
+	case 0xa1011: return 0xa101153; break;
+	case 0xa1012: return 0xa10124e; break;
+	case 0xa1081: return 0xa108109; break;
+	case 0xa2010: return 0xa20102f; break;
+	case 0xa2012: return 0xa201212; break;
+	case 0xa4041: return 0xa404109; break;
+	case 0xa5000: return 0xa500013; break;
+	case 0xa6012: return 0xa60120a; break;
+	case 0xa7041: return 0xa704109; break;
+	case 0xa7052: return 0xa705208; break;
+	case 0xa7080: return 0xa708009; break;
+	case 0xa70c0: return 0xa70C009; break;
+	case 0xaa001: return 0xaa00116; break;
+	case 0xaa002: return 0xaa00218; break;
+	case 0xb0021: return 0xb002146; break;
+	case 0xb0081: return 0xb008111; break;
+	case 0xb1010: return 0xb101046; break;
+	case 0xb2040: return 0xb204031; break;
+	case 0xb4040: return 0xb404031; break;
+	case 0xb4041: return 0xb404101; break;
+	case 0xb6000: return 0xb600031; break;
+	case 0xb6080: return 0xb608031; break;
+	case 0xb7000: return 0xb700031; break;
+	default: break;
+
+	}
+	return 0;
+}
+
 static bool need_sha_check(u32 cur_rev)
 {
+	u32 cutoff;
+
 	if (!cur_rev) {
 		cur_rev = cpuid_to_ucode_rev(bsp_cpuid_1_eax);
 		pr_info_once("No current revision, generating the lowest one: 0x%x\n", cur_rev);
 	}
 
-	switch (cur_rev >> 8) {
-	case 0x80012: return cur_rev <= 0x8001277; break;
-	case 0x80082: return cur_rev <= 0x800820f; break;
-	case 0x83010: return cur_rev <= 0x830107c; break;
-	case 0x86001: return cur_rev <= 0x860010e; break;
-	case 0x86081: return cur_rev <= 0x8608108; break;
-	case 0x87010: return cur_rev <= 0x8701034; break;
-	case 0x8a000: return cur_rev <= 0x8a0000a; break;
-	case 0xa0010: return cur_rev <= 0xa00107a; break;
-	case 0xa0011: return cur_rev <= 0xa0011da; break;
-	case 0xa0012: return cur_rev <= 0xa001243; break;
-	case 0xa0082: return cur_rev <= 0xa00820e; break;
-	case 0xa1011: return cur_rev <= 0xa101153; break;
-	case 0xa1012: return cur_rev <= 0xa10124e; break;
-	case 0xa1081: return cur_rev <= 0xa108109; break;
-	case 0xa2010: return cur_rev <= 0xa20102f; break;
-	case 0xa2012: return cur_rev <= 0xa201212; break;
-	case 0xa4041: return cur_rev <= 0xa404109; break;
-	case 0xa5000: return cur_rev <= 0xa500013; break;
-	case 0xa6012: return cur_rev <= 0xa60120a; break;
-	case 0xa7041: return cur_rev <= 0xa704109; break;
-	case 0xa7052: return cur_rev <= 0xa705208; break;
-	case 0xa7080: return cur_rev <= 0xa708009; break;
-	case 0xa70c0: return cur_rev <= 0xa70C009; break;
-	case 0xaa001: return cur_rev <= 0xaa00116; break;
-	case 0xaa002: return cur_rev <= 0xaa00218; break;
-	case 0xb0021: return cur_rev <= 0xb002146; break;
-	case 0xb0081: return cur_rev <= 0xb008111; break;
-	case 0xb1010: return cur_rev <= 0xb101046; break;
-	case 0xb2040: return cur_rev <= 0xb204031; break;
-	case 0xb4040: return cur_rev <= 0xb404031; break;
-	case 0xb4041: return cur_rev <= 0xb404101; break;
-	case 0xb6000: return cur_rev <= 0xb600031; break;
-	case 0xb6080: return cur_rev <= 0xb608031; break;
-	case 0xb7000: return cur_rev <= 0xb700031; break;
-	default: break;
-	}
+	cutoff = get_cutoff_revision(cur_rev);
+	if (cutoff)
+		return cur_rev <= cutoff;
 
 	pr_info("You should not be seeing this. Please send the following couple of lines to x86-<at>-kernel.org\n");
 	pr_info("CPUID(1).EAX: 0x%x, current revision: 0x%x\n", bsp_cpuid_1_eax, cur_rev);
@@ -468,6 +479,7 @@ static int verify_patch(const u8 *buf, s
 {
 	u8 family = x86_family(bsp_cpuid_1_eax);
 	struct microcode_header_amd *mc_hdr;
+	u32 cur_rev, cutoff, patch_rev;
 	unsigned int ret;
 	u32 sh_psize;
 	u16 proc_id;
@@ -511,6 +523,24 @@ static int verify_patch(const u8 *buf, s
 	if (patch_fam != family)
 		return 1;
 
+	cur_rev = get_patch_level();
+
+	/* No cutoff revision means old/unaffected by signing algorithm weakness => matches */
+	cutoff = get_cutoff_revision(cur_rev);
+	if (!cutoff)
+		goto ok;
+
+	patch_rev = mc_hdr->patch_id;
+
+	if (cur_rev <= cutoff && patch_rev <= cutoff)
+		goto ok;
+
+	if (cur_rev > cutoff && patch_rev > cutoff)
+		goto ok;
+
+	return 1;
+ok:
+
 	return 0;
 }
 


