Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB57284B37;
	Wed,  4 Feb 2026 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218186; cv=none; b=UVI3hIrmEBf2e0eLfgXU6APon8aXweo6JknX4RPDwt/2CvU1bY0finizgbUB+MStS/U03/c0GSdvz15kyil8tDutT5pa68NkSj5D2AryHMs2HozAzteKqRB7Pe8mOF095FJnUbb3jnlw1UOXvpijBbVKLkKkq5B2KN5vmpWNOwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218186; c=relaxed/simple;
	bh=d/sg6Oz+wt6PM8Q2mWu5IkoFRWH/ZLG70y4xCefDom8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tX72/qP0UMfRf6V4ny1D5RGqiK9KnOvyqqjz1rlZYO/3cNfB5yfx/NvLkQAvJSUT7B9xkdXvDDOTVSOJkuupVWz8m/VP1HE6TL9JYCQyUExLVy+KmI9ZWApd0egSdGkCwSEvNdBVtNk1tUbqJt1E6stpGi+2AaVrZ3/LEvPnzDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ot8kw1nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ot8kw1nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F35DC4CEF7;
	Wed,  4 Feb 2026 15:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218186;
	bh=d/sg6Oz+wt6PM8Q2mWu5IkoFRWH/ZLG70y4xCefDom8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ot8kw1nqs7IczaQjNIw3eUCuDH+v+T34l3CDrhBTY9DsKZsooU6/nbVZjXmqrw97z
	 rPNOh99EFrvoUVcHkG6RUdAwjeUdsBkyyEuB0HxwwF1KcATHa+rza2X++5TsPBWt6T
	 WDSSefsOhizzVOlAsu5//d7WxwPfCGXhxuMVacWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Sergeev <denserg.edu@gmail.com>,
	Mika Westerberg <westeri@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/280] gpiolib: acpi: use BIT_ULL() for u64 mask in address space handler
Date: Wed,  4 Feb 2026 15:39:38 +0100
Message-ID: <20260204143916.942018489@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Denis Sergeev <denserg.edu@gmail.com>

[ Upstream commit c0ae43d303e45764918fa8c1dc13d6a5db59c479 ]

The BIT() macro uses unsigned long, which is 32 bits on 32-bit
architectures. When iterating over GPIO pins with index >= 32,
the expression (*value & BIT(i)) causes undefined behavior due
to shifting by a value >= type width.

Since 'value' is a pointer to u64, use BIT_ULL() to ensure correct
64-bit mask on all architectures.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 2c4d00cb8fc5 ("gpiolib: acpi: Use BIT() macro to increase readability")
Signed-off-by: Denis Sergeev <denserg.edu@gmail.com>
Reviewed-by: Mika Westerberg <westeri@kernel.org>
Link: https://lore.kernel.org/r/20260126035914.16586-1-denserg.edu@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index baa77a8e83652..11338f47d884d 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1184,7 +1184,7 @@ acpi_gpio_adr_space_handler(u32 function, acpi_physical_address address,
 		mutex_unlock(&achip->conn_lock);
 
 		if (function == ACPI_WRITE)
-			gpiod_set_raw_value_cansleep(desc, !!(*value & BIT(i)));
+			gpiod_set_raw_value_cansleep(desc, !!(*value & BIT_ULL(i)));
 		else
 			*value |= (u64)gpiod_get_raw_value_cansleep(desc) << i;
 	}
-- 
2.51.0



