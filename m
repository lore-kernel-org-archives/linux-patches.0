Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766571A6192;
	Tue, 30 Jul 2024 16:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357700; cv=none; b=FHmOPHJEu+wLQyBuP/7O/JZupJxx0pF6ijwTDPW/myAiFoLsY8zbj5pzcm8TRQmdvjjEhjQroKTtZOkxigYQqLmWmFmFsZOSLygfz5wvDE1IVRIB1cAp3gVnjd++fUqq31uCKSmZJVEXtjGmPjl5tGc0tTAltO/4K+IF0f1jZLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357700; c=relaxed/simple;
	bh=d9enguOZkLzZPh7VbzDWrX+IUNxA0fw10r8ioQzTxIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQaGThHU6grV/TbGfO07DKvlwvMn5UnUhw1QKXvZQvFvJmpo+KH7NgrVb4JGGcv66D45QLP9W58UwKL+6AkfiWfR7ebn82wNS1rinqlAurcd+xIa+n2+BRl/4N8Ou83t9OHJO8EooEAKMjY/7YcPSYoo9HsSzjMjpyKrL4O8CpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDqw/uhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDqw/uhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F170CC4AF0A;
	Tue, 30 Jul 2024 16:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357700;
	bh=d9enguOZkLzZPh7VbzDWrX+IUNxA0fw10r8ioQzTxIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDqw/uhShF5xFwQcynaRvQJMyKWVfaZepTiVgKM7TCsr4qKXPJ9aZQytPy/5wX0bs
	 NDn6YAWjAVq1TCvZWcc0GmjvGDSSaaP/qspA8NnDyzI5XWtymLKyq4ts7KPgZb+Ryr
	 a0eJjVsAdImbttVA8hGAt87xH1HR0EhV/bLYxZCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 280/809] drm/panel: ilitek-ili9882t: If prepare fails, disable GPIO before regulators
Date: Tue, 30 Jul 2024 17:42:36 +0200
Message-ID: <20240730151735.651092593@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 554c00181968d43426bfe68c86541b89265075de ]

The enable GPIO should clearly be set low before turning off
regulators. That matches both the inverse order that things were
enabled and also the order in unprepare().

Fixes: e2450d32e5fb ("drm/panel: ili9882t: Break out as separate driver")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240517143643.4.Ieb0179065847972a0f13e9a8574a80a5f65f3338@changeid
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240517143643.4.Ieb0179065847972a0f13e9a8574a80a5f65f3338@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9882t.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c b/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
index 267a5307041c9..5762eba73955c 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
@@ -579,13 +579,13 @@ static int ili9882t_prepare(struct drm_panel *panel)
 	return 0;
 
 poweroff:
+	gpiod_set_value(ili->enable_gpio, 0);
 	regulator_disable(ili->avee);
 poweroffavdd:
 	regulator_disable(ili->avdd);
 poweroff1v8:
 	usleep_range(5000, 7000);
 	regulator_disable(ili->pp1800);
-	gpiod_set_value(ili->enable_gpio, 0);
 
 	return ret;
 }
-- 
2.43.0



