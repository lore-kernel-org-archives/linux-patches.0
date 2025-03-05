Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED8017B505;
	Wed,  5 Mar 2025 18:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197899; cv=none; b=g6usjaZX5cSjTITKxWp88jvrfGUM/h90Qka36ubXcIHu0wkF3d2I90FUIE0uhELIAqFBTJCkwaZ7in8q3aovyZU23F/+N5o+AMPe1LjMTLGdXaLdwcc8Qag1imz4nwj203CQi8GBFeSaKVTRUsBcfBqhBSBmJZIPAFodr8fa5eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197899; c=relaxed/simple;
	bh=gYGH5yMEoTb+PFHKjkvVpt53gcmZdRWC/bpeRYnvIx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSnrvfPg/2M8XZrfFaaPDps3Wt11lDRBVCs1uAWr+/FWgjdaNtFxsiS8oOBVpEjJzTJZaedSPk+R+t/eRNRuUBgfEUpmpcqTl8+Gcgd9KMT03bRRXNg2OnrmtabUe7JVpETzFVS+gPIKEnQ0tvDp9uk6jBOMPLOg6efZYXfgr4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSZb4/AU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSZb4/AU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0731BC4CED1;
	Wed,  5 Mar 2025 18:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197899;
	bh=gYGH5yMEoTb+PFHKjkvVpt53gcmZdRWC/bpeRYnvIx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSZb4/AUj7mX0irSTvczWc9X9bQhtd0PJlQ3r4d6bD6p3NeCg8Gdqg8M/vJi9m1ol
	 F+uyDSajNw9jaOvWZNBWyuWFh2WgNXcgvtbF8YtswhPD/1EawvAKz8qdt0b3FpZCDm
	 3BNk7RtVVXSrmdZ9/h1UWKx3EMDnTO3tZJM/sSew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 137/142] x86/microcode/AMD: Make __verify_patch_size() return bool
Date: Wed,  5 Mar 2025 18:49:16 +0100
Message-ID: <20250305174505.838726869@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Borisov <nik.borisov@suse.com>

commit d8317f3d8e6b412ff51ea66f1de2b2f89835f811 upstream

The result of that function is in essence boolean, so simplify to return the
result of the relevant expression. It also makes it follow the convention used
by __verify_patch_section().

No functional changes.

Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20241018155151.702350-3-nik.borisov@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -285,13 +285,13 @@ __verify_patch_section(const u8 *buf, si
  * exceed the per-family maximum). @sh_psize is the size read from the section
  * header.
  */
-static unsigned int __verify_patch_size(u32 sh_psize, size_t buf_size)
+static bool __verify_patch_size(u32 sh_psize, size_t buf_size)
 {
 	u8 family = x86_family(bsp_cpuid_1_eax);
 	u32 max_size;
 
 	if (family >= 0x15)
-		return min_t(u32, sh_psize, buf_size);
+		goto ret;
 
 #define F1XH_MPB_MAX_SIZE 2048
 #define F14H_MPB_MAX_SIZE 1824
@@ -305,13 +305,15 @@ static unsigned int __verify_patch_size(
 		break;
 	default:
 		WARN(1, "%s: WTF family: 0x%x\n", __func__, family);
-		return 0;
+		return false;
 	}
 
-	if (sh_psize > min_t(u32, buf_size, max_size))
-		return 0;
+	if (sh_psize > max_size)
+		return false;
 
-	return sh_psize;
+ret:
+	/* Working with the whole buffer so < is ok. */
+	return sh_psize <= buf_size;
 }
 
 /*
@@ -326,7 +328,6 @@ static int verify_patch(const u8 *buf, s
 {
 	u8 family = x86_family(bsp_cpuid_1_eax);
 	struct microcode_header_amd *mc_hdr;
-	unsigned int ret;
 	u32 sh_psize;
 	u16 proc_id;
 	u8 patch_fam;
@@ -350,8 +351,7 @@ static int verify_patch(const u8 *buf, s
 		return -1;
 	}
 
-	ret = __verify_patch_size(sh_psize, buf_size);
-	if (!ret) {
+	if (!__verify_patch_size(sh_psize, buf_size)) {
 		pr_debug("Per-family patch size mismatch.\n");
 		return -1;
 	}


