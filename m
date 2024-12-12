Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6431C223E6B;
	Thu, 12 Dec 2024 16:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022693; cv=none; b=EmyhhmWDZZNMn1Y81HvPm5debwv493bFFxJRto169i92UEO5IPY9ms4Kz+V2G6ddOoohK1XXitdnOUBswy9/IVUnKD8WBOAgidLGxOPgcbuWA+TW5NXmELW9PdpzvnLvCX+SCFVrja7e09Q66NCdCA74ugE6GIF8h2dUuYKMNoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022693; c=relaxed/simple;
	bh=kj+i1eh151Pk5U77DnQiCpFLD9m1i1vVBfSLKnUWECU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIJPQalDT0ivOUYuHdSdP7gZLyUID8GobRvYJd/WcYQltUsYdRirb82NaXMq+qwP/BR/gRIF61v3Z4iP+2AlkivIkYWeLx3bHohRg579uSZTI6iwvrQFlUCd5CECPc+J94GUMeNUr59BTpMOzUs8pjXreUAZYFSDGbHRyn2WaYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5G/94Y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5G/94Y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8979C4CECE;
	Thu, 12 Dec 2024 16:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022693;
	bh=kj+i1eh151Pk5U77DnQiCpFLD9m1i1vVBfSLKnUWECU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5G/94Y8DrkC85d4367J7rOwrmLTSzbmMc36P4jgGmAi4ghpRL4xB2rzfCb8RFO9V
	 1y7dDj4bg9zoPB/Zo6KcjZf/88tfm87ADyOYcO308gE4HaCZe3tkgQSAX6jl3CZEeE
	 b1DNpaOz1Yng8cryrUgTbRG33fLlRBTrVtBocWhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautam@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 310/565] powerpc/pseries: Fix KVM guest detection for disabling hardlockup detector
Date: Thu, 12 Dec 2024 15:58:25 +0100
Message-ID: <20241212144323.859718960@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -952,6 +952,7 @@ static int __init disable_hardlockup_det
 	hardlockup_detector_disable();
 #else
 	if (firmware_has_feature(FW_FEATURE_LPAR)) {
+		check_kvm_guest();
 		if (is_kvm_guest())
 			hardlockup_detector_disable();
 	}


