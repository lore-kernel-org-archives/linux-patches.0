Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6EF1C32EB;
	Tue,  8 Oct 2024 13:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393054; cv=none; b=d05joqwJgF/TkqHdmyPVZPOm+VGPNPi2/CmXK8zqW4CFE63H8wyh28ERL7MSEaCb+YUM4tVu5LPOVnuU2/JXYfn8Nuh6IDqeXPjV7cEfmathAEYFHV4mDiVeXa1Whhm5VFLnC3T2Om+uctOjSCVXkHb/s/ZgrOxOs+Vatnd/1zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393054; c=relaxed/simple;
	bh=Rpp/fHtUtw5Dqvylt96rPm6IMKq/Pr2ue69JmAyjIGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJKh/wZFXQXT0hU4s4aP+QdKwFowmMq0th4EyZ5hH67E0x6WlDITA6gCfOeYdMYpw/2DLZUZyeoIdAptgoWcZlQrdhsiAoJopLR9IS5uX+Oz8IDpCVSPpeGSMhlbAgGipC7rNck7mWDNs7pZxI3ddTC5RpMBG52Tvfg7/CNtjuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z73Ax1Kz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z73Ax1Kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3F0C4CECD;
	Tue,  8 Oct 2024 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393053;
	bh=Rpp/fHtUtw5Dqvylt96rPm6IMKq/Pr2ue69JmAyjIGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z73Ax1KzlXgDeiFe/lJgfTQyxDZYMR2IoCpDCB2P1Bi145txSLpSj2Yx1Qn/Vk1JZ
	 ujKtXf7qs3uJclJxx6iZU6Zg64mWMBzovMjrMaBXdjvqNjVL3wrH4yeco2mHZEw7x/
	 cjtslt2qbWV1gnpO9z6gPV47ENB02QidOFph/igM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Ferland <marc.ferland@sonatest.com>,
	Michal Simek <michal.simek@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/386] i2c: xiic: improve error message when transfer fails to start
Date: Tue,  8 Oct 2024 14:04:44 +0200
Message-ID: <20241008115631.012812494@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Ferland <marc.ferland@sonatest.com>

[ Upstream commit ee1691d0ae103ba7fd9439800ef454674fadad27 ]

xiic_start_xfer can fail for different reasons:

- EBUSY: bus is busy or i2c messages still in tx_msg or rx_msg
- ETIMEDOUT: timed-out trying to clear the RX fifo
- EINVAL: wrong clock settings

Both EINVAL and ETIMEDOUT will currently print a specific error
message followed by a generic one, for example:

    Failed to clear rx fifo
    Error xiic_start_xfer

however EBUSY will simply output the generic message:

    Error xiic_start_xfer

which is not really helpful.

This commit adds a new error message when a busy condition is detected
and also removes the generic message since it does not provide any
relevant information to the user.

Signed-off-by: Marc Ferland <marc.ferland@sonatest.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 1d4a1adbed25 ("i2c: xiic: Try re-initialization on bus busy timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 71391b590adae..19468565120e1 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -1105,8 +1105,11 @@ static int xiic_start_xfer(struct xiic_i2c *i2c, struct i2c_msg *msgs, int num)
 	mutex_lock(&i2c->lock);
 
 	ret = xiic_busy(i2c);
-	if (ret)
+	if (ret) {
+		dev_err(i2c->adap.dev.parent,
+			"cannot start a transfer while busy\n");
 		goto out;
+	}
 
 	i2c->tx_msg = msgs;
 	i2c->rx_msg = NULL;
@@ -1164,10 +1167,8 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 		return err;
 
 	err = xiic_start_xfer(i2c, msgs, num);
-	if (err < 0) {
-		dev_err(adap->dev.parent, "Error xiic_start_xfer\n");
+	if (err < 0)
 		goto out;
-	}
 
 	err = wait_for_completion_timeout(&i2c->completion, XIIC_XFER_TIMEOUT);
 	mutex_lock(&i2c->lock);
-- 
2.43.0



