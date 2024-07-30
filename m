Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9F3189502;
	Tue, 30 Jul 2024 17:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359547; cv=none; b=tabNathD5SLofzJsodkZWhcHOVrfs/Om5OhzJz7H1c7hhSZ/pNikAFoh3B4x9BWmx/w7hZ3D12wMvMl8CxS5gnmoPYHkPBQqoyuuQ2fkNQu6J1u0Yzno4vrVnLrFJ/I/ddmG4NPlkFmam+bIp29RSQQYK6jQFxU0FwR6AvYvdWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359547; c=relaxed/simple;
	bh=wdTFm9PLeWR/KCWTjTRYF8xj1O2aY9ofhIdVfvtzebc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hz9Z48hPQANDV19WWxg71CP8Am+rMJGrteQTVhC4BeXJTJ/eSu/5BGzs4eLSPQMeiKJY3N0kTB/W4T+jd3/rAHsU41jds5aBM44F43FVlaXD09BpG1JhRVpFBgDHcRdOP36Hq55bQvdbs0UH/xp/6A2ObwuNJXfrUYDxOfkXjZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdbeAvLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdbeAvLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDE0C4AF12;
	Tue, 30 Jul 2024 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359546;
	bh=wdTFm9PLeWR/KCWTjTRYF8xj1O2aY9ofhIdVfvtzebc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdbeAvLFVHUDFpJCZX9Tvu6tnR9liDMhZKkex5Bym/RyrkBtXzgGgbRdnBfN6ayiC
	 uYXFkH2D9p0GeoUdbvj93mENZhSYMOcoZYh99Nv++pfrk2DXFW59Vd2XiVFGcWLcyb
	 yRXgqRhjSEh1TJN3uVb/9ja/HuLij3jkBUKp+anA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Genoud <richard.genoud@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 499/809] rtc: tps6594: Fix memleak in probe
Date: Tue, 30 Jul 2024 17:46:15 +0200
Message-ID: <20240730151744.445422109@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Richard Genoud <richard.genoud@bootlin.com>

[ Upstream commit 94d4154792abf30ee6081d35beaeef035816e294 ]

struct rtc_device is allocated twice in probe(), once with
devm_kzalloc(), and then with devm_rtc_allocate_device().

The allocation with devm_kzalloc() is lost and superfluous.

Fixes: 9f67c1e63976 ("rtc: tps6594: Add driver for TPS6594 RTC")
Signed-off-by: Richard Genoud <richard.genoud@bootlin.com>
Link: https://lore.kernel.org/r/20240618141851.1810000-2-richard.genoud@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-tps6594.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/rtc/rtc-tps6594.c b/drivers/rtc/rtc-tps6594.c
index 838ae8562a351..bc8dc735aa238 100644
--- a/drivers/rtc/rtc-tps6594.c
+++ b/drivers/rtc/rtc-tps6594.c
@@ -360,10 +360,6 @@ static int tps6594_rtc_probe(struct platform_device *pdev)
 	int irq;
 	int ret;
 
-	rtc = devm_kzalloc(dev, sizeof(*rtc), GFP_KERNEL);
-	if (!rtc)
-		return -ENOMEM;
-
 	rtc = devm_rtc_allocate_device(dev);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
-- 
2.43.0



