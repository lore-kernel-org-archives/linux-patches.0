Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0DB12D1F1;
	Tue, 30 Apr 2024 11:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476317; cv=none; b=hj7pvllskxALqXm8BcB7gAcC2GEVcih8HwGLdiL7TBEt8Y7oSgKoH/YjOYshyb4VS2akgkSSlb3I3KyYkiNmcsPXOTd6VuiaMnNZ+qi/PHCGvtgWYqU8KKLyj5lLq4yrynWd2uAxhbVR0RWsTeS3+ZL5/HwAts2QvovP1cmGCT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476317; c=relaxed/simple;
	bh=8np9AGcW4zfmdyjd+EHwt5hnFE2h3jiXZtpIhzBE8JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKibFOgSR95EsDoU8kUFtxWR4RL1Q3yw24NeAdtED1i8O2DJImS7hwkyxIyB4W24j0sq2q7zPfBWDrN/0EyReDtiw9tPZbiQJ4K6vhiomkjew0YO6UG3x8UEnrIT+JGhGeFnGZv1keg3WbakjcpBkIOE9USye2Z6fiGe9ZI5HlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDZmt1RI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDZmt1RI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AB1C2BBFC;
	Tue, 30 Apr 2024 11:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476317;
	bh=8np9AGcW4zfmdyjd+EHwt5hnFE2h3jiXZtpIhzBE8JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDZmt1RI9rnaKNc3hVtiWtxI1jW2ka+dQ68HlNw1OT+zAQbaHxwrQ1K/IbDDa8ndR
	 NnFZzKop4TcO/h5f0h8v9lmOI/SB9RirldgIes6GKRDOH5SSvoz/amaW71+5QJwRk3
	 I5zMI3I3WA0a8OI3MFkEns0wdS/G+9m/lBdbLddI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baruch Siach <baruch@tkos.co.il>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/107] i2c: smbus: fix NULL function pointer dereference
Date: Tue, 30 Apr 2024 12:41:02 +0200
Message-ID: <20240430103047.668795535@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 964e8a29b27b4..cf9ad03bb34de 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1965,13 +1965,18 @@ static int i2c_check_for_quirks(struct i2c_adapter *adap, struct i2c_msg *msgs,
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
 
@@ -2038,11 +2043,6 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
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



