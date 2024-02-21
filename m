Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D522053816;
	Wed, 21 Feb 2024 13:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521208; cv=none; b=tsocR7glBrXCxTHryOwbkrSqNt1TieErjkTh7IxG8790+hvC5YOaP84G+LYik1vqmB3VKBOhIxfY3nCuquqIvnRTAw+imbYvD3OaZ8vLQC5yJs6CnM6k+TRQaexB+pj8odM0Or1fpejRaulo45rSys5XDv6jkcu5ZmXdsdNoGo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521208; c=relaxed/simple;
	bh=OGfLC4nT7/OgvJ3PJDHPe732OvDrXvWu4wW2JNN7uP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFVzHh6FCF4QhuXlKrH4BgLxkq2A3BPuGCRkwb7ZozdGFxTWBjK36/fwpuZm2jLRMRtXCWxdUHu9DmPbrjcUqtnpcx0YOiU9Bu4bR3p4UoFBotNScMDZypqEOWrsZXvmVR/MgGM3zCjsR535g9WjtB8TdyCceomJhhJkiGJ43GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfT1Ri2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfT1Ri2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89C1C433C7;
	Wed, 21 Feb 2024 13:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521208;
	bh=OGfLC4nT7/OgvJ3PJDHPe732OvDrXvWu4wW2JNN7uP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfT1Ri2C44kcZeVnPU/45GZDrMLjllrVqp6He7661cgxoXiKw2yP5DjF5RgtymdNi
	 +GmZzA5k4V6CdEGwZB0QjrNTBlSYBT7aNyUxWNnFzsto+TMMFcQFubCOR2fxiVcRWL
	 U5TpjThigVebnmfZaExlslzQMTlWrkksSFlifLhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH 4.19 019/202] x86/CPU/AMD: Fix disabling XSAVES on AMD family 0x17 due to erratum
Date: Wed, 21 Feb 2024 14:05:20 +0100
Message-ID: <20240221125932.377070058@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

The stable kernel version backport of the patch disabling XSAVES on AMD
Zen family 0x17 applied this change to the wrong function (init_amd_k6()),
one which isn't called for Zen CPUs.

Move the erratum to the init_amd_zn() function instead.

Add an explicit family 0x17 check to the erratum so nothing will break if
someone naively makes this kernel version call init_amd_zn() also for
family 0x19 in the future (as the current upstream code does).

Fixes: f028a7db9824 ("x86/CPU/AMD: Disable XSAVES on AMD family 0x17")
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -271,15 +271,6 @@ static void init_amd_k6(struct cpuinfo_x
 		return;
 	}
 #endif
-	/*
-	 * Work around Erratum 1386.  The XSAVES instruction malfunctions in
-	 * certain circumstances on Zen1/2 uarch, and not all parts have had
-	 * updated microcode at the time of writing (March 2023).
-	 *
-	 * Affected parts all have no supervisor XSAVE states, meaning that
-	 * the XSAVEC instruction (which works fine) is equivalent.
-	 */
-	clear_cpu_cap(c, X86_FEATURE_XSAVES);
 }
 
 static void init_amd_k7(struct cpuinfo_x86 *c)
@@ -979,6 +970,17 @@ static void init_amd_zn(struct cpuinfo_x
 		if (c->x86 == 0x19 && !cpu_has(c, X86_FEATURE_BTC_NO))
 			set_cpu_cap(c, X86_FEATURE_BTC_NO);
 	}
+
+	/*
+	 * Work around Erratum 1386.  The XSAVES instruction malfunctions in
+	 * certain circumstances on Zen1/2 uarch, and not all parts have had
+	 * updated microcode at the time of writing (March 2023).
+	 *
+	 * Affected parts all have no supervisor XSAVE states, meaning that
+	 * the XSAVEC instruction (which works fine) is equivalent.
+	 */
+	if (c->x86 == 0x17)
+		clear_cpu_cap(c, X86_FEATURE_XSAVES);
 }
 
 static bool cpu_has_zenbleed_microcode(void)


