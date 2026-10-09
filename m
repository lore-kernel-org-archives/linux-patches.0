Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEC64E50BD;
	Fri,  9 Oct 2026 14:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557376; cv=none; b=ZrBe/lIodnykovG4U4SNJ3X1GQ6QGQgUKTgXvRr2THvXGWicbgQrv7nwSqBQ9YhHBto7nxYwCxC0x4LFadmCzNNq0H11pHEA1rO4SNL46E5kkqNQANLPSR6XYEmgHdN1SJJfmwaKpaqYNwr2kPyNn/wV/rQOJ2Cw5GuQ/rLwA6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557376; c=relaxed/simple;
	bh=eOFEc9CD6N8uDollueV0XhXKKrMgoZpRhVcRm0FolHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yl14ZjLiL3xxTxflYUedjLsgnCCxdOpJdNwsodI/LmTypUwIGuOEPQNDcj9c8mXjIxaqL/9oRMaf2EXAncLwzGf6IzLP37xEWc6JmZU4s8B74Jb08sLj8wHKSiwyHm6kCLsXcehHTboXsgdLkoWvYaH5tYwcnOyPaTSSBHctgSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm5J4bln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm5J4bln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8CE1F000FF;
	Fri,  9 Oct 2026 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557375;
	bh=xvvegFnfqSrgqwhrbAS+R1mwhka9cUJgYA3KqIromWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bm5J4blnRPvUCXU/DvOiQzVFhgQ8LdazxOLj5YwaExKr6FH93Yv8QxB3MFfVF66nn
	 pLJnncI7ygIFRpAgHlUV5r67Zka1hveNc/BwBpxNIqgWfFtomS8FP34tnEUHW8g82D
	 JazFal1/YaHDCMmBMlVT5ytgucbv3B23h9fEbP44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 390/403] KVM: arm64: Apply the fine-grained UNDEFs without FEAT_FGT
Date: Fri,  9 Oct 2026 16:12:31 +0200
Message-ID: <20261009141001.463968667@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 4bdd2b3a708c1feb701cb8b62feb8ad2fd77bb07 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/emulate-nested.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2294,9 +2294,6 @@ int __init populate_nv_trap_config(void)
 				print_nv_trap_error(fgt, "FGT bit is reserved", ret);
 			}
 
-			if (!cpus_have_final_cap(ARM64_HAS_FGT))
-				continue;
-
 			prev = xa_store(&sr_forward_xa, enc,
 					xa_mk_value(tc.val), GFP_KERNEL);
 


