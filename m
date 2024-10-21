Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174D81F1306;
	Mon, 21 Oct 2024 10:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507349; cv=none; b=LpW2dGbUe7WaBfpmlHTiyuWb24Fbdoav0O2RS/YVrcFWtqc4wU8irc3ygLEM5ldlEXmoSKfMCRZu7HlArL/8AomGIGTWXTx34/3RByo3LTQAt1Xla9E2zS8Ntsn133DG4Up0s0qa3mwsaaTkvEn2C/d4nu58D8BA+U7E6BkmLtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507349; c=relaxed/simple;
	bh=dilGsiUiLHQPJ8xj59gU2+yecWAE5nJAjmB4Y+uGM3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chmtal8+d8QteS4gdgZRZshmvJW6+JmvpjZHUkffyKcJZmQIwbLakT7L2lStsxyWwKej0Qp6gMOgHE7MrLb1TUHZalDOOrsjYz7nvWtkoxKYexnWRFUb7FSfoqXubHO2w3iDOYvha0QcsY5ZzEx3iOhc8cLoXOiN4zvZz48DENg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKvvzT/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKvvzT/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7F7C4CEC7;
	Mon, 21 Oct 2024 10:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507348;
	bh=dilGsiUiLHQPJ8xj59gU2+yecWAE5nJAjmB4Y+uGM3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKvvzT/vnh6xAN+AgbOppU7+wWLHAXgUIQq9I4hlw0owFwa9k3A9KBzbjzPn6A2JW
	 iFv1vcYiGDZMxCw/MZj4E0I8HCK9wifXGGDFBZeCjOzjp6EjJly5JovYhEUNFZLnSg
	 NFwpu1tfUkiGBEmIrAuU8tal2yykUKOgStIAANpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Johannes Wikner <kwikner@ethz.ch>,
	stable@kernel.org
Subject: [PATCH 6.1 47/91] x86/bugs: Do not use UNTRAIN_RET with IBPB on entry
Date: Mon, 21 Oct 2024 12:25:01 +0200
Message-ID: <20241021102251.656108302@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1092,6 +1092,15 @@ do_cmd_auto:
 
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
@@ -2599,6 +2608,14 @@ static void __init srso_select_mitigatio
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


