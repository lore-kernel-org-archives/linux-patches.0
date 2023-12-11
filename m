Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BB351C53;
	Mon, 11 Dec 2023 18:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRtkLrMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68494C433C8;
	Mon, 11 Dec 2023 18:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320000;
	bh=SNO472HfZbPMbrrGL8XY8fzvCth3Zon0QjH+ZGjW9Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRtkLrMcrXVGwQlH+HPHobMyVwBjujFTGu5EYmB16L8Y/edeVUGDr6agcLkBFF58R
	 R4/MPse8GyvOIXssvZ03Wd4MZL9igsykoooArEEeAmeZptoDT4l5n8nGhPrg0+lIKm
	 JlrJdVMeNYjN+C3JavOtIRb/3XDZfIvzKpR4khrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boerge Struempfel <boerge.struempfel@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 67/97] gpiolib: sysfs: Fix error handling on failed export
Date: Mon, 11 Dec 2023 19:22:10 +0100
Message-ID: <20231211182022.641974250@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boerge Struempfel <boerge.struempfel@gmail.com>

[ Upstream commit 95dd1e34ff5bbee93a28ff3947eceaf6de811b1a ]

If gpio_set_transitory() fails, we should free the GPIO again. Most
notably, the flag FLAG_REQUESTED has previously been set in
gpiod_request_commit(), and should be reset on failure.

To my knowledge, this does not affect any current users, since the
gpio_set_transitory() mainly returns 0 and -ENOTSUPP, which is converted
to 0. However the gpio_set_transitory() function calles the .set_config()
function of the corresponding GPIO chip and there are some GPIO drivers in
which some (unlikely) branches return other values like -EPROBE_DEFER,
and -EINVAL. In these cases, the above mentioned FLAG_REQUESTED would not
be reset, which results in the pin being blocked until the next reboot.

Fixes: e10f72bf4b3e ("gpio: gpiolib: Generalise state persistence beyond sleep")
Signed-off-by: Boerge Struempfel <boerge.struempfel@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-sysfs.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index fa5d945b2f286..f45ba0f789d4f 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -491,14 +491,17 @@ static ssize_t export_store(struct class *class,
 	}
 
 	status = gpiod_set_transitory(desc, false);
-	if (!status) {
-		status = gpiod_export(desc, true);
-		if (status < 0)
-			gpiod_free(desc);
-		else
-			set_bit(FLAG_SYSFS, &desc->flags);
+	if (status) {
+		gpiod_free(desc);
+		goto done;
 	}
 
+	status = gpiod_export(desc, true);
+	if (status < 0)
+		gpiod_free(desc);
+	else
+		set_bit(FLAG_SYSFS, &desc->flags);
+
 done:
 	if (status)
 		pr_debug("%s: status %d\n", __func__, status);
-- 
2.42.0



