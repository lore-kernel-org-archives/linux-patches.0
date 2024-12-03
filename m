Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D52E1AB6C9;
	Tue,  3 Dec 2024 15:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241389; cv=none; b=FO6AvdMAlLKY+lz5f9NLwzB9z/w5ZJP2ZYNGKOnBp9FxyF4ZK8XNdNKwTf0MW4+wHYSbC9xiVTcuamw/Xu1z0+vjjK+4NeGRgqocKzpCUG8AmS8FsDIXumtN42xNvVVgqdRmB6t9NsN+JHgNCCd5wO3Rd3bz9PvRLURNrP+vLRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241389; c=relaxed/simple;
	bh=xtPItZmzbK+QYfInGhsSrLOIBetwo2X3gA36DUtoq5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kzd2ttwTkTDKzER6zRJcru+qzsmmGxcqXnsQCg6SaWcccreALhsrhZcIzOJeOkb9IPa6XUMMRN8qdQcmcbmG9u3WOfJjw/MP3QRIy1gGKJ2GZppbbVWWzA0e4dPlnR7PLUBVi6Z4qhPjk4E1r57eyS7jELLknb/4m/3NjsMxZRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUweB2Dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUweB2Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0874C4CECF;
	Tue,  3 Dec 2024 15:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241389;
	bh=xtPItZmzbK+QYfInGhsSrLOIBetwo2X3gA36DUtoq5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUweB2DcWNPj9h4vaSS4yQ7wy2TMlB+K8vzxI5f5XOeMeyT0H2x0yh3RdP6Mw/z/c
	 MuLEUWAL7aDDgahQi3UerlWY89DUWg/z8SLPB8FsVybIYw9tlyBzMdvIkrXQaI26Z2
	 Fw3Tfe3cW4O4tpcEBa+pHgNP91wb7Ys5wT568/jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 404/826] riscv: kvm: Fix out-of-bounds array access
Date: Tue,  3 Dec 2024 15:42:11 +0100
Message-ID: <20241203144759.520020155@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit 332fa4a802b16ccb727199da685294f85f9880cb ]

In kvm_riscv_vcpu_sbi_init() the entry->ext_idx can contain an
out-of-bound index. This is used as a special marker for the base
extensions, that cannot be disabled. However, when traversing the
extensions, that special marker is not checked prior indexing the
array.

Add an out-of-bounds check to the function.

Fixes: 56d8a385b605 ("RISC-V: KVM: Allow some SBI extensions to be disabled by default")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20241104191503.74725-1-bjorn@kernel.org
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 7de128be8db9b..6e704ed86a83a 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -486,19 +486,22 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
 	const struct kvm_riscv_sbi_extension_entry *entry;
 	const struct kvm_vcpu_sbi_extension *ext;
-	int i;
+	int idx, i;
 
 	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
 		entry = &sbi_ext[i];
 		ext = entry->ext_ptr;
+		idx = entry->ext_idx;
+
+		if (idx < 0 || idx >= ARRAY_SIZE(scontext->ext_status))
+			continue;
 
 		if (ext->probe && !ext->probe(vcpu)) {
-			scontext->ext_status[entry->ext_idx] =
-				KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
+			scontext->ext_status[idx] = KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
 			continue;
 		}
 
-		scontext->ext_status[entry->ext_idx] = ext->default_disabled ?
+		scontext->ext_status[idx] = ext->default_disabled ?
 					KVM_RISCV_SBI_EXT_STATUS_DISABLED :
 					KVM_RISCV_SBI_EXT_STATUS_ENABLED;
 	}
-- 
2.43.0



