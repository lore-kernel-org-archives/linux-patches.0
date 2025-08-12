Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF7C1A3029;
	Tue, 12 Aug 2025 19:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025721; cv=none; b=OSuGmzrjqYE0Xt1Y82kKMzi/fkwXGnyvUY99cp4SsJ+pEBqTINdAMAhDIARFo38bo23aVXV4OSSbNGL8Ty22KOp4vRjzrQogzojf5xggK5oSmqgdihj4bcWhR7kHO4dcmk8Y0pQh0sIr6ZVy6jDykkHfjYvjArOGYXLypEAz9yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025721; c=relaxed/simple;
	bh=Vz0CUNvXdpuotyKNUe6CjLED01GBBM+smdhp7+VbeB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDBsjhJMqHxMwlrN1ALwmi4bVw9eYWRNW+9/J5WszQcSj2460IkPaJz0CQRLLT9sc1CVrkdSYf0LPgs47JwVGKiBFihQ/xlA33cKOYmtruJZ35eVF0vMB3sKdYZI+dMDwdJi8JtRaybRIKuPqk9EV9bXMH+RLY56ZRT0GVVXC+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOLbk37X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOLbk37X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B583BC4CEF0;
	Tue, 12 Aug 2025 19:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025721;
	bh=Vz0CUNvXdpuotyKNUe6CjLED01GBBM+smdhp7+VbeB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOLbk37XPPif8o12Iqqymsi0g/FYIsupa+Xy7Bvt3Aty1sF7HCOOBKzKlLH0rL7ER
	 BiHFLgkcIHKu9SUH25QlnvU7p/dMAGLKz2bCPYZAvxg1phBLCacmRSog19cfNisl6h
	 JNO0ZZXea2zNPvzesO1gYVYOnI5ysIsl2e0HVGoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 125/480] wifi: ath11k: clear initialized flag for deinit-ed srng lists
Date: Tue, 12 Aug 2025 19:45:33 +0200
Message-ID: <20250812174402.681306928@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8cb1505a5a0c..cab11a35f911 100644
--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -1346,6 +1346,10 @@ EXPORT_SYMBOL(ath11k_hal_srng_init);
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



