Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5DA244661;
	Mon, 20 Apr 2026 16:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701253; cv=none; b=lgmlcKVdpujE9lIFFa1AEEr8WEupF3DwOSACYvpmPCXw4mI9OkzYi/4aU2+tdRAJh2kWJFSQOA1N+v02V0PDHUgQPdG8VdNzvV8T9s3vh3+5vLaWs/zR9xhaQwmADnsHE1zkIH7xN+R/chAhCuqGmq+fMl2mRwGe/MaAj3JcnJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701253; c=relaxed/simple;
	bh=hwYL9DyzhG1Q18u+5N9XnPwfQXt575Q0L2yeMqfXvjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FowztASwDVpkj2A/ZqJnyem8MA6uaELyeMXXhB2dTPmnhmXQ/n9rcnyzgVfXTtZcpQGocEO2etSoYX8gANQCjF3+i7gcPFBh1zXQBfsyQiFG5LYFF9l0U31VI5NGKa/sj9QgZ2+SP6jjAVBOkR0UsMomR0btkEr+62BgIBp8vmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c45uzj4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c45uzj4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05747C19425;
	Mon, 20 Apr 2026 16:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701253;
	bh=hwYL9DyzhG1Q18u+5N9XnPwfQXt575Q0L2yeMqfXvjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c45uzj4xT34h9Ibto1yeZIOJM61xO80WU1Fe5wrTY1GRk5H0VeNKdgL74P/71p6ZR
	 uHCSsfMo0mb3OCcxw4IfiNi9jlXyUSqRm/HY+lm/VhKm07EAZ5xL1kSIxnnoYWRE7v
	 f8vQycVvUjCjUb0BqhSFUeQxr8Q0K2HR+vRAAzuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhii Pievniev <spevnev16@gmail.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/162] tools/power/turbostat: Fix microcode patch level output for AMD/Hygon
Date: Mon, 20 Apr 2026 17:41:12 +0200
Message-ID: <20260420153928.479879415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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
index 86ffe7e06a146..fb1c65f6ff9de 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -8058,10 +8058,13 @@ void process_cpuid()
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
@@ -8076,7 +8079,7 @@ void process_cpuid()
 		fprintf(outf, "CPUID(1): family:model:stepping 0x%x:%x:%x (%d:%d:%d)",
 			family, model, stepping, family, model, stepping);
 		if (ucode_patch_valid)
-			fprintf(outf, " microcode 0x%x", (unsigned int)((ucode_patch >> 32) & 0xFFFFFFFF));
+			fprintf(outf, " microcode 0x%x", (unsigned int)ucode_patch);
 		fputc('\n', outf);
 
 		fprintf(outf, "CPUID(0x80000000): max_extended_levels: 0x%x\n", max_extended_level);
-- 
2.53.0



