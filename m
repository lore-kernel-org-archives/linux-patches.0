Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775532110E;
	Tue, 27 May 2025 17:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367283; cv=none; b=W8bpCWltKOp2J0AKeBjvPS9ovI34Y1M2I/VXSRH3huBIAfqRaZDsAUNp/0UismQUkcH/rMMmmjz6X6b8Vy6ju+E7MTYclYufKH0WdHs38/EZadjsMlnfu7WU18mjETHCBkwptsTg8/pySWGgWdkUHPkNLAEdDMDBnW1kyXDi10s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367283; c=relaxed/simple;
	bh=CK0qZG3GuUY7Fvez3Zc8W+rYMienKG/dUBnn5uWVBKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/SP+wAkKHAp49Slb1SIjFCeYK1DICx8Tup2lRPiUApHv28d0uSQOQQEkUOU+99AHrBhQ7mGyyUL8pSL24e9jgYqX7OSRYdmL2dcrVBT9Ts2qAokw0qlVshf43p2nAFbknTR42ncU0z0+xWy85QYCs3J0HfQXLInw5SEYkJNSyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toDDLqON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toDDLqON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01487C4CEE9;
	Tue, 27 May 2025 17:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367283;
	bh=CK0qZG3GuUY7Fvez3Zc8W+rYMienKG/dUBnn5uWVBKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=toDDLqONvWSKj2phA+u6EQ0U5A1v4ZZ3++EjIdFK9Zr59CpTgENcktr2ToO5KWqR9
	 WRb7rQ5+nLeGTEKiuBYyXemQ/K/ay7iW5BD9vdUzL+vpPrUuJBMS1/wrN7f7/yOWfP
	 gcMRrixebWp8e7Pw4RCWsqVROPeTJ3kr3z3rUnNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 337/783] accel/amdxdna: Check interrupt register before mailbox_rx_worker exits
Date: Tue, 27 May 2025 18:22:14 +0200
Message-ID: <20250527162526.787746602@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit cd740b873f8f6f5f4558723241ba9c09eb36d0ba ]

There is a timeout failure been found during stress tests. If the firmware
generates a mailbox response right after driver clears the mailbox channel
interrupt register, the hardware will not generate an interrupt for the
response. This causes the unexpected mailbox command timeout.

To handle this failure, driver checks the interrupt register before
exiting mailbox_rx_worker(). If there is a new response, driver goes back
to process it.

Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250226161810.4188334-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_mailbox.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_mailbox.c b/drivers/accel/amdxdna/amdxdna_mailbox.c
index e5301fac13971..2879e4149c937 100644
--- a/drivers/accel/amdxdna/amdxdna_mailbox.c
+++ b/drivers/accel/amdxdna/amdxdna_mailbox.c
@@ -349,8 +349,6 @@ static irqreturn_t mailbox_irq_handler(int irq, void *p)
 	trace_mbox_irq_handle(MAILBOX_NAME, irq);
 	/* Schedule a rx_work to call the callback functions */
 	queue_work(mb_chann->work_q, &mb_chann->rx_work);
-	/* Clear IOHUB register */
-	mailbox_reg_write(mb_chann, mb_chann->iohub_int_addr, 0);
 
 	return IRQ_HANDLED;
 }
@@ -367,6 +365,9 @@ static void mailbox_rx_worker(struct work_struct *rx_work)
 		return;
 	}
 
+again:
+	mailbox_reg_write(mb_chann, mb_chann->iohub_int_addr, 0);
+
 	while (1) {
 		/*
 		 * If return is 0, keep consuming next message, until there is
@@ -380,10 +381,18 @@ static void mailbox_rx_worker(struct work_struct *rx_work)
 		if (unlikely(ret)) {
 			MB_ERR(mb_chann, "Unexpected ret %d, disable irq", ret);
 			WRITE_ONCE(mb_chann->bad_state, true);
-			disable_irq(mb_chann->msix_irq);
-			break;
+			return;
 		}
 	}
+
+	/*
+	 * The hardware will not generate interrupt if firmware creates a new
+	 * response right after driver clears interrupt register. Check
+	 * the interrupt register to make sure there is not any new response
+	 * before exiting.
+	 */
+	if (mailbox_reg_read(mb_chann, mb_chann->iohub_int_addr))
+		goto again;
 }
 
 int xdna_mailbox_send_msg(struct mailbox_channel *mb_chann,
-- 
2.39.5



