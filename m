Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAC12FB08C;
	Wed, 25 Feb 2026 06:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002758; cv=none; b=mmh3sgFeUUswn1UNwltTY5c99CpHJqpAgU7k3o3hNo6pBF5QnPHo6QjyXAcfjRkNHb0v+L9BigcvnXqmUkwfofi4VL7/giIPFR2ZVi2dDqHpcW4YBLVqdgt0F/rfhFrvcx1cRf40tP2p1AVUn8zYfrNO9zC4tlj0/LVEm6z5ABc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002758; c=relaxed/simple;
	bh=DLdcpEFQtOVxrpHvLa/WnZGWQOBUifETBUkneoagpBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfef85HF23aUE1ZDRZk3pofaOxylC8wW+tGXLIm9oq/9rR8sKQZHI/1DzKaYJ6P30PKC6Oyepmjss/pJVNO84vMJrRCfyL5mgj6arEpfjsvjq7tFkQwK1vX0G4qeekmxuddSD7aax6HAPn9ybHBmx1TkpVAN5C7k0kbcotl1lTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKeiy1Pv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKeiy1Pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB8AC116D0;
	Wed, 25 Feb 2026 06:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002757;
	bh=DLdcpEFQtOVxrpHvLa/WnZGWQOBUifETBUkneoagpBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKeiy1Pvgj7pxd2sZsSOAaj5PRnsujp8w+m1xctairwTxPBcWHqrlOI3XTqiBf4vl
	 yJvK16qN7Qs2pd/XjxB1jxCDq+j4TEC7CxhgBovkyOTHTG1Khb5Xhy56SVVvP59SBm
	 RT0DrbhAZRbRWPT5Egr43Fc2Mv4cujuQObmUG81c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 585/641] mshv: fix SRCU protection in irqfd resampler ack handler
Date: Tue, 24 Feb 2026 17:25:11 -0800
Message-ID: <20260225012402.687400161@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 806674722868b..05d643f54f45a 100644
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



