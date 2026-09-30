Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48020364028;
	Wed, 30 Sep 2026 16:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785377; cv=none; b=s8M9U4ZjfbPejQfE3/2rh0yPL41CgzJYyuoeGMrkCI8aVZ3LDAJLb8D2w+rhdU4YBZYjDFPb2xZfWsznNse09R5Sn05WXQwDC2/xz6dRO5QsNiTjzimBa4Sk1HX4Y3VIQqmYl3+1udtNTeZIlt4EsCHl9d2fBXqGZ3wvlamh7BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785377; c=relaxed/simple;
	bh=o680gW4ZhHR3nGbTkYCW1VmcrqqQUpr2B/GHeoZcGf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6n8tRCzlVQhjvVljp06IwIa3dciz9xKBiVnO/4+mTBk37HgvDMNc02fkHHOLsP3ky+B2/+e2bcE7MGN5kqYj7D9kpw0zFUrbI5R5j1JFyymnFOwJ+yqIZup0sh8I3aU39U5mxD86VrWa1eFAuGhv0DCa69B8/seh2P8Og7WLqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEHuswpp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEHuswpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C1A1F00893;
	Wed, 30 Sep 2026 16:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785373;
	bh=+HIaFPI1oqiXxwujI/khWqYctMZG+pBT0tvFE2vVqaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEHuswppl4F6hMpnvL0qtdBRMpKaQZqRB6u7v/46qMNeJbDOmHh24ElT4iYXAJ5Kh
	 pXzE8OTnZAAnoetKRLsBxkmMldQRQCASVdFqJv/afdtARJksy/rs8kftyOgJjnTAqc
	 jNt0WVrfVDCPnX1bBcUXCRn7+4nDgTH52p2rrpOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 484/982] net: hinic: fix mailbox segment buffer overflow
Date: Wed, 30 Sep 2026 17:20:20 +0200
Message-ID: <20260930152427.176082714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



