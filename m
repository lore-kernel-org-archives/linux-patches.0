Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1E3185B5B;
	Fri, 15 Nov 2024 06:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653249; cv=none; b=pr542kp5BOtrjPrP2Txivi2eyqEEUBGYzgDzEpHcpqq9gZUQo2IFQZ8Wftl4nXm16nTxMQ2g62cllE0i/x8bElPbzEDMlvBLqz4UEPpZL11aBIRJ/yjSSgT8bvYocrwMUdfpdZjr4GXPzqfIRZ2Miq57VuOudVMi3iid5sz4W7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653249; c=relaxed/simple;
	bh=NKj+Mxmw2NiXEmYrRwG46qnQOVLxSgTttlQLIGPqjQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqZblB5KmfFewoNm6VBtAzbn5kQi972JoDjAusv7yZLlofg3GPoQYhNxNW6f5StWsSinWtvECepJ5YWcuYdRgQhF+187gbM95BrqjS2VXzL5vJKH5kJifgro1JtcKmdByCKvdiR/Pee7Pt5xBINKqqM55vkhaOqcH0TYb+KXTLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjlkIbt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjlkIbt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4892C4CECF;
	Fri, 15 Nov 2024 06:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653249;
	bh=NKj+Mxmw2NiXEmYrRwG46qnQOVLxSgTttlQLIGPqjQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjlkIbt7cbC/u3jENk2k5IDfuYMex+ElR98baetdIJ4vrLOcHNV4DQOi5DCZH/KYN
	 vnXTlhmS9OPayPZMvmazPqQEB81ChEgVZMucxp/7/NTyYSr1hHRGjAK0a/2t5fAH+d
	 sTTTY8iB0UAD7ttN6dxb2Zg3RHeN1EBQbub2oEdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 08/63] pinctrl: aw9523: add missing mutex_destroy
Date: Fri, 15 Nov 2024 07:37:31 +0100
Message-ID: <20241115063726.198034369@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 393c554093c0c4cbc8e2f178d36df169016384da ]

Otherwise the mutex remains after a failed kzalloc.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://lore.kernel.org/20241001212724.309320-1-rosenp@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-aw9523.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-aw9523.c b/drivers/pinctrl/pinctrl-aw9523.c
index b5e1c467625ba..1374f30166bc3 100644
--- a/drivers/pinctrl/pinctrl-aw9523.c
+++ b/drivers/pinctrl/pinctrl-aw9523.c
@@ -987,8 +987,10 @@ static int aw9523_probe(struct i2c_client *client)
 	lockdep_set_subclass(&awi->i2c_lock, i2c_adapter_depth(client->adapter));
 
 	pdesc = devm_kzalloc(dev, sizeof(*pdesc), GFP_KERNEL);
-	if (!pdesc)
-		return -ENOMEM;
+	if (!pdesc) {
+		ret = -ENOMEM;
+		goto err_disable_vregs;
+	}
 
 	ret = aw9523_hw_init(awi);
 	if (ret)
-- 
2.43.0



