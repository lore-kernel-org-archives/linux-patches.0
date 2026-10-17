Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3897436B93B;
	Sat, 17 Oct 2026 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254069; cv=none; b=ovvljKbRET1KFEXd5dyVE+BLnVazP47+6wWQKNcqyHtJv7w7eetgNrATrJApqoUt7Q3UrBDwmliF7Y8CkuF/Q2VmExHNZyXNhkp8BEkIdDhmF1M90f+fIsGMsmrKjA5YxAERGGKP7bdp6N/RDinS2xXaIgxi3sLC4WJRbY1WCX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254069; c=relaxed/simple;
	bh=AKmlhs+4xYNGa/EpvKnn1v9PQkP8KbsJyYSJBkvfcfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqcQxM9NAv6rHoIdNaSNmLT36yO77y++AT4tf+K/HMJ764nCAN5tJ8d7GvIBU7GmIl02xA+TDev5ACVrUyu1z8E4bbe0gjVAGP2zgMR3XW7TdvycNkGj5Wvcp0fwQdBlPlALrJPJu9of83BvN3KG5hGraWejQVcdKr4Cz7weYPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Agh5gUo3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Agh5gUo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860581F000C4;
	Sat, 17 Oct 2026 16:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254068;
	bh=0JBG1yIcOBeBkZX2Cm8wJfAWS/s+o4BrI8VT+0EE3R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Agh5gUo3bUEr3CtMrWvjHXz+rkHNhMYO/qMcQW60nPLLdWqOWubMXoPqFcH6tSy/R
	 a5ViWakYVAq1+AsQabc/Vp8EpjOucfQ+aS9gSD9tnwWJNrpMpCc9q36p9TI2c61kAa
	 RbJbOSB+MnL/W6KaMExjns3xrSrebBAliD5nAeYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 324/869] KVM: arm64: Take the SRCU lock for page table walks in fault injection and AT emulation
Date: Sat, 17 Oct 2026 17:52:45 +0200
Message-ID: <20261017160045.384340708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit f2ca45b50d4216c9cc7ffabf50d9ad1932209251 ]

walk_s1() and kvm_walk_nested_s2() expect to be called while holding
kvm->srcu to guard against memslot changes. While this is generally
the case, __kvm_at_s12() and __kvm_find_s1_desc_level() call into the
respective walkers without taking kvm->srcu.

Fix by acquiring kvm->srcu prior to the table walk in both instances.

Cc: stable@vger.kernel.org
Fixes: 50f77dc87f13 ("KVM: arm64: Populate level on S1PTW SEA injection")
Fixes: be04cebf3e78 ("KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}")
Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/aiAZfdeyanIvP8SD@v4bel
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/at.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 39f0e87a340e8..8192bc0bbc87b 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1087,7 +1087,8 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	/* Do the stage-2 translation */
 	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
 	out.esr = 0;
-	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
+	scoped_guard(srcu, &vcpu->kvm->srcu)
+		ret = kvm_walk_nested_s2(vcpu, ipa, &out);
 	if (ret < 0)
 		return;
 
-- 
2.53.0



