Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D591D1F4E;
	Wed,  2 Oct 2024 14:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878247; cv=none; b=c7gwbx53JBeLlrKQf4dM2Mtyo4yqO4Wjp3dkGKofx3Qml06rwZDN7jvnK/F7ObtnVw4Sfx3cJRygAAxhyb8CeUTdt0UpXrCrkXh10jG7bTvI8jzbH9+bg6Cbv8x+6gFC60nmUnNJK4Q/LUGtYSwxJkX35KvxpAlTQxKSEsS0upU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878247; c=relaxed/simple;
	bh=aX06DoB9qXwVJAbvi+p960zRRfzaME81DHeHpDL2GG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oULL6F7Cqvjrp9YqfTGIyTC2XS8RxGnw8u9kREz+5yg+pgi/JFcJJX0RE63sa29D3+xC8YVRTlo5yDiJy55NJst4UE7k6uNQJHLqVdTqeOfWE7OuUfXZ5eF+AnSlowi3piWeV/r3eHK4BA9LmCdOQSTaIrxaneEu+SzzVwGF5fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaIBzS66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaIBzS66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7B0C4CEC2;
	Wed,  2 Oct 2024 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878247;
	bh=aX06DoB9qXwVJAbvi+p960zRRfzaME81DHeHpDL2GG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaIBzS66+N9UL6+DzjmAwDH4SSVh/Zq5cui7zvC6vkVUqVACMZaYT81jNx5HKspSM
	 nwlLViXGTj5FL2RIGxAGXe5plEhwG5h2yHW1foztkl3ZBckf2Q/atPSOJ5ZtIl+AlK
	 iZ37O2wReuNuqENAdBJ7HINbD/vsxf4vFbaaWXBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 349/634] pinctrl: single: fix missing error code in pcs_probe()
Date: Wed,  2 Oct 2024 14:57:29 +0200
Message-ID: <20241002125824.874864827@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit cacd8cf79d7823b07619865e994a7916fcc8ae91 ]

If pinctrl_enable() fails in pcs_probe(), it should return the error code.

Fixes: 8f773bfbdd42 ("pinctrl: single: fix possible memory leak when pinctrl_enable() fails")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/20240819024625.154441-1-yangyingliang@huaweicloud.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 4da3c3f422b69..2ec599e383e4b 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1913,7 +1913,8 @@ static int pcs_probe(struct platform_device *pdev)
 
 	dev_info(pcs->dev, "%i pins, size %u\n", pcs->desc.npins, pcs->size);
 
-	if (pinctrl_enable(pcs->pctl))
+	ret = pinctrl_enable(pcs->pctl);
+	if (ret)
 		goto free;
 
 	return 0;
-- 
2.43.0



