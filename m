Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E521139597;
	Tue, 14 May 2024 10:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682955; cv=none; b=AKbLdEt82NHhZm6WhE7mlxuTVAl6Jkdalb4oAXv18oAQ8crujEYl+yKm/36+t2Lp7KWOpe4ofnWj/ITZq3cMvYni9nfk7HTjdpsF3D8zee3mQJdOjXvAJxcoFyu2FciS2IUr8A3HVq47LuqMGV4OzD4H0fUej0OZonGXFhNX2RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682955; c=relaxed/simple;
	bh=f4jR3AoJjUDPjw7y5HgcLQWEe+nebUY2sky8GFMNXCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8wxa403lbm6NCjwDyWi4BvbphViKoeMc574K3mulQHW8CVzOH+elDxEJOHhjLOnLdjsHHuE0szTcvLQ+kmPsU3rx0LG0FbzBy0kRNqI03vXQDCLH6OCQtIZiYlXL4XPVzVxiJJQ2u3exKovPl7ScZTh9RByruQEpW9xEbHZpPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6dr4QMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6dr4QMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B82C2BD10;
	Tue, 14 May 2024 10:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682955;
	bh=f4jR3AoJjUDPjw7y5HgcLQWEe+nebUY2sky8GFMNXCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6dr4QMFOVVN4ftPWB9F79wu7cY9hawgo2vI64WncP/KISDa9AG7mZKZ541u2IKNY
	 ohy65oKvaJUmVpyMoEbImdfQ+ocBzwpFigQ6l5UQcL4dS+qAehr9d4ir6xlSiul0c3
	 15tjYNLMHS/MHDt6omNWv9TX6diOddPCh33RDHSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 139/336] tools/power turbostat: Print ucode revision only if valid
Date: Tue, 14 May 2024 12:15:43 +0200
Message-ID: <20240514101043.848427993@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index bbd2e0edadfae..a4a40a6e1b957 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5679,6 +5679,7 @@ void process_cpuid()
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int fms, family, model, stepping, ecx_flags, edx_flags;
 	unsigned long long ucode_patch = 0;
+	bool ucode_patch_valid = false;
 
 	eax = ebx = ecx = edx = 0;
 
@@ -5708,6 +5709,8 @@ void process_cpuid()
 
 	if (get_msr(sched_getcpu(), MSR_IA32_UCODE_REV, &ucode_patch))
 		warnx("get_msr(UCODE)");
+	else
+		ucode_patch_valid = true;
 
 	/*
 	 * check max extended function levels of CPUID.
@@ -5718,9 +5721,12 @@ void process_cpuid()
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



