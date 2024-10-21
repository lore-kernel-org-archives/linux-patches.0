Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE071EBFFD;
	Mon, 21 Oct 2024 10:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507792; cv=none; b=LLCq3ysLOkCgOetDomqvsfH+/c3UtHuQ26rWl51m/pedLEMn/5pyHMkMJcTLiuwn3UqTYhzEQB9mlZvTWdK4Kk6oxZykqpqo7w6PCMJeBi8TEON9JDvB8v/Ro4EEF/VpcqrP4FwmljMGGe9nETFN1OLe103uqnWxLZAOpNC0/qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507792; c=relaxed/simple;
	bh=Iz3atXoJuy4EzJ6DtlNHe1j0U4+rc3V7/db6MYoPmq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffGDgUOkpdr0bPXhY3odpQuwiu0561tX2zyRYWpsiV4nObYyRN4sM8F1t6+7uBrBVdOGgiV4qOXsBQbLK79TBzf8qeD3f5uXrijqhTsnO6+vTAYHYW92nb+flxu24eiN6c9rOCPo4R7l++POBGa0gqhzdvNU1Zk0W1PEImbb9C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsMCy3xe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsMCy3xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7F8C4CEE5;
	Mon, 21 Oct 2024 10:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507792;
	bh=Iz3atXoJuy4EzJ6DtlNHe1j0U4+rc3V7/db6MYoPmq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsMCy3xeGwlPPxr0+CcPUEEDlBqzglLQXS/2ROsrn51PbT2odTRz/F+bfFguBId1b
	 kWhK+gUvhSlXdBsBx04YCKCM/9ExUNKDFvnrsbXvfcUtuLLJrmhQpOqxck8u+0iHkI
	 s7+koqzmOQt01nB0wKpbBeiI44i68sU5tNePXkOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Johannes Wikner <kwikner@ethz.ch>,
	stable@kernel.org
Subject: [PATCH 5.10 20/52] x86/bugs: Skip RSB fill at VMEXIT
Date: Mon, 21 Oct 2024 12:25:41 +0200
Message-ID: <20241021102242.416752755@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Wikner <kwikner@ethz.ch>

commit 0fad2878642ec46225af2054564932745ac5c765 upstream.

entry_ibpb() is designed to follow Intel's IBPB specification regardless
of CPU. This includes invalidating RSB entries.

Hence, if IBPB on VMEXIT has been selected, entry_ibpb() as part of the
RET untraining in the VMEXIT path will take care of all BTB and RSB
clearing so there's no need to explicitly fill the RSB anymore.

  [ bp: Massage commit message. ]

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Johannes Wikner <kwikner@ethz.ch>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1062,6 +1062,14 @@ do_cmd_auto:
 	case RETBLEED_MITIGATION_IBPB:
 		setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
 		mitigate_smt = true;
+
+		/*
+		 * There is no need for RSB filling: entry_ibpb() ensures
+		 * all predictions, including the RSB, are invalidated,
+		 * regardless of IBPB implementation.
+		 */
+		setup_clear_cpu_cap(X86_FEATURE_RSB_VMEXIT);
+
 		break;
 
 	default:
@@ -2465,6 +2473,13 @@ static void __init srso_select_mitigatio
 			if (!boot_cpu_has(X86_FEATURE_ENTRY_IBPB) && has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
 				srso_mitigation = SRSO_MITIGATION_IBPB_ON_VMEXIT;
+
+				/*
+				 * There is no need for RSB filling: entry_ibpb() ensures
+				 * all predictions, including the RSB, are invalidated,
+				 * regardless of IBPB implementation.
+				 */
+				setup_clear_cpu_cap(X86_FEATURE_RSB_VMEXIT);
 			}
 		} else {
 			pr_err("WARNING: kernel not compiled with CPU_SRSO.\n");


