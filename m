Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656A52E6136;
	Tue, 15 Jul 2025 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586968; cv=none; b=t50Nw/UQVyCP51UNn6EC2Pfs6VAB4oa/zJUaQ9zL2E3WTNVYyKrZTsZALiL9o1iym21ql+PNHh87XgoPi/bPMTfCIb37CAZFcBP9BXkEop2mVWQ8jo4fRA4o0xXW2H+GgZUsrvBgHei/R96yjfZgJW++klde/dLzwAYSGe08CTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586968; c=relaxed/simple;
	bh=RMFsho1VV5Gcqaxb/MoJmRZFdL7t8MOoEW1VYsrg/Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYKFp61dEEcPXHH9I6s3ewlNfnGLYDoZEXNGNje0W//V0NisSq1nCTsvqq5z2cEa0YQsj1z2wk1z0QMZ11M3mn5lzEcbUgqdJWgU8cMTV3Veq0/jU8uHAmcIE1Gz3/G1LomyrnLYCLku5TyzQ7wdOGqP06WD6N+HVy8CtOBq8cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAjURpk0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAjURpk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC79C4CEE3;
	Tue, 15 Jul 2025 13:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586968;
	bh=RMFsho1VV5Gcqaxb/MoJmRZFdL7t8MOoEW1VYsrg/Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAjURpk0TC/sSpGkhrZjTpWOVmx8F38s2Dw4n1z/VX82KEftipFHZpdj5PtmK4wit
	 fpOqkdwdjoyTo8FeuHvAu4qHWokVlXzuiB8rO8XHM03Y8R/VQERbLknTQdEtSmbjU9
	 LRdaSlv5c7mQF8dGnROHX3vBaLf8zojMsmyFzeKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Paulyshka <me@mixaill.net>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.15 116/192] x86/CPU/AMD: Disable INVLPGB on Zen2
Date: Tue, 15 Jul 2025 15:13:31 +0200
Message-ID: <20250715130819.542044496@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Paulyshka <me@mixaill.net>

commit a74bb5f202dabddfea96abc1328fcedae8aa140a upstream.

AMD Cyan Skillfish (Family 17h, Model 47h, Stepping 0h) has an issue
that causes system oopses and panics when performing TLB flush using
INVLPGB.

However, the problem is that that machine has misconfigured CPUID and
should not report the INVLPGB bit in the first place. So zap the
kernel's representation of the flag so that nothing gets confused.

  [ bp: Massage. ]

Fixes: 767ae437a32d ("x86/mm: Add INVLPGB feature and Kconfig entry")
Signed-off-by: Mikhail Paulyshka <me@mixaill.net>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/1ebe845b-322b-4929-9093-b41074e9e939@mixaill.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -979,6 +979,9 @@ static void init_amd_zen2(struct cpuinfo
 		msr_clear_bit(MSR_AMD64_CPUID_FN_7, 18);
 		pr_emerg("RDSEED is not reliable on this platform; disabling.\n");
 	}
+
+	/* Correct misconfigured CPUID on some clients. */
+	clear_cpu_cap(c, X86_FEATURE_INVLPGB);
 }
 
 static void init_amd_zen3(struct cpuinfo_x86 *c)


