Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BED512C544;
	Mon, 23 Dec 2024 16:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970611; cv=none; b=Ukr5MQYOcWfsyk53onkm/Xr4OHnrpVSRghzBT6PcjWscwkZX3l+bBuDMmdYq8Dkm9haXO2TE0evGh+whCsQRkvhFGfwBimAhDELbVwpioNlEkE79WVUpS+//RqGQfDv/A/MZoyaMPbrGIWamCsBkRhkYA/JYyhZYEOD6OM7SaDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970611; c=relaxed/simple;
	bh=YYHydWaP3PpYSBwt8ejE2mO3hr9ZWBHcxFuljbvSn58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmDAIT/Px0Sf7Q2VWzUOmqb73kqD6T4QjROLbyBdBUTGKIYe8dc709dyDAQwKugDi8Um3/i+5dL7uhOiOV418maJmDKv0Zs0wuqfNEprah6RiCpJcD8vlFkVJJ90mqnmksuvWOZg6QbNcSFK75eaKjcw7pEV/cZCTjuIh8qwHbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kd+1ZsoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kd+1ZsoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE03C4CED3;
	Mon, 23 Dec 2024 16:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970611;
	bh=YYHydWaP3PpYSBwt8ejE2mO3hr9ZWBHcxFuljbvSn58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kd+1ZsoRsEN2o+JvcyqNGX4vq3m55YI1eQIjGtXYbXHUih35LQaxz4tOJCGXrrQvm
	 neJl9javylrTBBCnF+g5wh0rXqHmTiYOt9IISOFLBTp+pcLjlCmXoxGbpZkPa82zBw
	 gvtXg6+C8qhUf8svzsGxZ4Z6pzi+E2C0x5ORyEY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/83] i2c: pnx: Fix timeout in wait functions
Date: Mon, 23 Dec 2024 16:58:56 +0100
Message-ID: <20241223155354.302449779@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Riabchun <ferr.lambarginio@gmail.com>

[ Upstream commit 7363f2d4c18557c99c536b70489187bb4e05c412 ]

Since commit f63b94be6942 ("i2c: pnx: Fix potential deadlock warning
from del_timer_sync() call in isr") jiffies are stored in
i2c_pnx_algo_data.timeout, but wait_timeout and wait_reset are still
using it as milliseconds. Convert jiffies back to milliseconds to wait
for the expected amount of time.

Fixes: f63b94be6942 ("i2c: pnx: Fix potential deadlock warning from del_timer_sync() call in isr")
Signed-off-by: Vladimir Riabchun <ferr.lambarginio@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-pnx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
index d2c09b0fdf52..ab87bef50402 100644
--- a/drivers/i2c/busses/i2c-pnx.c
+++ b/drivers/i2c/busses/i2c-pnx.c
@@ -95,7 +95,7 @@ enum {
 
 static inline int wait_timeout(struct i2c_pnx_algo_data *data)
 {
-	long timeout = data->timeout;
+	long timeout = jiffies_to_msecs(data->timeout);
 	while (timeout > 0 &&
 			(ioread32(I2C_REG_STS(data)) & mstatus_active)) {
 		mdelay(1);
@@ -106,7 +106,7 @@ static inline int wait_timeout(struct i2c_pnx_algo_data *data)
 
 static inline int wait_reset(struct i2c_pnx_algo_data *data)
 {
-	long timeout = data->timeout;
+	long timeout = jiffies_to_msecs(data->timeout);
 	while (timeout > 0 &&
 			(ioread32(I2C_REG_CTL(data)) & mcntrl_reset)) {
 		mdelay(1);
-- 
2.39.5



