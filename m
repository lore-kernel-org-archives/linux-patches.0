Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3308173352;
	Wed,  3 Jul 2024 10:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003577; cv=none; b=Lv0MRFe1wENXAkryV8wIRsr9y7Ym1v0kvjvHfCj50URugZjYwTedQjQliR28uLRZggx1aFRnd1YCkLBrCbaPik3WMCDFtV4CytJ4AYYzDseqk4qUHGqDEx4W1/ZVrLX/1mQcakBOPEqR4aCIYxGxus8mDV+KXmt2ZTqvxe+Ygsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003577; c=relaxed/simple;
	bh=CM4Pr9EvmHOarbgZxQyRe/WvNX6IO1XTme16y3O2zjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtuWKBEQdliKRuFth2rX+wBBRPmgvZcHTWgUI4ZObzW+tPqpsxRFplRDkJAM27JQUqefLEzJBPlp39BxKovCIPnBK8zDMV/Jpw8PgAeyjog2xnMzlAezy0H8tAhvwrW9pPCuXRGbMhNZ3FqfUn2T9GjQ5sqwFHGKPIspcIbgceM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmnWKyHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmnWKyHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFB8C2BD10;
	Wed,  3 Jul 2024 10:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003577;
	bh=CM4Pr9EvmHOarbgZxQyRe/WvNX6IO1XTme16y3O2zjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmnWKyHNL9MVOtCiiPQBW9CkdUWOuGPQiUM18ZVFH/2kv+wS7/z9nIIXsEM+94Ynl
	 VI/XUbV0Tgyon3Vekv4rFx+wRiOb4BEzO6CUDir24k4/hJruJGbZoh+49kgwbMNjiP
	 vYzw1KOjV7b6o/mPFUyJJqmUlh1PdKfNanppPH4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hoyer <mhoyer@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/139] scsi: qedi: Fix crash while reading debugfs attribute
Date: Wed,  3 Jul 2024 12:39:20 +0200
Message-ID: <20240703102832.820112402@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manish Rangankar <mrangankar@marvell.com>

[ Upstream commit 28027ec8e32ecbadcd67623edb290dad61e735b5 ]

The qedi_dbg_do_not_recover_cmd_read() function invokes sprintf() directly
on a __user pointer, which results into the crash.

To fix this issue, use a small local stack buffer for sprintf() and then
call simple_read_from_buffer(), which in turns make the copy_to_user()
call.

BUG: unable to handle page fault for address: 00007f4801111000
PGD 8000000864df6067 P4D 8000000864df6067 PUD 864df7067 PMD 846028067 PTE 0
Oops: 0002 [#1] PREEMPT SMP PTI
Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 06/15/2023
RIP: 0010:memcpy_orig+0xcd/0x130
RSP: 0018:ffffb7a18c3ffc40 EFLAGS: 00010202
RAX: 00007f4801111000 RBX: 00007f4801111000 RCX: 000000000000000f
RDX: 000000000000000f RSI: ffffffffc0bfd7a0 RDI: 00007f4801111000
RBP: ffffffffc0bfd7a0 R08: 725f746f6e5f6f64 R09: 3d7265766f636572
R10: ffffb7a18c3ffd08 R11: 0000000000000000 R12: 00007f4881110fff
R13: 000000007fffffff R14: ffffb7a18c3ffca0 R15: ffffffffc0bfd7af
FS:  00007f480118a740(0000) GS:ffff98e38af00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4801111000 CR3: 0000000864b8e001 CR4: 00000000007706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 ? __die_body+0x1a/0x60
 ? page_fault_oops+0x183/0x510
 ? exc_page_fault+0x69/0x150
 ? asm_exc_page_fault+0x22/0x30
 ? memcpy_orig+0xcd/0x130
 vsnprintf+0x102/0x4c0
 sprintf+0x51/0x80
 qedi_dbg_do_not_recover_cmd_read+0x2f/0x50 [qedi 6bcfdeeecdea037da47069eca2ba717c84a77324]
 full_proxy_read+0x50/0x80
 vfs_read+0xa5/0x2e0
 ? folio_add_new_anon_rmap+0x44/0xa0
 ? set_pte_at+0x15/0x30
 ? do_pte_missing+0x426/0x7f0
 ksys_read+0xa5/0xe0
 do_syscall_64+0x58/0x80
 ? __count_memcg_events+0x46/0x90
 ? count_memcg_event_mm+0x3d/0x60
 ? handle_mm_fault+0x196/0x2f0
 ? do_user_addr_fault+0x267/0x890
 ? exc_page_fault+0x69/0x150
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f4800f20b4d

Tested-by: Martin Hoyer <mhoyer@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Link: https://lore.kernel.org/r/20240415072155.30840-1-mrangankar@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_debugfs.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_debugfs.c b/drivers/scsi/qedi/qedi_debugfs.c
index fd914ca4149a8..6bb5f2b31b881 100644
--- a/drivers/scsi/qedi/qedi_debugfs.c
+++ b/drivers/scsi/qedi/qedi_debugfs.c
@@ -136,15 +136,11 @@ static ssize_t
 qedi_dbg_do_not_recover_cmd_read(struct file *filp, char __user *buffer,
 				 size_t count, loff_t *ppos)
 {
-	size_t cnt = 0;
-
-	if (*ppos)
-		return 0;
+	char buf[64];
+	int len;
 
-	cnt = sprintf(buffer, "do_not_recover=%d\n", qedi_do_not_recover);
-	cnt = min_t(int, count, cnt - *ppos);
-	*ppos += cnt;
-	return cnt;
+	len = sprintf(buf, "do_not_recover=%d\n", qedi_do_not_recover);
+	return simple_read_from_buffer(buffer, count, ppos, buf, len);
 }
 
 static int
-- 
2.43.0



