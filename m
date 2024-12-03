Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B78B1E3DF9;
	Tue,  3 Dec 2024 16:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242388; cv=none; b=mF5gK88XHo9V8mnt1XzuRG82xwUmEKwxJSoxFVMLVs2nJfc/W87rzlr6PshZ0sb/fg68RA2EWkkCTZzQieUuGqlssl9qgP3JKjOw9Kzaqbose+Fbl7Lf+RC0JLgfmQBkM6dCMD7Ek1zgLcDAaqXiZSkkpkPjCr1mS+ghovzlsgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242388; c=relaxed/simple;
	bh=I2sMxvyNcAXMbdf7hBlKOz07IPnbmgUr+HW2ihqYiyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSpSIh4+SBP8r83xnbTznGZdA5jh5qI8dGMA+Pu1ryCDjsnwAmIuhRDhy1SlY6PyjWmYqRdwJ7Rha0Tz58NofY/uQuQfS1yTfocfmt/DQVdywBjHEzFXWBhmtzpWltFpK6+0QEnmTJrCb/ww4lSOt71hLk7uEAiqRkPWcN1s66M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COhm7DMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COhm7DMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D8EC4CECF;
	Tue,  3 Dec 2024 16:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242388;
	bh=I2sMxvyNcAXMbdf7hBlKOz07IPnbmgUr+HW2ihqYiyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COhm7DMViW196oeUblgA6L0gbP/n11XbI8wbCKFKFAy3/q3MVL338hxxvx94Mso6n
	 GIeT2QxBLfBCwgyLIZlqqtp2t5NxTbb0F0XTW9WISBSbEhKcGYt5BjKIZ9nXwe4Q+f
	 ee+G9OgzdsSL2yyY7eAYLS8pa0wdubvtl+fO+vQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghavendra Rao Ananta <rananta@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.12 646/826] KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status
Date: Tue,  3 Dec 2024 15:46:13 +0100
Message-ID: <20241203144808.948318374@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raghavendra Rao Ananta <rananta@google.com>

commit 54bbee190d42166209185d89070c58a343bf514b upstream.

DDI0487K.a D13.3.1 describes the PMU overflow condition, which evaluates
to true if any counter's global enable (PMCR_EL0.E), overflow flag
(PMOVSSET_EL0[n]), and interrupt enable (PMINTENSET_EL1[n]) are all 1.
Of note, this does not require a counter to be enabled
(i.e. PMCNTENSET_EL0[n] = 1) to generate an overflow.

Align kvm_pmu_overflow_status() with the reality of the architecture
and stop using PMCNTENSET_EL0 as part of the overflow condition. The
bug was discovered while running an SBSA PMU test [*], which only sets
PMCR.E, PMOVSSET<0>, PMINTENSET<0>, and expects an overflow interrupt.

Cc: stable@vger.kernel.org
Fixes: 76d883c4e640 ("arm64: KVM: Add access handler for PMOVSSET and PMOVSCLR register")
Link: https://github.com/ARM-software/sbsa-acs/blob/master/test_pool/pmu/operating_system/test_pmu001.c
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
[ oliver: massaged changelog ]
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20241120005230.2335682-2-oliver.upton@linux.dev
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/pmu-emul.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -342,7 +342,6 @@ static u64 kvm_pmu_overflow_status(struc
 
 	if ((kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)) {
 		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
-		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 	}
 


