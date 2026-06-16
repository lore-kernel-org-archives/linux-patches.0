Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE31478E26;
	Tue, 16 Jun 2026 17:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630350; cv=none; b=Z8bmmxtznQjUyCmcKYdB6BSvfYs//qJGQ/FsybX+E4qCCcba9As4dM6wDVNTBWrV49dNcuFE5Z2MtwhtGDTQIq6U+IhhgOg4KL9UB7WYgUVOQTHXmW7207dv9+kvPjACML0Dz3mWAHHhtuVdBFcG5Z6s9ioMvUe6jf5dHrXgjDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630350; c=relaxed/simple;
	bh=uhVUp8UkkO/zAT7M1JcNeYK5wL9tLgRx9YxqoR9I+Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSz+BLbhJoGXHDhj6wrgtYw28/+5RV2Cf2J5tS5ig+LvcQTYSEKVK75h8kcmhPIeqRxa4U9er6oehKHdRedf92De7CYDe8vEO39/dT+6GPMUb8IfiqjZSU1gU/uhzRjZoX1aHGIO0N/ediRyJotsTO+XB6iFldzQQDW/J6t9o5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaqEddm2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaqEddm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBED1F000E9;
	Tue, 16 Jun 2026 17:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630349;
	bh=YpUMdXaL57/VHKYIGGPHtR7FR4A7GOb7pz1wISBW6Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vaqEddm2uLRIsjFN38zmUvJQryekEBOuY58enmwnJiC54WgW8fIMVlNVbqac+dB2b
	 qRmsGUcu46t8km1Mkh/gLRrAshN2UYoZesib3BkGWSeEQhMug2VIzXji2IQrqKDSCJ
	 /hbYHI6e8Z0e72cdnEmQbKUgRD+LCBPyy6jOiyL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>
Subject: [PATCH 6.6 450/452] x86/CPU/AMD: Move the Zen3 BTC_NO detection to the Zen3 init function
Date: Tue, 16 Jun 2026 20:31:17 +0530
Message-ID: <20260616145140.135302444@linuxfoundation.org>
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

commit affc66cb96f865b3763a8e18add52e133d864f04 upstream.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: http://lore.kernel.org/r/20231120104152.13740-4-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1090,14 +1090,6 @@ static void init_amd_zen1(struct cpuinfo
 		/* Erratum 1076: CPB feature bit not being set in CPUID. */
 		if (!cpu_has(c, X86_FEATURE_CPB))
 			set_cpu_cap(c, X86_FEATURE_CPB);
-
-		/*
-		 * Zen3 (Fam19 model < 0x10) parts are not susceptible to
-		 * Branch Type Confusion, but predate the allocation of the
-		 * BTC_NO bit.
-		 */
-		if (c->x86 == 0x19 && !cpu_has(c, X86_FEATURE_BTC_NO))
-			set_cpu_cap(c, X86_FEATURE_BTC_NO);
 	}
 
 	pr_notice_once("AMD Zen1 DIV0 bug detected. Disable SMT for full protection.\n");
@@ -1173,6 +1165,15 @@ static void init_amd_zen2(struct cpuinfo
 
 static void init_amd_zen3(struct cpuinfo_x86 *c)
 {
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR)) {
+		/*
+		 * Zen3 (Fam19 model < 0x10) parts are not susceptible to
+		 * Branch Type Confusion, but predate the allocation of the
+		 * BTC_NO bit.
+		 */
+		if (!cpu_has(c, X86_FEATURE_BTC_NO))
+			set_cpu_cap(c, X86_FEATURE_BTC_NO);
+	}
 }
 
 static void init_amd_zen4(struct cpuinfo_x86 *c)


