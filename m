Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D55473C8D;
	Fri,  9 Oct 2026 14:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557210; cv=none; b=aTsFoblzlo7wbA2FaodIuek6Ba6x7Q4frBU88AO8RJLyzANjRS4hItQHcBO/EpO5XwLaL95PAKjJ+wGh38ItUBHwE6Pt29rIVD3fFErdePjjXHGnb+SU+mmLmzqSWSslbAuXkyuO7hQhq4eY624hTyzcmKwKSwXejnStc6pAaBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557210; c=relaxed/simple;
	bh=2QLK+z6GuG0k0PDFjDOGb2nVM26BT/HWC3zJVNzwaWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCVtQz/PL+IFN+c4og1Lyoaj/uvQ5YsTVoqJkLI/FxxfF98VNypgSfgIZLQGNJJFTNPs3czUp8TjJdaODhjx0gotZQm/kMyLtSP7CL5xhQMyV1EgPgyEe07IebN5PNWknQEkF0GBuZC+up1wvSCLFHCud2tzXXCA8VVdo6ZJJtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nx+R91Cd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nx+R91Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F531F000FF;
	Fri,  9 Oct 2026 14:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557209;
	bh=dgJr2gBvwmc0FujpwoIphYszcuURun2MiVmHGvabXew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nx+R91CdPjlbMKkosFUZc3xdIAhVyN31Tj2HPDgsObhh8BvVXh+FWpboMN0zP5oX5
	 mgrZnpPhApQ9+AEBrbePkCb/GryAViKmcVGlMvEyhI8Jg7bGZth1XhKnLsi/ZoW8sE
	 XmeVCyhw80mOtENLGPB8QwvwKHh552VYgTDfeuys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 319/428] KVM: arm64: Apply the fine-grained UNDEFs without FEAT_FGT
Date: Fri,  9 Oct 2026 16:10:56 +0200
Message-ID: <20261009140953.135061799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

commit 4bdd2b3a708c1feb701cb8b62feb8ad2fd77bb07 upstream.

FGUs don't actually require hardware support, so don't gate fgt trap
config insertion on FGT. This is the only action required to allow FGUs
always, as kvm_calculate_traps() already computes the FGU bits with or
without FEAT_FGT.

This also fixes a spurious WARN when a TLBI OS is run on a guest in vEL1
without FEAT_TLBIOS on non FEAT_FGT hardware. In this configuration the
course-grained HCR_EL2.TTLBOS trap reaches the handler handle_tlbi_el1(),
which expects an EL1 TLBI only from vEL2. With FGUs enabled the UNDEF
will be injected without needing the specific handler.

Fixes: f5a5a406b4b8b ("KVM: arm64: Propagate and handle Fine-Grained UNDEF bits")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>
Link: https://patch.msgid.link/20260929090031.3829185-2-fuad.tabba@linux.dev
[oliver: Take Wei-Lin's suggested changelog]
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/emulate-nested.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2378,9 +2378,6 @@ int __init populate_nv_trap_config(void)
 				print_nv_trap_error(fgt, "FGT bit is reserved", ret);
 			}
 
-			if (!cpus_have_final_cap(ARM64_HAS_FGT))
-				continue;
-
 			prev = xa_store(&sr_forward_xa, enc,
 					xa_mk_value(tc.val), GFP_KERNEL);
 


