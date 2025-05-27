Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF9C1E25E3;
	Tue, 27 May 2025 17:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368050; cv=none; b=tZxTWPdURPAU4M1kt2GnY7i/l6k2s/do/aywJC6xSqgucxOyTkBnOc4tqTywWgJKZhOQiSrC1zlT/NoHe+C5WzI2L/GHtbgGgWKwdhrzR+SYrfcoMqL5RNvzaMw/wDN6XAMfqYtsi18VnksWC7Ddzkc1qeST0yo6xGqvOuhnATA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368050; c=relaxed/simple;
	bh=wt/RosMjzsB5sPXuOn0pJkNUd9KQEU4lxnwormUShmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfRj58KwF68WiVzbHK6fKfRahB2ry9so29jx0RXEm/ekbVjTAIfFOQJfYQPh9Z2+6S4zVoWPQSbeImsN+yFJiqy7cBA4RcVBgQpSR4Yl8uyK5vLaM3DLusOiRUTWSZgK+tSt9x8aLGIHSqZJehKQAm+na7frMMO6A7vJP9PElig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4+fHg1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4+fHg1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCA9C4CEE9;
	Tue, 27 May 2025 17:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368050;
	bh=wt/RosMjzsB5sPXuOn0pJkNUd9KQEU4lxnwormUShmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4+fHg1M9nIFlXeGqGX7QQKpEfeWQ3i38GyAjz0dP3FNFQaPa8eyefudOeGArn7QZ
	 MHn7thNQmZglvIHy/NK1nmesVaewCyoiu7H9F4oTWuFzC8SzjIVp2GwtgL/Go38TSw
	 hFaNIVyi8MP2R+SitjF5a//oQ8xdmT+kIsULhokM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 575/783] drm/xe/relay: Dont use GFP_KERNEL for new transactions
Date: Tue, 27 May 2025 18:26:12 +0200
Message-ID: <20250527162536.562453046@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 78d5d1e20d1de9422f013338a0f2311448588ba7 ]

VFs use a relay transaction during the resume/reset flow and use
of the GFP_KERNEL flag may conflict with the reclaim:

     -> #0 (fs_reclaim){+.+.}-{0:0}:
 [ ]        __lock_acquire+0x1874/0x2bc0
 [ ]        lock_acquire+0xd2/0x310
 [ ]        fs_reclaim_acquire+0xc5/0x100
 [ ]        mempool_alloc_noprof+0x5c/0x1b0
 [ ]        __relay_get_transaction+0xdc/0xa10 [xe]
 [ ]        relay_send_to+0x251/0xe50 [xe]
 [ ]        xe_guc_relay_send_to_pf+0x79/0x3a0 [xe]
 [ ]        xe_gt_sriov_vf_connect+0x90/0x4d0 [xe]
 [ ]        xe_uc_init_hw+0x157/0x3b0 [xe]
 [ ]        do_gt_restart+0x1ae/0x650 [xe]
 [ ]        xe_gt_resume+0xb6/0x120 [xe]
 [ ]        xe_pm_runtime_resume+0x15b/0x370 [xe]
 [ ]        xe_pci_runtime_resume+0x73/0x90 [xe]
 [ ]        pci_pm_runtime_resume+0xa0/0x100
 [ ]        __rpm_callback+0x4d/0x170
 [ ]        rpm_callback+0x64/0x70
 [ ]        rpm_resume+0x594/0x790
 [ ]        __pm_runtime_resume+0x4e/0x90
 [ ]        xe_pm_runtime_get_ioctl+0x9c/0x160 [xe]

Since we have a preallocated pool of relay transactions, which
should cover all our normal relay use cases, we may use the
GFP_NOWAIT flag when allocating new outgoing transactions.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Tested-by: Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>
Reviewed-by: Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250131153713.808-1-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_relay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_relay.c b/drivers/gpu/drm/xe/xe_guc_relay.c
index 8f62de026724c..e5dc94f3e6181 100644
--- a/drivers/gpu/drm/xe/xe_guc_relay.c
+++ b/drivers/gpu/drm/xe/xe_guc_relay.c
@@ -225,7 +225,7 @@ __relay_get_transaction(struct xe_guc_relay *relay, bool incoming, u32 remote, u
 	 * with CTB lock held which is marked as used in the reclaim path.
 	 * Btw, that's one of the reason why we use mempool here!
 	 */
-	txn = mempool_alloc(&relay->pool, incoming ? GFP_ATOMIC : GFP_KERNEL);
+	txn = mempool_alloc(&relay->pool, incoming ? GFP_ATOMIC : GFP_NOWAIT);
 	if (!txn)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.39.5



