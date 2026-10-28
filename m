Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212638;
	b=1/VJKBTqJBrzB1N6az4tCYOZj1jdV5xK8wg/eHSAUZaD5mAQQuyu21f+F0nQ6ACkSOUJ
	 4VKIG8cdxbZjQkOTqX3FlKxMDUTc3ps5fNYBCLRssGQ/AnfW9u401U2z/4z7HJNMN8gpU
	 b6kRDKtldpVlnArHzmDsiCREJh1WesvFMxRqdkEywlDLTh8kf5AIJ8WHwztkVjW042nAf
	 Q9kfzEf9lq/tCoqcxXN5hxcj8uSr71ESCZ1oyRPlmDDZCfBW8fx6aOUcGNsCD828D60fb
	 m+GdHb9aNI8l3oBmStcdgnx52rar6HIMguj5HOXwOJEK66p0ZBC8P44VwMmlQf9FNkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/BadyjsmHL7nd4/IxhaS2BeJMct1N/MPdTRd2i5T/iY=;
	b=l5pcmfykD1fOovhmoMSMj3zZeYnGSwOG7mjP5D3tTTawunxw0QJK8jEKgHlJxY3p3nb/
	 maZnrI/cbtnutkbfHF6mmHN5SlGkBKcMasQRlmZz3OdvgwjGniyVPduMkmgPMSRBRSpiL
	 2R+6hBUn3t1eTG0/jgln4N7esBBn9BbUIoJ7vxnWxNpkaTKGf0ayPxKLRlWT4QtzYp9nC
	 Tpq+Ue9/3n+PquK+0iSvTSUzkyBYpfdrfpHdQfA6Xvwb2PzttgGXOW1ds06dPJuGqfFXw
	 iNqi03NioJJKws3DiwoFwlDmudz1N2glb6TcZ0/abDNz3FJXHDm/WVHW+OwlniNBZkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25683606A31D;
	Wed, 28 Oct 2026 18:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755851F01825;
	Wed, 28 Oct 2026 18:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212635;
	bh=/BadyjsmHL7nd4/IxhaS2BeJMct1N/MPdTRd2i5T/iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1gfbu75nuFlDbLj8cme+e6q/MC6Df8jtAm4YQr0vs0GPTBan+cQMCMWCnrdLzarg5
	 nRG99f1tPgNrqYwOoyFL5WhnQJVLoOXpAOK81Jz1o6+OJ/aovNCVfJYx5pepMQh6uW
	 eMOw3yobegMmAItdVS7gJ3ZXXfMveNoGdEJzOODA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0223/1887] rtc: dev: zero-initialize struct rtc_wkalrm to prevent information leak
Date: Wed, 28 Oct 2026 17:38:39 +0100
Message-ID: <20261028170504.307783881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Dalin <liudalin@kylinsec.com.cn>

[ Upstream commit 0ee5c5d804d592a8328a425b9274487d393d3a05 ]

The struct rtc_wkalrm has padding holes after the 'pending' member.
When returned to userspace via the RTC_WKALRM_RD ioctl, uninitialized
kernel stack data residing in these holes may be leaked.

Zero-initialize the struct at declaration to eliminate this information
leak risk.

Fixes smatch warnings:
- drivers/rtc/dev.c:392 rtc_dev_ioctl() warn: check that 'alarm' doesn't
  leak information (struct has a hole after 'pending')

Fixes: 36e14f5fdfdf ("rtc: rename core files")
Assisted-by: smatch:2.0 [static analysis]
Signed-off-by: Liu Dalin <liudalin@kylinsec.com.cn>
Link: https://patch.msgid.link/B28B7DE18F3A9447+20260827015444.3314227-1-liudalin@kylinsec.com.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/dev.c b/drivers/rtc/dev.c
index 4aad9bb998683..8ff910017b105 100644
--- a/drivers/rtc/dev.c
+++ b/drivers/rtc/dev.c
@@ -207,7 +207,7 @@ static long rtc_dev_ioctl(struct file *file,
 	struct rtc_device *rtc = file->private_data;
 	const struct rtc_class_ops *ops = rtc->ops;
 	struct rtc_time tm;
-	struct rtc_wkalrm alarm;
+	struct rtc_wkalrm alarm = { 0 };
 	struct rtc_param param;
 	void __user *uarg = (void __user *)arg;
 
-- 
2.53.0



