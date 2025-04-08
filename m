Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD2826A1A4;
	Tue,  8 Apr 2025 10:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109863; cv=none; b=V0jcEOcpZUgrmSukefkIooWoKfbDjC5nSOceDLwwKVgJ4R+h6pT9tW5fMvSUCN3shOgA+knd5FRxdnoxFuPZFVQg9qfyWrKr2KQnSddOlJjh7jiQDBQtYZondGD/BpE6cR6d5G5r5H/hKMTSogX26XXy35YihdiAXJsUOvaYloo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109863; c=relaxed/simple;
	bh=onqPFiJPMo5Ttk6YbO3DE+BGXQ5gys/egLHyMAYmRCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oa30pNwjmyujBsuTaHT6snH/feh+auOAC43+ZnxQ0+9Bp+8awIeXNZmkqBjtehc/8g1Cbl+ILqV5HvLHAtzPGlINzqF5JFDk4smE1/MnsgF1WQWF2qe+cOsQ5hkRRGOGPYkno1SQKx2LeLwVJISucWe0ucSw0Yg5yRTGgPWUpe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vn0M8DIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vn0M8DIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B72EC4CEE5;
	Tue,  8 Apr 2025 10:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109861;
	bh=onqPFiJPMo5Ttk6YbO3DE+BGXQ5gys/egLHyMAYmRCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vn0M8DIVMEiPRi0VymlvqCkuk9ysxFKeQZ6Q7+l50vZkpPIa0q5HkQKf7E+4ND1C2
	 Y2novdDDnSwOakKPUz51rhiYhmJ+kJBYjZlL5w/4PI8JgcGZ2McD7+ItOvriaRSkyi
	 rgUp6IWjPk0Fy+PLUD14iurpSnB/iv+dCd5pmd0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/227] net: atm: fix use after free in lec_send()
Date: Tue,  8 Apr 2025 12:47:37 +0200
Message-ID: <20250408104822.759555053@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit f3009d0d6ab78053117f8857b921a8237f4d17b3 ]

The ->send() operation frees skb so save the length before calling
->send() to avoid a use after free.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/c751531d-4af4-42fe-affe-6104b34b791d@stanley.mountain
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/lec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index 7226c784dbe0c..ca9952c52fb5c 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -181,6 +181,7 @@ static void
 lec_send(struct atm_vcc *vcc, struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
+	unsigned int len = skb->len;
 
 	ATM_SKB(skb)->vcc = vcc;
 	atm_account_tx(vcc, skb);
@@ -191,7 +192,7 @@ lec_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	}
 
 	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
+	dev->stats.tx_bytes += len;
 }
 
 static void lec_tx_timeout(struct net_device *dev, unsigned int txqueue)
-- 
2.39.5



