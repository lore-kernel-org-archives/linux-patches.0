Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6ED2E62C;
	Mon,  8 Apr 2024 13:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581443; cv=none; b=SIZ4+WOtoVOu/ZNovUGtyW60QuEshgg8xpLAl7r8i0yxcNJ3q2sRbbHo2hPgxxKNaSEkwG/gVcnrHJGUuR/C4EbDxrVQuSJAnTEUpdbda6BCmj0D5qU0/nmkxvJ6h1O7JcMwkekjiRd4kKnNbIRwZVedBkARVWN0KVss/wTEWzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581443; c=relaxed/simple;
	bh=QwphQmeUoj4SArJT2eKVySVvRttUbF0UIAYuQwjh7PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/OOd++6EIi9OMOMX6T9ARJtBHB9Zqlq4DPgt4sf/oIbkU+Kx7NWWPowLT8XQZC2IXnrQ6yF8x0Gtyv+/QdjihL5rnQdzXcH8B8ABjoHkGU/f/U8eSLwTrv/enuL3o0U5w7wfPAZq/47U1dgHKTPgfczNJIDZbSke2vHEtXjM+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkODEshO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkODEshO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720C2C433C7;
	Mon,  8 Apr 2024 13:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581442;
	bh=QwphQmeUoj4SArJT2eKVySVvRttUbF0UIAYuQwjh7PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkODEshONiiFi8Jju+chUML4UuVKgAkkg6mCzNi/7Ij3mpGa46BOgYtl8koqGOg/w
	 THPA4k2v8FRbFVcXrxtdbjvyKzknhY/9+JE+TlRtACZVCvoq0TsqLEekw4ML5lNcg0
	 HOinzhaD1V4pnbiRaEWIWkl6LiC6jj/T6n1qYqFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/690] block: Clear zone limits for a non-zoned stacked queue
Date: Mon,  8 Apr 2024 14:48:12 +0200
Message-ID: <20240408125400.517137604@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 959b5c1e6d3b7..1b92e66249518 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -647,6 +647,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
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



