Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63392F7461;
	Tue, 12 Aug 2025 17:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020522; cv=none; b=tNQPplsM8BWsROAQxsEFNmqf1jVNuzGuGbvUCcwIlSFAKI9QQoIPZDD7yclG+bEziuY12ViTbBs22GjkR7UoLt3UF1D4ap1/m4Kt4yK7CLLouEad9OjperE4cqOc3bjfZ2kxpqGJl5K+9MKO7th0N6UpxNCtQM6md6lfY/DpKBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020522; c=relaxed/simple;
	bh=Y2rjdLqFeWXr5jwcFZmmIBt/jVnjstyjof4gz+cKLDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leReUqLbSpYBTHsZUtBr3yiwmIB9M3bKik0bsFkv7xLRRqBglaeW/IbvCTaOrdPaS7kdy2b0A5eT8FgkCZpQiXdJ7rL1oT1IOSJYa8xlF1T1zo5ecuVnBUU/klwI0LJ7Ue2hOM1vswik/OnFfQEqUxGInWk0yvW2qIHGj2joaZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6QiWc6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6QiWc6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369A0C4CEF6;
	Tue, 12 Aug 2025 17:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020522;
	bh=Y2rjdLqFeWXr5jwcFZmmIBt/jVnjstyjof4gz+cKLDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6QiWc6FD15cMMH+ATS+YYTMmeNSvs96GU4H2Ex1R5H0ywF/h5yVqmXgznrADeEvn
	 4z7CRpOTpEWmbTxMezqeIkNQ+KgqpGeluHiTKO9nKEk5PfmGP3TVWdT+Ab3cGgs7fu
	 UBJyVddzJAFcIJFppw5S+7UAskut2rfazXjbcrfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/253] wifi: ath11k: clear initialized flag for deinit-ed srng lists
Date: Tue, 12 Aug 2025 19:28:14 +0200
Message-ID: <20250812172953.236067360@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit a5b46aa7cf5f05c213316a018e49a8e086efd98e ]

In a number of cases we see kernel panics on resume due
to ath11k kernel page fault, which happens under the
following circumstances:

1) First ath11k_hal_dump_srng_stats() call

 Last interrupt received for each group:
 ath11k_pci 0000:01:00.0: group_id 0 22511ms before
 ath11k_pci 0000:01:00.0: group_id 1 14440788ms before
 [..]
 ath11k_pci 0000:01:00.0: failed to receive control response completion, polling..
 ath11k_pci 0000:01:00.0: Service connect timeout
 ath11k_pci 0000:01:00.0: failed to connect to HTT: -110
 ath11k_pci 0000:01:00.0: failed to start core: -110
 ath11k_pci 0000:01:00.0: firmware crashed: MHI_CB_EE_RDDM
 ath11k_pci 0000:01:00.0: already resetting count 2
 ath11k_pci 0000:01:00.0: failed to wait wlan mode request (mode 4): -110
 ath11k_pci 0000:01:00.0: qmi failed to send wlan mode off: -110
 ath11k_pci 0000:01:00.0: failed to reconfigure driver on crash recovery
 [..]

2) At this point reconfiguration fails (we have 2 resets) and
  ath11k_core_reconfigure_on_crash() calls ath11k_hal_srng_deinit()
  which destroys srng lists.  However, it does not reset per-list
  ->initialized flag.

3) Second ath11k_hal_dump_srng_stats() call sees stale ->initialized
  flag and attempts to dump srng stats:

 Last interrupt received for each group:
 ath11k_pci 0000:01:00.0: group_id 0 66785ms before
 ath11k_pci 0000:01:00.0: group_id 1 14485062ms before
 ath11k_pci 0000:01:00.0: group_id 2 14485062ms before
 ath11k_pci 0000:01:00.0: group_id 3 14485062ms before
 ath11k_pci 0000:01:00.0: group_id 4 14780845ms before
 ath11k_pci 0000:01:00.0: group_id 5 14780845ms before
 ath11k_pci 0000:01:00.0: group_id 6 14485062ms before
 ath11k_pci 0000:01:00.0: group_id 7 66814ms before
 ath11k_pci 0000:01:00.0: group_id 8 68997ms before
 ath11k_pci 0000:01:00.0: group_id 9 67588ms before
 ath11k_pci 0000:01:00.0: group_id 10 69511ms before
 BUG: unable to handle page fault for address: ffffa007404eb010
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 100000067 P4D 100000067 PUD 10022d067 PMD 100b01067 PTE 0
 Oops: 0000 [#1] PREEMPT SMP NOPTI
 RIP: 0010:ath11k_hal_dump_srng_stats+0x2b4/0x3b0 [ath11k]
 Call Trace:
 <TASK>
 ? __die_body+0xae/0xb0
 ? page_fault_oops+0x381/0x3e0
 ? exc_page_fault+0x69/0xa0
 ? asm_exc_page_fault+0x22/0x30
 ? ath11k_hal_dump_srng_stats+0x2b4/0x3b0 [ath11k (HASH:6cea 4)]
 ath11k_qmi_driver_event_work+0xbd/0x1050 [ath11k (HASH:6cea 4)]
 worker_thread+0x389/0x930
 kthread+0x149/0x170

Clear per-list ->initialized flag in ath11k_hal_srng_deinit().

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Baochen Qiang <quic_bqiang@quicinc.com>
Fixes: 5118935b1bc2 ("ath11k: dump SRNG stats during FW assert")
Link: https://patch.msgid.link/20250612084551.702803-1-senozhatsky@chromium.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/hal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/hal.c b/drivers/net/wireless/ath/ath11k/hal.c
index a5028efbdd2e..ec64fbf9aa82 100644
--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -1314,6 +1314,10 @@ EXPORT_SYMBOL(ath11k_hal_srng_init);
 void ath11k_hal_srng_deinit(struct ath11k_base *ab)
 {
 	struct ath11k_hal *hal = &ab->hal;
+	int i;
+
+	for (i = 0; i < HAL_SRNG_RING_ID_MAX; i++)
+		ab->hal.srng_list[i].initialized = 0;
 
 	ath11k_hal_unregister_srng_key(ab);
 	ath11k_hal_free_cont_rdp(ab);
-- 
2.39.5



