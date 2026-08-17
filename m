Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC8D4457C9;
	Mon, 17 Aug 2026 15:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980438; cv=none; b=X3CRJPhC5OXeIuXDDfH2utsA8j2oQkC9vC0ED3bX/ZI6HKz2JcIYobl8Z457TAc3woXliyZgSde4oLyxVFO8EdsnrbrwPWv9bWMuS0Z8q2Fwd473DdTM1Sf1whXjbI/WnFwiZEH1W4IUYHhDz6LAdTBJZByb1ksaUdt5e/EbedY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980438; c=relaxed/simple;
	bh=lzo0iYKumerhb0KQ7awEH/qAolsIDICQ9PTadxelWnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcbeA58DxWEBe2SbIa2MDpu7Z7A5bhY4SgxX9WX0SfuS+WrsMvXuyN+j7TxC8zvUdP0vOg60vrUJZimfPbstDeV9EBry/IDVAdLpdNcITVepBYSZll/OoELyLTAsZvrjDMgmKq04WkckhBcuZ+78pNoakW/7PbPFUASbwT36Qcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTJiCAdO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTJiCAdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760051F000E9;
	Mon, 17 Aug 2026 15:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980436;
	bh=BODICF1Go0Pmeg3p+RWY7hGZDTeM2DEWHvdSuryQ1/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTJiCAdOoelkqqKF8jc0LDnqEzqCDl5TmvjzQQwLNLGAfQWgg5pFQdWj0eWbnTAga
	 mK9Ta1JAqdu3zClwAqR4PZ6OG6xE2U5/JqJEjo8fVldJxiBZteIk9LCpaJM4dIIGz6
	 zD0r+ii1IFzwoSkf4ltB1zPa9i3XzQm2Py0rs2gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 532/609] hwmon: (corsair-psu) fix possible out-of-bounds access on missing string termination
Date: Mon, 17 Aug 2026 15:33:48 +0200
Message-ID: <20260817132601.594060078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wilken Gottwalt <wilken.gottwalt@posteo.net>

[ Upstream commit 36c4d73ce05d1d8896c2669eb0730d35a02a2ec1 ]

In theory it could be possible that the REPLY_SIZE sized buffers for
holding the vendor and product strings could be end up missing the null
termination (for example by malicious hardware built on purpose)
required by the seq_printf() call. That limits the debugfs printf calls
to a maximum string length of REPLY_SIZE.

Fixes: d115b51e0e567 ("hwmon: add Corsair PSU HID controller driver")
Signed-off-by: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Link: https://lore.kernel.org/r/anLj9gPWRoRDbQBV@monster.localdomain
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-psu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/corsair-psu.c b/drivers/hwmon/corsair-psu.c
index 2f2cbc067634a..8392a18758d21 100644
--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -647,7 +647,7 @@ static int vendor_show(struct seq_file *seqf, void *unused)
 {
 	struct corsairpsu_data *priv = seqf->private;
 
-	seq_printf(seqf, "%s\n", priv->vendor);
+	seq_printf(seqf, "%.*s\n", REPLY_SIZE, priv->vendor);
 
 	return 0;
 }
@@ -657,7 +657,7 @@ static int product_show(struct seq_file *seqf, void *unused)
 {
 	struct corsairpsu_data *priv = seqf->private;
 
-	seq_printf(seqf, "%s\n", priv->product);
+	seq_printf(seqf, "%.*s\n", REPLY_SIZE, priv->product);
 
 	return 0;
 }
-- 
2.53.0



