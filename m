Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B115F4E3247;
	Thu, 17 Sep 2026 15:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659943; cv=none; b=W4jH00ZfL3Le5par3tQpSxXT7uWcCEKXPFUNnN40c0xGIr5ZxEfhZP1oy6vqf4ev1wIz2GA/KPPz6uKB0NJw/oGKOR7TUU5R76pED4ugzns0J15NeqQoBjjFRv6/ZBZmCAvLgZqMlpRZTM18p0ed5GTVl1diwkojTOAiZN56PXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659943; c=relaxed/simple;
	bh=CrSk4uUY9ek10YTGGiv6nPCEJSx9rESFt0ZOEyc/Rjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyCntPaxocmjKWR+IEWQTUrNXtEV7WQTMv78BLDObbAV9k6O5p9mY0YICDD4UHWf5q+svDds4YKIURuczLd/h3FsYlENcuoHa0fnB+VyjLOVe+E4pu8aStiWqFU03/gSgMhTiJOFMCSY3zu+QMv+qSvaqLJ1AGwKRCoVob8EiNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4qAAT3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4qAAT3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B28A1F00893;
	Thu, 17 Sep 2026 15:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659937;
	bh=cFPGGGO9cdY51I7+4P98rbGIjXK13z092lZMSsz78MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4qAAT3ewp2qlvq3OqjtXL6A4udwyAeyWJStkIHUHad4LnbzQbVDc9PnZ8DYHO4nB
	 W131fbWF+SjNk0+2aZwxoVjvjroSxrmBg9CC/dxfm9MUFgZeWR/jq75ng7lJX7PoJn
	 4/q+KP0p6jxUqtOBcZbPJwyFZXN7L/ADlZSXeIIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 425/733] net: hinic: fix mailbox segment buffer overflow
Date: Thu, 17 Sep 2026 16:12:13 +0100
Message-ID: <20260917151402.411876837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2784127327e64..6e67a6c9578e1 100644
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



