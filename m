Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3416D1DE4EF;
	Sat, 30 May 2026 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158916; cv=none; b=OT0q9WVHw317vgFw5g3XXLNLGUEtCi8S/9U7GG31vESkutxAiYbE6lNLGqo7fbSMNYJ1hKuzPSHpRIi1Pst1rKRWewGMFwx0er6GfKhpdd41JxTOu3lR2RslHtT08sZLy7YWv/gqbyxRqPEMdVz8XCysMCYhGIPS7LIURz/bap8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158916; c=relaxed/simple;
	bh=Lts9KSEwCdBnq8G3YwSVKycR3EeYBqs3LhKQmAK+0CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYm/ePdgLfoypMhPE6RK2GH1WhF99UcMj+Gfx+7lqec8l20Wsid5c3VQa5dl184uT3e6t2C/ewgaDmgHVuOTVx/+Cxk3jzih2lZ0TR1qetOpCk7A0VuBi4ywEF1OfXmc9uFWppNVGJuE6FDbcg3TeLjSNownsLS8FvEGJNSr5Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmBf5DDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmBf5DDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13FC1F00893;
	Sat, 30 May 2026 16:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158915;
	bh=1lUm4mOAiwBeKQbkmVHfvtdBy/fqf6uAvv8mDkTUGiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmBf5DDB9N36a4bpHNA/jpdq9aBO353iq00rkiKS66YflHZTUqAjzMdsacM5U3zjg
	 3G1B2JktlFM3bSZzo3z/Vs6SBxWbav9boMXjjHtE2NyhQcLJE6jhGBIoAW0IAwbvBz
	 4HGR0zytsJkuwmBlEFntJdrGQtb73SHAFjwxJ9es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Merwick <liam.merwick@oracle.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 087/969] KVM: SEV: Drop WARN on large size for KVM_MEMORY_ENCRYPT_REG_REGION
Date: Sat, 30 May 2026 17:53:31 +0200
Message-ID: <20260530160302.740334093@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 8acffeef5ef720c35e513e322ab08e32683f32f2 upstream.

Drop the WARN in sev_pin_memory() on npages overflowing an int, as the
WARN is comically trivially to trigger from userspace, e.g. by doing:

  struct kvm_enc_region range = {
          .addr = 0,
          .size = -1ul,
  };

  __vm_ioctl(vm, KVM_MEMORY_ENCRYPT_REG_REGION, &range);

Note, the checks in sev_mem_enc_register_region() that presumably exist to
verify the incoming address+size are completely worthless, as both "addr"
and "size" are u64s and SEV is 64-bit only, i.e. they _can't_ be greater
than ULONG_MAX.  That wart will be cleaned up in the near future.

	if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
		return -EINVAL;

Opportunistically add a comment to explain why the code calculates the
number of pages the "hard" way, e.g. instead of just shifting @ulen.

Fixes: 78824fabc72e ("KVM: SVM: fix svn_pin_memory()'s use of get_user_pages_fast()")
Cc: stable@vger.kernel.org
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Liam Merwick <liam.merwick@oracle.com>
Link: https://patch.msgid.link/20260313003302.3136111-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -406,10 +406,16 @@ static struct page **sev_pin_memory(stru
 	if (ulen == 0 || uaddr + ulen < uaddr)
 		return ERR_PTR(-EINVAL);
 
-	/* Calculate number of pages. */
+	/*
+	 * Calculate the number of pages that need to be pinned to cover the
+	 * entire range.  Note!  This isn't simply ulen >> PAGE_SHIFT, as KVM
+	 * doesn't require the incoming address+size to be page aligned!
+	 */
 	first = (uaddr & PAGE_MASK) >> PAGE_SHIFT;
 	last = ((uaddr + ulen - 1) & PAGE_MASK) >> PAGE_SHIFT;
 	npages = (last - first + 1);
+	if (npages > INT_MAX)
+		return ERR_PTR(-EINVAL);
 
 	locked = sev->pages_locked + npages;
 	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -418,9 +424,6 @@ static struct page **sev_pin_memory(stru
 		return ERR_PTR(-ENOMEM);
 	}
 
-	if (WARN_ON_ONCE(npages > INT_MAX))
-		return ERR_PTR(-EINVAL);
-
 	/* Avoid using vmalloc for smaller buffers. */
 	size = npages * sizeof(struct page *);
 	if (size > PAGE_SIZE)


