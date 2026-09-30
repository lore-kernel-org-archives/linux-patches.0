Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A3F51CF44;
	Wed, 30 Sep 2026 18:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793601; cv=none; b=JbgaNOvYWMycKojcfIMxn7i/bYzC/biYYNG+i5rad3kvoXB+PG3erSCM4qMfs2yCrXM09hAG8stSh3ki1ATxJN/dXhP1ZQD1InIn2bb5iGvz2xpFfIvOuLvJdI0vo9CxGP7Dhg8cI/sSR8ZWn0Rnvd2KnjNdI0QZX5YcSRNtMKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793601; c=relaxed/simple;
	bh=42mYmInfmiqG87HEoJLUMypPZ0XwBSIwlfdmDp08urw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiU33f4FCoXiHARTxG4NCrRB/TG3XmZN//RzC15+aWnKJMytLc3uaRybSNam30QtVdV3XOvCQqiredszDqFrJtqWcbgtd95BDLjkB+/NULbj0HFoitYtY8vtVLOCAiVFH302IUBrgCIKk6FqM62GvUgAdzCcEDKA+FQ2yudI0/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zP10F4s5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zP10F4s5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED491F000FF;
	Wed, 30 Sep 2026 18:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793599;
	bh=mQuJFoFAGxQXKBZmz8+J04u0wNt+krVpmukdlZFl5qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zP10F4s5PskvGG2KZ8KWxkMEWdtznZODk+vxd1qURdeXk+lH7P2dyxgN/yNAfVazP
	 LP1RggaDon2JUt1LeLkhh6T07zJlsukK9jHrvbytjfzvLoeFtFEcbVM5G+Om2fRbFO
	 E87dhsuTTyfkjlWOCvMdT0uBK8lz2X0MP/M9OYpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ballesteros <davimaba.v@proton.me>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 310/395] KVM: Ensure memory attributes xarray nodes are accounted to the callers memcg
Date: Wed, 30 Sep 2026 17:29:32 +0200
Message-ID: <20260930152347.379226922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
@@ -1132,7 +1132,7 @@ static struct kvm *kvm_create_vm(unsigne
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
 	xa_init(&kvm->vcpu_array);
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	xa_init(&kvm->mem_attr_array);
+	xa_init_flags(&kvm->mem_attr_array, XA_FLAGS_ACCOUNT);
 #endif
 
 	INIT_LIST_HEAD(&kvm->gpc_list);


