Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425923A48E2;
	Sat, 17 Oct 2026 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254108; cv=none; b=CkBBvwOVN2mgn7hs+6DUpJj6o/C8+pImycZGaEQrh820t1RYheks4L5wr6qac4V9hS0aOgX8KudvadVOgziB1YVT4CjkWSxF0IpubwA+oIVJOIRsg56W6KXh+OPr+j9POGOO/nnJ1YteYkNWCDIFmWu3BUQcRV3s8QxuM2nAwQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254108; c=relaxed/simple;
	bh=jiupGa8YOfvEUa2C8A9+xvRtjsDrnxoo/1HlVZ3DgQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBqIwROzuN+gsJ+DDoYGepororMnvMVIkgbybW65gBX4UBJ9S4Lwn4FLDbBQBsyMD3SScXpwFyFjygV1pmOrcFsVO1/WIfesfZmxwOs4R+XtCjflXYJV520Xy6h5n92bA3ugA0FbtkVP7ipiSJtGjK7qbYoY9yTf9HyZbk6Ky0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TknQ7icB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TknQ7icB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AB41F000C5;
	Sat, 17 Oct 2026 16:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254104;
	bh=aFv01fn9g3mx4M4IE/hZ6aNAADrzyzHPuiqYX7dd7/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TknQ7icBG7FOljRp+LLzW+7Nn+R15gF9BGVQje1A9xYgd646nySj/o1bt8MO2sHTp
	 7WLaML2Ckas2E8d/DpWnRmpDwSF8mKgbJpVw/Tzlk/MwD/TKB4Rm4gh1yf2Lm1GSEb
	 erO728D5pdb6LGhBumStAHVd7t7g17S2r7kGM4UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Andy Chiu <andybnac@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/869] riscv: kvm: fix vector context allocation leak
Date: Sat, 17 Oct 2026 17:52:13 +0200
Message-ID: <20261017160044.559601220@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

[ Upstream commit b7c958d7c1eb1cb9b2be7b5ee4129fcd66cec978 ]

When the second kzalloc (host_context.vector.datap) fails in
kvm_riscv_vcpu_alloc_vector_context, the first allocation
(guest_context.vector.datap) is leaked. Free it before returning.

Fixes: 0f4b82579716 ("riscv: KVM: Add vector lazy save/restore support")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Link: https://lore.kernel.org/r/20260316151612.13305-1-osama.abdelkader@gmail.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_vector.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
index 8454c1c3655a4..eaf88c20508a4 100644
--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -79,8 +79,11 @@ int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
 	cntx->vector.vlenb = riscv_v_vsize / 32;
 
 	vcpu->arch.host_context.vector.datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
-	if (!vcpu->arch.host_context.vector.datap)
+	if (!vcpu->arch.host_context.vector.datap) {
+		kfree(vcpu->arch.guest_context.vector.datap);
+		vcpu->arch.guest_context.vector.datap = NULL;
 		return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
2.53.0



