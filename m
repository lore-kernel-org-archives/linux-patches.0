Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A878F47255C;
	Tue, 21 Jul 2026 17:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656665; cv=none; b=ev7ZqlMSdK7WjaHo3jnJqphf+opgUWAZFw+0zzQCYfd9/p8jkDydRukArd5nW8Qy//zeA8it26k9Y8BJTKMGa5oAX7fFQvV0RtqhdxcJAVWVY27sQM6O392pLFhA9302UA800LfTk8MDKTnkYQi3XakeazzHm6frmhDzxleotLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656665; c=relaxed/simple;
	bh=EK9RDYRcAvvt1ow7C7cYAt5aYUPKib+RJKSRGHH9fDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYratzRVE6I7DHEAwF2di6ceMykwAKaJTBv+ArmeWilDBRdpr0g6qaR8s//Y2HSj+tfe2+8BJaUAQ66SLywaZV/TDyk9J82mJYpIw53Im/AiAuDMkbW9oxuTUIBytgEghzEaHtQLajoZjTcSBEIKqn7iVTFAXXvaXFRRcx77JKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08BFAEf1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08BFAEf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C691B1F000E9;
	Tue, 21 Jul 2026 17:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656663;
	bh=NfPt3pnn2//QBg+FgkEntxq+geB1bMlQM2JumdCXnZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08BFAEf1bRgHwOvSqLEOLQ8y86/JtlWSfKobPAt4BwJPtrIRcU1a4N3619SqouGwR
	 g45GBiekFEGS0zsW62+PZnjS+7jXn4qQqTNmWRyJV1aYfEY3bZjd3m/zOdTHTqLRl9
	 Oe5lz1orbWh9owWirOaJ6ZnED42D4yWNvV622c+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0465/1611] Bluetooth: hci_qca: fix NULL pointer dereference in qca_dmp_hdr() for non-serdev device
Date: Tue, 21 Jul 2026 17:09:41 +0200
Message-ID: <20260721152525.774477278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 6b8cbcf08de0db62254d1981f83db0f94681ccd9 ]

hu->serdev is NULL for hci_uart attached via non-serdev paths, but
qca_dmp_hdr() unconditionally dereferences hu->serdev->dev.driver->name,
causing a NULL pointer dereference.

Fix by guarding the dereference with a NULL check and falling back to
"hci_ldisc_qca" for the non-serdev case.

Fixes: 06d3fdfcdf5c ("Bluetooth: hci_qca: Add qcom devcoredump support")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index d37a51101ca760..c649a3f702c042 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1023,7 +1023,7 @@ static void qca_dmp_hdr(struct hci_dev *hdev, struct sk_buff *skb)
 	skb_put_data(skb, buf, strlen(buf));
 
 	snprintf(buf, sizeof(buf), "Driver: %s\n",
-		hu->serdev->dev.driver->name);
+		 hu->serdev ? hu->serdev->dev.driver->name : "hci_ldisc_qca");
 	skb_put_data(skb, buf, strlen(buf));
 }
 
-- 
2.53.0



