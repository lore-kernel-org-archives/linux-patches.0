Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F3E15FCE9;
	Mon, 27 May 2024 19:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837550; cv=none; b=p5f1MMj8P9nN6S7irCyIoGhHYA9fHZSSSi3A3yNfbq18SaOvMqwRV6eIucJq3AALms7F8iuMgsgybDc8XN/XX3jtmax+jvhzE0EutC7i36U5jb17cvZ2mPPyeKQzZy1u6bVKKuTQ+Qb2m2HAZ3SyzETNnJQeookMa4kgVD2loC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837550; c=relaxed/simple;
	bh=wbn1pwDX8bcl70xK/+QX0IzHaNlL1g/OgDJgoETMSYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3S3IauWw14aEBRfhANFEdXX7GT8KBY8MKo/hwe9x0CK499vBBJ7sYmtxgtlLTJQMhCBQMtbqc+n6N+/Ho7cqBshVo91asTMZFFiRbsfT02v9+tyTKyosbHISxZkzIMwYLyM/ZNw/Rszb2IYoIfKU3+GIgZnM3+kswxCzXsTjA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXb+X9xD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXb+X9xD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87890C2BBFC;
	Mon, 27 May 2024 19:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837549;
	bh=wbn1pwDX8bcl70xK/+QX0IzHaNlL1g/OgDJgoETMSYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXb+X9xDb0+F9oDZ1EIuNuQDNJirQ9wAiaVRAHCXbfHuIMiUITXq494vTA5nzlyIJ
	 DT0qIjfjWwSLhVvDcYJSlImbROt4t0LGSvSraT/AH5DQ72pvO048bnJ4XUH4Lz72en
	 HGAcnmP8JMFY52ijBWWPA+kWREXKlmjAtHxZu0y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 055/493] cpu: Ignore "mitigations" kernel parameter if CPU_MITIGATIONS=n
Date: Mon, 27 May 2024 20:50:57 +0200
Message-ID: <20240527185631.106292948@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit ce0abef6a1d540acef85068e0e82bdf1fbeeb0e9 ]

Explicitly disallow enabling mitigations at runtime for kernels that were
built with CONFIG_CPU_MITIGATIONS=n, as some architectures may omit code
entirely if mitigations are disabled at compile time.

E.g. on x86, a large pile of Kconfigs are buried behind CPU_MITIGATIONS,
and trying to provide sane behavior for retroactively enabling mitigations
is extremely difficult, bordering on impossible.  E.g. page table isolation
and call depth tracking require build-time support, BHI mitigations will
still be off without additional kernel parameters, etc.

  [ bp: Touchups. ]

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240420000556.2645001-3-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  3 +++
 arch/x86/Kconfig                                |  8 ++++++--
 include/linux/cpu.h                             | 11 +++++++++++
 kernel/cpu.c                                    | 14 ++++++++++----
 4 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 31fdaf4fe9dd8..9bfc972af2403 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3399,6 +3399,9 @@
 			arch-independent options, each of which is an
 			aggregation of existing arch-specific options.
 
+			Note, "mitigations" is supported if and only if the
+			kernel was built with CPU_MITIGATIONS=y.
+
 			off
 				Disable all optional CPU mitigations.  This
 				improves system performance, but it may also
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6f49999a6b838..bfccf1213871b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2474,9 +2474,13 @@ menuconfig CPU_MITIGATIONS
 	help
 	  Say Y here to enable options which enable mitigations for hardware
 	  vulnerabilities (usually related to speculative execution).
+	  Mitigations can be disabled or restricted to SMT systems at runtime
+	  via the "mitigations" kernel parameter.
 
-	  If you say N, all mitigations will be disabled. You really
-	  should know what you are doing to say so.
+	  If you say N, all mitigations will be disabled.  This CANNOT be
+	  overridden at runtime.
+
+	  Say 'Y', unless you really know what you are doing.
 
 if CPU_MITIGATIONS
 
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 8654714421a0d..75f0344bd3b94 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -219,7 +219,18 @@ void cpuhp_report_idle_dead(void);
 static inline void cpuhp_report_idle_dead(void) { }
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
+#ifdef CONFIG_CPU_MITIGATIONS
 extern bool cpu_mitigations_off(void);
 extern bool cpu_mitigations_auto_nosmt(void);
+#else
+static inline bool cpu_mitigations_off(void)
+{
+	return true;
+}
+static inline bool cpu_mitigations_auto_nosmt(void)
+{
+	return false;
+}
+#endif
 
 #endif /* _LINUX_CPU_H_ */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index f8a0406ce8ba5..bac70ea54e349 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -3196,6 +3196,7 @@ void __init boot_cpu_hotplug_init(void)
 	this_cpu_write(cpuhp_state.target, CPUHP_ONLINE);
 }
 
+#ifdef CONFIG_CPU_MITIGATIONS
 /*
  * These are used for a global "mitigations=" cmdline option for toggling
  * optional CPU mitigations.
@@ -3206,9 +3207,7 @@ enum cpu_mitigations {
 	CPU_MITIGATIONS_AUTO_NOSMT,
 };
 
-static enum cpu_mitigations cpu_mitigations __ro_after_init =
-	IS_ENABLED(CONFIG_CPU_MITIGATIONS) ? CPU_MITIGATIONS_AUTO :
-					     CPU_MITIGATIONS_OFF;
+static enum cpu_mitigations cpu_mitigations __ro_after_init = CPU_MITIGATIONS_AUTO;
 
 static int __init mitigations_parse_cmdline(char *arg)
 {
@@ -3224,7 +3223,6 @@ static int __init mitigations_parse_cmdline(char *arg)
 
 	return 0;
 }
-early_param("mitigations", mitigations_parse_cmdline);
 
 /* mitigations=off */
 bool cpu_mitigations_off(void)
@@ -3239,3 +3237,11 @@ bool cpu_mitigations_auto_nosmt(void)
 	return cpu_mitigations == CPU_MITIGATIONS_AUTO_NOSMT;
 }
 EXPORT_SYMBOL_GPL(cpu_mitigations_auto_nosmt);
+#else
+static int __init mitigations_parse_cmdline(char *arg)
+{
+	pr_crit("Kernel compiled without mitigations, ignoring 'mitigations'; system may still be vulnerable\n");
+	return 0;
+}
+#endif
+early_param("mitigations", mitigations_parse_cmdline);
-- 
2.43.0



