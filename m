Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABB11B21B5;
	Mon, 23 Dec 2024 16:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970214; cv=none; b=SPrLszgFgPd3aZHQXcK08ES1HdmMMQdvOeknfW9AZwwnV1GG8VZaq7H6qzHmCxOrBqdAxf5PUkkhXRmGXok/M3gSrfflXfVaUSRtQ71p3Zj4T2310aOMpN2Oi7eos5pngB4cOe610lnT8G/dtZ23RJb4YNHO0Fjs/gs7E1WwKbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970214; c=relaxed/simple;
	bh=0I9KTh7l+UJ84ymnVgMkmspj4CvLcn0l5qzqyAQ5HsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RL7nk10XbluCOG7OZpUdcWvgHG+zqEVivnFFKl673SPRF/vVCbKGCj5bwx9geHgl09S9UDzMv4iy4mcv4v6Z2kUS10zWNN63gLhDRoxtjMABeFqKlEUpXyIWmlG9xi9jMEPjEUyzLoKnYf8bnW4MJ5yJ/BmmmSEv55QZWUh8768=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPtlIcef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPtlIcef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9BFC4CED4;
	Mon, 23 Dec 2024 16:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970214;
	bh=0I9KTh7l+UJ84ymnVgMkmspj4CvLcn0l5qzqyAQ5HsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPtlIcefuxvFEHu8n/VAJQQfEqFKI+B5m7fsPXSvEWl6yqBwB84704vdYJRGB1Nlx
	 JZDOkYaDU+8PRQKKs0aqr4OQgesyEd39Aneo/81XjgXckku94K1r2KmZl0meV1I3Ty
	 h4J2ys+EhtJJoNYXOFwoylBO0u0LpXuwyRoqxOKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/116] i2c: pnx: Fix timeout in wait functions
Date: Mon, 23 Dec 2024 16:58:08 +0100
Message-ID: <20241223155400.262130725@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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
index f448505d5468..2b9cc86fb3ab 100644
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



