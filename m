Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3839A3A291;
	Fri, 21 Nov 2025 13:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732104; cv=none; b=J0vUfscEJvcPTIHaJjcqaS9/N2FdWqpU6BLPopzbiLgis/qfMn2bi6gXdBVyh6JOdCzLnENZTBpRMQwXGq1EafrhOtJ95mpE29WKrwond1p+yAKeviu/wc+7LmvkCeT5vxJWMxKG+NgBJS+1yUAIc/0IAlOm37gdKvfMEn8K9RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732104; c=relaxed/simple;
	bh=8q7GOzJ7SFoCJ6yEudiumBf4YmSMChO9s/ufYW5xA8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAyTz2hT6wpjI/Rh7Jm6YIqolDb9UHi0F6QxI1mTF71m5YF5RtFwRQf4iU17O5qDmCwW2a+imZgn/ykxLJ9ezuGSknNqLr14kjAFmLnWiInDvxALlVwhQ+0VtoE7FFgy/7IWMAdzsWd9KrGbu0D1aB1u8MCX5XxnaVjQ3YrPk3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9W7vID6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9W7vID6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BA3C4CEF1;
	Fri, 21 Nov 2025 13:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732102;
	bh=8q7GOzJ7SFoCJ6yEudiumBf4YmSMChO9s/ufYW5xA8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9W7vID6i+DFLwtQR/ru2wvZoITKsDdrekP1A7TujSr9KwbWhMICdGB939QViygZ5
	 L6TwnwMBEBLe4f5zmHb+VevjkEvY9o0CzKpocOoBbNj0Jse3vPzm+2+fSbrMyXKtL8
	 5LfPVjziiCrVjCwNCZzyF6ZIbs2d3vg8Y5fBCxak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/185] KVM: guest_memfd: Pass index, not gfn, to __kvm_gmem_get_pfn()
Date: Fri, 21 Nov 2025 14:13:10 +0100
Message-ID: <20251121130149.759327833@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 4af18dc6a9204464db76d9771d1f40e2b46bf6ae ]

Refactor guest_memfd usage of __kvm_gmem_get_pfn() to pass the index into
the guest_memfd file instead of the gfn, i.e. resolve the index based on
the slot+gfn in the caller instead of in __kvm_gmem_get_pfn().  This will
allow kvm_gmem_get_pfn() to retrieve and return the specific "struct page",
which requires the index into the folio, without a redoing the index
calculation multiple times (which isn't costly, just hard to follow).

Opportunistically add a kvm_gmem_get_index() helper to make the copy+pasted
code easier to understand.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20241010182427.1434605-46-seanjc@google.com>
Stable-dep-of: ae431059e75d ("KVM: guest_memfd: Remove bindings on memslot deletion when gmem is dying")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/guest_memfd.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -304,6 +304,11 @@ static inline struct file *kvm_gmem_get_
 	return get_file_active(&slot->gmem.file);
 }
 
+static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return gfn - slot->base_gfn + slot->gmem.pgoff;
+}
+
 static struct file_operations kvm_gmem_fops = {
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
@@ -553,12 +558,11 @@ void kvm_gmem_unbind(struct kvm_memory_s
 }
 
 /* Returns a locked folio on success.  */
-static struct folio *
-__kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
-		   gfn_t gfn, kvm_pfn_t *pfn, bool *is_prepared,
-		   int *max_order)
+static struct folio *__kvm_gmem_get_pfn(struct file *file,
+					struct kvm_memory_slot *slot,
+					pgoff_t index, kvm_pfn_t *pfn,
+					bool *is_prepared, int *max_order)
 {
-	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem = file->private_data;
 	struct folio *folio;
 
@@ -594,6 +598,7 @@ __kvm_gmem_get_pfn(struct file *file, st
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
+	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct file *file = kvm_gmem_get_file(slot);
 	struct folio *folio;
 	bool is_prepared = false;
@@ -602,7 +607,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, st
 	if (!file)
 		return -EFAULT;
 
-	folio = __kvm_gmem_get_pfn(file, slot, gfn, pfn, &is_prepared, max_order);
+	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
 	if (IS_ERR(folio)) {
 		r = PTR_ERR(folio);
 		goto out;
@@ -650,6 +655,7 @@ long kvm_gmem_populate(struct kvm *kvm,
 	for (i = 0; i < npages; i += (1 << max_order)) {
 		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
+		pgoff_t index = kvm_gmem_get_index(slot, gfn);
 		bool is_prepared = false;
 		kvm_pfn_t pfn;
 
@@ -658,7 +664,7 @@ long kvm_gmem_populate(struct kvm *kvm,
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &is_prepared, &max_order);
+		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
 			break;


