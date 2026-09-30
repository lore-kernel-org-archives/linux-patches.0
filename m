Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788F84FDA73;
	Wed, 30 Sep 2026 16:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784648; cv=none; b=dsd+WQ7eOHKoPziCRNLgom0FQSjLDxlF6mh5Gn0b5hpKmhNc/lvx+Q9m4bJpxxA+7PlT3sR24NrXX2H9YWyivBY6lioCYe/AeEdIKBQ8ASSTk+f8Z1DYgYNvx/G0omYhXmefrOwGmKjpe4hZ55mCKcYeqhVosI/CxUIW7Y/RF1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784648; c=relaxed/simple;
	bh=pzCNfjKRS6lEtDZpJAnYLNi5Q2fOsVKSuV955jKam6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5MhQS0pqYxly5y3KGEeEyU2X3Y/j9FR7lYNTZfKiGxRANNGb+0UyWQJ/thBFuaw2T4xDcUuHUcFp7xTHUuSLIlkeIxrQf6gaqKgI6ENDwltpYNx+j5ChzyfEobPbzdhytNnBuIyar7wlhTvULdo3TyiLuyj1/oXtZChpQsByO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyyeO/qB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyyeO/qB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DEE1F00893;
	Wed, 30 Sep 2026 16:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784643;
	bh=e4c//EmWjvjK42zuUiT7QlHUlAK2nhIMn+R02db4wcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GyyeO/qB+3XspI1OD6uUyBnDxvOetfyhOS8SGZLQthnHp5TJq50zJkJlHyazlBk4K
	 JZ7yRGANTmWjKsVEezYwX16rPp+cr/USE/eSiItA//H63Opvr0mfc+iddoUBjkQ1nC
	 A7fBV0qMeAhW3iPm+rD9lEzGQP4ckpLbIXWJiI54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adriana Stancu <adriana@arista.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 228/982] rtc: bq32000: add delay between RTC reads
Date: Wed, 30 Sep 2026 17:16:04 +0200
Message-ID: <20260930152421.696035387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adriana Stancu <adriana@arista.com>

[ Upstream commit d4992b7050a10079bc760bdc5b8688e05a09dfc2 ]

When the RTC is used on systems without a interrupt line, userspace
tools like `hwclock` fall back to a frequent polling loop to synchronize
with the edge of the next second.

On the BQ32000, this aggressive polling can temporarly lock the register
refresh cycle, because the continuous transfers prevent the hardware from
updating the buffer. This results in stale data reads or select() timeouts
in userspace.

This patch introduces a delay before reading the RTC registers in order to
provide a sufficient idle time for the hardware to sync with the register
buffer.

Signed-off-by: Adriana Stancu <adriana@arista.com>
Link: https://patch.msgid.link/20260416142151.3385827-1-adriana@arista.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-bq32k.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/rtc/rtc-bq32k.c b/drivers/rtc/rtc-bq32k.c
index 6d6a55efb9cc7..4522bec54d3ff 100644
--- a/drivers/rtc/rtc-bq32k.c
+++ b/drivers/rtc/rtc-bq32k.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/bcd.h>
+#include <linux/delay.h>
 
 #define BQ32K_SECONDS		0x00	/* Seconds register address */
 #define BQ32K_SECONDS_MASK	0x7F	/* Mask over seconds value */
@@ -88,9 +89,17 @@ static int bq32k_write(struct device *dev, void *data, uint8_t off, uint8_t len)
 
 static int bq32k_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct bq32k_regs regs;
 	int error;
 
+	/*
+	 * When the device doesn't have the interrupt connected, prevent
+	 * userpace from polling the RTC registers too frequently.
+	 */
+	if (client->irq <= 0)
+		usleep_range(2000, 2500);
+
 	error = bq32k_read(dev, &regs, 0, sizeof(regs));
 	if (error)
 		return error;
-- 
2.53.0



