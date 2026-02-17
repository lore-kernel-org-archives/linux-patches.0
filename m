Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DD7376BFF;
	Tue, 17 Feb 2026 20:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361076; cv=none; b=gA1HhfNo00gBVQXIXJsEsFueQraCUFKc2BQsv4XFc5T3h5eKa+/SLqXTa+zbQIj2wm5ftnnkmQumN4ILjDP4l0g2AI9plEbERUjWbtEOATM+bMRXuIFIFdSvopNPDz6SgJEo8tozALQROpo2ZA9DNr6PpqYnwDChYFLQZshtm6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361076; c=relaxed/simple;
	bh=DxhR+MgaT8sMRHFWHOUxYF8cq6gneD6c77kLwUJx1IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNe6ccraeuSaG9k9WRN1qQdxWWi+u/6Hm1ADF98GBAK4gZ9Llwdu8qpT9yyEJ9A75dFnz1iv6svtvVZ6GxUbSzNP+eMXZjvNh/ETtyjjuTSEq1bst4WpuBvUyD9kW6jl5V7TSITpkzfVxCbDaVLDGv5flcrvQIwdT2vXan7LkgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFUg8lKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFUg8lKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19838C4CEF7;
	Tue, 17 Feb 2026 20:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361075;
	bh=DxhR+MgaT8sMRHFWHOUxYF8cq6gneD6c77kLwUJx1IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFUg8lKiPKDZb6fk90FDoWw5FZftewWQq5295gLzVOSK0y9ZvgI79UVli94lN6ZsA
	 yjvFHEgbna+P3ns9yV3YVXZvvyii1L75E6s1aHQ6jIBKhRSZM/+jiRBi/OoR6jRsh5
	 tDXlfeVMA2F8/+Jhlj1qdY1QjHhccPbaSTkbGRws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anil Gurumurthy <agurumurthy@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <hmadhani2024@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 06/39] scsi: qla2xxx: Delay module unload while fabric scan in progress
Date: Tue, 17 Feb 2026 21:31:15 +0100
Message-ID: <20260217200003.174307555@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anil Gurumurthy <agurumurthy@marvell.com>

commit 8890bf450e0b6b283f48ac619fca5ac2f14ddd62 upstream.

System crash seen during load/unload test in a loop.

[105954.384919] RBP: ffff914589838dc0 R08: 0000000000000000 R09: 0000000000000086
[105954.384920] R10: 000000000000000f R11: ffffa31240904be5 R12: ffff914605f868e0
[105954.384921] R13: ffff914605f86910 R14: 0000000000008010 R15: 00000000ddb7c000
[105954.384923] FS:  0000000000000000(0000) GS:ffff9163fec40000(0000) knlGS:0000000000000000
[105954.384925] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[105954.384926] CR2: 000055d31ce1d6a0 CR3: 0000000119f5e001 CR4: 0000000000770ee0
[105954.384928] PKRU: 55555554
[105954.384929] Call Trace:
[105954.384931]  <IRQ>
[105954.384934]  qla24xx_sp_unmap+0x1f3/0x2a0 [qla2xxx]
[105954.384962]  ? qla_async_scan_sp_done+0x114/0x1f0 [qla2xxx]
[105954.384980]  ? qla24xx_els_ct_entry+0x4de/0x760 [qla2xxx]
[105954.384999]  ? __wake_up_common+0x80/0x190
[105954.385004]  ? qla24xx_process_response_queue+0xc2/0xaa0 [qla2xxx]
[105954.385023]  ? qla24xx_msix_rsp_q+0x44/0xb0 [qla2xxx]
[105954.385040]  ? __handle_irq_event_percpu+0x3d/0x190
[105954.385044]  ? handle_irq_event+0x58/0xb0
[105954.385046]  ? handle_edge_irq+0x93/0x240
[105954.385050]  ? __common_interrupt+0x41/0xa0
[105954.385055]  ? common_interrupt+0x3e/0xa0
[105954.385060]  ? asm_common_interrupt+0x22/0x40

The root cause of this was that there was a free (dma_free_attrs) in the
interrupt context.  There was a device discovery/fabric scan in
progress.  A module unload was issued which set the UNLOADING flag.  As
part of the discovery, after receiving an interrupt a work queue was
scheduled (which involved a work to be queued).  Since the UNLOADING
flag is set, the work item was not allocated and the mapped memory had
to be freed.  The free occurred in interrupt context leading to system
crash.  Delay the driver unload until the fabric scan is complete to
avoid the crash.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/202512090414.07Waorz0-lkp@intel.com/
Fixes: 783e0dc4f66a ("qla2xxx: Check for device state before unloading the driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
Link: https://patch.msgid.link/20251210101604.431868-8-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1216,7 +1216,8 @@ qla2x00_wait_for_hba_ready(scsi_qla_host
 	while ((qla2x00_reset_active(vha) || ha->dpc_active ||
 		ha->flags.mbox_busy) ||
 	       test_bit(FX00_RESET_RECOVERY, &vha->dpc_flags) ||
-	       test_bit(FX00_TARGET_SCAN, &vha->dpc_flags)) {
+	       test_bit(FX00_TARGET_SCAN, &vha->dpc_flags) ||
+	       (vha->scan.scan_flags & SF_SCANNING)) {
 		if (test_bit(UNLOADING, &base_vha->dpc_flags))
 			break;
 		msleep(1000);


