Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59E715CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3412EC433D6;
	Tue,  8 Nov 2022 13:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667914869;
	bh=cHRPvFdv9KZoP/+MEMR61Xwze9P3ECNAtVssDDxevWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhZt1u8gLf0WpkUSfj4MkyJY56+mxxK9ix4krQHUqR4cC8Fllefn6861YnTM3ZYbg
	 5cpmtfp/UNtTdvvvlIJ7QqGuOhMpcSqQaN1vx7JOQWALGc2NTtW7Et6J1bhDp6UQRb
	 GZgegVFPUS6TJWj6gQ/YEEJhv2421QElRPtMyYVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 05/30] nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()
Date: Tue,  8 Nov 2022 14:38:53 +0100
Message-Id: <20221108133326.902997533@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 93d904a734a74c54d945a9884b4962977f1176cd ]

nfcmrvl_i2c_nci_send() will be called by nfcmrvl_nci_send(), and skb
should be freed in nfcmrvl_i2c_nci_send(). However, nfcmrvl_nci_send()
will only free skb when i2c_master_send() return >=0, which means skb
will memleak when i2c_master_send() failed. Free skb no matter whether
i2c_master_send() succeeds.

Fixes: b5b3e23e4cac ("NFC: nfcmrvl: add i2c driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nfcmrvl/i2c.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index bb546cabe809..91d7ef11aba3 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -151,10 +151,15 @@ static int nfcmrvl_i2c_nci_send(struct nfcmrvl_private *priv,
 			ret = -EREMOTEIO;
 		} else
 			ret = 0;
+	}
+
+	if (ret) {
 		kfree_skb(skb);
+		return ret;
 	}
 
-	return ret;
+	consume_skb(skb);
+	return 0;
 }
 
 static void nfcmrvl_i2c_nci_update_config(struct nfcmrvl_private *priv,
-- 
2.35.1



