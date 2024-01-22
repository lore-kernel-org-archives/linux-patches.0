Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4D6132C19;
	Tue, 23 Jan 2024 00:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969119; cv=none; b=jTAjaMTfotzJ4Wg3UsHdoWRA9NQlwrtM72SD66ArSWqQGtK85NnJGjsRpf17sU+6siZpgKG8NBqpHMENO49csR1zg8rheljey2ryUXA10nTsaxAaguVFWVI5aTYZmr2NWrLvNPPj6tSqM7nkP6HGH8bnM8nXlkTN829DdWnyOuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969119; c=relaxed/simple;
	bh=r2I7dCO7O3MxB1l8KNo5G2rUMS4Wk+VixhkegVdJD20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cigS+Zd3rcb1j+QZ4v4op/w/1tqLPKh/YS1o4e+mcMyKTKLLnGqEJAdLt7yHTKvMF9TuU3e80YdcMPWdSKcX2RACc0Cad1+C1J1NPdR6rJmc8osPB/3EAqGhQlJOebHB7QCnASvZctxY1Ri7ltJ39Ou0Z473hEPCDaxOoXVO/uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7N5qjhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7N5qjhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D93C433C7;
	Tue, 23 Jan 2024 00:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969118;
	bh=r2I7dCO7O3MxB1l8KNo5G2rUMS4Wk+VixhkegVdJD20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7N5qjhdcrVVyABnW5bjCsfJWDUN5Hd/r+ONBHJnmBs1wS6J4MDVWY7WzMvallyW0
	 vMjuqbEmLXZq32JMgBbyo6CSZlSPlrI0pH9mewQvm3VspcJvCpon/jZYBKdTU1Kd1N
	 akyWsMVEa1Hc3auoEFBrtucZ5AlTzUOqBo/FXvmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashok Raj <ashok.raj@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 009/641] x86/microcode/intel: Set new revision only after a successful update
Date: Mon, 22 Jan 2024 15:48:33 -0800
Message-ID: <20240122235818.399298110@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 9c21ea53e6bd1104c637b80a0688040f184cc761 ]

This was meant to be done only when early microcode got updated
successfully. Move it into the if-branch.

Also, make sure the current revision is read unconditionally and only
once.

Fixes: 080990aa3344 ("x86/microcode: Rework early revisions reporting")
Reported-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Ashok Raj <ashok.raj@intel.com>
Link: https://lore.kernel.org/r/ZWjVt5dNRjbcvlzR@a4bf019067fa.jf.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/intel.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 070426b9895f..334972c097d9 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -370,14 +370,14 @@ static __init struct microcode_intel *get_microcode_blob(struct ucode_cpu_info *
 {
 	struct cpio_data cp;
 
+	intel_collect_cpu_info(&uci->cpu_sig);
+
 	if (!load_builtin_intel_microcode(&cp))
 		cp = find_microcode_in_initrd(ucode_path);
 
 	if (!(cp.data && cp.size))
 		return NULL;
 
-	intel_collect_cpu_info(&uci->cpu_sig);
-
 	return scan_microcode(cp.data, cp.size, uci, save);
 }
 
@@ -410,13 +410,13 @@ void __init load_ucode_intel_bsp(struct early_load_data *ed)
 {
 	struct ucode_cpu_info uci;
 
-	ed->old_rev = intel_get_microcode_revision();
-
 	uci.mc = get_microcode_blob(&uci, false);
-	if (uci.mc && apply_microcode_early(&uci) == UCODE_UPDATED)
-		ucode_patch_va = UCODE_BSP_LOADED;
+	ed->old_rev = uci.cpu_sig.rev;
 
-	ed->new_rev = uci.cpu_sig.rev;
+	if (uci.mc && apply_microcode_early(&uci) == UCODE_UPDATED) {
+		ucode_patch_va = UCODE_BSP_LOADED;
+		ed->new_rev = uci.cpu_sig.rev;
+	}
 }
 
 void load_ucode_intel_ap(void)
-- 
2.43.0



