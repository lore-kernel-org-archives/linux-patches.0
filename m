Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5309C8801;
	Tue, 30 Apr 2024 11:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476002; cv=none; b=jDkUmEjZRRFdOWQDeDDUwSCnz0VfOpY2sg59pM3vdVD459aM/D+KjI2BhzWLDMXUr55pYUlaxwO4QBX16dGmoKg1P9/CIETszGXh1DaDiizFIe+Ww1PX7txfcEot33skCJcIr56omNJe9Vgd97HTIvIJM+PGcwJ4WAYOePZDlpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476002; c=relaxed/simple;
	bh=snb6GboBo7PNNAIBFh6LY65CP/8shjphSJ1kUA2+prc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hK3aTzyxMgRpfBWvjV6gD7kOR5U9sKBWAPFagdTt3TX8f9IcWpUmif31AomkJP55VOZi+VDOLq6vZ54Qib/Lbam4AsS0dHfbKUtVw+J/aoXt2n5CLl8zH10b6BhQcTHmGA+VA42vmF845PfWQyB+4ONaFqursnd3UvsTMkootlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjILW7F/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjILW7F/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65F2C2BBFC;
	Tue, 30 Apr 2024 11:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476002;
	bh=snb6GboBo7PNNAIBFh6LY65CP/8shjphSJ1kUA2+prc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjILW7F/m81V6WKV9TZSWHv6scYCus5D8m6M04gaxHfunIkD03WZhiZnVXyCMaf0w
	 15tjxbwVgQhBFYGuERcU0NnkTklxkLOkFqZIn8IJQnAsAKx/ugxoFVZ4QXQJkePcca
	 DIILjPHKgjkkqH6oZXvZLfGuJuOkYxDIW3lK6l1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baruch Siach <baruch@tkos.co.il>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 75/80] i2c: smbus: fix NULL function pointer dereference
Date: Tue, 30 Apr 2024 12:40:47 +0200
Message-ID: <20240430103045.627071203@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 91811a31b68d3765b3065f4bb6d7d6d84a7cfc9f ]

Baruch reported an OOPS when using the designware controller as target
only. Target-only modes break the assumption of one transfer function
always being available. Fix this by always checking the pointer in
__i2c_transfer.

Reported-by: Baruch Siach <baruch@tkos.co.il>
Closes: https://lore.kernel.org/r/4269631780e5ba789cf1ae391eec1b959def7d99.1712761976.git.baruch@tkos.co.il
Fixes: 4b1acc43331d ("i2c: core changes for slave support")
[wsa: dropped the simplification in core-smbus to avoid theoretical regressions]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 8fb065caf30b4..1810a994c07ca 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -2072,13 +2072,18 @@ static int i2c_check_for_quirks(struct i2c_adapter *adap, struct i2c_msg *msgs,
  * Returns negative errno, else the number of messages executed.
  *
  * Adapter lock must be held when calling this function. No debug logging
- * takes place. adap->algo->master_xfer existence isn't checked.
+ * takes place.
  */
 int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 {
 	unsigned long orig_jiffies;
 	int ret, try;
 
+	if (!adap->algo->master_xfer) {
+		dev_dbg(&adap->dev, "I2C level transfers not supported\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (WARN_ON(!msgs || num < 1))
 		return -EINVAL;
 
@@ -2145,11 +2150,6 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 {
 	int ret;
 
-	if (!adap->algo->master_xfer) {
-		dev_dbg(&adap->dev, "I2C level transfers not supported\n");
-		return -EOPNOTSUPP;
-	}
-
 	/* REVISIT the fault reporting model here is weak:
 	 *
 	 *  - When we get an error after receiving N bytes from a slave,
-- 
2.43.0



