Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C627F1A9FAA;
	Sun,  7 Sep 2025 20:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276303; cv=none; b=VpZBWZm0kV2KCz7RHyM+saGMgKWHq8D+Pkam5kDORSPXkkF33vSzI0bTP3slgT4Uz+qmUW/m9oQcFrxbQTFzHFUUF/uCh5z1NCzeSWPDU0FJ96nZPzQwrgWIJi/hqwoU8QRileWWYelyv6ml7momyF6qBNP1ZJ5RSdtGMbDThjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276303; c=relaxed/simple;
	bh=Ytxi8mw+Z5oRAtU+WUW2vcqy2VSqDnSrGoOMz6gFIAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/uj/Eb27LrEKThnTd7fwWyRa036O0iWQDVNeCQ+LafrBvakNqNUKuCtWLhlxlbaXnLa5gWEB1t6BHZAOF1IqSsVfTCjcmBAL5/U0GM9+pa9RcRktsLf2w33ni1c6NcJPRJDX6cykPMGzmPHVzRSyLqHbY9/by/XRvHZ0w0VNHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cv8cgt/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cv8cgt/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49858C4CEF0;
	Sun,  7 Sep 2025 20:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276303;
	bh=Ytxi8mw+Z5oRAtU+WUW2vcqy2VSqDnSrGoOMz6gFIAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cv8cgt/UjCKUI9LbNMYGeLwc/9RrURC7P1QU2BcnOKUA6Z0H8i8mZuAvwE3sQ8r2a
	 HoHrtn2+Utfr2YoAXsISWxGmJ/KwSpHOakq568Ef1V+Uno/y19GqqGWMZcQ8VkOJNw
	 uY8Svwx6KeaQhtD4hceXlNhtymYGPrwrHP3Kh0eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/104] iio: light: opt3001: fix deadlock due to concurrent flag access
Date: Sun,  7 Sep 2025 21:58:17 +0200
Message-ID: <20250907195609.238591305@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit f063a28002e3350088b4577c5640882bf4ea17ea ]

The threaded IRQ function in this driver is reading the flag twice: once to
lock a mutex and once to unlock it. Even though the code setting the flag
is designed to prevent it, there are subtle cases where the flag could be
true at the mutex_lock stage and false at the mutex_unlock stage. This
results in the mutex not being unlocked, resulting in a deadlock.

Fix it by making the opt3001_irq() code generally more robust, reading the
flag into a variable and using the variable value at both stages.

Fixes: 94a9b7b1809f ("iio: light: add support for TI's opt3001 light sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20250321-opt3001-irq-fix-v1-1-6c520d851562@bootlin.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt3001.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -692,8 +692,9 @@ static irqreturn_t opt3001_irq(int irq,
 	struct opt3001 *opt = iio_priv(iio);
 	int ret;
 	bool wake_result_ready_queue = false;
+	bool ok_to_ignore_lock = opt->ok_to_ignore_lock;
 
-	if (!opt->ok_to_ignore_lock)
+	if (!ok_to_ignore_lock)
 		mutex_lock(&opt->lock);
 
 	ret = i2c_smbus_read_word_swapped(opt->client, OPT3001_CONFIGURATION);
@@ -730,7 +731,7 @@ static irqreturn_t opt3001_irq(int irq,
 	}
 
 out:
-	if (!opt->ok_to_ignore_lock)
+	if (!ok_to_ignore_lock)
 		mutex_unlock(&opt->lock);
 
 	if (wake_result_ready_queue)


