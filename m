Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2457B7C6EB;
	Mon,  8 Apr 2024 13:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582206; cv=none; b=FtSzJYTO92NYn/vFf+arhM+LsVkfyOehpF/UdKJls35hTzPrF/PCM/u04bY0qlnr/cNB0HKRPkH78+x8BlhXZnA1r748nfu0FMdjSJ6BHuJ8onyUTCDbZpzw5ruI29sIfoZnMxAmU6Ii2530gbd9PQMemVvoWOXiMm8MjPXCMIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582206; c=relaxed/simple;
	bh=qRTJ9+6rTbsAU3hdunc36l0yPNe2IKfR5AQz6C68y+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htELbeWOkUI+sETFLObAVDsH2pMaLqnBiob+aJMPOTl5RsKy1uEioyC5hV/lJnvwCUDI2O1dGVLl1Dx4YjAgWFVDl4pH1Qu/T+Mdv8FEO988leC8tqs/VCTjykiKPKvqqOfJT53ryXbhYQAOz1zeAvat51P78toi49N0vGUJqjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lvr8uuDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lvr8uuDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CACDC433F1;
	Mon,  8 Apr 2024 13:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582206;
	bh=qRTJ9+6rTbsAU3hdunc36l0yPNe2IKfR5AQz6C68y+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lvr8uuDd4U+NzwvTRZtBxFWS9MTxwM0HyOf/5LeI0v+lYKWHjXodmh6tnRQDetCmJ
	 JFczl5oAKI8OIY0jUU4v/ZEmlmrFZ/iqB4EueUVOHQQbnH/yGE+oS10EcvRrDcKThw
	 v+v63n6tEYKhsrAmgqfXUdwTnIoC6IDMg2CVUlic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabe Kirkpatrick <gkirkpatrick@google.com>,
	Josh Eads <josheads@google.com>,
	Peter Gonda <pgonda@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 123/690] KVM: SVM: Flush pages under kvm->lock to fix UAF in svm_register_enc_region()
Date: Mon,  8 Apr 2024 14:49:49 +0200
Message-ID: <20240408125404.015070012@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1662,20 +1662,22 @@ int svm_register_enc_region(struct kvm *
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


