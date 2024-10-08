Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14221D618C;
	Tue,  8 Oct 2024 12:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389639; cv=none; b=ckjFQcFUCj6Bq0ykfWpPf8cqYw8/UMU2wgFzsmO0upH7YqeQbb5Q+2PTGkNH14ti/yvEjYCohPz64gF+XbpFuwLxekpe3KfiZv+o6PEPbIRpMiWlRvTKNuDa54+GGj/0k0GgKLq7OrQZ+TBKM42Mh+iy39Qfv6OjZSJCdg4m9IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389639; c=relaxed/simple;
	bh=+VUz9UVD//cVy3FcLadYZzaXWZEYl40G2VToRJskXe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMTzI4d2xYDlDatad/r8pASfWb35uIsagArJTkK/wXqmYk6vqk06msP639KBMwEaWRZ7JROOI44mlrwgvdrHxY9pij+i9H7y1CMUH7yCNYoSKChH9E85JXNzkHuaakVpj84ExtDXUsgFoejoTm/SNyByruZL+VI+PH2IYIWUhIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcI3OSiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcI3OSiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB28AC4CEC7;
	Tue,  8 Oct 2024 12:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389639;
	bh=+VUz9UVD//cVy3FcLadYZzaXWZEYl40G2VToRJskXe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcI3OSiwShhaQJjZ14XeCvBu+iYx15EquhFSCI/WLjGOl3KxAa1ptiaOHGy2QBAxx
	 6IePaa28OZZXwRhmbN61HQXK939sIky/tpS2YssT6F/uWShWd3x4GbE08ZdgT26ktg
	 90m3EDc2plNuoHQlWzLSVou0lQsRtSlZiXKPQ3Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Ferland <marc.ferland@sonatest.com>,
	Michal Simek <michal.simek@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 051/482] i2c: xiic: improve error message when transfer fails to start
Date: Tue,  8 Oct 2024 14:01:54 +0200
Message-ID: <20241008115650.314172470@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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



