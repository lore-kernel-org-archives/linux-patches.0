Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5316168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566CCC433EF;
	Mon,  8 May 2023 11:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544405;
	bh=9yy/HZY/C+K3AJl6G24hXErnAHqKSnZo1FpKBWuJSsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7eMiTCN6BIh2Hs0vFj+docvP38rCAbCXjHfjn8LQrdtAwIpTzDkWM+Inzk7ZpD/R
	 v4MmfuPDGU0tjomf33T2/ghoa2dgvrc8XZQKK7f0zoBGoz4JIvyBRNo32F0AFvYLHp
	 tUtbq+tnizbC78MT0sPAvLxeDdf2Y6HhoAX7oJpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 399/694] wifi: ath11k: fix writing to unintended memory region
Date: Mon,  8 May 2023 11:43:54 +0200
Message-Id: <20230508094446.069558106@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit 756a7f90878f0866fd2fe167ef37e90b47326b96 ]

While initializing spectral, the magic value is getting written to the
invalid memory address leading to random boot-up crash. This occurs
due to the incorrect index increment in ath11k_dbring_fill_magic_value
function. Fix it by replacing the existing logic with memset32 to ensure
there is no invalid memory access.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.4.0.1-01838-QCAHKSWPL_SILICONZ-1

Fixes: d3d358efc553 ("ath11k: add spectral/CFR buffer validation support")
Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230321052900.16895-1-quic_ppranees@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dbring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dbring.c b/drivers/net/wireless/ath/ath11k/dbring.c
index 2107ec05d14fd..5536e86423312 100644
--- a/drivers/net/wireless/ath/ath11k/dbring.c
+++ b/drivers/net/wireless/ath/ath11k/dbring.c
@@ -26,13 +26,13 @@ int ath11k_dbring_validate_buffer(struct ath11k *ar, void *buffer, u32 size)
 static void ath11k_dbring_fill_magic_value(struct ath11k *ar,
 					   void *buffer, u32 size)
 {
-	u32 *temp;
-	int idx;
-
-	size = size >> 2;
+	/* memset32 function fills buffer payload with the ATH11K_DB_MAGIC_VALUE
+	 * and the variable size is expected to be the number of u32 values
+	 * to be stored, not the number of bytes.
+	 */
+	size = size / sizeof(u32);
 
-	for (idx = 0, temp = buffer; idx < size; idx++, temp++)
-		*temp++ = ATH11K_DB_MAGIC_VALUE;
+	memset32(buffer, ATH11K_DB_MAGIC_VALUE, size);
 }
 
 static int ath11k_dbring_bufs_replenish(struct ath11k *ar,
-- 
2.39.2



