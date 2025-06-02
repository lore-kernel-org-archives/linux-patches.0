Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5231C6FE9;
	Mon,  2 Jun 2025 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876710; cv=none; b=ByqCUdFQJQ0073otzTyco0hYJiLmi7Ew9lksOdrEyASNSmGz7+mQpP7rK5Z8b7Oh9dvhucyWRWOdfNKTsCaFpLjQHxmRoDZ5B7ne8UpNsX/z/2TVxNjFVTRp5x/+Hl3AQeMCiaDxafgtpzLeQgLxQ57Z3C75lP8e69fh9D2Qekk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876710; c=relaxed/simple;
	bh=GIzz2P2rRwd1m4n4vqvZjJmqNYgxOSIJ5QJgWlPi13U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8A5nWKGfnKjIz2jN5GtVrxk7arIOW9mOHu8R/bywfOjZbSTh/kFNZ4/+L0HL2iurzJinDOjJ/ZLHg5Pcezo8PgnpfZSavLHbIh81WtnIy1PuQijJArTbyMFtP6BSCUuCEf51HJYPxvcfX736OcJfY/XwSSZreV5ByAhEw4pX84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+Fr0BS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+Fr0BS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F651C4CEEB;
	Mon,  2 Jun 2025 15:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876710;
	bh=GIzz2P2rRwd1m4n4vqvZjJmqNYgxOSIJ5QJgWlPi13U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+Fr0BS7DIIvgipM7UVqhoyq7kZbUFDgGpXv28qdUsblyozou+Bs7N9ByZQglYDkN
	 JwyA99P2o2MdspN7WQjFHiUtehiFyLvYFlIZNRkSHcjLmFE6tD57rn3FIAL30QbJ3G
	 M8lxu0VUmbUAEuUVJ0ZfnRFU1vqgiwWXUQEwXRlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/325] i2c: pxa: fix call balance of i2c->clk handling routines
Date: Mon,  2 Jun 2025 15:45:26 +0200
Message-ID: <20250602134321.798122485@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitalii Mordan <mordan@ispras.ru>

[ Upstream commit be7113d2e2a6f20cbee99c98d261a1fd6fd7b549 ]

If the clock i2c->clk was not enabled in i2c_pxa_probe(), it should not be
disabled in any path.

Found by Linux Verification Center (linuxtesting.org) with Klever.

Signed-off-by: Vitalii Mordan <mordan@ispras.ru>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250212172803.1422136-1-mordan@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-pxa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index ade3f0ea59551..8263e017577de 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1508,7 +1508,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
 				i2c->adap.name);
 	}
 
-	clk_prepare_enable(i2c->clk);
+	ret = clk_prepare_enable(i2c->clk);
+	if (ret)
+		return dev_err_probe(&dev->dev, ret,
+				     "failed to enable clock\n");
 
 	if (i2c->use_pio) {
 		i2c->adap.algo = &i2c_pxa_pio_algorithm;
-- 
2.39.5



