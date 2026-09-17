Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5B0547042;
	Thu, 17 Sep 2026 18:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670833; cv=none; b=ObNwKWdPtJGHw/5fqxW4V64fUJSGYyD4U8Npcitg8SeBdhllH2WU5GHbVOhY5TwmhP7sZzcOHacnfwRLYatebROXI9bwBm6YTtX7XlEk31u/MIiDSFM4P5ngHeeeP9T86rK2wg9DBpHCpJnQ4tc77nQD/XJyQcReFxuaZPFD4jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670833; c=relaxed/simple;
	bh=WBP/ZYUeIW9oCPm6p57UgWE7PGXGoX/0xFCDM4T+FDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loMDx0xrGzDrZLOtuDkNWiV5Eq3vwvSQaOgUVLtzdHSmqRCrUWN+bDLQHhdCPl+UoLyPnTCaRE/2SNSI5rf0uGahBWVfWa51c5ydv3G6ZNZJNShN29dRs1EcLd826qughvLwsrcNvaaa5nD1LgM8R3jyOW7f4ypKX73MIwjjdHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkJhwLsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkJhwLsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6941F000FF;
	Thu, 17 Sep 2026 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670831;
	bh=7QAt00QbUsJejnrgUaRvr73RF6INtgxM0E4D99ek7VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkJhwLsnIYqK8O6af3hn+dJdDNf6wA0UCUPWP/m8e6y+2hS7zkXAk1gqkvQ2yngiw
	 XtlGaL9rtudSf9t/AmdAQKPo90g9yuz7EkpI5hD6hb1eT+vvbdrKILGxsBwQwRbbtP
	 M0JgpwYkDjiY1UkFIebX5KEpOoBurirU4E5o+2Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0784/1102] net: hinic: fix mailbox segment buffer overflow
Date: Thu, 17 Sep 2026 16:12:07 +0100
Message-ID: <20260917151600.146655935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit 5d4d985957434867bbe85e4fa5e638f3e48ad522 ]

check_mbox_seq_id_and_seg_len() validates that seq_id does not
exceed SEQ_ID_MAX_VAL (42) and seg_len does not exceed
MBOX_SEG_LEN (48).  However, this allows the last segment
(seq_id=42) to carry a full 48-byte payload, writing to offset
42*48=2016 for 48 bytes (ending at byte 2064).  The receive
buffer is only MBOX_MAX_BUF_SZ (2048) bytes, resulting in a
16-byte heap buffer overflow.

The hinic3 driver already handles this correctly by defining
MBOX_LAST_SEG_MAX_LEN and rejecting the last segment when it
exceeds the remaining buffer space.  Apply the same fix to the
hinic driver.

Fixes: a425b6e1c69b ("hinic: add mailbox function support")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Link: https://patch.msgid.link/AS8P251MB0001AE870B09020B46B5D7DBC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
index 3f9c31d292158..420fb64460e10 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
@@ -128,6 +128,7 @@ enum hinic_mbox_tx_status {
 
 #define SEQ_ID_START_VAL			0
 #define SEQ_ID_MAX_VAL				42
+#define MBOX_LAST_SEG_MAX_LEN			(MBOX_MAX_BUF_SZ - SEQ_ID_MAX_VAL * MBOX_SEG_LEN)
 
 #define NO_DMA_ATTRIBUTE_VAL			0
 
@@ -372,7 +373,8 @@ recv_pf_from_vf_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
 static bool check_mbox_seq_id_and_seg_len(struct hinic_recv_mbox *recv_mbox,
 					  u8 seq_id, u8 seg_len)
 {
-	if (seq_id > SEQ_ID_MAX_VAL || seg_len > MBOX_SEG_LEN)
+	if (seq_id > SEQ_ID_MAX_VAL || seg_len > MBOX_SEG_LEN ||
+	    (seq_id == SEQ_ID_MAX_VAL && seg_len > MBOX_LAST_SEG_MAX_LEN))
 		return false;
 
 	if (seq_id == 0) {
-- 
2.53.0



