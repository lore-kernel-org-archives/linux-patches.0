Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A24435AB2;
	Fri,  7 Aug 2026 15:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115484; cv=none; b=eQfjX49L1Jw3uD5+HBqho237j/f1h34VHd2C22w7LiwzzugtSjbOU8rz3tqkJfNjItNZGKRolcnuYiCTgW6KVWHqUUUZFpQzwW7HTUKGZQsNFCMaKRWjmdzCzvxd2YkT4P0C204wAm4eVJrVlO8GZnGD1IYgKxgBU3I8qRcfm/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115484; c=relaxed/simple;
	bh=S5W1VT6nNeRKFThsAE2nKLmEUQvWMqnkfFnWTua/ro4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDiL0/0XGNGXWu/Zwo4U23Yk7baoihGzAx3wPWxXGWzLfmzrQZh0NKpA7CCAhVGUBqzlAHKsfsKpEKxKPmoMAg7dOix3f+3maGtcMq+EGWKLI/j+Ynqf8DuSb3G0X54COZmDV5ig364x6A/Ku3R2oHBWmph56KesONT4lbTACvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVT4Z4SZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVT4Z4SZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FF11F00A3A;
	Fri,  7 Aug 2026 15:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115482;
	bh=G2a52FjtOUF9bhE+VNVvk06Sr0CmN0xjQLF1v+oVtSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVT4Z4SZhPn6vDCdvAn7Ayr9jWxmAckrKDMp9KpQsySIEr/wArHwDuOFyAHUtoX/C
	 3JJkvdjecpEUIleOEugZtasTv1qSl+oJGroaFMsmvSKkasf6LZpwbgQ+z2fifI1L96
	 hlhaUNH7fJudUwlfNyyWM9WCC4ywejRJeCFAmwBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liem <liem16213@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Carlos Song <carlos.song@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 293/396] i2c: imx: Fix slave registration race and error handling
Date: Fri,  7 Aug 2026 16:37:33 +0200
Message-ID: <20260807143430.591634629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liem <liem16213@gmail.com>

commit d64ec362c369bbc33833f7936d5f3a706b0d5c45 upstream.

In i2c_imx_reg_slave(), the slave pointer was assigned before
pm_runtime_resume_and_get().  If pm_runtime_resume_and_get() failed,
the error path returned without clearing i2c_imx->slave, leaving it
non-NULL and causing all subsequent registration attempts to fail
with -EBUSY.

Additionally, because this driver uses a shared IRQ, the interrupt
handler i2c_imx_isr() can execute concurrently and, after acquiring
slave_lock, dereference i2c_imx->slave.  The previous fix attempt
added a lockless i2c_imx->slave = NULL on the error path, but that
could race with the ISR under the lock and still cause a NULL pointer
dereference.

Fix both issues by deferring the assignment of i2c_imx->slave and
i2c_imx->last_slave_event to after a successful resume, and by
performing the assignment inside the slave_lock critical section.
This guarantees that the slave pointer is never left stale on the
error path and is always valid when observed by the interrupt handler.

Fixes: f7414cd6923f ("i2c: imx: support slave mode for imx I2C driver")
Signed-off-by: Liem <liem16213@gmail.com>
Cc: <stable@vger.kernel.org> # v5.11+
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Carlos Song <carlos.song@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260629023829.152651-2-liem16213@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -930,9 +930,6 @@ static int i2c_imx_reg_slave(struct i2c_
 	if (i2c_imx->slave)
 		return -EBUSY;
 
-	i2c_imx->slave = client;
-	i2c_imx->last_slave_event = I2C_SLAVE_STOP;
-
 	/* Resume */
 	ret = pm_runtime_resume_and_get(i2c_imx->adapter.dev.parent);
 	if (ret < 0) {
@@ -940,6 +937,11 @@ static int i2c_imx_reg_slave(struct i2c_
 		return ret;
 	}
 
+	scoped_guard(spinlock_irqsave, &i2c_imx->slave_lock) {
+		i2c_imx->slave = client;
+		i2c_imx->last_slave_event = I2C_SLAVE_STOP;
+	}
+
 	i2c_imx_slave_init(i2c_imx);
 
 	return 0;


