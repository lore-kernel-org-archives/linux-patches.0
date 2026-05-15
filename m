Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CB13B635B;
	Fri, 15 May 2026 16:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861195; cv=none; b=lPsCVeVjLt07x4nFNLWn6nhMr/NglKH4fMM0Ov+ISsr8nOw17OEJQ1JJC3YHOZFc1XrhGA+JNUHTrVDbdslk+EYUdrYTlBuWtQMpSXSWcrqwb3YOZwXP05N99XOpI1KcvM2LCPzbP+9VWSNtx6FuCxQiRuGWStyy2flmOsyFOjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861195; c=relaxed/simple;
	bh=AlsPIkO+PMOl08ew4vYm6YDr8Tu7666KelUiJFMLGc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQCYu2SwFMezaozSKQBoJAr6evdH0tLVNx6t5pXy1AtSpKvdAud15XGrlMrfwqBwWrcVibnA2bFGMFbJwn4POPwzDWeRhAQxW7t+JNI57EC8jVBD3Kzhp0AkBc2zr6dJfWtWJ0DXiGO1TPSyzb89uj91SeaQBPu6s3sQ2MocXCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THeUmWSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THeUmWSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278A3C2BCB0;
	Fri, 15 May 2026 16:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861195;
	bh=AlsPIkO+PMOl08ew4vYm6YDr8Tu7666KelUiJFMLGc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THeUmWSykF7ztX/vxozt9H+5Iyo9+vurcE4A6tuahv2Phm6A/9bzjl6wVP5FMaJ9R
	 bbVfa/fz0Uj70ZCm6u3aAQNCxn9HFa9gKyImBLiUqvoXRJ9H+4tJAD3ZQ5wcT/QSgW
	 3UVhzGBH3ZKWApvtp+x7SZ8gge0lJ5BAtsv9Eqbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.6 234/474] gpio: of: clear OF_POPULATED on hog nodes in remove path
Date: Fri, 15 May 2026 17:45:43 +0200
Message-ID: <20260515154720.066984005@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit bbee90e750262bfb406d66dc65c46d616d2b6673 upstream.

The previously set OF_POPULATED flag should be cleared on the hog nodes
when removing the chip.

Cc: stable@vger.kernel.org
Fixes: 63636d956c455 ("gpio: of: Add DT overlay support for GPIO hogs")
Acked-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260309-gpio-hog-fwnode-v2-1-4e61f3dbf06a@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-of.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -1136,5 +1136,12 @@ int of_gpiochip_add(struct gpio_chip *ch
 
 void of_gpiochip_remove(struct gpio_chip *chip)
 {
-	of_node_put(dev_of_node(&chip->gpiodev->dev));
+	struct device_node *np = dev_of_node(&chip->gpiodev->dev);
+
+	for_each_child_of_node_scoped(np, child) {
+		if (of_property_present(child, "gpio-hog"))
+			of_node_clear_flag(child, OF_POPULATED);
+	}
+
+	of_node_put(np);
 }


