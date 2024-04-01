Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF92C1DFF4;
	Mon,  1 Apr 2024 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991158; cv=none; b=RzhGOlmVvADkqVVa9w2/82tmIbTx40SDXb5xAKC4syG1JvdRo1CITRpPU81eLthmDmJtvQuKxEVAPjhobeCsQ5K6GjJJLbgId+zOvtJK+FETahKHNivRRPnxXhBK0xW5iptghWVOQqCaGLkqN3ht2Gb/gXXVWjca7K73ymlFTyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991158; c=relaxed/simple;
	bh=eLj4EarOgHKJ+7TmZ1g/Exr5RskA14in5GNS4htonZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzgecyPMYfdaPq3HBH4R9KksZsmIk3d0vQ+ND0mutlAxok8EZgaqBJM1IiYalgo1/TwLl78oIpw4ZgVkIj07YLPrc1fUhUZllw+7Tk7ISODdSs50RHHg9zGCFSniBjHt3zHqpHT04MRpU7fAZvzSd3EN47r6Yde5o7G+xs9jNvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNz0cWZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNz0cWZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6F4C433F1;
	Mon,  1 Apr 2024 17:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991158;
	bh=eLj4EarOgHKJ+7TmZ1g/Exr5RskA14in5GNS4htonZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNz0cWZzq0v7xcqG1HDFdUSeDExMd2Sj1PMpkvSqJqeMNBJnSDQUyF2IFHuIx7tjP
	 8w9zYBrqwjZ//SaWG+pfGD3dYz8jQ64YxZ0HB5/QNFMhHJheA8FcJSwYM3dBpxtGcs
	 xc5Q/u0ZviF1adDB8GHqoetuAhaO2wTRludnHNR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabe Kirkpatrick <gkirkpatrick@google.com>,
	Josh Eads <josheads@google.com>,
	Peter Gonda <pgonda@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 152/272] KVM: SVM: Flush pages under kvm->lock to fix UAF in svm_register_enc_region()
Date: Mon,  1 Apr 2024 17:45:42 +0200
Message-ID: <20240401152535.455794394@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 5ef1d8c1ddbf696e47b226e11888eaf8d9e8e807 upstream.

Do the cache flush of converted pages in svm_register_enc_region() before
dropping kvm->lock to fix use-after-free issues where region and/or its
array of pages could be freed by a different task, e.g. if userspace has
__unregister_enc_region_locked() already queued up for the region.

Note, the "obvious" alternative of using local variables doesn't fully
resolve the bug, as region->pages is also dynamically allocated.  I.e. the
region structure itself would be fine, but region->pages could be freed.

Flushing multiple pages under kvm->lock is unfortunate, but the entire
flow is a rare slow path, and the manual flush is only needed on CPUs that
lack coherency for encrypted memory.

Fixes: 19a23da53932 ("Fix unsynchronized access to sev members through svm_register_enc_region")
Reported-by: Gabe Kirkpatrick <gkirkpatrick@google.com>
Cc: Josh Eads <josheads@google.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20240217013430.2079561-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1958,20 +1958,22 @@ int sev_mem_enc_register_region(struct k
 		goto e_free;
 	}
 
-	region->uaddr = range->addr;
-	region->size = range->size;
-
-	list_add_tail(&region->list, &sev->regions_list);
-	mutex_unlock(&kvm->lock);
-
 	/*
 	 * The guest may change the memory encryption attribute from C=0 -> C=1
 	 * or vice versa for this memory range. Lets make sure caches are
 	 * flushed to ensure that guest data gets written into memory with
-	 * correct C-bit.
+	 * correct C-bit.  Note, this must be done before dropping kvm->lock,
+	 * as region and its array of pages can be freed by a different task
+	 * once kvm->lock is released.
 	 */
 	sev_clflush_pages(region->pages, region->npages);
 
+	region->uaddr = range->addr;
+	region->size = range->size;
+
+	list_add_tail(&region->list, &sev->regions_list);
+	mutex_unlock(&kvm->lock);
+
 	return ret;
 
 e_free:


