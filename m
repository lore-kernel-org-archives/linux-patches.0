Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341BF297B92;
	Mon, 12 May 2025 18:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073182; cv=none; b=Uo5RogGCIqPSKsw9bHaoXr5eAmPT6KJGCxyP6uNNIAqMPLHlPFUOdFshH1W3T470scgdInUB5TuQ+kNqMs++FP6VYtxX9taHZjNECosZ2hMg6/NMk1ZCsDDX4yBI2W7w2lZjQzk5SycCIWPeEKE6y9Zb523W7sZE7jc6GoSwgeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073182; c=relaxed/simple;
	bh=B2bSmgXpzwdSPuJtcP4KrQsCKr+ZmZNYnxW6Otgw3Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktcZBf0+yCWihvLRrS/enmuFrlVEKSxxnnHJslXvTzEi+dAOdSUGThHSGW1m1JJt8BpICj24Q9Cbr7zIhvyK7K67FIKcLzEzOvKmLu7ndTL4zK2gEodtyfI4WVGXAQmp2zObjWtAExD8aNRvT8qPHeWG7Mye4l5mdA1bOYbSj3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpKUccUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpKUccUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5DFC4CEE7;
	Mon, 12 May 2025 18:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073182;
	bh=B2bSmgXpzwdSPuJtcP4KrQsCKr+ZmZNYnxW6Otgw3Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpKUccUBk7psOfzK57d8xR7SRBXW8R6TWESAjW1Azp3J86WJ6a1WSjrkmzfsyEQOe
	 tWukMcwRfJRl0rJQ3mCQ34yLj+gx/2mMivCS4pPhnSGXbS0Dt1IYfRvNLM4f8qTVt8
	 0zPjEZoTXCOTcpBBUmg5wmjxgBaCks2YxfIPpDwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.12 180/184] x86/its: Add support for RSB stuffing mitigation
Date: Mon, 12 May 2025 19:46:21 +0200
Message-ID: <20250512172049.136783746@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/kernel/cpu/bugs.c                      |   19 +++++++++++++++++++
 2 files changed, 22 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2159,6 +2159,9 @@
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
@@ -1190,6 +1190,7 @@ enum its_mitigation_cmd {
 	ITS_CMD_OFF,
 	ITS_CMD_ON,
 	ITS_CMD_VMEXIT,
+	ITS_CMD_RSB_STUFF,
 };
 
 enum its_mitigation {
@@ -1230,6 +1231,8 @@ static int __init its_parse_cmdline(char
 		setup_force_cpu_bug(X86_BUG_ITS);
 	} else if (!strcmp(str, "vmexit")) {
 		its_cmd = ITS_CMD_VMEXIT;
+	} else if (!strcmp(str, "stuff")) {
+		its_cmd = ITS_CMD_RSB_STUFF;
 	} else {
 		pr_err("Ignoring unknown indirect_target_selection option (%s).", str);
 	}
@@ -1281,6 +1284,12 @@ static void __init its_select_mitigation
 		goto out;
 	}
 
+	if (cmd == ITS_CMD_RSB_STUFF &&
+	    (!boot_cpu_has(X86_FEATURE_RETPOLINE) || !IS_ENABLED(CONFIG_MITIGATION_CALL_DEPTH_TRACKING))) {
+		pr_err("RSB stuff mitigation not supported, using default\n");
+		cmd = ITS_CMD_ON;
+	}
+
 	switch (cmd) {
 	case ITS_CMD_OFF:
 		its_mitigation = ITS_MITIGATION_OFF;
@@ -1298,6 +1307,16 @@ static void __init its_select_mitigation
 		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
 		set_return_thunk(its_return_thunk);
 		break;
+	case ITS_CMD_RSB_STUFF:
+		its_mitigation = ITS_MITIGATION_RETPOLINE_STUFF;
+		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
+		setup_force_cpu_cap(X86_FEATURE_CALL_DEPTH);
+		set_return_thunk(call_depth_return_thunk);
+		if (retbleed_mitigation == RETBLEED_MITIGATION_NONE) {
+			retbleed_mitigation = RETBLEED_MITIGATION_STUFF;
+			pr_info("Retbleed mitigation updated to stuffing\n");
+		}
+		break;
 	}
 out:
 	pr_info("%s\n", its_strings[its_mitigation]);


