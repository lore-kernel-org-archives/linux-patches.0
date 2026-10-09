Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC244E50B4;
	Fri,  9 Oct 2026 14:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557371; cv=none; b=bpkmmBXzgzUGXgUbUs5sv9CmHU+z+QgIpHLpzk1odEjyWazGqRNeaADZDrz4gRxycMYDkd3HUU2kcCyGbTpHuONHpnP0jLjA4pzbu+cnfeXA1JtppGPHGr4cqn/fBWRRQWAi9pwJy8Wp0wHa2QXe3XIijZttxfri7t0+EX8YSys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557371; c=relaxed/simple;
	bh=1zcxfBz8ChhpJP05EpCN1EnvcWluNITdI8FzTFQpmuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AC1l7yZy3VkJ3ZRQxaxKzG7ue0WJSFw2POaFE7kGBZ5Wjm6/Eqli7vlcCrJsBv+UAtzAlMfy/53y2kDkG/IqAmRYdXdsh7Qy0Je2SlHeNCnnI6gsiCU24jFDIZkZ9+RPDsqIS5CGDpk3UvZCBbDsE+GnI4mhnoR5oiG4JohBoRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAWn2G0z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAWn2G0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E761F000FF;
	Fri,  9 Oct 2026 14:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557369;
	bh=B3awyfdX7JycMKpFoAtQXFD1hwopV9DFpTWtEMO9Mk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pAWn2G0z3bHrV7z58L/4JhlB6FQhlYbVxw2bMmWviIWu3KLUKS7I59/qEbYP6DGXX
	 0JiKXrOA92UTOHCbjAKaulcblTqJbTg8Q5F6NQX+vRCYOcNTkkVig2tDoydC34Ee7L
	 QQWv7X6RFA+d+Ujil6DkyeHpEbjhlPMtA/Ypypm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 389/403] KVM: arm64: Always populate FGT masks at boot time
Date: Fri,  9 Oct 2026 16:12:30 +0200
Message-ID: <20261009141001.439368743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 54adbfe40e3b6d238293cc36ef071ed9f35c8af7 ]

We currently only populate the FGT masks if the underlying HW does
support FEAT_FGT. However, with the addition of the RES1 support for
system registers, this results in a lot of noise at boot time, as
reported by Nathan.

That's because even if FGT isn't supported, we still check for the
attribution of the bits to particular features, and not keeping the
masks up-to-date leads to (fairly harmess) warnings.

Given that we want these checks to be enforced even if the HW doesn't
support FGT, enable the generation of FGT masks unconditionally (this
is rather cheap anyway). Only the storage of the FGT configuration is
avoided, which will save a tiny bit of memory on these machines.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Fixes: c259d763e6b09 ("KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co")
Link: https://lore.kernel.org/r/20260120211558.GA834868@ax162
Link: https://patch.msgid.link/20260122085153.535538-1-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Stable-dep-of: 4bdd2b3a708c ("KVM: arm64: Apply the fine-grained UNDEFs without FEAT_FGT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/emulate-nested.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2269,9 +2269,6 @@ int __init populate_nv_trap_config(void)
 	kvm_info("nv: %ld coarse grained trap handlers\n",
 		 ARRAY_SIZE(encoding_to_cgt));
 
-	if (!cpus_have_final_cap(ARM64_HAS_FGT))
-		goto check_mcb;
-
 	for (int i = 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
 		const struct encoding_to_trap_config *fgt = &encoding_to_fgt[i];
 		union trap_config tc;
@@ -2291,6 +2288,15 @@ int __init populate_nv_trap_config(void)
 			}
 
 			tc.val |= fgt->tc.val;
+
+			if (!aggregate_fgt(tc)) {
+				ret = -EINVAL;
+				print_nv_trap_error(fgt, "FGT bit is reserved", ret);
+			}
+
+			if (!cpus_have_final_cap(ARM64_HAS_FGT))
+				continue;
+
 			prev = xa_store(&sr_forward_xa, enc,
 					xa_mk_value(tc.val), GFP_KERNEL);
 
@@ -2298,11 +2304,6 @@ int __init populate_nv_trap_config(void)
 				ret = xa_err(prev);
 				print_nv_trap_error(fgt, "Failed FGT insertion", ret);
 			}
-
-			if (!aggregate_fgt(tc)) {
-				ret = -EINVAL;
-				print_nv_trap_error(fgt, "FGT bit is reserved", ret);
-			}
 		}
 	}
 
@@ -2318,7 +2319,6 @@ int __init populate_nv_trap_config(void)
 	kvm_info("nv: %ld fine grained trap handlers\n",
 		 ARRAY_SIZE(encoding_to_fgt));
 
-check_mcb:
 	for (int id = __MULTIPLE_CONTROL_BITS__; id < __COMPLEX_CONDITIONS__; id++) {
 		const enum cgt_group_id *cgids;
 


