Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088091E47A5;
	Mon, 21 Oct 2024 10:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506558; cv=none; b=ls3KVZ3UeYFm4YonsSuOcCqg87dcDvslYeNBFmrBw/qSE8BaTlOfMbaoZbOyQmk2TIoQuiLOH36IlvSFIwt7FqOzTF2sM+brviVzH22r6p3ZOxXthMtQdKNIrMyZcBGfgWcBOVyZZnH0nWhocTvVSVqRt9TI6lPvFaUsRoK78mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506558; c=relaxed/simple;
	bh=exa/K0qNrI1Kd4zaI+GHeuRG7oq/xK5DbC9Ky6SPspE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JG7LLrEobXhxoWCyE0LrVRzohY/6gvj8Tk2biGCWHPPZOtcKPMB7N86vywsEit5lWaWD7/YcjyfQvVo/x8zUiZRguB7YLIoUgDInPOa2UOAoew1ctUu6PQ9ORsNWSPm79Tb84B9EwNRQhYE9AyrWE1P8D7p/pO+tuqjPRumODiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Od8tMGa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Od8tMGa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB5DC4CEE5;
	Mon, 21 Oct 2024 10:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506557;
	bh=exa/K0qNrI1Kd4zaI+GHeuRG7oq/xK5DbC9Ky6SPspE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Od8tMGa0Al10tueFO8gu17gZXH8zUX+lDjOQfdq14UTBCTSlLWUYcbPg/Nl2s4cCB
	 RlDZtYKkDRD0e2rmju4imQmSiFJH4lKVmbXz+wMC7r+0ELt1++BWOeUOebIfRTpPjs
	 bQPAiqQ221307Ya6D4jz+FTqhhjkqp1TO+XL8Y2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Johannes Wikner <kwikner@ethz.ch>,
	stable@kernel.org
Subject: [PATCH 6.11 045/135] x86/bugs: Do not use UNTRAIN_RET with IBPB on entry
Date: Mon, 21 Oct 2024 12:23:21 +0200
Message-ID: <20241021102301.095779501@linuxfoundation.org>
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
@@ -1113,6 +1113,15 @@ do_cmd_auto:
 
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
 		setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
 		mitigate_smt = true;
 
@@ -2629,6 +2638,14 @@ static void __init srso_select_mitigatio
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
 			pr_err("WARNING: kernel not compiled with MITIGATION_IBPB_ENTRY.\n");


