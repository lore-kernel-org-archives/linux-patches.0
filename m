Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5813570B0;
	Tue, 16 Dec 2025 12:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886556; cv=none; b=lxf4KuNO0aumnuFNDhOYUoT+uHcxJ5z3Vrsn+QdS26mBieh3uDJn1+B5aEM5n7LmBhEC4wMKAlRUptFz47Rdcu49qqMDQDH9l/vxuaIfZMPFo6O4JIAK+86qbiZT8gNwxjAWVQgzncrhqGnaEn/pry1wJIQwOiFNOZRqOWnZizk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886556; c=relaxed/simple;
	bh=Cb6GkD7mCr5uzxCdhRbY/ZxliOkGzjumHmw9ii9xzAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BY59gG9MWeXdmLGcbrzBvw6ke4K/1061SIRntnyNlyfOq9ZAhqd9i7FWl7BhQ7HrluVKHmLnUKWofXk3EW7BE7xLD9VVXV4qmQ38AYCNRTDiZjrO+/KSa+j2LNI89Iuvhnsmg+9f2UxbSTYgxaM/3g9a6CO6XXxB6jaHDS6KcoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vr0i56SR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vr0i56SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D6DC4CEF1;
	Tue, 16 Dec 2025 12:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886555;
	bh=Cb6GkD7mCr5uzxCdhRbY/ZxliOkGzjumHmw9ii9xzAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vr0i56SRnqoCBRyevJ25WLEmaUSIOcU7t7XAGCxULxAWr1svWHgWMOOjqwC4MT3PU
	 1Lrztc4pBkVPyPVpJjG93jfXQOHE0TD7FQtofab+RxIsWoFdbC60Jr6sYi2WkO7yGv
	 5yLoO0NUWO4hvdPQzp4HB/pfh1iIZbZVdw4m6xJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Michael Opdenacker <michael.opdenacker@rootcommit.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 472/507] i2c: spacemit: fix detect issue
Date: Tue, 16 Dec 2025 12:15:13 +0100
Message-ID: <20251216111402.543925448@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Troy Mitchell <troy.mitchell@linux.spacemit.com>

[ Upstream commit 25faa5364638b86ec0d0edb4486daa9d40a0be8f ]

This commit addresses two issues causing i2c detect to fail.

The identified issues are:

1. Incorrect error handling for BED (Bus Error No ACK/NAK):
   Before this commit, Both ALD (Arbitration Loss Detected) and
   BED returned -EAGAIN.
2. Missing interrupt status clear after initialization in xfer():
   On the K1 SoC, simply fixing the first issue changed the error
   from -EAGAIN to -ETIMEOUT. Through tracing, it was determined that
   this is likely due to MSD (Master Stop Detected) latency issues.

   That means the MSD bit in the ISR may still be set on the next transfer.
   As a result, the controller won't work — we can see from the scope that
   it doesn't issue any signal.
   (This only occurs during rapid consecutive I2C transfers.
   That explains why the issue only shows up with i2cdetect.)

With these two fixes, i2c device detection now functions correctly on the K1 SoC.

Fixes: 5ea558473fa31 ("i2c: spacemit: add support for SpacemiT K1 SoC")
Tested-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Tested-by: Michael Opdenacker <michael.opdenacker@rootcommit.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20251113-fix-k1-detect-failure-v2-1-b02a9a74f65a@linux.spacemit.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-k1.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-k1.c b/drivers/i2c/busses/i2c-k1.c
index 6b918770e612e..d42c03ef5db59 100644
--- a/drivers/i2c/busses/i2c-k1.c
+++ b/drivers/i2c/busses/i2c-k1.c
@@ -158,11 +158,16 @@ static int spacemit_i2c_handle_err(struct spacemit_i2c_dev *i2c)
 {
 	dev_dbg(i2c->dev, "i2c error status: 0x%08x\n", i2c->status);
 
-	if (i2c->status & (SPACEMIT_SR_BED | SPACEMIT_SR_ALD)) {
+	/* Arbitration Loss Detected */
+	if (i2c->status & SPACEMIT_SR_ALD) {
 		spacemit_i2c_reset(i2c);
 		return -EAGAIN;
 	}
 
+	/* Bus Error No ACK/NAK */
+	if (i2c->status & SPACEMIT_SR_BED)
+		spacemit_i2c_reset(i2c);
+
 	return i2c->status & SPACEMIT_SR_ACKNAK ? -ENXIO : -EIO;
 }
 
@@ -224,6 +229,12 @@ static void spacemit_i2c_check_bus_release(struct spacemit_i2c_dev *i2c)
 	}
 }
 
+static inline void
+spacemit_i2c_clear_int_status(struct spacemit_i2c_dev *i2c, u32 mask)
+{
+	writel(mask & SPACEMIT_I2C_INT_STATUS_MASK, i2c->base + SPACEMIT_ISR);
+}
+
 static void spacemit_i2c_init(struct spacemit_i2c_dev *i2c)
 {
 	u32 val;
@@ -267,12 +278,8 @@ static void spacemit_i2c_init(struct spacemit_i2c_dev *i2c)
 	val = readl(i2c->base + SPACEMIT_IRCR);
 	val |= SPACEMIT_RCR_SDA_GLITCH_NOFIX;
 	writel(val, i2c->base + SPACEMIT_IRCR);
-}
 
-static inline void
-spacemit_i2c_clear_int_status(struct spacemit_i2c_dev *i2c, u32 mask)
-{
-	writel(mask & SPACEMIT_I2C_INT_STATUS_MASK, i2c->base + SPACEMIT_ISR);
+	spacemit_i2c_clear_int_status(i2c, SPACEMIT_I2C_INT_STATUS_MASK);
 }
 
 static void spacemit_i2c_start(struct spacemit_i2c_dev *i2c)
-- 
2.51.0



