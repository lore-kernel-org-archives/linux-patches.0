Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E69519E1E;
	Wed, 30 Sep 2026 17:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789597; cv=none; b=SknEexTIDb/OqaT1B3TplTiRDw7bpA1hBrNeiv0bnsfRlbNYJ7lSOJKMddStP37GE8i1VNaEVwnovtn2FUy32Jt97mwbBkDjhe35NFmoVnimAp0v4cW9zzao2uH+wqdQOaO7I2p/RXxlcixmXMl09Ar17ELvJFdQEBNUR4PL0wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789597; c=relaxed/simple;
	bh=Ee0eCohBvdTCgSy7a9KE6nZ3gNrjFbtwEbmnPXLMd34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRPc33VXu7aMlNwCOJLNMKDnekkwSoo2BLehdUbpgiKB2SJBnFhIS1tNO+MRzoPp62gj/yhBvrI/A/GYwhs6EeFF9+qWt3IfUmTg7u8yv9ravZ5EYsRHvw+45o5N8m+Od5VHu1Yc5YnXWZKqZQo2zqAqknqmCXfRgi45KoMQ8ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQaE0Bso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQaE0Bso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAC81F000FF;
	Wed, 30 Sep 2026 17:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789595;
	bh=9M4ioaAExIA/9uXEmj/a9HqMYtUTOpuBA0sAmQIpJpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQaE0Bso22gN02/uJpkle2+0r14ngG4gkrO0RspDDwl1qFlYMdhd7rNy+8Q7d8NF+
	 FuGOr+0d7AvO4TBxA0/K2qOxdR6O6aoAYXraWd9dP3NPAnGWVi/cV6xWlhEBE+F7ot
	 75P6WYm/PFcKaJ0IEXida8O20GuXWoiWib0ybHJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ballesteros <davimaba.v@proton.me>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 532/877] KVM: Ensure memory attributes xarray nodes are accounted to the callers memcg
Date: Wed, 30 Sep 2026 17:24:03 +0200
Message-ID: <20260930152426.124874459@linuxfoundation.org>
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

From: David Ballesteros <davimaba.v@proton.me>

commit 382e5d514b6f35bdda2ab9044b4eed23d2ec4254 upstream.

Explicitly instantiate the memory attributes xarray with XA_FLAGS_ACCOUNT
to ensure that all allocations are accounted to the memcg.  Frustratingly,
memory allocations done in the "fastpath" do not honor the passed in gfp,
even for an explicit xa_reserve().  Only the rare, slow path __xas_nomem()
honors the original gfp.  E.g.

  xa_reserve(..., GFP_KERNEL_ACCOUNT)
  |
  -> ...
     |
     -> __xa_cmpxchg_raw()
        |
        -> xas_store()  <== does not take @gfp
           |
           -> xas_create()
              |
              -> xas_alloc()

The bug was confirmed by observing that a process in a cgroup limited to
256 MiB grew radix_tree_node slab by ~512 MiB while its memory.current
stayed near 0.

Fixes: 5a475554db1e ("KVM: Introduce per-page memory attributes")
Cc: stable@vger.kernel.org
Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: David Ballesteros <davimaba.v@proton.me>
Link: https://patch.msgid.link/20260915175335.138547-4-davimaba.v@proton.me
[sean: rewrite changelog, tag for stable]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1164,7 +1164,7 @@ static struct kvm *kvm_create_vm(unsigne
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
 	xa_init(&kvm->vcpu_array);
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	xa_init(&kvm->mem_attr_array);
+	xa_init_flags(&kvm->mem_attr_array, XA_FLAGS_ACCOUNT);
 #endif
 
 	INIT_LIST_HEAD(&kvm->gpc_list);


