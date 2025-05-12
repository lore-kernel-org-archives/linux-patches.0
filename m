Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00BC29711A;
	Mon, 12 May 2025 18:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073549; cv=none; b=Ov8T8h7eUcXVJVuGjspFsUM50nL/B41XIWnj1jO93B3IQCBm4yNIcVgMb/IqUf14DJkFCUMzygnnBVNmNirqx9nElmGcdb7hXJgZ03b+zcEHx/iIdpC4lSSmaexpU6IYz8DcMqy+dDfMHi73+WrpbQpJdJlwpFhg6QCNXuoJOUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073549; c=relaxed/simple;
	bh=bSURhbOxLYVZAIY+FhsGSY0IFc4uEQFlb8POPTc3Buk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnRVipEI+1p3DRlHH+8qGNasTIBAXmMsivbsSmLf54hVMMAD03f7TK2lmmSj685ECRaSnDe9P090ErFbhWmxXwFvcuBAfjFP/lJ2YUlTlZNkKdpSAMdxeceuI0thoGei0Z6tMiX90VKaGVfzhxdDBtNtKC5CzL4qEhl/o9CNgOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYgbrqaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYgbrqaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBDCC4CEE9;
	Mon, 12 May 2025 18:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073549;
	bh=bSURhbOxLYVZAIY+FhsGSY0IFc4uEQFlb8POPTc3Buk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYgbrqaN/7e4goQ7fXugrJcDcYwYSFWI4+WJZLS6RpmR7h3TlZ80RYn/4Tf1hsCjS
	 5h6yB2LaI9EsDBv6OeOkkOFuKe/MFQ8Z/uLwXqh3tpXOgDvkT3/EHHgi8hobJBvxpK
	 s3kK3oVBuf26T6ETWS4eWL+GS0/LxcBhnNpe0uco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.6 110/113] x86/its: Add support for RSB stuffing mitigation
Date: Mon, 12 May 2025 19:46:39 +0200
Message-ID: <20250512172032.152882365@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit facd226f7e0c8ca936ac114aba43cb3e8b94e41e upstream.

When retpoline mitigation is enabled for spectre-v2, enabling
call-depth-tracking and RSB stuffing also mitigates ITS. Add cmdline option
indirect_target_selection=stuff to allow enabling RSB stuffing mitigation.

When retpoline mitigation is not enabled, =stuff option is ignored, and
default mitigation for ITS is deployed.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    3 +++
 arch/x86/kernel/cpu/bugs.c                      |   21 +++++++++++++++++++++
 2 files changed, 24 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2070,6 +2070,9 @@
 				mitigation.
 			vmexit: Only deploy mitigation if CPU is affected by
 				guest/host isolation part of ITS.
+			stuff:	Deploy RSB-fill mitigation when retpoline is
+				also deployed. Otherwise, deploy the default
+				mitigation.
 
 			For details see:
 			Documentation/admin-guide/hw-vuln/indirect-target-selection.rst
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1189,6 +1189,7 @@ enum its_mitigation_cmd {
 	ITS_CMD_OFF,
 	ITS_CMD_ON,
 	ITS_CMD_VMEXIT,
+	ITS_CMD_RSB_STUFF,
 };
 
 enum its_mitigation {
@@ -1229,6 +1230,8 @@ static int __init its_parse_cmdline(char
 		setup_force_cpu_bug(X86_BUG_ITS);
 	} else if (!strcmp(str, "vmexit")) {
 		its_cmd = ITS_CMD_VMEXIT;
+	} else if (!strcmp(str, "stuff")) {
+		its_cmd = ITS_CMD_RSB_STUFF;
 	} else {
 		pr_err("Ignoring unknown indirect_target_selection option (%s).", str);
 	}
@@ -1279,6 +1282,12 @@ static void __init its_select_mitigation
 		goto out;
 	}
 
+	if (cmd == ITS_CMD_RSB_STUFF &&
+	    (!boot_cpu_has(X86_FEATURE_RETPOLINE) || !IS_ENABLED(CONFIG_CALL_DEPTH_TRACKING))) {
+		pr_err("RSB stuff mitigation not supported, using default\n");
+		cmd = ITS_CMD_ON;
+	}
+
 	switch (cmd) {
 	case ITS_CMD_OFF:
 		its_mitigation = ITS_MITIGATION_OFF;
@@ -1296,6 +1305,18 @@ static void __init its_select_mitigation
 		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
 		set_return_thunk(its_return_thunk);
 		break;
+	case ITS_CMD_RSB_STUFF:
+		its_mitigation = ITS_MITIGATION_RETPOLINE_STUFF;
+		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
+		setup_force_cpu_cap(X86_FEATURE_CALL_DEPTH);
+#ifdef CONFIG_CALL_DEPTH_TRACKING
+		set_return_thunk(&__x86_return_skl);
+#endif
+		if (retbleed_mitigation == RETBLEED_MITIGATION_NONE) {
+			retbleed_mitigation = RETBLEED_MITIGATION_STUFF;
+			pr_info("Retbleed mitigation updated to stuffing\n");
+		}
+		break;
 	}
 out:
 	pr_info("%s\n", its_strings[its_mitigation]);


