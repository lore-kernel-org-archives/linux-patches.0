Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067341E4938;
	Mon, 21 Oct 2024 10:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506647; cv=none; b=FcApU/p/3ZiVt44MwgX1Otm7vnA33tMuqhYuQ6G4D5dWquyZ/gucOlJlvz8NsRMb4H9PWvs9+ZATFHeVYazmuS4mH4lDrmQkbxm0vPozfk5WHlX1K4R+nu2VRBEKgb1HUk8uPgeyLlI5UTWRZqrKgmabVnwnHQ8ZJHNHBulIuPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506647; c=relaxed/simple;
	bh=jcOHHRcCq8nhlppLmQQArQ75h+Ftt8hrFy/loHKeBD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltCIjM5s+SrPxo/aHw3dMSq9k7lTBw0PMT2e/XOHYKdzz7c09eXxNWB/T6O1fhVELJ1S0wEsFozu1muQRgKB11UXMEefWPNPEjLh4kpRPprTubywknCcNrkdeFhU+hwmFQYRSSpl1vzwXApWSyTXcvHdOfIK8K/T8rua8ScwhaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7t6NIGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7t6NIGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F45C4CEF3;
	Mon, 21 Oct 2024 10:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506646;
	bh=jcOHHRcCq8nhlppLmQQArQ75h+Ftt8hrFy/loHKeBD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7t6NIGjCvbu/CJ/BWgJWIuxVZEjRumLErsr7WgI+2vMnprpcbTzXaBslQzO8ctWM
	 7SeRL3Q3O4+MKk2a0XgUhEvHYiGxhrDEsWJPv+YLrCqHVaPJYC3WCM91PzQWaCJRV4
	 +VrnHYY5r/PcG9l2YPKvhid6mM8TwSij+Oyf6soo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Johannes Wikner <kwikner@ethz.ch>,
	stable@kernel.org
Subject: [PATCH 6.11 044/135] x86/bugs: Skip RSB fill at VMEXIT
Date: Mon, 21 Oct 2024 12:23:20 +0200
Message-ID: <20241021102301.056568621@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1115,6 +1115,14 @@ do_cmd_auto:
 		setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
 		setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
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
 
 	case RETBLEED_MITIGATION_STUFF:
@@ -2632,6 +2640,13 @@ static void __init srso_select_mitigatio
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
 			pr_err("WARNING: kernel not compiled with MITIGATION_SRSO.\n");


