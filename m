Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77799185A;
	Sat, 13 Jan 2024 09:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1No9QYPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23F6C433C7;
	Sat, 13 Jan 2024 09:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139955;
	bh=mWNiw6JikDcCJYQxHNiuOXMZ9Lz+wRhC9yV/t5kfgyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1No9QYPIC+j/KY5IQEGTlsOLMBZ8cv9pbb/DtLWXQiEXbY8A//XChwGdsaJD/M3xJ
	 KiulrbHiKwCV3aPM269G9RlxlIo8VG/bsulgt3mTgw06yG3oi++Z6Q7ARDfAKr3c97
	 6tn4qixIpa7JDFl5fGehYY1kSoHT7YdNpPCV5D8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 34/43] mmc: core: Cancel delayed work before releasing host
Date: Sat, 13 Jan 2024 10:50:13 +0100
Message-ID: <20240113094208.026878291@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.930684111@linuxfoundation.org>
References: <20240113094206.930684111@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 1036f69e251380573e256568cf814506e3fb9988 upstream.

On RZ/Five SMARC EVK, where probing of SDHI is deferred due to probe
deferral of the vqmmc-supply regulator:

    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 0 at kernel/time/timer.c:1738 __run_timers.part.0+0x1d0/0x1e8
    Modules linked in:
    CPU: 0 PID: 0 Comm: swapper Not tainted 6.7.0-rc4 #101
    Hardware name: Renesas SMARC EVK based on r9a07g043f01 (DT)
    epc : __run_timers.part.0+0x1d0/0x1e8
     ra : __run_timers.part.0+0x134/0x1e8
    epc : ffffffff800771a4 ra : ffffffff80077108 sp : ffffffc800003e60
     gp : ffffffff814f5028 tp : ffffffff8140c5c0 t0 : ffffffc800000000
     t1 : 0000000000000001 t2 : ffffffff81201300 s0 : ffffffc800003f20
     s1 : ffffffd8023bc4a0 a0 : 00000000fffee6b0 a1 : 0004010000400000
     a2 : ffffffffc0000016 a3 : ffffffff81488640 a4 : ffffffc800003e60
     a5 : 0000000000000000 a6 : 0000000004000000 a7 : ffffffc800003e68
     s2 : 0000000000000122 s3 : 0000000000200000 s4 : 0000000000000000
     s5 : ffffffffffffffff s6 : ffffffff81488678 s7 : ffffffff814886c0
     s8 : ffffffff814f49c0 s9 : ffffffff81488640 s10: 0000000000000000
     s11: ffffffc800003e60 t3 : 0000000000000240 t4 : 0000000000000a52
     t5 : ffffffd8024ae018 t6 : ffffffd8024ae038
    status: 0000000200000100 badaddr: 0000000000000000 cause: 0000000000000003
    [<ffffffff800771a4>] __run_timers.part.0+0x1d0/0x1e8
    [<ffffffff800771e0>] run_timer_softirq+0x24/0x4a
    [<ffffffff80809092>] __do_softirq+0xc6/0x1fa
    [<ffffffff80028e4c>] irq_exit_rcu+0x66/0x84
    [<ffffffff80800f7a>] handle_riscv_irq+0x40/0x4e
    [<ffffffff80808f48>] call_on_irq_stack+0x1c/0x28
    ---[ end trace 0000000000000000 ]---

What happens?

    renesas_sdhi_probe()
    {
    	tmio_mmc_host_alloc()
	    mmc_alloc_host()
		INIT_DELAYED_WORK(&host->detect, mmc_rescan);

	devm_request_irq(tmio_mmc_irq);

	/*
	 * After this, the interrupt handler may be invoked at any time
	 *
	 *  tmio_mmc_irq()
	 *  {
	 *	__tmio_mmc_card_detect_irq()
	 *	    mmc_detect_change()
	 *		_mmc_detect_change()
	 *		    mmc_schedule_delayed_work(&host->detect, delay);
	 *  }
	 */

	tmio_mmc_host_probe()
	    tmio_mmc_init_ocr()
		-EPROBE_DEFER

	tmio_mmc_host_free()
	    mmc_free_host()
    }

When expire_timers() runs later, it warns because the MMC host structure
containing the delayed work was freed, and now contains an invalid work
function pointer.

Fix this by cancelling any pending delayed work before releasing the
MMC host structure.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/205dc4c91b47e31b64392fe2498c7a449e717b4b.1701689330.git.geert+renesas@glider.be
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/host.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -612,6 +612,7 @@ EXPORT_SYMBOL(mmc_remove_host);
  */
 void mmc_free_host(struct mmc_host *host)
 {
+	cancel_delayed_work_sync(&host->detect);
 	mmc_pwrseq_free(host);
 	put_device(&host->class_dev);
 }


