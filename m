Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE8C1C32FF;
	Mon, 12 May 2025 17:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072063; cv=none; b=Vco8l4vsEoYc+jyhXhWjvqcH1WZmSIAAgGffNiSNXM6imoCtRl9OoqoAnQtccdtwzSzG94kTIFPDL4M8QMOc2LweKGkRwHhhvfPeNPoOcr9bjLUKXguqKB1kn49GJEn9LtdfsF6EIGGAv88+op34Vk1jxkrPGDzIKZrLJPxuVmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072063; c=relaxed/simple;
	bh=mq1lSOHsBgDs41wpIzAgUhLsbkcrKrEZjKuAtmVjJkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDgGEC9UWaDZXZUV1joxTILkhPn3THk+UiptSJLuvzi44RDLU+8mhJDBAhb8QrJbaRWtHzjq8X60pr5Pvze5k/i9wPxw8SrQPrRVKF7sJqby/3rG5GQilC728DweBbP4LwGNTGOR7IXy/F9eeG/J9Dk8VqbFhHueTbgsYW2uHOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAPvVPZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAPvVPZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5C2C4CEE9;
	Mon, 12 May 2025 17:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072063;
	bh=mq1lSOHsBgDs41wpIzAgUhLsbkcrKrEZjKuAtmVjJkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAPvVPZJl7W83MwSvUVhdLoLUSH3dOXMP9MEWxLzS72L0ttucaSVBRuEfPbHrlo5J
	 m+P9jYxC/75BRXvHqgEvINPYUaQL7oMP/9uVC2z9uvTQ+r9k7t1lzJQjO1It/OMHi6
	 bYpYg2SnFGqogAInRS04wBPIc8l3sdr8W0na03rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.14 125/197] KVM: arm64: Fix uninitialized memcache pointer in user_mem_abort()
Date: Mon, 12 May 2025 19:39:35 +0200
Message-ID: <20250512172049.477843725@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ott <sebott@redhat.com>

commit 157dbc4a321f5bb6f8b6c724d12ba720a90f1a7c upstream.

Commit fce886a60207 ("KVM: arm64: Plumb the pKVM MMU in KVM") made the
initialization of the local memcache variable in user_mem_abort()
conditional, leaving a codepath where it is used uninitialized via
kvm_pgtable_stage2_map().

This can fail on any path that requires a stage-2 allocation
without transition via a permission fault or dirty logging.

Fix this by making sure that memcache is always valid.

Fixes: fce886a60207 ("KVM: arm64: Plumb the pKVM MMU in KVM")
Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/kvmarm/3f5db4c7-ccce-fb95-595c-692fa7aad227@redhat.com/
Link: https://lore.kernel.org/r/20250505173148.33900-1-sebott@redhat.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/mmu.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1489,6 +1489,11 @@ static int user_mem_abort(struct kvm_vcp
 		return -EFAULT;
 	}
 
+	if (!is_protected_kvm_enabled())
+		memcache = &vcpu->arch.mmu_page_cache;
+	else
+		memcache = &vcpu->arch.pkvm_memcache;
+
 	/*
 	 * Permission faults just need to update the existing leaf entry,
 	 * and so normally don't require allocations from the memcache. The
@@ -1498,13 +1503,11 @@ static int user_mem_abort(struct kvm_vcp
 	if (!fault_is_perm || (logging_active && write_fault)) {
 		int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
 
-		if (!is_protected_kvm_enabled()) {
-			memcache = &vcpu->arch.mmu_page_cache;
+		if (!is_protected_kvm_enabled())
 			ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
-		} else {
-			memcache = &vcpu->arch.pkvm_memcache;
+		else
 			ret = topup_hyp_memcache(memcache, min_pages);
-		}
+
 		if (ret)
 			return ret;
 	}


