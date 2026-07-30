Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8519346A18;
	Thu, 30 Jul 2026 14:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421847; cv=none; b=hyVbCEW+PHz92GuMVUTqtpmlZYOGIfPKb8SxvRkzxzYFLs9yjvDKpJnp+bef5hrG/Mhhld3zkGpNs2tc11oRxS2GGidwowHO6AqqllTCB+bp2Xn6KDhAqsLAiHof8TI6FQtqtw+n+1HkvMadc2Zeal2DRXTC+oNVyBRlcPGN/0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421847; c=relaxed/simple;
	bh=t2D6cUmmI2ViKZK0PVtVb5bf9l5IBNZ316TySSU0V8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWBPTyi9rWYQLjzOgWASWoIprUiBbhv3ChrXusPokeOgkei3wmyQXNLOZM0yNuJX92UYonZn7kKzHhOwQzr7s+xWOXRMJ4QNaJI8JL+IVkHHLU6ADfeishHp2zPfSAmZce5U/fSnyi+hId0gqjeYm6e0l3daXNURjvbZvdJLEfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWu77veN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWu77veN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0861F000E9;
	Thu, 30 Jul 2026 14:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421846;
	bh=lCaJLkQMmJbdBMm5WtYz6hqvxi48gDP3mGQZuoEoeAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWu77veNVF83pzYpxFaAzz8B/XdqekBwbUQDnnN+G/iRy4l3BWKImpu0cdlE6ej60
	 GCQGRJFmoZF+AW5QD6BhIPErfmBkxKXxfuR3rNqRUnEGi1EcRD35sHPsSGoeryeVgr
	 ZB4yqL0Fa3atnILnHUX1Q+lcNGqFoK00Jz/7LRjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayen Yan <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 240/744] net: airoha: Fix potential use-after-free in airoha_ppe_deinit()
Date: Thu, 30 Jul 2026 16:08:33 +0200
Message-ID: <20260730141449.394698125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index a1f9939c21f20a..75b33e5af9b2c5 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1619,6 +1619,7 @@ void airoha_ppe_deinit(struct airoha_eth *eth)
 	npu = rcu_replace_pointer(eth->npu, NULL,
 				  lockdep_is_held(&flow_offload_mutex));
 	if (npu) {
+		synchronize_rcu();
 		npu->ops.ppe_deinit(npu);
 		airoha_npu_put(npu);
 	}
-- 
2.53.0



