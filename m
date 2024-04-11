Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D9B149C7C;
	Thu, 11 Apr 2024 10:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831495; cv=none; b=cpnX5xHg0rWz7xvGYkhxAtUukGBlIUDvgpkF2yEAdBe+plC8Hs8pXBdhdGcrpjkjjmtqslbMxtVbx7DGXjxrIwZtyJfCjxgId8uDcf4ghN4AX6y9w0LyN2cTF6lPoU6wV0y6J7E663AQx2s883k6eYnvgl78Jhhvj+dduJwqPdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831495; c=relaxed/simple;
	bh=ekRnN7OeZXcbixpJfbVGfchhoEutQN77lFCnr+eZ07k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7AmfHPe94cM9uvaPXMw+IgoARjBvjhoDR7EpCrKna3zWbU5j2VM8oEhr9l6ia43Y8vQYIBa9WsrVCzD7mFXUT2dmnvYldIZ5tIv84s7odmHb4KFwDiJrLDZXeTXHjtP/5DlFjpC9IYIUsjmbyFv6q07FnSUwZIvFfp9/h2HeRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfdyNBFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfdyNBFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A585FC433C7;
	Thu, 11 Apr 2024 10:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831495;
	bh=ekRnN7OeZXcbixpJfbVGfchhoEutQN77lFCnr+eZ07k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfdyNBFUzfF6vE5kjFmQTWyvYf0RUWzkt/f6e5T9CaRe3b+eDImmeb41Usp5kcBIU
	 RSYLisadkJ9bKqMpZnRl1LDKMoDBWD11tA0eBiQSNynRjvNgMhWWX8yyPU6wbZhap5
	 za9w8loPTpHeR8+8eUrsuaUlsKY/+XbOJTg30r0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/294] block: Clear zone limits for a non-zoned stacked queue
Date: Thu, 11 Apr 2024 11:53:11 +0200
Message-ID: <20240411095436.483833608@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit c8f6f88d25929ad2f290b428efcae3b526f3eab0 ]

Device mapper may create a non-zoned mapped device out of a zoned device
(e.g., the dm-zoned target). In such case, some queue limit such as the
max_zone_append_sectors and zone_write_granularity endup being non zero
values for a block device that is not zoned. Avoid this by clearing
these limits in blk_stack_limits() when the stacked zoned limit is
false.

Fixes: 3093a479727b ("block: inherit the zoned characteristics in blk_stack_limits")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20240222131724.1803520-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index ab39169aa2b28..ebd373469c807 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -656,6 +656,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->zone_write_granularity = max(t->zone_write_granularity,
 					b->zone_write_granularity);
 	t->zoned = max(t->zoned, b->zoned);
+	if (!t->zoned) {
+		t->zone_write_granularity = 0;
+		t->max_zone_append_sectors = 0;
+	}
 	return ret;
 }
 EXPORT_SYMBOL(blk_stack_limits);
-- 
2.43.0



