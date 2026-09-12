Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C7F31F9B1;
	Sat, 12 Sep 2026 16:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231738; cv=none; b=HUCJHS/2uF/bl4+YSQXpiVAcZJOSWBA5RwPs8wz/eetUzC5ktIYxskXPDnvWQ1NeFkGFUxorx7Y7obVfuhqM31N47ZFI/+vuAZmtMVmQCT00hdS3Z+1bjn74lBxw1FmyrlS7irlJaqPouhQ1/XMpKyw4haa1qG9d+YM00iu4T84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231738; c=relaxed/simple;
	bh=HjQHF8v//KL4WAz5gEcjAPT4rTAzdC5M+67kOcQhG7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clVZejQW5tpnUhEHSvw0K4ZZ9cAstXeKFoiqHVg8PwzcoyEeP0LoGjxo0KVYc1KBmTL9v7Uf+icPFNSHbVd7vnQPGykkBALh+/LQdxpUiYMSD+2DcujAbEqhzUZ41vYB4e1o1ba0rZpJUmK8zYxBoSIdPBtNHTXDZclnhqBamH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFHUe4YF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFHUe4YF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456AC1F000FF;
	Sat, 12 Sep 2026 16:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231737;
	bh=IQ+koyA+jNiqn9vOPX2d11XZtuZK1k4oMmdFe9rWLds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFHUe4YFTA8nahVUO8sAxpDXD/Gla7HF+pr9bQfqgVVYHsqj2x0wSugXCOIQpBZQp
	 8Bh8wicvgVJxPaONgBEXnV59we/bwDBfZMMBhQFDFWXNH00dvajAuuLqq7gi3cmzcT
	 1snv3PJJ2k+JviyukTLCCQ5mmPpAM8SJafEu+Ak0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Young <admiyo@os.amperecomputing.com>,
	Robbie King <robbiek@xsightlabs.com>,
	Huisong Li <lihuisong@huawei.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1018/1191] mailbox: pcc: Fix the possible race in updation of chan_in_use flag
Date: Sat, 12 Sep 2026 09:02:26 +0200
Message-ID: <20260912065611.056248666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 9779d45c749340ab461d595c1a4a664cb28f3007 ]

The function mbox_chan_received_data() calls the Rx callback of the
mailbox client driver. The callback might set chan_in_use flag from
pcc_send_data(). This flag's status determines whether the PCC channel
is in use.

However, there is a potential race condition where chan_in_use is
updated incorrectly due to concurrency between the interrupt handler
(pcc_mbox_irq()) and the command sender(pcc_send_data()).

The 'chan_in_use' flag of a channel is set to true after sending a
command. And the flag of the new command may be cleared erroneous by
the interrupt handler afer mbox_chan_received_data() returns,

As a result, the interrupt being level triggered can't be cleared in
pcc_mbox_irq() and it will be disabled after the number of handled times
exceeds the specified value. The error log is as follows:

  |  kunpeng_hccs HISI04B2:00: PCC command executed timeout!
  |  kunpeng_hccs HISI04B2:00: get port link status info failed, ret = -110
  |  irq 13: nobody cared (try booting with the "irqpoll" option)
  |  Call trace:
  |   dump_backtrace+0x0/0x210
  |   show_stack+0x1c/0x2c
  |   dump_stack+0xec/0x130
  |   __report_bad_irq+0x50/0x190
  |   note_interrupt+0x1e4/0x260
  |   handle_irq_event+0x144/0x17c
  |   handle_fasteoi_irq+0xd0/0x240
  |   __handle_domain_irq+0x80/0xf0
  |   gic_handle_irq+0x74/0x2d0
  |   el1_irq+0xbc/0x140
  |   mnt_clone_write+0x0/0x70
  |   file_update_time+0xcc/0x160
  |   fault_dirty_shared_page+0xe8/0x150
  |   do_shared_fault+0x80/0x1d0
  |   do_fault+0x118/0x1a4
  |   handle_pte_fault+0x154/0x230
  |   __handle_mm_fault+0x1ac/0x390
  |   handle_mm_fault+0xf0/0x250
  |   do_page_fault+0x184/0x454
  |   do_translation_fault+0xac/0xd4
  |   do_mem_abort+0x44/0xb4
  |   el0_da+0x40/0x74
  |   el0_sync_handler+0x60/0xb4
  |   el0_sync+0x168/0x180
  |  handlers:
  |   pcc_mbox_irq
  |  Disabling IRQ #13

To solve this issue, pcc_mbox_irq() must clear 'chan_in_use' flag before
the call to mbox_chan_received_data().

Tested-by: Adam Young <admiyo@os.amperecomputing.com>
Tested-by: Robbie King <robbiek@xsightlabs.com>
Signed-off-by: Huisong Li <lihuisong@huawei.com>
(sudeep.holla: Minor updates to the subject, commit message and comment)
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: 3360b088175d ("mailbox: pcc: Fix command timeout due to missed interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index be295313119cb..8cf51d75c4ef4 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -342,10 +342,16 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 	if (pcc_chan_reg_read_modify_write(&pchan->plat_irq_ack))
 		return IRQ_NONE;
 
+	/*
+	 * Clear this flag after updating interrupt ack register and just
+	 * before mbox_chan_received_data() which might call pcc_send_data()
+	 * where the flag is set again to start new transfer. This is
+	 * required to avoid any possible race in updatation of this flag.
+	 */
+	pchan->chan_in_use = false;
 	mbox_chan_received_data(chan, NULL);
 
 	check_and_ack(pchan, chan);
-	pchan->chan_in_use = false;
 
 	return IRQ_HANDLED;
 }
-- 
2.53.0



