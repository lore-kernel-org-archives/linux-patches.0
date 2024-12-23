Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576EB80C02;
	Mon, 23 Dec 2024 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969751; cv=none; b=LUvBI5cV2JRyg3o7rx3oYKD4MHsgH4uwfAqgOXeeGhfGUMbGjMAjzN5UZtALbLdr6wiq2LjG+KgB7sZyEUsls5btBeNdiFE3Qqwrqiomr0qTT69YuZac0mg3t1rnURFWdQMYERkO5yh7D36GAAtiNkGDl5k1N7LXnliUzoHwRxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969751; c=relaxed/simple;
	bh=yvFSZu73HNGc7af/a/WGB3eRKi3WEQv/7wiMUwE72qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0DyWWKcjgjM0igMFvj7B+rW94/PhJG1o/PvjDNxDfoL0pB8KDe5xvouMWnG7y+wTqBBxF0OOEy8CuersEmTVBKO/EY5NCIOj2oYSCLZ4g1vcGB0vGvdk0QvIJYJm4aJSTCLZCEyGg5iaJLA0BcATmoKXA7dBUOkapWey+bH+F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qb0LtLET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qb0LtLET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B230CC4CED3;
	Mon, 23 Dec 2024 16:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969751;
	bh=yvFSZu73HNGc7af/a/WGB3eRKi3WEQv/7wiMUwE72qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qb0LtLETNfO+z3o60OorTy4cNhAHUX8YA0l9k0SqCIRgUYrsP75ZqS9kGIgqpLjsL
	 ppNAaXjJCTKaYiV60P5tFNZUqLk3CgxBVib6rhIh8+alkOSP+N9lwBVLRQJnFhf4qK
	 x9Cl/R4LlIZMxXm9i1+YG7pyVkrWmn1NMOMMbgcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/160] i2c: pnx: Fix timeout in wait functions
Date: Mon, 23 Dec 2024 16:57:04 +0100
Message-ID: <20241223155409.160886965@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1dafadda73af..135300f3b534 100644
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



