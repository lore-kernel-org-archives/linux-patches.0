Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E052351B178;
	Wed, 30 Sep 2026 18:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791589; cv=none; b=Cwd94S+3VYD/6lG8M/fJ0+vS0GdCKPUE95ISZ4dKXD+SfDzKXbLux0MZJYiQEFnabsv7iCYYnpIpxM92ITTJQ+Urtf4XXvUp5D+oAHEdXuL7IxrYILrlgPk9lFLHhMghVHxiXEasBlC9wsGBProAME+Dcjsa4ooTuyRH9GIdf4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791589; c=relaxed/simple;
	bh=KpQvHVg1RmxmvV24koNcbMPR+wSDgqgD/9uhMEPjQRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaBsvaExz2+GE7eqdxfFOCh6mIpJUV014RRUk7GB27bvgea6pU4XwpGEBIDni7xrKkoD3e29SCtj5rl7LJ1X0BwLoVnpUASuXSklnKNP4ot+rh6lEWagLn50kSJf8c9YQ8JGcDbB390/amCAmr0zldcaQ4xLOKzN98tf86vtNwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsQxSS/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsQxSS/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465011F000FF;
	Wed, 30 Sep 2026 18:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791587;
	bh=SXS7VAy/jpdalB5P13yiLoQeM2gfTSbnY/P4CfKiYh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsQxSS/KPMmqs5rhPCUejfw9xU/Zc0G9mKNIosjAIPPFt7Nd+HVpjmFGXjGMy5+Tp
	 AyE080qKFNbzq9KP7K+uV8yB8bzzRwu5XG0ua4tFjlndPGzo3AWdUZZgrRccDyH7EE
	 YKw1esLAq/vcCxr+H9txtXp0mfURTzyRielEREjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 354/752] net: hinic: fix mailbox segment buffer overflow
Date: Wed, 30 Sep 2026 17:23:44 +0200
Message-ID: <20260930152405.945377987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5078c0c738635..f5781eaea7965 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
@@ -129,6 +129,7 @@ enum hinic_mbox_tx_status {
 
 #define SEQ_ID_START_VAL			0
 #define SEQ_ID_MAX_VAL				42
+#define MBOX_LAST_SEG_MAX_LEN			(MBOX_MAX_BUF_SZ - SEQ_ID_MAX_VAL * MBOX_SEG_LEN)
 
 #define DST_AEQ_IDX_DEFAULT_VAL			0
 #define SRC_AEQ_IDX_DEFAULT_VAL			0
@@ -377,7 +378,8 @@ recv_pf_from_vf_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
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



