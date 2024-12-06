Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49370206F10;
	Fri,  6 Dec 2024 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498070; cv=none; b=sNY/VONUrOxr93EaGRExzpw2d7cu8OqPSyW2PCg1mFB7Ah+L9mfRdd+XxRvDTd6J5G/EQ5o47ooPclL5Csl/Owxp5pgwJgYCMN1AokD1TqxKP6wufFVROKk7opYSArrq/g3XRczEm+QAi2sfDaFKBoe9lYkyUDw93xUQ677nOBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498070; c=relaxed/simple;
	bh=sVix0gnsEuOwKTRJNNEEveR+vwdyMehBi23YYF5sAcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMeKtKRnVqj663JhP8ssR4ZNY4T9vvK1ZTX6AekTtS4n996wBBjSotbm38UQbuFF1LyCHNQlwRaBxUmXpIRRogfg3LH61zaLO5O5cArpGbfOCEv9OT+HmzLMgmH9QIz8JRqKLKAM/+49fcPHG/7tv+p+h0CBRLOGlPrsFeiLLhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uUG33cK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uUG33cK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42878C4CED1;
	Fri,  6 Dec 2024 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498069;
	bh=sVix0gnsEuOwKTRJNNEEveR+vwdyMehBi23YYF5sAcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2uUG33cKENsdJ3onapqNC3BOdkLRtucBcsq4WMElZPXoEZEKDw7UnN8Q4QG9VyI+J
	 JCX5DClSZdTxTaNuE1Am9wIOw9IH12D7t6G8XkIH6xFUD7KdQ4oOPBRfcdCmK6YHJh
	 9w03LwchDOPD+kuFSNwCwkmd74/KGhMQQhXDyGmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautam@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.6 477/676] powerpc/pseries: Fix KVM guest detection for disabling hardlockup detector
Date: Fri,  6 Dec 2024 15:34:56 +0100
Message-ID: <20241206143711.996384347@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Gautam Menghani <gautam@linux.ibm.com>

commit 44e5d21e6d3fd2a1fed7f0327cf72e99397e2eaf upstream.

As per the kernel documentation[1], hardlockup detector should
be disabled in KVM guests as it may give false positives. On
PPC, hardlockup detector is enabled inside KVM guests because
disable_hardlockup_detector() is marked as early_initcall and it
relies on kvm_guest static key (is_kvm_guest()) which is initialized
later during boot by check_kvm_guest(), which is a core_initcall.
check_kvm_guest() is also called in pSeries_smp_probe(), which is called
before initcalls, but it is skipped if KVM guest does not have doorbell
support or if the guest is launched with SMT=1.

Call check_kvm_guest() in disable_hardlockup_detector() so that
is_kvm_guest() check goes through fine and hardlockup detector can be
disabled inside the KVM guest.

[1]: Documentation/admin-guide/sysctl/kernel.rst

Fixes: 633c8e9800f3 ("powerpc/pseries: Enable hardlockup watchdog for PowerVM partitions")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241108094839.33084-1-gautam@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/setup_64.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -924,6 +924,7 @@ static int __init disable_hardlockup_det
 	hardlockup_detector_disable();
 #else
 	if (firmware_has_feature(FW_FEATURE_LPAR)) {
+		check_kvm_guest();
 		if (is_kvm_guest())
 			hardlockup_detector_disable();
 	}


