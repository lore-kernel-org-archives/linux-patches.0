Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39C32222AA;
	Tue, 17 Mar 2026 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765485; cv=none; b=a+v6cbDM9gaskOlUsxJCFFQaUksfoPs3sY9n3DjwoUzcxWFzkvzcyWxQ/3TWGOgRSIt5lrqMsHm3MJM2JNCmTD4/nQG66+S1rtSCmC2lSR3N3Wg1vhCDjlxlZaTs8pxdEi5FDkPqksxyJ5/cRT8JPiDceFnHaWeIM7epxtsd7J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765485; c=relaxed/simple;
	bh=DgroseNRwnbNwM4L/P+Es9XdTfmDuc8uhbHaT8WXcnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qh9dc+NUq4T6Wsll+/bFrrfRzOJuB9BokVkdn2/I+DE7S/MYkLmoFP+W/u5htapx44kMfR8lclfl9ogBB9SmAH/lUQYyXTOVVPl5c6fqIsrSN3opMWmQ+CMzhHfwIVdouVNrhOJN8L7a+nJ8GPMZd4rKqTrsUnCuiOFptQfGn04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmKk/s5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmKk/s5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5577C4CEF7;
	Tue, 17 Mar 2026 16:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765485;
	bh=DgroseNRwnbNwM4L/P+Es9XdTfmDuc8uhbHaT8WXcnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmKk/s5GR3DRXYEuj3SwOej229rVAubKDoUBoX1qbAEML2/ZlTG/zFcvE97sLTpDY
	 ll3mKOySOJIt4Vhhv2enQlTQcAujU9ANeWbRRW9KRVipcluZks1PDw31DSXrp9UfKI
	 E9sYbcFUNh7SIYX/39Fk5Em9ekzhL832LLQPgB/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 021/378] scsi: ufs: core: Fix possible NULL pointer dereference in ufshcd_add_command_trace()
Date: Tue, 17 Mar 2026 17:29:38 +0100
Message-ID: <20260317163007.755269736@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 30df81f2228d65bddf492db3929d9fcaffd38fc5 ]

The kernel log indicates a crash in ufshcd_add_command_trace, due to a NULL
pointer dereference when accessing hwq->id.  This can happen if
ufshcd_mcq_req_to_hwq() returns NULL.

This patch adds a NULL check for hwq before accessing its id field to
prevent a kernel crash.

Kernel log excerpt:
[<ffffffd5d192dc4c>] notify_die+0x4c/0x8c
[<ffffffd5d1814e58>] __die+0x60/0xb0
[<ffffffd5d1814d64>] die+0x4c/0xe0
[<ffffffd5d181575c>] die_kernel_fault+0x74/0x88
[<ffffffd5d1864db4>] __do_kernel_fault+0x314/0x318
[<ffffffd5d2a3cdf8>] do_page_fault+0xa4/0x5f8
[<ffffffd5d2a3cd34>] do_translation_fault+0x34/0x54
[<ffffffd5d1864524>] do_mem_abort+0x50/0xa8
[<ffffffd5d2a297dc>] el1_abort+0x3c/0x64
[<ffffffd5d2a29718>] el1h_64_sync_handler+0x44/0xcc
[<ffffffd5d181133c>] el1h_64_sync+0x80/0x88
[<ffffffd5d255c1dc>] ufshcd_add_command_trace+0x23c/0x320
[<ffffffd5d255bad8>] ufshcd_compl_one_cqe+0xa4/0x404
[<ffffffd5d2572968>] ufshcd_mcq_poll_cqe_lock+0xac/0x104
[<ffffffd5d11c7460>] ufs_mtk_mcq_intr+0x54/0x74 [ufs_mediatek_mod]
[<ffffffd5d19ab92c>] __handle_irq_event_percpu+0xc8/0x348
[<ffffffd5d19abca8>] handle_irq_event+0x3c/0xa8
[<ffffffd5d19b1f0c>] handle_fasteoi_irq+0xf8/0x294
[<ffffffd5d19aa778>] generic_handle_domain_irq+0x54/0x80
[<ffffffd5d18102bc>] gic_handle_irq+0x1d4/0x330
[<ffffffd5d1838210>] call_on_irq_stack+0x44/0x68
[<ffffffd5d183af30>] do_interrupt_handler+0x78/0xd8
[<ffffffd5d2a29c00>] el1_interrupt+0x48/0xa8
[<ffffffd5d2a29ba8>] el1h_64_irq_handler+0x14/0x24
[<ffffffd5d18113c4>] el1h_64_irq+0x80/0x88
[<ffffffd5d2527fb4>] arch_local_irq_enable+0x4/0x1c
[<ffffffd5d25282e4>] cpuidle_enter+0x34/0x54
[<ffffffd5d195a678>] do_idle+0x1dc/0x2f8
[<ffffffd5d195a7c4>] cpu_startup_entry+0x30/0x3c
[<ffffffd5d18155c4>] secondary_start_kernel+0x134/0x1ac
[<ffffffd5d18640bc>] __secondary_switched+0xc4/0xcc

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260223065657.2432447-1-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6f9c5d7012812..d5628ed086381 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -516,8 +516,8 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, struct scsi_cmnd *cmd,
 
 	if (hba->mcq_enabled) {
 		struct ufs_hw_queue *hwq = ufshcd_mcq_req_to_hwq(hba, rq);
-
-		hwq_id = hwq->id;
+		if (hwq)
+			hwq_id = hwq->id;
 	} else {
 		doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	}
-- 
2.51.0



