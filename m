Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FB53BF665;
	Mon, 23 Mar 2026 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283224; cv=none; b=rDQSuRmYoevCcRNcUsJDmHPvlX0NTZGmNUWVg1Q0tISD+S1oZqpG8/Keh+ZF6H7uoh21PlFdMSGVKKL/IWPAkV+dHbiK6yQkQ7BI8bXfmUKKHh+1HFwZe6k7lxepa/wtZQCsoWFQ1ss0+o125InTt2N4F7tpnwAtt8Jsdwaa+wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283224; c=relaxed/simple;
	bh=FGXCWu436ias0cvU97ocxesWLgkuVP0uOHSQUOjjrlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiE+9PcFHbXRWyrrkTH55waBjnja8F6mRpVK+F3psczSsJfWJ4/+73LbmFToEnSX9gXu6Q++16uvJE/lE4M7zYOmv6dFiXtUbNzg94MmdAxrR3fhAQLYkUFBy0W4YIgi4RPsSIq3P0KJ9N4/RMyx9HU72+wokyCTywUj8m9zWlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bG0t8Ryg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bG0t8Ryg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8298C4CEF7;
	Mon, 23 Mar 2026 16:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283224;
	bh=FGXCWu436ias0cvU97ocxesWLgkuVP0uOHSQUOjjrlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bG0t8RygqBw2nmaTUFfwpXFY/VE7UDHtNwJAwmWHxwwMcOQHpxo89NVlO15SqFIf/
	 yTYxMjOsH1fDHnYuD1dqeLBsyQeYhKJ+z6bJ4MNW0BF0fzTaKuKLgmjIrMPLNJnMR6
	 Nf83UwrKfQ0amJKKzp/uWWS8DJCP5caLA7QBCS0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 421/481] net: mana: fix use-after-free in mana_hwc_destroy_channel() by reordering teardown
Date: Mon, 23 Mar 2026 14:46:43 +0100
Message-ID: <20260323134535.453324798@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

[ Upstream commit fa103fc8f56954a60699a29215cb713448a39e87 ]

A potential race condition exists in mana_hwc_destroy_channel() where
hwc->caller_ctx is freed before the HWC's Completion Queue (CQ) and
Event Queue (EQ) are destroyed. This allows an in-flight CQ interrupt
handler to dereference freed memory, leading to a use-after-free or
NULL pointer dereference in mana_hwc_handle_resp().

mana_smc_teardown_hwc() signals the hardware to stop but does not
synchronize against IRQ handlers already executing on other CPUs. The
IRQ synchronization only happens in mana_hwc_destroy_cq() via
mana_gd_destroy_eq() -> mana_gd_deregister_irq(). Since this runs
after kfree(hwc->caller_ctx), a concurrent mana_hwc_rx_event_handler()
can dereference freed caller_ctx (and rxq->msg_buf) in
mana_hwc_handle_resp().

Fix this by reordering teardown to reverse-of-creation order: destroy
the TX/RX work queues and CQ/EQ before freeing hwc->caller_ctx. This
ensures all in-flight interrupt handlers complete before the memory they
access is freed.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/abHA3AjNtqa1nx9k@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 66a0552fc8b3a..8111f181f9572 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -757,9 +757,6 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 		gc->max_num_cqs = 0;
 	}
 
-	kfree(hwc->caller_ctx);
-	hwc->caller_ctx = NULL;
-
 	if (hwc->txq)
 		mana_hwc_destroy_wq(hwc, hwc->txq);
 
@@ -769,6 +766,9 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	if (hwc->cq)
 		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
 
+	kfree(hwc->caller_ctx);
+	hwc->caller_ctx = NULL;
+
 	mana_gd_free_res_map(&hwc->inflight_msg_res);
 
 	hwc->num_inflight_msg = 0;
-- 
2.51.0



