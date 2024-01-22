Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA87612A15E;
	Tue, 23 Jan 2024 00:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968761; cv=none; b=D90oDlALcHrLP6vIg/3wNZjbn4ohNT5ECOlbKrgmvf+WfYgq0woxsC6JHjiVq/MTCBDhfL+mvmxfIQGOWdfu8cvpKwXCO74Wt2MwxHdwDUO2ZXFtiJFY2ZGOVn/jwCt0sxLM8YHiL0GmiQXOuWz1S9ILrUYTuH4v0JjW+M2cvbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968761; c=relaxed/simple;
	bh=aR6M945+lyR4OriTEkSs1dOvI/LV4qRXwqTZv8OtTrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZakoiNo8t7GANv/L+jrbmXWGrZiEBX7LEYZDitwrYrmZ/CYv6WuAfz6QLyhymhfc7xQaIvM3V0/aQizQvqbVyyCKZEl8DcszHLMINqt9tCMJHSF2gPqCnmDbv7fRKmJnDyPdJvBZHpFnu9v5/WxWfGMYfsLgU/F3o71pbvLvZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ow2ew21Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ow2ew21Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22740C433C7;
	Tue, 23 Jan 2024 00:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968761;
	bh=aR6M945+lyR4OriTEkSs1dOvI/LV4qRXwqTZv8OtTrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ow2ew21ZQt4zTUCPlyjNFnhLP3kOPZ4KyOUPtQ+qrjs+A/eAb/JbVu0h7ntsFGP4u
	 aKwvk/3W8k6rkQ5MsbEUYLa0YR8XwSn5RkuYKLkm24Wgjvfba//iD7IpGC5BR0hXVk
	 wbXe/nqXTLS4h9C4ZMmhXrqSMoQAJFFjt/WMoyCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Tran <thinhtr@linux.vnet.ibm.com>,
	Venkata Sai Duggi <venkata.sai.duggi@ibm.com>,
	David Christensen <drc@linux.vnet.ibm.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/194] net/tg3: fix race condition in tg3_reset_task()
Date: Mon, 22 Jan 2024 15:55:41 -0800
Message-ID: <20240122235719.673465341@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Tran <thinhtr@linux.vnet.ibm.com>

[ Upstream commit 16b55b1f2269962fb6b5154b8bf43f37c9a96637 ]

When an EEH error is encountered by a PCI adapter, the EEH driver
modifies the PCI channel's state as shown below:

   enum {
      /* I/O channel is in normal state */
      pci_channel_io_normal = (__force pci_channel_state_t) 1,

      /* I/O to channel is blocked */
      pci_channel_io_frozen = (__force pci_channel_state_t) 2,

      /* PCI card is dead */
      pci_channel_io_perm_failure = (__force pci_channel_state_t) 3,
   };

If the same EEH error then causes the tg3 driver's transmit timeout
logic to execute, the tg3_tx_timeout() function schedules a reset
task via tg3_reset_task_schedule(), which may cause a race condition
between the tg3 and EEH driver as both attempt to recover the HW via
a reset action.

EEH driver gets error event
--> eeh_set_channel_state()
    and set device to one of
    error state above           scheduler: tg3_reset_task() get
                                returned error from tg3_init_hw()
                             --> dev_close() shuts down the interface
tg3_io_slot_reset() and
tg3_io_resume() fail to
reset/resume the device

To resolve this issue, we avoid the race condition by checking the PCI
channel state in the tg3_reset_task() function and skip the tg3 driver
initiated reset when the PCI channel is not in the normal state.  (The
driver has no access to tg3 device registers at this point and cannot
even complete the reset task successfully without external assistance.)
We'll leave the reset procedure to be managed by the EEH driver which
calls the tg3_io_error_detected(), tg3_io_slot_reset() and
tg3_io_resume() functions as appropriate.

Adding the same checking in tg3_dump_state() to avoid dumping all
device registers when the PCI channel is not in the normal state.

Signed-off-by: Thinh Tran <thinhtr@linux.vnet.ibm.com>
Tested-by: Venkata Sai Duggi <venkata.sai.duggi@ibm.com>
Reviewed-by: David Christensen <drc@linux.vnet.ibm.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20231201001911.656-1-thinhtr@linux.vnet.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 4cfb0d0ee80c..4847441cf161 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6460,6 +6460,14 @@ static void tg3_dump_state(struct tg3 *tp)
 	int i;
 	u32 *regs;
 
+	/* If it is a PCI error, all registers will be 0xffff,
+	 * we don't dump them out, just report the error and return
+	 */
+	if (tp->pdev->error_state != pci_channel_io_normal) {
+		netdev_err(tp->dev, "PCI channel ERROR!\n");
+		return;
+	}
+
 	regs = kzalloc(TG3_REG_BLK_SIZE, GFP_ATOMIC);
 	if (!regs)
 		return;
@@ -11205,7 +11213,8 @@ static void tg3_reset_task(struct work_struct *work)
 	rtnl_lock();
 	tg3_full_lock(tp, 0);
 
-	if (tp->pcierr_recovery || !netif_running(tp->dev)) {
+	if (tp->pcierr_recovery || !netif_running(tp->dev) ||
+	    tp->pdev->error_state != pci_channel_io_normal) {
 		tg3_flag_clear(tp, RESET_TASK_PENDING);
 		tg3_full_unlock(tp);
 		rtnl_unlock();
-- 
2.43.0



