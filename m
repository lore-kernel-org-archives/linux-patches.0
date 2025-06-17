Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EA2285059;
	Tue, 17 Jun 2025 16:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178383; cv=none; b=An6SA2FtY8nacF+bCkDfigzGRfDvWxcZ69YR/oj9FRwWuhvD5YWGbYy7hSWbE1iLlGUP80IQ62J4pLXTtnNG9rLQq/4f1zpl4R0m044aPn4gNLYmYymgaVGnZfrwEmBPOOQR4mM8McBHOufIdurQYx7SF93+/1plnc4QzRGxzVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178383; c=relaxed/simple;
	bh=0Ae4qDSkWuprj23mDcIjEwwNpIt6HKVc/OOnQTvW8Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AROaIW1eF7VonNp/pRwX8mzx6fO035tujT2volypji7NHc1oBdyZMVKgSdyW1xpnGNdLbuGUHdIZwHM/YTXtmBqfwjt1zs3nMAkPQCiSkKQihpTCz7RoRduwsQ9geUthARJqKrFzzVfa6Ln4Ue5o2N0D5kEWJA1E7o6YSuLwh50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfxr5b3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfxr5b3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0793CC4CEE3;
	Tue, 17 Jun 2025 16:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178383;
	bh=0Ae4qDSkWuprj23mDcIjEwwNpIt6HKVc/OOnQTvW8Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfxr5b3Dy0Jsiml62Gl7RHa0MY3IUsOcMEDhx7QlbqVycYiiWDBm4WQZEme2mL7OF
	 fsYSmLrXk2ow+lqA4dqI5bPufklnFAvzZeSwRZU8BkaAXNI/F3UmMu5AZMCtcb6Aj5
	 nyW3a3mHXevx6yyvUswJOz43KPV5zTcz6n0tSqv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 452/780] rpmsg: qcom_smd: Fix uninitialized return variable in __qcom_smd_send()
Date: Tue, 17 Jun 2025 17:22:40 +0200
Message-ID: <20250617152509.877292890@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5de775df3362090a6e90046d1f2d83fe62489aa0 ]

The "ret" variable isn't initialized if we don't enter the loop.  For
example,  if "channel->state" is not SMD_CHANNEL_OPENED.

Fixes: 33e3820dda88 ("rpmsg: smd: Use spinlock in tx path")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/aAkhvV0nSbrsef1P@stanley.mountain
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index 40d386809d6b7..bb161def31753 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -746,7 +746,7 @@ static int __qcom_smd_send(struct qcom_smd_channel *channel, const void *data,
 	__le32 hdr[5] = { cpu_to_le32(len), };
 	int tlen = sizeof(hdr) + len;
 	unsigned long flags;
-	int ret;
+	int ret = 0;
 
 	/* Word aligned channels only accept word size aligned data */
 	if (channel->info_word && len % 4)
-- 
2.39.5



