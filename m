Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BA934A315;
	Tue, 26 Aug 2025 13:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216630; cv=none; b=fqYPd2jQ8Y4yOa0UFuxiwYrmJdE2/sVGcz4ailA2QNdWwfBI+s9c5cOyFim82vDnSSSkjPcY/KO46rx2m+kivbpWynoja3vW909Go9e9zwoiJcTWLVuWovhiSXP9ufqCo0JitU9VwRljgQcp+uYXl8SKPh2eb1k5PnYhDNSHkgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216630; c=relaxed/simple;
	bh=n3NrfI0BL3KZz2vNYIxLDwH0+fTdaKE0czVDD0UIIls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZfjQ8Xh04Sc3Ws7f6x0aPh/o9p25lVU56Yr0D0eLAf7BOwjctAzamTRTBdj5P8ue4uIppSHuuVSqfj0BzJzQyjbzagGQ2VQV2uWML/RijSjV2vWlo1aYZXAAgMzW7Ur1o0zhq0DZYBIgrTr3X4Ja3JGMWwYocbVKsLnLCSuAd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEW0wKWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEW0wKWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2A4C4CEF1;
	Tue, 26 Aug 2025 13:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216630;
	bh=n3NrfI0BL3KZz2vNYIxLDwH0+fTdaKE0czVDD0UIIls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEW0wKWIbdc2IRZFKP5UehD+6NJ7yXCBkRlfjNU/UQ6Hw810f+9GyjXoM9uv1Jkp/
	 UbGWuaPprrby1eqw+58RRdJe69s22EEcc05VEPOKtSdXZERWjY9+73JbXdJ+cawuCu
	 3JkWKe6lj7WMQnXi+0U5QR7UYOuyQGOOP9a2iyYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 484/644] jbd2: prevent softlockup in jbd2_log_do_checkpoint()
Date: Tue, 26 Aug 2025 13:09:35 +0200
Message-ID: <20250826110958.481051200@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit 9d98cf4632258720f18265a058e62fde120c0151 upstream.

Both jbd2_log_do_checkpoint() and jbd2_journal_shrink_checkpoint_list()
periodically release j_list_lock after processing a batch of buffers to
avoid long hold times on the j_list_lock. However, since both functions
contend for j_list_lock, the combined time spent waiting and processing
can be significant.

jbd2_journal_shrink_checkpoint_list() explicitly calls cond_resched() when
need_resched() is true to avoid softlockups during prolonged operations.
But jbd2_log_do_checkpoint() only exits its loop when need_resched() is
true, relying on potentially sleeping functions like __flush_batch() or
wait_on_buffer() to trigger rescheduling. If those functions do not sleep,
the kernel may hit a softlockup.

watchdog: BUG: soft lockup - CPU#3 stuck for 156s! [kworker/u129:2:373]
CPU: 3 PID: 373 Comm: kworker/u129:2 Kdump: loaded Not tainted 6.6.0+ #10
Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.27 06/13/2017
Workqueue: writeback wb_workfn (flush-7:2)
pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : native_queued_spin_lock_slowpath+0x358/0x418
lr : jbd2_log_do_checkpoint+0x31c/0x438 [jbd2]
Call trace:
 native_queued_spin_lock_slowpath+0x358/0x418
 jbd2_log_do_checkpoint+0x31c/0x438 [jbd2]
 __jbd2_log_wait_for_space+0xfc/0x2f8 [jbd2]
 add_transaction_credits+0x3bc/0x418 [jbd2]
 start_this_handle+0xf8/0x560 [jbd2]
 jbd2__journal_start+0x118/0x228 [jbd2]
 __ext4_journal_start_sb+0x110/0x188 [ext4]
 ext4_do_writepages+0x3dc/0x740 [ext4]
 ext4_writepages+0xa4/0x190 [ext4]
 do_writepages+0x94/0x228
 __writeback_single_inode+0x48/0x318
 writeback_sb_inodes+0x204/0x590
 __writeback_inodes_wb+0x54/0xf8
 wb_writeback+0x2cc/0x3d8
 wb_do_writeback+0x2e0/0x2f8
 wb_workfn+0x80/0x2a8
 process_one_work+0x178/0x3e8
 worker_thread+0x234/0x3b8
 kthread+0xf0/0x108
 ret_from_fork+0x10/0x20

So explicitly call cond_resched() in jbd2_log_do_checkpoint() to avoid
softlockup.

Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20250812063752.912130-1-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/checkpoint.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -297,6 +297,7 @@ restart:
 		retry:
 			if (batch_count)
 				__flush_batch(journal, &batch_count);
+			cond_resched();
 			spin_lock(&journal->j_list_lock);
 			goto restart;
 	}


