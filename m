Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126441E47B4;
	Mon, 21 Oct 2024 10:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507100; cv=none; b=XgBBAN2gZ3Ysb2I4Vg6wb4q+fKqBawbZcMSTmlWsKjrfxvl+Tr/kyUSHKZziG9VICtU6xSb17pKMzarcwwHCtucGCN+TSIYDNZ5YI+6xQdVvzG8Xs+m7PPc4jzY9RI6HdB3R3F/+nC+/rRul8c400twhAaIuNm7+y0IXs2aytQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507100; c=relaxed/simple;
	bh=zjtGK5ZZhyR5sZyO2j8YQzOOipLRtk7UTmL8+bkOI7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrRHNwnIkd1HWO3AqucR18EpSY1cXLqnC6bAX9eRPE1mlbF09gPqnWVHT556+IwjW7Eap0kRTfECqUXa2XJPLbWpE2/xs5iyqhGxDSsrD+YVp396F/l/GVYKbZSxvv4RckuDOaAxCVMxyzZlB3rywyR4LKwh4g00GSfZVGMwgdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OY6j2vU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OY6j2vU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FFEC4CEC7;
	Mon, 21 Oct 2024 10:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507099;
	bh=zjtGK5ZZhyR5sZyO2j8YQzOOipLRtk7UTmL8+bkOI7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OY6j2vU7xM/MbeiLXWtu6aW42yurl3rL0MIO+0Nx7yhtGylBQUbyS4Slo/DU8h/kV
	 dFcarm96giefNTl6P5sK0xXSDFh8ntFJw+oH81Z2gdUlFqgqpThdbhgoVaMd17yajD
	 dqv6NsoRQ81HczalrRdNAy0S4aCKtLp8mhh7AR7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Johannes Wikner <kwikner@ethz.ch>,
	stable@kernel.org
Subject: [PATCH 6.6 058/124] x86/bugs: Do not use UNTRAIN_RET with IBPB on entry
Date: Mon, 21 Oct 2024 12:24:22 +0200
Message-ID: <20241021102258.977676880@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -2618,6 +2627,14 @@ static void __init srso_select_mitigatio
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


