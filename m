Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92F735AC1A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302681; cv=none; b=AiKyhsg0vv7M0IfEqcCNQ6JnqM2VPS2hQk8RLGR8QV+bLo/bhI5GMqUuCBplbBTInAI8+LU55HudHelM1TTqdN60/VITOfvIE5Ki42HfJXzJ0vHk+yePPxmgY3jlNqCKhLsLJwkC/rWsN/8IbRUVhWd4T0wGr8+hHQu3i5qUHRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302681; c=relaxed/simple;
	bh=ic8NwFyiZnzfHYX0m5UVf/W5VqKuH6ML43R5bPrUuJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ4bI/VZPa66o5uLcW/emhaccaTqhZIwD1LMKJfA8rpXQXBhaZXrwA/yCm8kdJOvqQVkhdy5QCWR+2CIA1zYjtT4kkgzJuBr9VjZRuYYRe+YzTPKaWcspztOxsD1RpDikHU0gl3wHynNs1EWksLbR/22hra5MNdbWtN8tCAomp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5nLnMwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5nLnMwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4E1C19423;
	Sat, 28 Feb 2026 18:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302681;
	bh=ic8NwFyiZnzfHYX0m5UVf/W5VqKuH6ML43R5bPrUuJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5nLnMwFQ+xUIP+1K4/YTVXW9Odcty0UQpuQg1RLxEOJ9qeSbV4mnfZmg5hJpDVG6
	 tt/ZOae4d2KTzp5wHUYvHAhfW5+QYhhLFpaeOsd8ubEuAaNcUZU7CT/GPKNnG7KwT7
	 S83kYDANIrKNkXRPdW3dZrDuREDKcI9RMQW1l9HawHOh1dZc5eibZvZUnS9T6DHNeQ
	 qgUjNEl9lO0MPE7UN+55uSjn6FqI/u4UwzcB4XwSWjErTeLBesBmOv+WEJMTsCXt8j
	 HvrrE44QuT/KpVRfrJdvXzp8ePAe2L8FzsCoWBw6w+PUqmOQRtoVV1ha2aisCH50vM
	 yjFJFRvOmPc4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/147] EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()
Date: Sat, 28 Feb 2026 13:15:40 -0500
Message-ID: <20260228181736.1605592-32-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 72f12683611344853ab030fe7d19b23970ed2bd8 ]

The snprintf() can't really overflow because we're writing a max of 42
bytes to a PAGE_SIZE buffer.  But my static checker complains because
the limit calculation doesn't take the first 11 space characters that
we wrote into the buffer into consideration.  Fix this for the sake of
correctness even though it doesn't affect runtime.

Also delete an earlier "space -= n;" which was not used.

Fixes: 68d086f89b80 ("i5400_edac: improve debug messages to better represent the filled memory")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://patch.msgid.link/ccd06b91748e7ed8e33eeb2ff1e7b98700879304.1765290801.git.dan.carpenter@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i5400_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 92d63eb533aee..9f11b15397c36 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1024,13 +1024,13 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 		space -= n;
 	}
 
-	space -= n;
 	edac_dbg(2, "%s\n", mem_buffer);
 	p = mem_buffer;
 	space = PAGE_SIZE;
 
 	n = snprintf(p, space, "           ");
 	p += n;
+	space -= n;
 	for (branch = 0; branch < MAX_BRANCHES; branch++) {
 		n = snprintf(p, space, "       branch %d       | ", branch);
 		p += n;
-- 
2.51.0

