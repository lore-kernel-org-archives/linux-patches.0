Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB4B268C6D;
	Tue, 25 Mar 2025 12:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905938; cv=none; b=thudyY8y1XO1Sf5txQmZqiliM08d8MahBgfUSnUYcneH16cKpJbBYCJf3HWUHT3DvDClVIfL9H4YvVMpHhINcxMO7R3E/FARPK4Ms+OjuafZKi3VuPyZKrO3lt/LU8dhd0yUy1oRrCCZvdkl7H7yObGUPw/SJGzGbmBsZWyT1f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905938; c=relaxed/simple;
	bh=7BaIzI+ztlHIE+3eDd/NkUAd+2fn4musVk6TElEYkV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JllsRUz0VauWcpKbv6KEbcUXM7oLbQYS58r3BtXSP0DlMpdEDd/1QlnKpXQNwmfwL0WG00iREzodW+Oqcq+I6leLCbPhWLh+Y8G6aUgMBt+1kKtDOjSLGUbxu04xbvy/fBUGVBFcOro6x0Zt+N036QZKipjQoOUM2Z/ZAlQJaks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDJU/Bo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDJU/Bo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BCCC4CEE4;
	Tue, 25 Mar 2025 12:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905936;
	bh=7BaIzI+ztlHIE+3eDd/NkUAd+2fn4musVk6TElEYkV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDJU/Bo0y74I5Pptvf2/lc4Ahzu/AWimDJmgioCxBxKp7e5yVfyWyceMhKmkMKq4W
	 C7p8/q0bg60JC3mqb9QwLb3CuK8vuX0XsngFYf6YRrUmSbCmTHS9KmKM4JUl+nwPR8
	 QRfsGV3q2wSftO0HqVz4F/KDB9x+LhYZXUAuKxT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 045/119] net: atm: fix use after free in lec_send()
Date: Tue, 25 Mar 2025 08:21:43 -0400
Message-ID: <20250325122150.206403812@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index ffef658862db1..a948dd47c3f34 100644
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



