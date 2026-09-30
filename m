Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47586519DEA;
	Wed, 30 Sep 2026 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793077; cv=none; b=qUve9NTbzhPi64wEcWNlKAAdFT5BKCJ5lRg0qNwSSiBP6XCgk0cVFL9OguJ53w7bbEV0E1sMFfHrf0To9adyFQpqBtZUJLo+Ywp9MnVuzzDx0NT6b3h2aonOixAaEZu6Vkx00CGQgqKe2IAujm4nA0ItRLfuWePrVdBc81Dib4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793077; c=relaxed/simple;
	bh=rJ0Ot5vE13+QqzQpeg0lUMvv0HjFICpH1bxyUwbvNYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9Nq8r92KIUoTisweF+UCileFo/0RnvoqbmUZkVf1kjcD6HY9IXfhDZdDWgkK/wJRWkGgutAfir3O7Wf6GYGA8pSjAl5WtqsINSIeV5OmEGOjruoClcAicxFd/cqdzyiiKk0op98u3DfGyZ0EksCTkiGsNkHdGxaJoVcnn9OVZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZswyyrg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZswyyrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56401F000FF;
	Wed, 30 Sep 2026 18:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793076;
	bh=+9GD+mD/HxknlWyvAT9iPwATMCFMxbbmmtqvJo9pv3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZswyyrg+XdLDJRoRqbRGotbjtQlS62wOO1nV89j5kPtthrszl72Ezz31xTeviJZi
	 lM7hpVr+OQ8oOn8JFzURHHgShMHfNTsxvnjurbYk9o/412EFmwixzP0LDuTbaaQriu
	 IBY6vgnFe4ZtPeDUNRJ9Da1B8oCRfU9guD4e/BRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/395] eth: fbnic: Set AW_FLUSH_MODE alongside AW_FLUSH when flushing the mailbox
Date: Wed, 30 Sep 2026 17:25:44 +0200
Message-ID: <20260930152342.416751855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit 8947f13e436a4ff5eed9f8f019b2865a07af4bb2 ]

When tearing down the FW mailbox Rx ring, fbnic_mbx_reset_desc_ring()
writes AW_CFG with FLUSH set and everything else, BME included, cleared.
Clearing BME halts the device's writes to the host but leaves the staged
requests parked in the PUL write pipeline rather than draining them, so
on the write path FLUSH alone never terminates the outstanding requests
and the flush the firmware waits on never completes.

Add the FLUSH_MODE definition and set both bits so the staged writes
drain out of the pipeline on their own. BME stays cleared, so nothing
lands on the host; it is restored later in fbnic_mbx_init_desc_ring()
when the ring is rebuilt, once the outstanding writes are gone.

The read path is unaffected. AR_CFG has no equivalent mode bit and
AR_FLUSH terminates the outstanding reads by itself, so it is left as
is.

Both writes remain plain stores rather than read-modify-writes. That is
deliberate: the matching write in fbnic_mbx_init_desc_ring() restores
BME and the TLP attributes, and clears both flush bits as a side effect.

Fixes: 3b12f00ddd08 ("fbnic: Gate AXI read/write enabling on FW mailbox")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/178942022583.7700.11050671998277309744.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_csr.h | 1 +
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c  | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_csr.h b/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
index d3a7ad921f18c..3e070f57df6e5 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
@@ -958,6 +958,7 @@ enum {
 /* PUL User Registers */
 #define FBNIC_CSR_START_PUL_USER	0x31000	/* CSR section delimiter */
 #define FBNIC_PUL_OB_TLP_HDR_AW_CFG	0x3103d		/* 0xc40f4 */
+#define FBNIC_PUL_OB_TLP_HDR_AW_CFG_FLUSH_MODE	CSR_BIT(20)
 #define FBNIC_PUL_OB_TLP_HDR_AW_CFG_FLUSH	CSR_BIT(19)
 #define FBNIC_PUL_OB_TLP_HDR_AW_CFG_BME		CSR_BIT(18)
 #define FBNIC_PUL_OB_TLP_HDR_AR_CFG	0x3103e		/* 0xc40f8 */
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 1204c12ea0fa2..9e5de01698fc4 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -60,8 +60,15 @@ static void fbnic_mbx_reset_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
 	 */
 	switch (mbx_idx) {
 	case FBNIC_IPC_MBX_RX_IDX:
+		/* Clearing BME blocks the device from writing to the host
+		 * but leaves the requests parked in the write pipeline. The
+		 * write path only clears outstanding requests when both FLUSH
+		 * and FLUSH_MODE are set; FLUSH_MODE lets them drain without
+		 * landing on the host.
+		 */
 		wr32(fbd, FBNIC_PUL_OB_TLP_HDR_AW_CFG,
-		     FBNIC_PUL_OB_TLP_HDR_AW_CFG_FLUSH);
+		     FBNIC_PUL_OB_TLP_HDR_AW_CFG_FLUSH |
+		     FBNIC_PUL_OB_TLP_HDR_AW_CFG_FLUSH_MODE);
 		break;
 	case FBNIC_IPC_MBX_TX_IDX:
 		wr32(fbd, FBNIC_PUL_OB_TLP_HDR_AR_CFG,
-- 
2.53.0



