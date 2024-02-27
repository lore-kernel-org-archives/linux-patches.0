Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5838113B2A7;
	Tue, 27 Feb 2024 13:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040799; cv=none; b=t8bKh+bZK6ryRFKH82LxoYGK/66NuQZs/DE/LpHNgdNQ3a1+6fk9Ltb+26zf0vR00QOBj6afCxkTyCKushxMzw6ZmWsUda/WlhZj1rk4wllf+fS0TtjbdlvzWZfoXkRR2+WiYSqR0zw+w59lQlBoBXzdoLuMphxXoCjMrGA2LOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040799; c=relaxed/simple;
	bh=9GQuGABVOEDJHVxpGQb2ndrs26bpyUm4aZIzzTlmCxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5BcMrULOgDgPJzv1Iw0Q+zEngcWydN//Hx1IJv6S0iEDn+PXa3M2Vl1D0luPpRYruPheHH06eMxOER02J/cT9e45Gi95Me/6BOGAsX2JV0LKZJemqSVnB2cZnOHtb9DubLBUlvKJFu6Z1c7sT2eh+NBLgtoDSBPhfz+cQN1Nuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hft+SG2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hft+SG2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B3DC433C7;
	Tue, 27 Feb 2024 13:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040799;
	bh=9GQuGABVOEDJHVxpGQb2ndrs26bpyUm4aZIzzTlmCxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hft+SG2FUur1cV8zfTpJnaLmbR1vdChFjcVpMvFCz2f7JYJJx02+5xJHLJZrQB1CI
	 f9uwvZbJ2kK7KlkURvNajhOtBsMnZvyUgP0UCsPLcmfBRkwDzRKriEd+bqQS3Sl/rB
	 mtyDgz0XYkaxpCX6IpNJcq0H0Ms0ecrAACVcqZow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Chao <alice.chao@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 112/334] scsi: ufs: core: Fix shift issue in ufshcd_clear_cmd()
Date: Tue, 27 Feb 2024 14:19:30 +0100
Message-ID: <20240227131634.096499346@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Chao <alice.chao@mediatek.com>

[ Upstream commit b513d30d59bb383a6a5d6b533afcab2cee99a8f8 ]

When task_tag >= 32 (in MCQ mode) and sizeof(unsigned int) == 4, 1U <<
task_tag will out of bounds for a u32 mask. Fix this up to prevent
SHIFT_ISSUE (bitwise shifts that are out of bounds for their data type).

[name:debug_monitors&]Unexpected kernel BRK exception at EL1
[name:traps&]Internal error: BRK handler: 00000000f2005514 [#1] PREEMPT SMP
[name:mediatek_cpufreq_hw&]cpufreq stop DVFS log done
[name:mrdump&]Kernel Offset: 0x1ba5800000 from 0xffffffc008000000
[name:mrdump&]PHYS_OFFSET: 0x80000000
[name:mrdump&]pstate: 22400005 (nzCv daif +PAN -UAO)
[name:mrdump&]pc : [0xffffffdbaf52bb2c] ufshcd_clear_cmd+0x280/0x288
[name:mrdump&]lr : [0xffffffdbaf52a774] ufshcd_wait_for_dev_cmd+0x3e4/0x82c
[name:mrdump&]sp : ffffffc0081471b0
<snip>
Workqueue: ufs_eh_wq_0 ufshcd_err_handler
Call trace:
 dump_backtrace+0xf8/0x144
 show_stack+0x18/0x24
 dump_stack_lvl+0x78/0x9c
 dump_stack+0x18/0x44
 mrdump_common_die+0x254/0x480 [mrdump]
 ipanic_die+0x20/0x30 [mrdump]
 notify_die+0x15c/0x204
 die+0x10c/0x5f8
 arm64_notify_die+0x74/0x13c
 do_debug_exception+0x164/0x26c
 el1_dbg+0x64/0x80
 el1h_64_sync_handler+0x3c/0x90
 el1h_64_sync+0x68/0x6c
 ufshcd_clear_cmd+0x280/0x288
 ufshcd_wait_for_dev_cmd+0x3e4/0x82c
 ufshcd_exec_dev_cmd+0x5bc/0x9ac
 ufshcd_verify_dev_init+0x84/0x1c8
 ufshcd_probe_hba+0x724/0x1ce0
 ufshcd_host_reset_and_restore+0x260/0x574
 ufshcd_reset_and_restore+0x138/0xbd0
 ufshcd_err_handler+0x1218/0x2f28
 process_one_work+0x5fc/0x1140
 worker_thread+0x7d8/0xe20
 kthread+0x25c/0x468
 ret_from_fork+0x10/0x20

Signed-off-by: Alice Chao <alice.chao@mediatek.com>
Link: https://lore.kernel.org/r/20240205104905.24929-1-alice.chao@mediatek.com
Reviewed-by: Stanley Jhu <chu.stanley@gmail.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1f8d86b9c4fa0..6f7cfecacd273 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3045,7 +3045,7 @@ bool ufshcd_cmd_inflight(struct scsi_cmnd *cmd)
  */
 static int ufshcd_clear_cmd(struct ufs_hba *hba, u32 task_tag)
 {
-	u32 mask = 1U << task_tag;
+	u32 mask;
 	unsigned long flags;
 	int err;
 
@@ -3063,6 +3063,8 @@ static int ufshcd_clear_cmd(struct ufs_hba *hba, u32 task_tag)
 		return 0;
 	}
 
+	mask = 1U << task_tag;
+
 	/* clear outstanding transaction before retry */
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_utrl_clear(hba, mask);
-- 
2.43.0



