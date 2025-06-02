Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694492147E7;
	Mon,  2 Jun 2025 14:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875514; cv=none; b=Ug0CEz/6vKhJ+3kL6qnIy8HX4iZrXYYu5e4Sb8vjCnAH6suEEVUgNJPwahmZVI7SjmBLmHP3nmzRamdeDOdghf6+A3ES9O3CU92l/wi4mlp4dZATRlOW1zyYCLyjUINaLnKOYG+x8qUhZTaf4nOuBi2ykuiLJ7QMq/TqHw4ta78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875514; c=relaxed/simple;
	bh=o/3WzLnwKaMcBnfo95/Ugu6C0f0VwsjJZGrVgksiXLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H446j4m+7aeRXLsndz7c3xXVBpJMs6OQHh9nPYxGONmlBfDh3jx1v7x6JY95kpdH8mY18hswKh18NQUeAaGRDC/huW1NQkXRvwP087FgBFRI+3iIi/LnGu4dJ32rf9mNrE/C/7OcL4nOdy4h5PT2BCo+JgGHfHFjEk+ohkOTn2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6hUUVYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6hUUVYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB23C4CEEB;
	Mon,  2 Jun 2025 14:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875514;
	bh=o/3WzLnwKaMcBnfo95/Ugu6C0f0VwsjJZGrVgksiXLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6hUUVYvE/Jt2Sm0iA6dZxgAyb6uUr0g237T4FGMVn3HkbQiVXVIwI5XR03BPeT6/
	 sPw4PFKV5BLX/TN7pO4fJtZwA5Uoi96dUw55Ji6OSJTgyMWeVv3iElJbv9J2dOc9h3
	 /9eo0qgsscowz4/Z6wok7/HhZTwDSCf/soAMi0pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/270] rtc: ds1307: stop disabling alarms on probe
Date: Mon,  2 Jun 2025 15:47:22 +0200
Message-ID: <20250602134313.631899346@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit dcec12617ee61beed928e889607bf37e145bf86b ]

It is a bad practice to disable alarms on probe or remove as this will
prevent alarms across reboots.

Link: https://lore.kernel.org/r/20250303223744.1135672-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 07a9cc91671b0..3a2401ce2ec9c 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -1864,10 +1864,8 @@ static int ds1307_probe(struct i2c_client *client,
 		 * For some variants, be sure alarms can trigger when we're
 		 * running on Vbackup (BBSQI/BBSQW)
 		 */
-		if (want_irq || ds1307_can_wakeup_device) {
+		if (want_irq || ds1307_can_wakeup_device)
 			regs[0] |= DS1337_BIT_INTCN | chip->bbsqi_bit;
-			regs[0] &= ~(DS1337_BIT_A2IE | DS1337_BIT_A1IE);
-		}
 
 		regmap_write(ds1307->regmap, DS1337_REG_CONTROL,
 			     regs[0]);
-- 
2.39.5



