Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A255A1EBFFD;
	Mon, 21 Oct 2024 10:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507795; cv=none; b=jQw1/1wqhuDLC2GhfQi23ErHLSdshBx8FpEmxsxA0HqXh3ZTI1TIR/j38r2BeeMPGN5MDhrdCbcVxEP/mTxsgquJizf/x4s2APxEWMx9Bpby8jf5dDwsaFxIWwUxpdUR74YfLtmU6RPdUWpT9RQYKH/pgKHLk/aSjJcQFpfO5oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507795; c=relaxed/simple;
	bh=NDPlvmL2PYNOm9YLrEEpgeZwkAQ8E+QQ6d4dkSC3NQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J07qh+f6qrNtdhGRrXiC+LeGULHLu3VYYm/9zMKeEYEtNEfP23lKkqWKSjxpFoWy8tvtggeA+rUIscxLklSDpc2IpvBpS4WQjI3xH+rAhlynqqWbNRLopy7tl3jtiCHOpy1pe5zK2QGd00W2AExO86zd+cA9svbIAYFnHSBvTGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E75OZ2Ev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E75OZ2Ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCDDC4CEE6;
	Mon, 21 Oct 2024 10:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507795;
	bh=NDPlvmL2PYNOm9YLrEEpgeZwkAQ8E+QQ6d4dkSC3NQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E75OZ2EvxcHV5NmpcadgT4icvp73LUj/94J2NUoZbELJpEwpifADcc6ldCcpESttt
	 E4XUMpeh890BAW13vdrUbXcicvwlXv2DxDHg17FJeaF9w5cti0xBxkUcEEdLFa+iRb
	 jmz/ixwCMbmsKWpfVZd3BlUGB2o0JIqj9WdywUKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Johannes Wikner <kwikner@ethz.ch>,
	stable@kernel.org
Subject: [PATCH 5.10 21/52] x86/bugs: Do not use UNTRAIN_RET with IBPB on entry
Date: Mon, 21 Oct 2024 12:25:42 +0200
Message-ID: <20241021102242.455367749@linuxfoundation.org>
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

commit c62fa117c32bd1abed9304c58e0da6940f8c7fc2 upstream.

Since X86_FEATURE_ENTRY_IBPB will invalidate all harmful predictions
with IBPB, no software-based untraining of returns is needed anymore.
Currently, this change affects retbleed and SRSO mitigations so if
either of the mitigations is doing IBPB and the other one does the
software sequence, the latter is not needed anymore.

  [ bp: Massage commit message. ]

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Johannes Wikner <kwikner@ethz.ch>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1061,6 +1061,15 @@ do_cmd_auto:
 
 	case RETBLEED_MITIGATION_IBPB:
 		setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
+
+		/*
+		 * IBPB on entry already obviates the need for
+		 * software-based untraining so clear those in case some
+		 * other mitigation like SRSO has selected them.
+		 */
+		setup_clear_cpu_cap(X86_FEATURE_UNRET);
+		setup_clear_cpu_cap(X86_FEATURE_RETHUNK);
+
 		mitigate_smt = true;
 
 		/*
@@ -2461,6 +2470,14 @@ static void __init srso_select_mitigatio
 			if (has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
 				srso_mitigation = SRSO_MITIGATION_IBPB;
+
+				/*
+				 * IBPB on entry already obviates the need for
+				 * software-based untraining so clear those in case some
+				 * other mitigation like Retbleed has selected them.
+				 */
+				setup_clear_cpu_cap(X86_FEATURE_UNRET);
+				setup_clear_cpu_cap(X86_FEATURE_RETHUNK);
 			}
 		} else {
 			pr_err("WARNING: kernel not compiled with CPU_IBPB_ENTRY.\n");


