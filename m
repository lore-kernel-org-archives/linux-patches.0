Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A80625742B;
	Mon, 12 May 2025 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072752; cv=none; b=IoGYyPjx1Hny2LbIhasSGXZtYUpvqqmfbG+8cs3W6sczjVVBQ5Tv9tliWajASaEKwYU7kMdL5j3Hv8yomvRDCKdtXCxKYKMJgOYodI09xP8d4i/LnAnMFAadugTFM1DHv29FVyvL0Y6UpEdGuSUSrpbuuAxNq9fxRf1Ae6W7Bqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072752; c=relaxed/simple;
	bh=X3l74GXgu8/E1nDntqoxVi530qIz0J8DLNQcOBtLKdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0sgXOZHqhfr3CTAATlNKYPKvmgEuc+v4u0AEExTBWzKzsare7QBi+oE8jlvVPXcg4D+yjDZDnn8KFBaTBz2Zb2LOrVR61oqDOhEc0FZc1pkmjTNZcnF4GZ8lxKqa6AczrtltYYJT+7BPGjygjV0G9h4SvTi+pAlGo5y0QawkMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkIwmzYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkIwmzYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004AFC4CEE7;
	Mon, 12 May 2025 17:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072752;
	bh=X3l74GXgu8/E1nDntqoxVi530qIz0J8DLNQcOBtLKdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkIwmzYsBG6BAi6EahP2z4lnv0n6Thp4Qee74RQ+k1zQC0dDUIcZUXuCstzaZczxO
	 5NWSlsn2BzXUsDtMhgWCi0k+UGqz/L546M2znkDcYe895LkrduNm8fazEqW2nhE07s
	 F0+aQIQEBbVATUDLMmwTgGJiGMA7oxIY7onzThFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/184] fbnic: Fix initialization of mailbox descriptor rings
Date: Mon, 12 May 2025 19:44:07 +0200
Message-ID: <20250512172043.612284105@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit f34343cc11afc7bb1f881c3492bee3484016bf71 ]

Address to issues with the FW mailbox descriptor initialization.

We need to reverse the order of accesses when we invalidate an entry versus
writing an entry. When writing an entry we write upper and then lower as
the lower 32b contain the valid bit that makes the entire address valid.
However for invalidation we should write it in the reverse order so that
the upper is marked invalid before we update it.

Without this change we may see FW attempt to access pages with the upper
32b of the address set to 0 which will likely result in DMAR faults due to
write access failures on mailbox shutdown.

Fixes: da3cde08209e ("eth: fbnic: Add FW communication mechanism")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/174654717972.499179.8083789731819297034.stgit@ahduyck-xeon-server.home.arpa
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c | 32 ++++++++++++++++------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 8f7a2a19ddf80..612d09ea08ebb 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -17,11 +17,29 @@ static void __fbnic_mbx_wr_desc(struct fbnic_dev *fbd, int mbx_idx,
 {
 	u32 desc_offset = FBNIC_IPC_MBX(mbx_idx, desc_idx);
 
+	/* Write the upper 32b and then the lower 32b. Doing this the
+	 * FW can then read lower, upper, lower to verify that the state
+	 * of the descriptor wasn't changed mid-transaction.
+	 */
 	fw_wr32(fbd, desc_offset + 1, upper_32_bits(desc));
 	fw_wrfl(fbd);
 	fw_wr32(fbd, desc_offset, lower_32_bits(desc));
 }
 
+static void __fbnic_mbx_invalidate_desc(struct fbnic_dev *fbd, int mbx_idx,
+					int desc_idx, u32 desc)
+{
+	u32 desc_offset = FBNIC_IPC_MBX(mbx_idx, desc_idx);
+
+	/* For initialization we write the lower 32b of the descriptor first.
+	 * This way we can set the state to mark it invalid before we clear the
+	 * upper 32b.
+	 */
+	fw_wr32(fbd, desc_offset, desc);
+	fw_wrfl(fbd);
+	fw_wr32(fbd, desc_offset + 1, 0);
+}
+
 static u64 __fbnic_mbx_rd_desc(struct fbnic_dev *fbd, int mbx_idx, int desc_idx)
 {
 	u32 desc_offset = FBNIC_IPC_MBX(mbx_idx, desc_idx);
@@ -41,21 +59,17 @@ static void fbnic_mbx_init_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
 	 * solid stop for the firmware to hit when it is done looping
 	 * through the ring.
 	 */
-	__fbnic_mbx_wr_desc(fbd, mbx_idx, 0, 0);
-
-	fw_wrfl(fbd);
+	__fbnic_mbx_invalidate_desc(fbd, mbx_idx, 0, 0);
 
 	/* We then fill the rest of the ring starting at the end and moving
 	 * back toward descriptor 0 with skip descriptors that have no
 	 * length nor address, and tell the firmware that they can skip
 	 * them and just move past them to the one we initialized to 0.
 	 */
-	for (desc_idx = FBNIC_IPC_MBX_DESC_LEN; --desc_idx;) {
-		__fbnic_mbx_wr_desc(fbd, mbx_idx, desc_idx,
-				    FBNIC_IPC_MBX_DESC_FW_CMPL |
-				    FBNIC_IPC_MBX_DESC_HOST_CMPL);
-		fw_wrfl(fbd);
-	}
+	for (desc_idx = FBNIC_IPC_MBX_DESC_LEN; --desc_idx;)
+		__fbnic_mbx_invalidate_desc(fbd, mbx_idx, desc_idx,
+					    FBNIC_IPC_MBX_DESC_FW_CMPL |
+					    FBNIC_IPC_MBX_DESC_HOST_CMPL);
 }
 
 void fbnic_mbx_init(struct fbnic_dev *fbd)
-- 
2.39.5



