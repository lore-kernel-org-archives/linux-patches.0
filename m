Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EF512C48A;
	Tue, 30 Apr 2024 10:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474678; cv=none; b=i0jbQYv99/Y1+XhKoSTArXUBptrgUZxukG1VBPS0n6NKMQJt68xfGhSSmBONGNqPjkgdCyrh7DeRJuX23I0Ft5hdGgz7f8kB4CKuxZUH3R6DO8RHey5JYUGnX768b31jfJh1YkgwJmb9QkPpP8OWMLvIg7oMKgm1DiBgQq1qqw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474678; c=relaxed/simple;
	bh=iysVbsy5VTBxIyuNzw6hqDw3HuFp0H+LQq2EI6WA7ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXsVsm4DHnGM2zwp9NLEv/2EUsPLlsS/BdNwZ1Gi1mSDHefQ3SjLr/iYsh9aaqokB9z2II2llhj5V22LPGxZ39QBo/0WzNYewyJ9KrC/K12MtxlVIIOfw1UQGPmYXwxkgLtcfLLKF3RxtA5GZCT4Uudal0jJazA7tLei3BiCCmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFjzJkhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFjzJkhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EB5C4AF18;
	Tue, 30 Apr 2024 10:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474678;
	bh=iysVbsy5VTBxIyuNzw6hqDw3HuFp0H+LQq2EI6WA7ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFjzJkhUbHtEERarcYdPSCNF8rBZNqgSizJycK+lHorA9DWfJV6f6JJz3eJC6G3AX
	 5pFSDhd1+W2f6f6nRQW5l5wzyPFrJNjezO1uJsInO5oypSrtieIADPUPhydP6SxPUW
	 X1trXzjI+9O6AFu9rHCvndpNBysCAICcsFtp7MS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baruch Siach <baruch@tkos.co.il>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 223/228] i2c: smbus: fix NULL function pointer dereference
Date: Tue, 30 Apr 2024 12:40:01 +0200
Message-ID: <20240430103110.237695676@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 3bd48d4b6318f..5e2cefb37e1a4 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -2200,13 +2200,18 @@ static int i2c_check_for_quirks(struct i2c_adapter *adap, struct i2c_msg *msgs,
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
 
@@ -2273,11 +2278,6 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
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



