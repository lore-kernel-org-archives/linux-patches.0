Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07906FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290D1C433EF;
	Mon, 16 Jan 2023 16:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887736;
	bh=5p9BKXAPPxjt7yjuJmohSVC6uSy3ssFZcJxZO9Q+h04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kve2wnwEOspi4GDoml3e2gde16saNA7kq64Q5St3jaXUB5HLRkHjaaVVH0E5SUrJb
	 6g6w5bk3ZjHC6W+dZgI58xPcVjhkT/JmtkEcqtVt5CmLLppR02DctSoPKL5zwbZeku
	 BXuHju0f6uSKjHwa51OoIsPY7HUegPH6YEWpOrIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 233/521] misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()
Date: Mon, 16 Jan 2023 16:48:15 +0100
Message-Id: <20230116154857.554993782@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit fd2c930cf6a5b9176382c15f9acb1996e76e25ad ]

If device_register() returns error in tifm_7xx1_switch_media(),
name of kobject which is allocated in dev_set_name() called in device_add()
is leaked.

Never directly free @dev after calling device_register(), even
if it returned an error! Always use put_device() to give up the
reference initialized.

Fixes: 2428a8fe2261 ("tifm: move common device management tasks from tifm_7xx1 to tifm_core")
Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20221117064725.3478402-1-ruanjinjie@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/tifm_7xx1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index 9ac95b48ef92..1d33c4facd44 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -194,7 +194,7 @@ static void tifm_7xx1_switch_media(struct work_struct *work)
 				spin_unlock_irqrestore(&fm->lock, flags);
 			}
 			if (sock)
-				tifm_free_device(&sock->dev);
+				put_device(&sock->dev);
 		}
 		spin_lock_irqsave(&fm->lock, flags);
 	}
-- 
2.35.1



