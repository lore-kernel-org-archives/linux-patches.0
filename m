Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577B9BA34;
	Mon,  6 Jan 2025 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179069; cv=none; b=fr6bAxTG3O3M+K2EkdztWei1NSMQUxKg4GAQKDoJdJY7yA48sAQ/8wmB1PKgiBSDHX1xSQtCn5v9q4dHERu8EJvSC3vbt7oTKFcmZRdY+Qq2nll21yHItU9sKjgrdUJ68u2JE1RwoOed7xkdo/vimDHwTKqFb/GGKnKIIbxLukQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179069; c=relaxed/simple;
	bh=EVuctLCK9ZVq5IQQpbZxBBN73V6ePcmp32+nLslKnA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhuThNLYqVFxGTBMJUqWE7NL2qaRa7/ey9z57s8oCmbCHPt9C1iCgTmVVDtpWq5WTOfXsE31L5HbJLmpF93v05fB+3T0Q7bgG5equMfxEcdHACxR90zFZQak8XM+Z0D4F3nNNpdpE13VIkeKY/nRPmOPaFa0jIhTspS73x1vXgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLDjYJBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLDjYJBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D194AC4CED2;
	Mon,  6 Jan 2025 15:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179069;
	bh=EVuctLCK9ZVq5IQQpbZxBBN73V6ePcmp32+nLslKnA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLDjYJBiBglcFrxTG+LG0czkXGWpsHjareZxWMfZJKd4EPI085Tl65bp7lOaVDJRg
	 ol20GIPNk4PnoOyPsgjeOwYlNtzPvL4Hd+07e5K+dzfaqRtAOGzwXv9x8fgFG5Ueuq
	 j1CYxtkOx2ID4Zvdq8/Ihf4zLGoL0EKQijLfSVso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/93] i2c: pnx: Fix timeout in wait functions
Date: Mon,  6 Jan 2025 16:16:42 +0100
Message-ID: <20250106151128.935219293@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
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
index 4d09665a72e5..6ba534c983de 100644
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



