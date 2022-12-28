Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4093D1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D55FC433EF;
	Wed, 28 Dec 2022 16:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244860;
	bh=RJOBklZfdn/3YC9rVuulS/t8uNeco02yuuvSzdG+/go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0y3WIbHeGNNFGX12lYw2Rf+XXKrzXZr5H3ffD8lrsSGQ7vNi1YEpEX5yACzny77/
	 0Tre8D/D/Oe8nbJGNYbK/cjIKB8p4dde728Fm7DBn3VOtAGeIIOfj4rKD6pRmiKnLr
	 p/6OA/KUrehfA6xJbZEFcXLcI6+AstPZugPrPbxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0717/1146] misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()
Date: Wed, 28 Dec 2022 15:37:36 +0100
Message-Id: <20221228144349.618846606@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 017c2f7d6287..7dd86a9858ab 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -190,7 +190,7 @@ static void tifm_7xx1_switch_media(struct work_struct *work)
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



