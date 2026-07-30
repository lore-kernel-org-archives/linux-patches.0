Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159C3411A09;
	Thu, 30 Jul 2026 15:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424020; cv=none; b=mspwVWuxRNnraZAFR5DYElA10aNB+PGRNz5qSHajUWnNOo4Kj7eirjnmcQjbwl9DhzgUNF/YDERWqzB5TxlkTtkTFv1rsvtR1FwHW5xAHkvAjtSJWjyVqBn9U67wnpnZF48Cwh3dK4oaZ+DGZDiRSHurCNqE85AMO/XClnALrQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424020; c=relaxed/simple;
	bh=pWcvC+4ux8+UvVmXG02p0s4yvo5KM5DBPU3K7Uk2eTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGPlFzwrfBHQpvlKtPcrQzUJ1spb0qsNSXv6giCoD/3Hy+f29iPRVD2KLYvA+NoBfpeI869BGlkfZlV47feLF4e00R530h+KOsqsRn2BLN+NUehzd80cIFBl8I1kq9PEZQcFJ0d4LqmOHbRttf+qA0dGPhXiYojpAHcm6AuK+Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuBmt7pe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuBmt7pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA861F000E9;
	Thu, 30 Jul 2026 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424019;
	bh=6J/R0XTWTI/pI8+9zsjHaatPBOSn27Wks+6BOrGxids=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuBmt7pekUz2qztDzdKYMGvqD4dRDWgRR9AWwOt40f1IY4bRzK9unqDvRBanPb2xx
	 QObUhymE7hO7fWYqlDDYQ9hWxaUWwWOEqxOIJsQ1K9cnoAfBZzCUs65h/wRVOnmqZs
	 1zSrdwbKfN+zD9pcX099N/uW5vpDBFyc5bNoxr+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayen Yan <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 220/675] net: airoha: Fix potential use-after-free in airoha_ppe_deinit()
Date: Thu, 30 Jul 2026 16:09:10 +0200
Message-ID: <20260730141449.818780167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Wayen Yan <win847@gmail.com>

[ Upstream commit 2484568a335cd7bda951c75b3a7d95ea36161ae7 ]

airoha_ppe_deinit() replaces the NPU pointer with NULL via
rcu_replace_pointer() but does not wait for existing RCU readers
to exit before calling ppe_deinit() and airoha_npu_put(). This can
cause a use-after-free if a reader in an RCU read-side critical
section still holds a reference to the NPU when it is freed.

The init path (airoha_ppe_init) already calls synchronize_rcu()
after rcu_assign_pointer(), but the deinit path introduced in
commit 6abcf751bc08 ("net: airoha: Fix schedule while atomic in
airoha_ppe_deinit()") omitted the matching barrier when switching
from rcu_read_lock()/rcu_dereference() to rcu_replace_pointer().

Add synchronize_rcu() before ppe_deinit() to ensure all existing
RCU readers have completed before the NPU resources are released.

Fixes: 6abcf751bc084804a9e5b3051442e8a2ce67f48a ("net: airoha: Fix schedule while atomic in airoha_ppe_deinit()")
Signed-off-by: Wayen Yan <win847@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/178351022574.97989.6880403520276841703@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 798839aa1010b8..8defd194568f25 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1575,6 +1575,7 @@ void airoha_ppe_deinit(struct airoha_eth *eth)
 	npu = rcu_replace_pointer(eth->npu, NULL,
 				  lockdep_is_held(&flow_offload_mutex));
 	if (npu) {
+		synchronize_rcu();
 		npu->ops.ppe_deinit(npu);
 		airoha_npu_put(npu);
 	}
-- 
2.53.0



