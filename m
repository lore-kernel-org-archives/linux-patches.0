Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EAB1E2834;
	Wed, 25 Feb 2026 01:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983619; cv=none; b=CpATXOgECa4wKuGPs+XH3Gf+NVvaQ6rugJQY9ZjDWLeFp6wJCiGIdTjwQoqaPGcqn8I+L1k8IJ2W7LXgOGvEKuLWlKxNzYpkPjI0LT6Cj1dHm66RbLJP7N3PRmMMfirILUEltYLkNnm3zGi3E6oqZPQ3dHLJIGWl3njA4Cek9eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983619; c=relaxed/simple;
	bh=c/Niyh7Y89BXUusXTtKbgxDX9H1tTkcKRltKuq/ICZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvC7SCIsCKNA7cuxr6t9ZfN1o34GxExGZ/zhMrikMBJlB30ZGlPQ8YLncNQBNm3VXV3nqwxgptNZEzUDS+JIsyd2mcswtVtDs8SkT+GO2Db74kdwQou5dK8897xyrhox6ChCtruq3jo2x5dzgP5OKARSfRJj2JCvmzMxNYBIbYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mroqL37w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mroqL37w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D91C116D0;
	Wed, 25 Feb 2026 01:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983619;
	bh=c/Niyh7Y89BXUusXTtKbgxDX9H1tTkcKRltKuq/ICZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mroqL37wS2ht1VFGSNM0IQK9eY2HiOzE/jUavACFzDSUZQPcJdRWMHivu3MafY/fL
	 MIE6i4X0ROAV3trjcA6PRGEhdeg5wgt6svYa5Pn5H6mtSLbwg/FJtJurGpbLIVVqGT
	 1ECVEEG1D53stF5pq8OlgVX5SBV0ux4kPhT2LnDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 713/781] mshv: fix SRCU protection in irqfd resampler ack handler
Date: Tue, 24 Feb 2026 17:23:42 -0800
Message-ID: <20260225012417.233910107@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 2e7577cd5ddc1f86d1b6c48caf3cfa87dbb14e34 ]

Replace hlist_for_each_entry_rcu() with hlist_for_each_entry_srcu()
in mshv_irqfd_resampler_ack() to correctly handle SRCU-protected
linked list traversal.

The function uses SRCU (sleepable RCU) synchronization via
partition->pt_irq_srcu, but was incorrectly using the RCU variant
for list iteration. This could lead to race conditions when the
list is modified concurrently.

Also add srcu_read_lock_held() assertion as required by
hlist_for_each_entry_srcu() to ensure we're in the proper
read-side critical section.

Fixes: 621191d709b14 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Acked-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_eventfd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_eventfd.c b/drivers/hv/mshv_eventfd.c
index 0b75ff1edb735..6d176ed8ae516 100644
--- a/drivers/hv/mshv_eventfd.c
+++ b/drivers/hv/mshv_eventfd.c
@@ -87,8 +87,9 @@ static void mshv_irqfd_resampler_ack(struct mshv_irq_ack_notifier *mian)
 
 	idx = srcu_read_lock(&partition->pt_irq_srcu);
 
-	hlist_for_each_entry_rcu(irqfd, &resampler->rsmplr_irqfd_list,
-				 irqfd_resampler_hnode) {
+	hlist_for_each_entry_srcu(irqfd, &resampler->rsmplr_irqfd_list,
+				 irqfd_resampler_hnode,
+				 srcu_read_lock_held(&partition->pt_irq_srcu)) {
 		if (hv_should_clear_interrupt(irqfd->irqfd_lapic_irq.lapic_control.interrupt_type))
 			hv_call_clear_virtual_interrupt(partition->pt_id);
 
-- 
2.51.0



