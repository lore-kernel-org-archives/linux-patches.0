Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2FE209695;
	Wed, 19 Mar 2025 14:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395233; cv=none; b=SlN8RNICVkjMLB/LEpd6RCQVMx26vIQVqc4XVAuzNQttZRYmUEtUWURG43D46tJyezsGJOYMtAhJ5cwzAJ56Eli1IAcNX5H3B/3U73zostAszeppWFjKLgBICew31aidLPTIw5/VmJFmX6bjeWMSxEV04A3HJKStPZxaIEAOdTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395233; c=relaxed/simple;
	bh=ybB3D7W+cqikEnQ+tAGpfYQry3Gz3IYV8VaW6pmuR50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/9rj155PnGr5p28JntZu61wUsc+Xnkz4X8UvIUODAkAYEhtmxH3wC/3x+07MLfXNCsE8vtqhC12zDH2Z/vxIQ+g1JsZ6TMDCj4Mi65BLP3eudZqlzVoYy75LCCxG9HeDNxeJlX2xaDWN3/A8964zFixW1Slmw6955z7/AmjP2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gd9he8WN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gd9he8WN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EF8C2BD00;
	Wed, 19 Mar 2025 14:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395233;
	bh=ybB3D7W+cqikEnQ+tAGpfYQry3Gz3IYV8VaW6pmuR50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gd9he8WNNrDXWovPV4on/M5taUwqFogSpbW1oPoif5VYJkm/xmdrnC16QBXHv1bRE
	 NSo200IqewQcd39Jp2cU2Iocohly+1gMiuEQcb7151FElrWTs7hTMSWe9Ynl4MATJu
	 f1rjz3fBMqNv8jrdEEwO0DPbO7KaHk5eQjkOjZ+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 104/166] Input: ads7846 - fix gpiod allocation
Date: Wed, 19 Mar 2025 07:31:15 -0700
Message-ID: <20250319143022.835188893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H. Nikolaus Schaller <hns@goldelico.com>

commit c9ccb88f534ca760d06590b67571c353a2f0cbcd upstream.

commit 767d83361aaa ("Input: ads7846 - Convert to use software nodes")

has simplified the code but accidentially converted a devm_gpiod_get()
to gpiod_get(). This leaves the gpio reserved on module remove and the
driver can no longer be loaded again.

Fixes: 767d83361aaa ("Input: ads7846 - Convert to use software nodes")
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://lore.kernel.org/r/6e9b143f19cdfda835711a8a7a3966e5a2494cff.1738410204.git.hns@goldelico.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/ads7846.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -995,7 +995,7 @@ static int ads7846_setup_pendown(struct
 	if (pdata->get_pendown_state) {
 		ts->get_pendown_state = pdata->get_pendown_state;
 	} else {
-		ts->gpio_pendown = gpiod_get(&spi->dev, "pendown", GPIOD_IN);
+		ts->gpio_pendown = devm_gpiod_get(&spi->dev, "pendown", GPIOD_IN);
 		if (IS_ERR(ts->gpio_pendown)) {
 			dev_err(&spi->dev, "failed to request pendown GPIO\n");
 			return PTR_ERR(ts->gpio_pendown);


