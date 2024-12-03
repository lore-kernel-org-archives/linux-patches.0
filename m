Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E2D1F76A8;
	Tue,  3 Dec 2024 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241532; cv=none; b=ZvRWLctl0BEQMx4CvY7qMJZVHqkk/eWJs1E8Dw7NefTI15ta5Uwo3znN+pftFxOdhX0uCHhsZl2EVAJtW9V77nFpUo3yIHcrrH20IE305zZDse5ZtiwdWvFYCSrgmYeke0lWTDEF2THTkbsTn4S2L91z22cFjA6wkKie8BTUCYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241532; c=relaxed/simple;
	bh=p7WpSkre8fqytHaI5HVW7apqlG+jwu/vUONlQUPjTUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sl3tMatzu9NfH6ymCYryvgkQBLI8d+8GVcJ8cGQ26hKZFU8EjLP7yIOK/are4fesU0vL02b8qhIg9Rb1A7Z8plxaZlEq9+rABW+Or5l6z9VEWKPcNRLROJEalWtd6Z4ca0H1px/ulTrxQa8HB59HePQFgE9cKP05JLcIM1dApGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAsqwfg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAsqwfg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8F1C4CECF;
	Tue,  3 Dec 2024 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241532;
	bh=p7WpSkre8fqytHaI5HVW7apqlG+jwu/vUONlQUPjTUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAsqwfg/SMJuny6aHiSWGY7io5UMkMtdLax4taAvxwMsdx/TQhMN/v7cONqK0Oy4g
	 EuqfCrT08w5sjcGg36WRnRD2ucnNEsTc99k6EWewZYC4tu8boXgGzFVa+B2mrDaGlR
	 fwSNFTzRwx9gskO3xt4zMu/L/Jt5YwvXBPu05Jno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 414/826] leds: max5970: Fix unreleased fwnode_handle in probe function
Date: Tue,  3 Dec 2024 15:42:21 +0100
Message-ID: <20241203144759.909442801@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 02f58f97419c828f58e30f24f54395ac9be159c0 ]

An object initialized via device_get_named_child_node() requires calls
to fwnode_handle_put() when it is no longer required to avoid leaking
memory.

Add the automatic cleanup facility for 'led_node' to ensure that
fwnode_handle_put() is called in all execution paths.

Fixes: 736214b4b02a ("leds: max5970: Add support for max5970")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241031-max5970-of_node_put-v2-1-0ffe1f1d3bc9@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-max5970.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-max5970.c b/drivers/leds/leds-max5970.c
index 56a584311581a..285074c53b234 100644
--- a/drivers/leds/leds-max5970.c
+++ b/drivers/leds/leds-max5970.c
@@ -45,7 +45,7 @@ static int max5970_led_set_brightness(struct led_classdev *cdev,
 
 static int max5970_led_probe(struct platform_device *pdev)
 {
-	struct fwnode_handle *led_node, *child;
+	struct fwnode_handle *child;
 	struct device *dev = &pdev->dev;
 	struct regmap *regmap;
 	struct max5970_led *ddata;
@@ -55,7 +55,8 @@ static int max5970_led_probe(struct platform_device *pdev)
 	if (!regmap)
 		return -ENODEV;
 
-	led_node = device_get_named_child_node(dev->parent, "leds");
+	struct fwnode_handle *led_node __free(fwnode_handle) =
+		device_get_named_child_node(dev->parent, "leds");
 	if (!led_node)
 		return -ENODEV;
 
-- 
2.43.0



