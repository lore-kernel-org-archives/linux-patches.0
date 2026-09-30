Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8662433D4E9;
	Wed, 30 Sep 2026 16:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786819; cv=none; b=l4Y2gXLJrPX8nYyhHGMXwNUAzV1FqL3Z61gZ/wKTZQSEDwRxSZj2g4Mqh9cbBfp9v/AXcGooyoIj47DksE9WCEkKniIPkb5ha+xMie0c2YUc7Y1uEON+6aINp23QmkWXCcn5qQGzQDfFre/+VJt4J8DTxB7gHyzny9Y+ZzxEDuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786819; c=relaxed/simple;
	bh=SzzYz0nLGgGwTtbdGr4SE3BbKeM1U2Rrp/JLJ0C9m+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgp8Ghb1G/Q5dzqcLSYyNUZHFOAYAM8G4uHbo/TMz2LsZ0/ABCcD1LJRtFNxiazh5UnpRm9BpQq92+FkUod+vFjpdfEW/LHDbm7nhiAu5M8jaMTg+EBdjmNEdEk+sYjQIKFVDSZ6dPNkGylBJhDJ0Dw1Tfh/PMw3sxO85XdWXF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbmAwGzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbmAwGzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09C81F00893;
	Wed, 30 Sep 2026 16:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786818;
	bh=SzYq7gzYKe629owZxBo2JYdokaK1y9kITBwDQDQvCIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbmAwGzSq2ZN9iRTn6fEcJsKr8EWAtFRjoFN+hI3dNcj/BSR4M7/hEQK8B+78HwLZ
	 ZG8UxfFnoZPWlOP3dkxeZiT+uHdEJQCFYqq7RrO7DHXZCKKTqZQTZqFaKvrQxtwPKx
	 a8R1WH8SloCMznIGlJSOtN6Z7cPmkTlApH0rJi04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 006/457] KVM: s390: Fix dirty marking in adapter_indicators_set*()
Date: Wed, 30 Sep 2026 17:21:51 +0200
Message-ID: <20260930152346.168707483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit d215f014b3526a9898d87bfb4b866287f0864cc9 ]

When the indicator and/or summary bits are set in the guest, the
accessed page was only marked dirty in KVM if the access was performed
using the slow path; accesses through the new kvm_arch_set_irq_inatomic
fast inject path would not mark the page as dirty.

Fix by adding/moving the missing calls to mark_page_dirty(). Note that
for the inatomic path set_page_dirty{,_lock}() is not needed as the
page stays pinned; the unpin path correctly marks it as dirty.

Opportunistically reorder the local variables to be in reverse
Christmas tree order and refactor to use guard().

Fixes: 1e95e3bc6b05 ("KVM: s390: Enable adapter_indicators_set to use mapped pages")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260828115439.145885-2-imbrenda@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/interrupt.c | 75 ++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 37 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index d33dd58f4a4fd..70431eb38aa50 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2976,61 +2976,58 @@ static int adapter_indicators_set(struct kvm *kvm,
 				  struct s390_io_adapter *adapter,
 				  struct kvm_s390_adapter_int *adapter_int)
 {
-	unsigned long bit;
-	int summary_set, idx;
 	struct s390_map_info *ind_info, *summary_info;
-	void *map;
 	struct page *ind_page, *summary_page;
-	unsigned long flags;
+	unsigned long bit;
+	int summary_set;
+	void *map;
 
 	ind_page = NULL;
 
-	spin_lock_irqsave(&adapter->maps_lock, flags);
-	ind_info = get_map_info(adapter, adapter_int->ind_addr);
+	scoped_guard(spinlock_irqsave, &adapter->maps_lock) {
+		ind_info = get_map_info(adapter, adapter_int->ind_addr);
+		if (ind_info) {
+			map = page_address(ind_info->page);
+			bit = get_ind_bit(ind_info->addr, adapter_int->ind_offset, adapter->swap);
+			set_bit(bit, map);
+		}
+	}
 	if (!ind_info) {
-		spin_unlock_irqrestore(&adapter->maps_lock, flags);
 		ind_page = pin_map_page(kvm, adapter_int->ind_addr, 0);
 		if (!ind_page)
 			return -1;
-		idx = srcu_read_lock(&kvm->srcu);
 		map = page_address(ind_page);
 		bit = get_ind_bit(adapter_int->ind_addr,
 				  adapter_int->ind_offset, adapter->swap);
 		set_bit(bit, map);
-		mark_page_dirty(kvm, adapter_int->ind_gaddr >> PAGE_SHIFT);
 		set_page_dirty_lock(ind_page);
-		srcu_read_unlock(&kvm->srcu, idx);
 		unpin_user_page(ind_page);
-	} else {
-		map = page_address(ind_info->page);
-		bit = get_ind_bit(ind_info->addr, adapter_int->ind_offset, adapter->swap);
-		set_bit(bit, map);
-		spin_unlock_irqrestore(&adapter->maps_lock, flags);
 	}
+	scoped_guard(srcu, &kvm->srcu)
+		mark_page_dirty(kvm, gpa_to_gfn(adapter_int->ind_gaddr));
 
-	spin_lock_irqsave(&adapter->maps_lock, flags);
-	summary_info = get_map_info(adapter, adapter_int->summary_addr);
+	scoped_guard(spinlock_irqsave, &adapter->maps_lock) {
+		summary_info = get_map_info(adapter, adapter_int->summary_addr);
+		if (summary_info) {
+			map = page_address(summary_info->page);
+			bit = get_ind_bit(summary_info->addr, adapter_int->summary_offset,
+					  adapter->swap);
+			summary_set = test_and_set_bit(bit, map);
+		}
+	}
 	if (!summary_info) {
-		spin_unlock_irqrestore(&adapter->maps_lock, flags);
 		summary_page = pin_map_page(kvm, adapter_int->summary_addr, 0);
 		if (WARN_ON_ONCE(!summary_page))
 			return -1;
-		idx = srcu_read_lock(&kvm->srcu);
 		map = page_address(summary_page);
 		bit = get_ind_bit(adapter_int->summary_addr,
 				  adapter_int->summary_offset, adapter->swap);
 		summary_set = test_and_set_bit(bit, map);
-		mark_page_dirty(kvm, adapter_int->summary_gaddr >> PAGE_SHIFT);
 		set_page_dirty_lock(summary_page);
-		srcu_read_unlock(&kvm->srcu, idx);
 		unpin_user_page(summary_page);
-	} else {
-		map = page_address(summary_info->page);
-		bit = get_ind_bit(summary_info->addr, adapter_int->summary_offset,
-				  adapter->swap);
-		summary_set = test_and_set_bit(bit, map);
-		spin_unlock_irqrestore(&adapter->maps_lock, flags);
 	}
+	scoped_guard(srcu, &kvm->srcu)
+		mark_page_dirty(kvm, gpa_to_gfn(adapter_int->summary_gaddr));
 
 	return summary_set ? 0 : 1;
 }
@@ -3040,26 +3037,29 @@ static int adapter_indicators_set_fast(struct kvm *kvm,
 				       struct kvm_s390_adapter_int *adapter_int,
 				       int setbit)
 {
+	struct s390_map_info *ind_info, *summary_info;
 	unsigned long bit;
 	int summary_set;
-	struct s390_map_info *ind_info, *summary_info;
 	void *map;
 
-	spin_lock(&adapter->maps_lock);
+	guard(srcu)(&kvm->srcu);
+	guard(spinlock)(&adapter->maps_lock);
+
 	ind_info = get_map_info(adapter, adapter_int->ind_addr);
-	if (!ind_info) {
-		spin_unlock(&adapter->maps_lock);
+	if (!ind_info)
 		return -EWOULDBLOCK;
-	}
+
 	map = page_address(ind_info->page);
 	bit = get_ind_bit(ind_info->addr, adapter_int->ind_offset, adapter->swap);
-	if (setbit)
+	if (setbit) {
 		set_bit(bit, map);
+		mark_page_dirty(kvm, gpa_to_gfn(adapter_int->ind_gaddr));
+	}
+
 	summary_info = get_map_info(adapter, adapter_int->summary_addr);
-	if (!summary_info) {
-		spin_unlock(&adapter->maps_lock);
+	if (!summary_info)
 		return -EWOULDBLOCK;
-	}
+
 	map = page_address(summary_info->page);
 	bit = get_ind_bit(summary_info->addr, adapter_int->summary_offset,
 			  adapter->swap);
@@ -3069,7 +3069,8 @@ static int adapter_indicators_set_fast(struct kvm *kvm,
 		summary_set = test_and_set_bit(bit, map);
 	else
 		summary_set = test_and_clear_bit(bit, map);
-	spin_unlock(&adapter->maps_lock);
+	mark_page_dirty(kvm, gpa_to_gfn(adapter_int->summary_gaddr));
+
 	return summary_set ? 0 : 1;
 }
 
-- 
2.53.0



