Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDE251597D;
	Wed, 30 Sep 2026 17:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789012; cv=none; b=ARHs3GD+yIEJeay8i+w7G7D57JkOt3umbRao0X8auVB5Xpdo5aQ1+0qH1E3NKy9vOeYjYjn3mhDJpR0XlrWVJhKOTqC9bgHfMBbnfrEZGdNrCmqnQM3o1FETVP/hw0br77D03XUKb2vRZRXqxXizQq0qaYzqaAqN/bUjHYVWMxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789012; c=relaxed/simple;
	bh=ybeRIqFfb+JBt5gQgK+IdZgDatQK56qg6t1JdsviRV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiF/0wtoxiCNpIt0BKGR2UQF6a4cewmiEMF07yHupc/PnsDen2RwTvYoMwCf3WcUgehfyY7Vqnx9VSeMMhEkj5nCDiKDj+6JGxu8wINXmBzYCXYioPn89xJwR146tENESJDGqLxpWcDxirKve2VQixSeY+x+3a8CfjDWvvTBmxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnnrgeEp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnnrgeEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8311F000FF;
	Wed, 30 Sep 2026 17:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789011;
	bh=XD+JwHlfdwA3skKo+F+xVGdsx1/kynEjLlgAfsSaSRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnnrgeEpAMnQqdZsl3ijibqs82LOVdSiN13L7ChGht5zl4R00A+EJ1lLDivrLtcYD
	 UFBtAEhlKBrrDV4ke1gyTIdDPzuyah73XGzOPrQSmlSleJWvi+rjMQHzOq05XE9uY5
	 9CyuMRv5bcMp3DXt6Z8X4Tc3++X2+GXL+y4Vg7/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 327/877] KVM: arm64: Return -EINVAL for an empty SMCCC filter range at base 0
Date: Wed, 30 Sep 2026 17:20:38 +0200
Message-ID: <20260930152421.740311515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 64dc6f1db7e620f2e9337bb181f305fb0561da79 ]

kvm_smccc_set_filter() only rejects a range if its inclusive end,
base + nr_functions - 1, is below base. That catches an empty range
(nr_functions == 0) at every nonzero base, but at base 0 the end wraps
to U32_MAX and KVM tries to insert [0, U32_MAX], which overlaps the
reserved Arm Architecture Calls ranges. KVM_ARM_VM_SMCCC_FILTER then
returns -EEXIST instead of the -EINVAL that the smccc_filter selftest
expects for an empty range.

Reject a zero function count explicitly.

Tested with a userspace reproducer on an arm64 VHE host under QEMU TCG:
EEXIST before, EINVAL after.

Fixes: 821d935c87bc ("KVM: arm64: Introduce support for userspace SMCCC filtering")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260829054856.70549-2-kmehltretter@gmail.com
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hypercalls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index ee6573befb813..82af201d60285 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -183,7 +183,8 @@ static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user
 	start = filter.base;
 	end = start + filter.nr_functions - 1;
 
-	if (end < start || filter.action >= NR_SMCCC_FILTER_ACTIONS)
+	if (!filter.nr_functions || end < start ||
+	    filter.action >= NR_SMCCC_FILTER_ACTIONS)
 		return -EINVAL;
 
 	mutex_lock(&kvm->arch.config_lock);
-- 
2.53.0



