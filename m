Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F9047AF65;
	Tue, 16 Jun 2026 17:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630355; cv=none; b=Svqb8ZT/eXuvo/dbqjmxhOJBchC5OQTzuvApyByFf54lcRP34ecLPluS0SEezG1uojNkql+ailGVUhKpYvbj/ncuhjQtUxMb5zlKfPCWHcAu3g1U58RIrjchkGSuR2ZVvHyT2Ji+mo/gjxol4fi1gAC5xulYEoN7Aj0AhdwPRkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630355; c=relaxed/simple;
	bh=PBsQS6AQ1MPWTZQGe9a90NMrQWeCPT52ZpIiTxaHsE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcF9iSRgOP1nVxTrPY3wWRnRnJULqi+WJjXjRMTOXaUtS/MUdE/sOMeANjAleSW8crtaxoXzG5h64GHvBia2b4XUxcZMJKHRio1UaWHc4aOQrhPgtXSvtVsX3c5IJ+BaI9rsSozEx8ZDZMWzgOlHQK8mo0Ex8YbrRo0CxrBSQII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CI7n5SLq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CI7n5SLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D953E1F000E9;
	Tue, 16 Jun 2026 17:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630354;
	bh=h59QY0Ln9Css3Szo+tQvJrwPEzxYOITLa9hJDab+mtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CI7n5SLq+3EotRfI7tFSBwSduIyymGwsjI68BxQuVAU/1RHsA889ery0i9UcIr4AF
	 fdS5HAkkFUCOlruUNAHTpLRGai+KaGZWMGMgDKVzqQzAF8AedQp9LoPek2mWgECWRj
	 44sS8cYlUmO5pUzPMxCDWX5/3Ee9ShcLRkNauJOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>
Subject: [PATCH 6.6 451/452] x86/CPU/AMD: Call the spectral chicken in the Zen2 init function
Date: Tue, 16 Jun 2026 20:31:18 +0530
Message-ID: <20260616145140.177192824@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit cfbf4f992bfce1fa9f2f347a79cbbea0368e7971 upstream.

No functional change.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: http://lore.kernel.org/r/20231120104152.13740-6-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1060,10 +1060,8 @@ void init_spectral_chicken(struct cpuinf
 	 *
 	 * This suppresses speculation from the middle of a basic block, i.e. it
 	 * suppresses non-branch predictions.
-	 *
-	 * We use STIBP as a heuristic to filter out Zen2 from the rest of F17H
 	 */
-	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && cpu_has(c, X86_FEATURE_AMD_STIBP)) {
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR)) {
 		if (!rdmsrl_safe(MSR_ZEN2_SPECTRAL_CHICKEN, &value)) {
 			value |= MSR_ZEN2_SPECTRAL_CHICKEN_BIT;
 			wrmsrl_safe(MSR_ZEN2_SPECTRAL_CHICKEN, value);
@@ -1149,6 +1147,7 @@ static void zen2_zenbleed_check(struct c
 
 static void init_amd_zen2(struct cpuinfo_x86 *c)
 {
+	init_spectral_chicken(c);
 	fix_erratum_1386(c);
 	zen2_zenbleed_check(c);
 
@@ -1213,7 +1212,7 @@ static void init_amd(struct cpuinfo_x86
 	case 0x12: init_amd_ln(c); break;
 	case 0x15: init_amd_bd(c); break;
 	case 0x16: init_amd_jg(c); break;
-	case 0x17: init_spectral_chicken(c);
+	case 0x17:
 		   fallthrough;
 	case 0x19: init_amd_zn(c); break;
 	}


