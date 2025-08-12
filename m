Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ADC284685;
	Tue, 12 Aug 2025 18:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024817; cv=none; b=Fei2jny9w90cSGi1QNAe0awSUgmrjWg6xetUCb4RbPGqI7a8VLL6Lo7iG3mmwmDQNxSVzv+z/xNXrcYIyzTZRJbbZkRW9bx8ul3ult478vM+uN4ctM2R25RKlmkOulc9pCA6TXqSWjLNBZEQb1vTi5uj1QG3zMfQ9NnX1l6u9J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024817; c=relaxed/simple;
	bh=jbPH3D7ztrl+hXyG0jTlD2Mj7wSpn8Vyc56hpse4jm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bS9yM48ENYGRkhc4qYplJtzFrddiEKOnJqh+cPrG+DP+FCmi0SYi75c28WAtD1XJy+Rj0ya0gbAAlYkp7HTC03UokJpbAafeEFqpDSmGes6FnvZMUv8/Z33pwBsnVpoWTGDeG0GOdblQdOMdIOsvjRXEJVShyude/p/HiTMUaIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlXfSdDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlXfSdDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642D0C4CEF0;
	Tue, 12 Aug 2025 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024815;
	bh=jbPH3D7ztrl+hXyG0jTlD2Mj7wSpn8Vyc56hpse4jm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlXfSdDNtcv2nrnQ0cVdCpgk7wVpNVQfCFFoSjcxGaD5nzctKu9UCeWPCfa3XWlLq
	 2qb1S84HO9visadzcHAHLxuuS0sAxPAr/327KE3yRGrV8vSj3HXJT5POhai1Ic0Vbd
	 2NGwd4SSadNgZuw6k+qM7vdRsIc0rklF3E34sUL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Prusakowski <jprusakowski@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 484/627] f2fs: vm_unmap_ram() may be called from an invalid context
Date: Tue, 12 Aug 2025 19:32:59 +0200
Message-ID: <20250812173443.810994935@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Prusakowski <jprusakowski@google.com>

[ Upstream commit 08a7efc5b02a0620ae16aa9584060e980a69cb55 ]

When testing F2FS with xfstests using UFS backed virtual disks the
kernel complains sometimes that f2fs_release_decomp_mem() calls
vm_unmap_ram() from an invalid context. Example trace from
f2fs/007 test:

f2fs/007 5s ...  [12:59:38][    8.902525] run fstests f2fs/007
[   11.468026] BUG: sleeping function called from invalid context at mm/vmalloc.c:2978
[   11.471849] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 68, name: irq/22-ufshcd
[   11.475357] preempt_count: 1, expected: 0
[   11.476970] RCU nest depth: 0, expected: 0
[   11.478531] CPU: 0 UID: 0 PID: 68 Comm: irq/22-ufshcd Tainted: G        W           6.16.0-rc5-xfstests-ufs-g40f92e79b0aa #9 PREEMPT(none)
[   11.478535] Tainted: [W]=WARN
[   11.478536] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   11.478537] Call Trace:
[   11.478543]  <TASK>
[   11.478545]  dump_stack_lvl+0x4e/0x70
[   11.478554]  __might_resched.cold+0xaf/0xbe
[   11.478557]  vm_unmap_ram+0x21/0xb0
[   11.478560]  f2fs_release_decomp_mem+0x59/0x80
[   11.478563]  f2fs_free_dic+0x18/0x1a0
[   11.478565]  f2fs_finish_read_bio+0xd7/0x290
[   11.478570]  blk_update_request+0xec/0x3b0
[   11.478574]  ? sbitmap_queue_clear+0x3b/0x60
[   11.478576]  scsi_end_request+0x27/0x1a0
[   11.478582]  scsi_io_completion+0x40/0x300
[   11.478583]  ufshcd_mcq_poll_cqe_lock+0xa3/0xe0
[   11.478588]  ufshcd_sl_intr+0x194/0x1f0
[   11.478592]  ufshcd_threaded_intr+0x68/0xb0
[   11.478594]  ? __pfx_irq_thread_fn+0x10/0x10
[   11.478599]  irq_thread_fn+0x20/0x60
[   11.478602]  ? __pfx_irq_thread_fn+0x10/0x10
[   11.478603]  irq_thread+0xb9/0x180
[   11.478605]  ? __pfx_irq_thread_dtor+0x10/0x10
[   11.478607]  ? __pfx_irq_thread+0x10/0x10
[   11.478609]  kthread+0x10a/0x230
[   11.478614]  ? __pfx_kthread+0x10/0x10
[   11.478615]  ret_from_fork+0x7e/0xd0
[   11.478619]  ? __pfx_kthread+0x10/0x10
[   11.478621]  ret_from_fork_asm+0x1a/0x30
[   11.478623]  </TASK>

This patch modifies in_task() check inside f2fs_read_end_io() to also
check if interrupts are disabled. This ensures that pages are unmapped
asynchronously in an interrupt handler.

Fixes: bff139b49d9f ("f2fs: handle decompress only post processing in softirq")
Signed-off-by: Jan Prusakowski <jprusakowski@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 31e892842625..718e0b81a02f 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -282,7 +282,7 @@ static void f2fs_read_end_io(struct bio *bio)
 {
 	struct f2fs_sb_info *sbi = F2FS_P_SB(bio_first_page_all(bio));
 	struct bio_post_read_ctx *ctx;
-	bool intask = in_task();
+	bool intask = in_task() && !irqs_disabled();
 
 	iostat_update_and_unbind_ctx(bio);
 	ctx = bio->bi_private;
-- 
2.39.5



