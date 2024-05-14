Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7298595F;
	Tue, 14 May 2024 11:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685278; cv=none; b=jDRJfRJv/9ZF6cp3mMh9OgtozVJbRHecFDyG0nkG96dA8IX+8Y1SjBMp8GkHNMcAb0kquNHa5tH2WhFSFHjYdo7YqZzGycxRkN8I0eJnkUGlogNt97XeVqL1GvATddXjkn0ZRhFsA2+73BEW7IQncwKVjvkRRRNm5K2qWiR7ACo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685278; c=relaxed/simple;
	bh=lkruGvw3axrFa0BseNMZrDwFqThqznM7ae2u+XJiDZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JItyw+0BnR8YCujt12QC5oKrhz+XcmoDvmg51GoYQGxr0JcLX+HwsBeo9XhTAKMnD5oNurpbop+aT+hI47pPbay9aO7YRrM/A4ccPlKv9TG38mhPIm+aNV/OIOQHWZ8UCAfOJ6QhZsynYdgbmTK70gMSY6wR0BWGbSiv2cELWrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ozxvNMnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ozxvNMnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CA6C2BD10;
	Tue, 14 May 2024 11:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685278;
	bh=lkruGvw3axrFa0BseNMZrDwFqThqznM7ae2u+XJiDZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozxvNMnIGWKMhEtrAOLRgFSYgTjYWWqghdCmegNpUzq5daU7dXZkUQoAJYhl7LYCx
	 hAEaHLLAlQbW0FWA0gksqeN83DGIew3a+8m+P9SNtomfXwD9n9Dzp1sdXMHaUmnp7k
	 Il1F47BfcFJzhaCPKAh2xR4ApbrnCwfgvunZYY+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/301] tools/power turbostat: Print ucode revision only if valid
Date: Tue, 14 May 2024 12:16:43 +0200
Message-ID: <20240514101037.231168561@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>

[ Upstream commit fb5ceca046efc84f69fcf9779a013f8a0e63bbff ]

If the MSR read were to fail, turbostat would print "microcode 0x0"

Signed-off-by: Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 5b892c53fc2c2..4dfeda4870f71 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5518,6 +5518,7 @@ void process_cpuid()
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int fms, family, model, stepping, ecx_flags, edx_flags;
 	unsigned long long ucode_patch = 0;
+	bool ucode_patch_valid = false;
 
 	eax = ebx = ecx = edx = 0;
 
@@ -5547,6 +5548,8 @@ void process_cpuid()
 
 	if (get_msr(sched_getcpu(), MSR_IA32_UCODE_REV, &ucode_patch))
 		warnx("get_msr(UCODE)");
+	else
+		ucode_patch_valid = true;
 
 	/*
 	 * check max extended function levels of CPUID.
@@ -5557,9 +5560,12 @@ void process_cpuid()
 	__cpuid(0x80000000, max_extended_level, ebx, ecx, edx);
 
 	if (!quiet) {
-		fprintf(outf, "CPUID(1): family:model:stepping 0x%x:%x:%x (%d:%d:%d) microcode 0x%x\n",
-			family, model, stepping, family, model, stepping,
-			(unsigned int)((ucode_patch >> 32) & 0xFFFFFFFF));
+		fprintf(outf, "CPUID(1): family:model:stepping 0x%x:%x:%x (%d:%d:%d)",
+			family, model, stepping, family, model, stepping);
+		if (ucode_patch_valid)
+			fprintf(outf, " microcode 0x%x", (unsigned int)((ucode_patch >> 32) & 0xFFFFFFFF));
+		fputc('\n', outf);
+
 		fprintf(outf, "CPUID(0x80000000): max_extended_levels: 0x%x\n", max_extended_level);
 		fprintf(outf, "CPUID(1): %s %s %s %s %s %s %s %s %s %s\n",
 			ecx_flags & (1 << 0) ? "SSE3" : "-",
-- 
2.43.0



