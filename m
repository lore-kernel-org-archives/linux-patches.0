Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996F31F707A;
	Tue,  3 Dec 2024 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239626; cv=none; b=kSC/BCavd7euR7trB56AMGITQTxm4teXwt83B6yE8hKICFhViV8hFUobUJB+m5EiCQ88C+zdpav97LbRHwQ/t2x5oRglOw5jMIy6GoJzB+r8LaAtLg6kt5JyEnfuhqxhybAmYlTakU0/dip6CZYlz7fL1V6Xo74CTvb/DznLkwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239626; c=relaxed/simple;
	bh=0tvd5s/tu9tDD9nXNXWLbiH245FFf1RSFDBMOY2QOuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nB+9nyvQoU0U6XipuK/zdse7a1bp3qtOqcqN+YnIIqBgejngVbc5nO9thNal4qGCZL4bwBMUp2mU0xfFCBtxOcMPJoFxS6kgsNPyUVllb2+B/F2iD7crxem7c5NWRYRaBDdMlO0fuEla3dXT/Bb5oeKlFA167gdVzNEoPXujwg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jEGwy7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jEGwy7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39B1C4CECF;
	Tue,  3 Dec 2024 15:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239626;
	bh=0tvd5s/tu9tDD9nXNXWLbiH245FFf1RSFDBMOY2QOuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jEGwy7K5V6yf9KbUbyWyvR0MF40i2Aq1aC+yLdLRUl8j2B2SXb+fr+QuCGvWpJYE
	 LQHJD6FCqKeu9XnT/KBiq9N/cMq1cdMEb6Sa44sVNuwlvnseM1rYPbSmejjGPIgp8B
	 Rs34ATJ0bSQ1gZBfPmOhetU3q/d0FukjvjNWIR2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautam@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.11 647/817] powerpc/pseries: Fix KVM guest detection for disabling hardlockup detector
Date: Tue,  3 Dec 2024 15:43:39 +0100
Message-ID: <20241203144021.211979345@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
@@ -920,6 +920,7 @@ static int __init disable_hardlockup_det
 	hardlockup_detector_disable();
 #else
 	if (firmware_has_feature(FW_FEATURE_LPAR)) {
+		check_kvm_guest();
 		if (is_kvm_guest())
 			hardlockup_detector_disable();
 	}


