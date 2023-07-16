Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7B38F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB4AC433C7;
	Sun, 16 Jul 2023 20:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540565;
	bh=D8ie1eqjMTmf9EzHLT3urpkwADiWirvrQkEpywxft1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOYLLYNWw/Bp+DqTzcHmG9WOUUNC0DmdkG1HYxJMnLRpUUjyxlJS+vBcc2KQx29oP
	 0ESq7ngy6NhZELvr6C2XiYCy3+lFprsqRGU8pd6rE/tJwM99se0ad//xsJcu0xNCCX
	 +tTKip+Gh9zNpV8cT6GaH5E5Np6dLM5in9py/xxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kepplinger <martin.kepplinger@puri.sm>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 401/591] media: hi846: fix usage of pm_runtime_get_if_in_use()
Date: Sun, 16 Jul 2023 21:49:00 +0200
Message-ID: <20230716194934.294632536@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Kepplinger <martin.kepplinger@puri.sm>

[ Upstream commit 04fc06f6dc1592ed5d675311ac50d8fba5db62ab ]

pm_runtime_get_if_in_use() does not only return nonzero values when
the device is in use, it can return a negative errno too.

And especially during resuming from system suspend, when runtime pm
is not yet up again, -EAGAIN is being returned, so the subsequent
pm_runtime_put() call results in a refcount underflow.

Fix system-resume by handling -EAGAIN of pm_runtime_get_if_in_use().

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Fixes: e8c0882685f9 ("media: i2c: add driver for the SK Hynix Hi-846 8M pixel camera")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/hi846.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/hi846.c b/drivers/media/i2c/hi846.c
index 306dc35e925fd..f8709cdf28b39 100644
--- a/drivers/media/i2c/hi846.c
+++ b/drivers/media/i2c/hi846.c
@@ -1353,7 +1353,8 @@ static int hi846_set_ctrl(struct v4l2_ctrl *ctrl)
 					 exposure_max);
 	}
 
-	if (!pm_runtime_get_if_in_use(&client->dev))
+	ret = pm_runtime_get_if_in_use(&client->dev);
+	if (!ret || ret == -EAGAIN)
 		return 0;
 
 	switch (ctrl->id) {
-- 
2.39.2



