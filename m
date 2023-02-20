Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F9D63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91504C433EF;
	Mon, 20 Feb 2023 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901579;
	bh=VggQe6XIzkvZUU0GcnuQDlaxkGBO8ax39sAdfkODASs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPuHuNYJWgH1oi3VFG9S5ZYI6Uxnso5OOYKMMTGKeFEPlV1dXNfQ+ePzEtW/lcsTy
	 Hn1/W8dae2yEAyCUDNeQM+lP8Vnzvd2rM73Hth2yEG1MMhn0bLpPnMLx6qLFZxAwOH
	 nVNJ5xGAKt6Ecd2Dz1pB9Ka++Ake5Si/irFuKdH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.1 072/118] gpio: sim: fix a memory leak
Date: Mon, 20 Feb 2023 14:36:28 +0100
Message-Id: <20230220133603.312930951@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 79eeab1d85e0fee4c0bc36f3b6ddf3920f39f74b upstream.

Fix an inverted logic bug in gpio_sim_remove_hogs() that leads to GPIO
hog structures never being freed.

Fixes: cb8c474e79be ("gpio: sim: new testing module")
Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-sim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -732,7 +732,7 @@ static void gpio_sim_remove_hogs(struct
 
 	gpiod_remove_hogs(dev->hogs);
 
-	for (hog = dev->hogs; !hog->chip_label; hog++) {
+	for (hog = dev->hogs; hog->chip_label; hog++) {
 		kfree(hog->chip_label);
 		kfree(hog->line_name);
 	}


