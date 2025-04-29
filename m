Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C57D21883E;
	Tue, 29 Apr 2025 17:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946810; cv=none; b=IEcvfpaXSL0m+OZpXrq0X5rGV30wCQW5WG5d33BgkZ8Rrdrv+fDtiOXkwGJ5U34gwL/Eh+cjS84aGV5iLc/alQN4OFr/9cx7Vymex9YyLJdUMD3OZm0XWBozblZmGyKCU5d4IRW1PD9+22URTmSrHHGrP1mBTFyw9gghfK422xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946810; c=relaxed/simple;
	bh=6HZUo9pHrfURPbQS8eJocFN8d+WH9pf52BlItf7IRv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9GKf6MlTlvoToDyOuiduHcBdfoh/BKLfFDtvlp/A0uH9VQtqEVCUfhZzKFu5OaEcOwQjqgt10cIJSuUKiqSADmBJFsXjzoq9yi2pdCUMzN2WgqCbmqJ1dAGAYKrNQn8yk8H9kwIoRj22EYlLpT4lE4P9bsCEW//Zk4zJ9//IRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MvhttlHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MvhttlHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD8FC4CEE3;
	Tue, 29 Apr 2025 17:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946810;
	bh=6HZUo9pHrfURPbQS8eJocFN8d+WH9pf52BlItf7IRv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MvhttlHabvp1MwwdxRfdzcBjszPKr+JKam692+y9GPOvaQtJOiik17xWSlQVI7V1U
	 iPp3mrcRMS/6Ad7VaeoDq+0OXjufH9YkmGb++AnXmk9e+ZVi4Y+6MifxSaMFcQDrI7
	 /7fnh3SNREf0cnwRbRlKWDPE9DNq/UE+mbVDVJmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH 5.10 077/286] mfd: ene-kb3930: Fix a potential NULL pointer dereference
Date: Tue, 29 Apr 2025 18:39:41 +0200
Message-ID: <20250429161111.017842348@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

commit 4cdf1d2a816a93fa02f7b6b5492dc7f55af2a199 upstream.

The off_gpios could be NULL. Add missing check in the kb3930_probe().
This is similar to the issue fixed in commit b1ba8bcb2d1f
("backlight: hx8357: Fix potential NULL pointer dereference").

This was detected by our static analysis tool.

Cc: stable@vger.kernel.org
Fixes: ede6b2d1dfc0 ("mfd: ene-kb3930: Add driver for ENE KB3930 Embedded Controller")
Suggested-by: Lee Jones <lee@kernel.org>
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250224233736.1919739-1-chenyuan0y@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/ene-kb3930.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/ene-kb3930.c
+++ b/drivers/mfd/ene-kb3930.c
@@ -162,7 +162,7 @@ static int kb3930_probe(struct i2c_clien
 			devm_gpiod_get_array_optional(dev, "off", GPIOD_IN);
 		if (IS_ERR(ddata->off_gpios))
 			return PTR_ERR(ddata->off_gpios);
-		if (ddata->off_gpios->ndescs < 2) {
+		if (ddata->off_gpios && ddata->off_gpios->ndescs < 2) {
 			dev_err(dev, "invalid off-gpios property\n");
 			return -EINVAL;
 		}


