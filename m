Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9754D4891;
	Thu, 17 Sep 2026 15:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659874; cv=none; b=bZOgmUzdF2SHZoZWyiCzPpCs7txubC9fZe4NmgF8k6a5uODq8yMZY6mcNXwvrlAskc5xlwFK5W3IKgZDpCIMWcWV71wRiivvqW+R5v5cmGJ/jKn3Wr4L2UXMPiWUNariPStG0OR4YVAVrUrcKaxBhAbNRoTOB21rBackizFFlkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659874; c=relaxed/simple;
	bh=J1nmgzorq+j5nkbIs0j1peQLNvtrzf+HfoInWDaUCYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2Ci8Qy+cooEhamL2G1itYUHlpDLRcyQ03KLcWBHfakGVduTWsVHrOLN666MCiSkfkhEa2pj5Ul4j/SFifjWtQTeVfJ/V6KDY1LkpK8fdwNNoQ9IxDYo8iFk4nkhPOWPnHna04CmCuSO20GwVDeJFKVWsSPQXtwULb663I4ufEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSzGDa1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSzGDa1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1401F00893;
	Thu, 17 Sep 2026 15:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659868;
	bh=WvkBSyaFM0FgMqtkCJ1La3vmAmX+HpVigyXR3rx1+DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSzGDa1F3ex5TqoA/nbG6eTEhP0M/UQjj6eR0dNXOSK//IZS0sffLBoGs1hUdWMzb
	 TaniXah6gMFOsQzREpwRMqdU3YqgWffMCApgClj9IK73h79nevCy6KSeSuG3eCWbnh
	 zNoVnUkZIT8ZtbUtswDJRLI6MZD+l6CgFSbLS8Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Cong Nguyen <congnt264@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 400/733] hwmon: (gpio-fan) take fan_data->lock in gpio_fan_shutdown()
Date: Thu, 17 Sep 2026 16:11:48 +0100
Message-ID: <20260917151401.701781279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit bb2424c3502cc72292eedade46960c331d5f28fb ]

set_fan_speed() writes the control GPIOs one bit at a time. Every
other caller locks around it; gpio_fan_shutdown() doesn't. If it races
a locked caller, the GPIO writes can interleave and leave the fan at a
speed neither caller asked for.

Fixes: b95579cd8795 ("hwmon: (gpio-fan) Add a shutdown handler to poweroff the fans")
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/20260830152150.27F5F1F000E9@smtp.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Link: https://patch.msgid.link/20260901155404.1532092-1-congnt264@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gpio-fan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 084828e1e2817..10c91bc33b020 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -606,8 +606,11 @@ static void gpio_fan_shutdown(struct platform_device *pdev)
 {
 	struct gpio_fan_data *fan_data = platform_get_drvdata(pdev);
 
-	if (fan_data->gpios)
+	if (fan_data->gpios) {
+		mutex_lock(&fan_data->lock);
 		set_fan_speed(fan_data, 0);
+		mutex_unlock(&fan_data->lock);
+	}
 }
 
 static int gpio_fan_runtime_suspend(struct device *dev)
-- 
2.53.0



