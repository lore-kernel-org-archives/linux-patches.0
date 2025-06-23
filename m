Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1274C6E;
	Mon, 23 Jun 2025 13:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685493; cv=none; b=ElaOiB01fGtceUinqwTZLsKuXVUm/JOyyV7DMFhJwO4pd50htFkiJbzB9Kc4LwcUx0nVTdz8ILX3RGu8R4W9f7bYKI9afSrzYVIsyxyWBD8QyJn4WI3Z0t+m3TaI2Ld1PYjoeDgmHwX0rXt9uRyQ/nARGzVOzynKf/bMbUtMUvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685493; c=relaxed/simple;
	bh=GPmkiTpCqQzzdWSjby7Pc68YOpKbDB9AA2tHz9RdaZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b806d4jfjhweaMBkWfQCK2F0iWfUSLjO3JObpZfhABKfz9aJ2Ua1Po9HdDxBF8qtof8qbTiJS9JQi/HtQIEruqwp2LzuBGuynYVe6NoPA/PAZhIznYiXqjxq3K7B9TK6xVwiZFeRH2R09lPWuZ0LJq0BdwShXiUSVaHJ4Vk4ERM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/0hOWJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/0hOWJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40DEC4CEEA;
	Mon, 23 Jun 2025 13:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685493;
	bh=GPmkiTpCqQzzdWSjby7Pc68YOpKbDB9AA2tHz9RdaZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/0hOWJy4ii8pvMFf9+qLje5i1es8a+Ll4EwnmmJ24pZT3HNRPp6k8ZRVfLw/mVO8
	 pYIxUz2J4ZVsKnh+J99fQPySJlDNIvXZqS4otwDjCcd8Kp9iCCuJ5THZKF/w5Ap9L4
	 U14AfiYruLSotaRuwHCZEIj6uHG9X2j8bnDBozVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/355] rpmsg: qcom_smd: Fix uninitialized return variable in __qcom_smd_send()
Date: Mon, 23 Jun 2025 15:04:39 +0200
Message-ID: <20250623130629.165371233@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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
index b5167ef93abf9..6facf1b31d463 100644
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



