Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB6A7F465;
	Mon,  8 Apr 2024 13:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582017; cv=none; b=ogaeyfZa2UI6b17Sgi4Qs73CuL/UKornFtK3SqTCzHHn4zOj6ShO7d10R44vtb7U+z/rqvuQ6bzwnh1POtvsdM0JnmOmh5Tn1slrTF6Bf1kRCZ4aoY2dUqECrU/TqePZDdHB8MYMym6CmqRY6v/jMMtXr7p7UD1hq8+XXprHGWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582017; c=relaxed/simple;
	bh=7U5rG+4oy1Yh+Ct3uuVdl9TXwt93h+ZMi9ZGPiSxwx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfWtEwQrCt2+XfYw1/NA1tqmcXvcfe1dIEoxdz013KdwvqufPoJqKwIk5nfBbEY9wMBmz1JwLzbKZP9qe9RO1qHXj/lD76OKumFi6ojO+GFY2T1gFZcfn3HtqVAgUOwEvzjOaHp57d4bUgSV8pedBu6aSyOWpNg/WjlANEV6iQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhhrxbOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhhrxbOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65701C433C7;
	Mon,  8 Apr 2024 13:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582016;
	bh=7U5rG+4oy1Yh+Ct3uuVdl9TXwt93h+ZMi9ZGPiSxwx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhhrxbOtQZFrwUrhjNHlSF6imkTXXcpXy1ghE+Irr9YDlIQ0A9gTsqZW1ZqnkuP6/
	 J1y+le/o2z5z6XD/TcdJ/rpXSru/rv63EX7qHsl61VpcyJ2YyFWYSF75BDFzba/Og9
	 WVqZJOZLN2mmB8fKMDBxcV6tD76cjakGz4kEef+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/252] x86/CPU/AMD: Carve out the erratum 1386 fix
Date: Mon,  8 Apr 2024 14:55:56 +0200
Message-ID: <20240408125308.410329157@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit a7c32a1ae9ee43abfe884f5af376877c4301d166 ]

Call it on the affected CPU generations.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: http://lore.kernel.org/r/20231120104152.13740-3-bp@alien8.de
Stable-dep-of: c7b2edd8377b ("perf/x86/amd/core: Update and fix stalled-cycles-* events for Zen 2 and later")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 5391385707b3f..28c3a1045b060 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -988,6 +988,19 @@ static void init_amd_bd(struct cpuinfo_x86 *c)
 	clear_rdrand_cpuid_bit(c);
 }
 
+static void fix_erratum_1386(struct cpuinfo_x86 *c)
+{
+	/*
+	 * Work around Erratum 1386.  The XSAVES instruction malfunctions in
+	 * certain circumstances on Zen1/2 uarch, and not all parts have had
+	 * updated microcode at the time of writing (March 2023).
+	 *
+	 * Affected parts all have no supervisor XSAVE states, meaning that
+	 * the XSAVEC instruction (which works fine) is equivalent.
+	 */
+	clear_cpu_cap(c, X86_FEATURE_XSAVES);
+}
+
 void init_spectral_chicken(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_CPU_UNRET_ENTRY
@@ -1008,15 +1021,6 @@ void init_spectral_chicken(struct cpuinfo_x86 *c)
 		}
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
 
 static void init_amd_zn(struct cpuinfo_x86 *c)
@@ -1085,10 +1089,12 @@ static void zenbleed_check(struct cpuinfo_x86 *c)
 
 static void init_amd_zen(struct cpuinfo_x86 *c)
 {
+	fix_erratum_1386(c);
 }
 
 static void init_amd_zen2(struct cpuinfo_x86 *c)
 {
+	fix_erratum_1386(c);
 }
 
 static void init_amd_zen3(struct cpuinfo_x86 *c)
-- 
2.43.0



