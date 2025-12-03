Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3E2346789;
	Wed,  3 Dec 2025 16:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780574; cv=none; b=Q+QE/oMktmGcnoQZsUmQ1pqVJOosqf4kYVWYzc3gZdGvHTRlWnSLX2uwCE4vbAMvsrpvXYHJ5B7TEUQdjHLhhkndyG2qq4JH4tA8noXJFzziL87VlbwfxO0Aer/i7TRy/cyPBNDLMo66k4ltRjJ1Dhb4NEDpll5lJrZxBBoBsyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780574; c=relaxed/simple;
	bh=s1fHEdWEfPpReqhg/0li7FvNv2htbCprznAWinZs1Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6kyZEtCwAgTk5RDkTd+aUAjdMCjblb+Qzea1NGT6VgNoQl6RJGp3k34Mn3dmRaQ5o2lfaFzjb7Crtw4dG0txvGidiFC6m2i/bCNLL82ngFPDxcYE+LemYuHtvIzGQm9BaiYglBuyulc7sF+592TUVu8GUQ5YaowwL+9tXPJGj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWvS8ML8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWvS8ML8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0BDC4CEF5;
	Wed,  3 Dec 2025 16:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780574;
	bh=s1fHEdWEfPpReqhg/0li7FvNv2htbCprznAWinZs1Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWvS8ML8uGv5sDa1KnxdIAua/xMg+mDlSMJ2g8hSMotPCODLlCmBM0P8w/GJtwsQV
	 gxVAEHOSjzKE2TAHGSsL/6jtcIZppsYZvrjmS2KQoZy+j/qtXbt/80dpbMlVCvxI2c
	 Z5y5088JvkFO8tN9NK9SqhDDcacsgVjgZs2BhmKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/132] eth: fbnic: Fix counter roll-over issue
Date: Wed,  3 Dec 2025 16:28:25 +0100
Message-ID: <20251203152344.270416114@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohsin Bashir <mohsin.bashr@gmail.com>

[ Upstream commit 6d66e093e0740d39a36ef742c60eec247df26f41 ]

Fix a potential counter roll-over issue in fbnic_mbx_alloc_rx_msgs()
when calculating descriptor slots. The issue occurs when head - tail
results in a large positive value (unsigned) and the compiler interprets
head - tail - 1 as a signed value.

Since FBNIC_IPC_MBX_DESC_LEN is a power of two, use a masking operation,
which is a common way of avoiding this problem when dealing with these
sort of ring space calculations.

Fixes: da3cde08209e ("eth: fbnic: Add FW communication mechanism")
Signed-off-by: Mohsin Bashir <mohsin.bashr@gmail.com>
Link: https://patch.msgid.link/20251125211704.3222413-1-mohsin.bashr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index d6cf97ecf3276..6f606bdfd2296 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -198,7 +198,7 @@ static int fbnic_mbx_alloc_rx_msgs(struct fbnic_dev *fbd)
 		return -ENODEV;
 
 	/* Fill all but 1 unused descriptors in the Rx queue. */
-	count = (head - tail - 1) % FBNIC_IPC_MBX_DESC_LEN;
+	count = (head - tail - 1) & (FBNIC_IPC_MBX_DESC_LEN - 1);
 	while (!err && count--) {
 		struct fbnic_tlv_msg *msg;
 
-- 
2.51.0



