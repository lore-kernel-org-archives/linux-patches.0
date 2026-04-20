Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE9C33262B;
	Mon, 20 Apr 2026 15:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700140; cv=none; b=FtUYFgLiEEMuDN3XW+JqsBBu73B/vtnbeOhAoD2SItezbEXDEPIqQwmr0BuIaIhIEy1JQiVJlKZienlhSqOIE2ukzWfPpBKJN7p6pJBq5oHPrSzB0TJY1tfjw2oqHKlz023g+yOW+32cSklXcHAxLSYR0eZXYiaixJs6ffZnoRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700140; c=relaxed/simple;
	bh=F//j7PmZoYXaEEiiPZFhjEXcViOXWihfQNs1y0FLhmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LL7/3LPkYbv/AcdHMUFITurklEbvD3pPpcQnB4l1KOI7DS/VWSxJcVEf3XNFqm4rApVxeJXawo273Jqwjn+Ul4rj1LbcBX9b5R84H1Mup30ujrJeBgjLhm/TX4QiwUIy5lZ8NLS6ASf+LDATwlvdOMnaZHynkpTx/hwMz1w6DT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKB8+JSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKB8+JSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EED8C19425;
	Mon, 20 Apr 2026 15:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700139;
	bh=F//j7PmZoYXaEEiiPZFhjEXcViOXWihfQNs1y0FLhmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKB8+JSALfKG1i2Nntf7RhgUf6wmuDgySeVcJB67h9xhEeQA7GnxXuKg2s4JTI0bk
	 3spWiUzgU9U8WcdwMpbV7yCTDSGac+J2K/KWDNL4li9m/m7AjFKWzd/n+NfwZVhFji
	 YLcu8/saKuwENBKAn3I7cqZBpU1zOrlGOWeB5TYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhii Pievniev <spevnev16@gmail.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 057/220] tools/power/turbostat: Fix microcode patch level output for AMD/Hygon
Date: Mon, 20 Apr 2026 17:39:58 +0200
Message-ID: <20260420153936.093219156@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhii Pievniev <spevnev16@gmail.com>

[ Upstream commit a444083286434ec1fd127c5da11a3091e6013008 ]

turbostat always used the same logic to read the microcode patch level,
which is correct for Intel but not for AMD/Hygon.
While Intel stores the patch level in the upper 32 bits of MSR, AMD
stores it in the lower 32 bits, which causes turbostat to report the
microcode version as 0x0 on AMD/Hygon.

Fix by shifting right by 32 for non-AMD/Hygon, preserving the existing
behavior for Intel and unknown vendors.

Fixes: 3e4048466c39 ("tools/power turbostat: Add --no-msr option")
Signed-off-by: Serhii Pievniev <spevnev16@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 903943d30f713..83a90f413f976 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -8812,10 +8812,13 @@ void process_cpuid()
 	edx_flags = edx;
 
 	if (!no_msr) {
-		if (get_msr(sched_getcpu(), MSR_IA32_UCODE_REV, &ucode_patch))
+		if (get_msr(sched_getcpu(), MSR_IA32_UCODE_REV, &ucode_patch)) {
 			warnx("get_msr(UCODE)");
-		else
+		} else {
 			ucode_patch_valid = true;
+			if (!authentic_amd && !hygon_genuine)
+				ucode_patch >>= 32;
+		}
 	}
 
 	/*
@@ -8829,7 +8832,7 @@ void process_cpuid()
 	if (!quiet) {
 		fprintf(outf, "CPUID(1): family:model:stepping 0x%x:%x:%x (%d:%d:%d)", family, model, stepping, family, model, stepping);
 		if (ucode_patch_valid)
-			fprintf(outf, " microcode 0x%x", (unsigned int)((ucode_patch >> 32) & 0xFFFFFFFF));
+			fprintf(outf, " microcode 0x%x", (unsigned int)ucode_patch);
 		fputc('\n', outf);
 
 		fprintf(outf, "CPUID(0x80000000): max_extended_levels: 0x%x\n", max_extended_level);
-- 
2.53.0



