Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A482017B505;
	Wed,  5 Mar 2025 18:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197896; cv=none; b=BRfyzl1FZaNrSRGc+/GmGWrNRBDXH2QaDa/WHxfgoWlbf2W4sHv1k0nyXkLYmk7AHfDGaMbwd87zgCY8eUaKqiMRQ047cA2g4lChg2J7abyYcslye9bcKO354P3/xR+vv14HwZtTCoFGd4ZIneZbLBlS0FYINYZnRTKgrzbqf/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197896; c=relaxed/simple;
	bh=QOPeakIYZvuEVW+7/5pkmBo1Sn+wAJRcX2zvt61npFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mt6XZrr7JkkjScDTjPva+qbkJw3X4P0w/K5iZF9Po/yaS8SCxciQREyYnK1LlxRGcEc1Y/8wkhM29GB06ZVGbCG2YEHTPdKfYQhl2KAOceo4T2azjB3VKaEEq1s/8k8SiXhjmyRrgdaTMbMPTx1H+yCn9h6Q1YVZC1kodttHu10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfzxT5l2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfzxT5l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29094C4CED1;
	Wed,  5 Mar 2025 18:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197896;
	bh=QOPeakIYZvuEVW+7/5pkmBo1Sn+wAJRcX2zvt61npFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfzxT5l2WmB2nyGYy86VajEqmONtonyiJAvRrf5pXF2sgB5Sph/42R+ctvseaDQQQ
	 6vt+t4AZr9atCMHd061bbg2cCC7k84bTbfUnR+1eIEvrTavtXB8/Wybqy7VWsRopCK
	 MdOILhO+YnN17QqBb+GjKBXfxm0Vc5i51frWK7Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 136/142] x86/microcode/AMD: Return bool from find_blobs_in_containers()
Date: Wed,  5 Mar 2025 18:49:15 +0100
Message-ID: <20250305174505.799622198@linuxfoundation.org>
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

commit a85c08aaa665b5436d325f6d7138732a0e1315ce upstream

Instead of open-coding the check for size/data move it inside the
function and make it return a boolean indicating whether data was found
or not.

No functional changes.

  [ bp: Write @ret in find_blobs_in_containers() only on success. ]

Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20241018155151.702350-2-nik.borisov@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -571,14 +571,19 @@ static bool get_builtin_microcode(struct
 	return false;
 }
 
-static void __init find_blobs_in_containers(struct cpio_data *ret)
+static bool __init find_blobs_in_containers(struct cpio_data *ret)
 {
 	struct cpio_data cp;
+	bool found;
 
 	if (!get_builtin_microcode(&cp))
 		cp = find_microcode_in_initrd(ucode_path);
 
-	*ret = cp;
+	found = cp.data && cp.size;
+	if (found)
+		*ret = cp;
+
+	return found;
 }
 
 void __init load_ucode_amd_bsp(struct early_load_data *ed, unsigned int cpuid_1_eax)
@@ -593,8 +598,7 @@ void __init load_ucode_amd_bsp(struct ea
 	/* Needed in load_microcode_amd() */
 	ucode_cpu_info[0].cpu_sig.sig = cpuid_1_eax;
 
-	find_blobs_in_containers(&cp);
-	if (!(cp.data && cp.size))
+	if (!find_blobs_in_containers(&cp))
 		return;
 
 	if (early_apply_microcode(ed->old_rev, cp.data, cp.size))
@@ -614,8 +618,7 @@ static int __init save_microcode_in_init
 	if (dis_ucode_ldr || c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10)
 		return 0;
 
-	find_blobs_in_containers(&cp);
-	if (!(cp.data && cp.size))
+	if (!find_blobs_in_containers(&cp))
 		return -EINVAL;
 
 	scan_containers(cp.data, cp.size, &desc);


