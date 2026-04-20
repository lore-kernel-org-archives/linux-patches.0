Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D62933F586;
	Mon, 20 Apr 2026 16:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701072; cv=none; b=IatcmhJz04hXafPcJUpkm6Ke6WxzH96+sheDjDshE2WFiLnH5N12O5JmsJ9opo8SOHHgKAtYnTwJiopCQK7rEAK+E+4LaWxojvf0b8ta4lZZMYFkEmpabUhwbPanba22CsUhy9wDJ4/Y++E3knKDLTUkWHJGISdQFqQG43Gu/FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701072; c=relaxed/simple;
	bh=mR3PhMMVDi/Z8slmmcUbR6dzFnTXLtjbGTj/xgyITSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ss1gNDDP+3SZYwuUWzIWz2IEp+SA4kbtf2bcG6SuSdNnxW3xVrwHl/k9NfXCYbCt9xFyg3xUAMUAh2t6pChQtqyccpk8NvOfx7Fhqn571Uiym1HPi1kUDb/3+ptr5FlHOcthwjcSHqIwJX2Kptt2kPuI5Sr1nnZdVfqF0EPO934=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XM06AZ/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XM06AZ/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7E8C19425;
	Mon, 20 Apr 2026 16:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701072;
	bh=mR3PhMMVDi/Z8slmmcUbR6dzFnTXLtjbGTj/xgyITSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XM06AZ/zxpJnQXnG26VWqkrI1ixcFHP1v2ENt32QEypSF41MDJMjZuUNKTJrhGkgw
	 ntE6IPdU9qrOhFndHjhWW0XKyZKIzW5lwg2yXl35E4cPU5VBqlUmQWWbGxvUjIoWCz
	 vnjkICp4cSfZZ1vi8WHsLcJshpAQpREl3FZUH+sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Merwick <liam.merwick@oracle.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 170/198] KVM: SEV: Drop WARN on large size for KVM_MEMORY_ENCRYPT_REG_REGION
Date: Mon, 20 Apr 2026 17:42:29 +0200
Message-ID: <20260420153941.731387160@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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
@@ -679,10 +679,16 @@ static struct page **sev_pin_memory(stru
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
@@ -691,9 +697,6 @@ static struct page **sev_pin_memory(stru
 		return ERR_PTR(-ENOMEM);
 	}
 
-	if (WARN_ON_ONCE(npages > INT_MAX))
-		return ERR_PTR(-EINVAL);
-
 	/* Avoid using vmalloc for smaller buffers. */
 	size = npages * sizeof(struct page *);
 	if (size > PAGE_SIZE)


