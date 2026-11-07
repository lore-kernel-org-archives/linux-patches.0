Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062098;
	b=tPgYV6yiVEexE9njbIiE5zKul5jBLJ3BEuvu/ZEc01sdx84oDGgnsxdMFIrw/q1EmBes
	 o+qARdboZHQ5DEvNUaCk308KnUtm1/fzor046gbqpxvAwRBZq2fZQiPBr1rhVtZcrUNbk
	 ymw+ibUT5MQ2EeOHiN2RIFvsP/hkD+AKamWMNUf0w5QXQ7Dd2jo2iJLImMSXfoOaeeX9i
	 4thPfio3XleuWBnIxs/Xoe6us4Y4p8yNjesafFLQzlx81d1vTsSAc9OAAYszakZM25Ndx
	 wrRm9SX5pvYZUmaGlXw0F1COhwMFbRdyRxpAljlFJ6EZdOrJ1oDmBZf0GLK4Qh+Dujw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yN9hMNEVdDQt0cwPHVMbcnFxMUDJRxZE4gr5NO03vc4=;
	b=XxFNK97v6axnr8a4ZX0dS8ebvhyqyBrCOek827uXS8dBWeH2ysIRkxMrH+8e8kflN7yt
	 D4d1jW2/vM+7JNTkrazlFhH+XernBaOPfSuzSCzY1QnpklWB73xlFvpZlRuPBpAt/gpdo
	 YDFgKjEQ++yE1s9NY8iSMwvagf8ZUAtqRooudFwOAD12D/2VqSUEB8RLDNJ3BidnwxPHf
	 k9Kpul/NZcDd6hpNclRDJdpiKy7xyUT+Lk2x2Od07IeTtkDh/JnsCXmCz7nlZKTIz+Vpz
	 wuy9R25qhWJ2Ik9+8FMCHw8HywOLmlrNoFqk3Ccg9FMvxx6/3FxYqCoCOnIuWIKkSNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2Bcx6VH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6304606D80C;
	Sat,  7 Nov 2026 14:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2Bcx6VH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C411F008A6;
	Sat,  7 Nov 2026 14:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062097;
	bh=yN9hMNEVdDQt0cwPHVMbcnFxMUDJRxZE4gr5NO03vc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2Bcx6VH2jlmx2RWs8iLJCEkRXR/jONfrQKsDbKfycWSgi6jCAmhSyBAux4JSB+3r
	 BPBmgWPjNwyjN0GcxftyCFfFckuOXLZaioh5UrjBt+dPCFe0mdvoCGjFHT4//KptS4
	 4WdyJfPHSaSEVE+lQLuJTrjw6NZn83hUdSNwIgI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1069/1536] mtd: amd76xrom: Fix PCI device reference leak in amd76xrom_init_one()
Date: Sat,  7 Nov 2026 08:51:25 -0500
Message-ID: <20261107135027.715299908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 1a122f5fecbabd47b81b1be3f0934f57b78aad42 ]

init_amd76xrom() obtains the PCI device with pci_get_device() and
hands the reference over to amd76xrom_init_one(), which stores it in
window->pdev.  When reserving the ROM window fails, that function
returns -EBUSY directly instead of going through amd76xrom_cleanup(),
so the reference is neither released nor cleared.

Drop the reference and clear window->pdev on that path.

Fixes: dd8e9ed6ed54 ("[MTD] Switch to pci_get_device and do ref counting")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/amd76xrom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/maps/amd76xrom.c b/drivers/mtd/maps/amd76xrom.c
index 281fcbaa74e70..43411ec02ed59 100644
--- a/drivers/mtd/maps/amd76xrom.c
+++ b/drivers/mtd/maps/amd76xrom.c
@@ -152,6 +152,8 @@ static int amd76xrom_init_one(struct pci_dev *pdev,
 		printk(KERN_ERR MOD_NAME
 		       " %s(): Unable to register resource %pR - kernel bug?\n",
 		       __func__, &window->rsrc);
+		pci_dev_put(window->pdev);
+		window->pdev = NULL;
 		return -EBUSY;
 	}
 
-- 
2.53.0



