Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34121E525;
	Mon,  1 Apr 2024 16:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989414; cv=none; b=WO8NWrCwjn9t2LWWrz6StbaFRIJbL+wtVZq88NiuOJq2UBaZH9QvdlCRkkxvyrkPHb/jZ6u3+kvCw647tYqMwWwGK+HY8qBH0P56FTvrah5wH+6gHmEKLam47pKFSZwFbYAeEdnwrRzjXpJ1Xa7KWlcljFHzwRXq+Wj1+oQe5jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989414; c=relaxed/simple;
	bh=DcUCwC4e56L0BTAvD9tUUtz6y0X+kwPykcntPmqBCp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgoWr7w9kw1auKXAAUoLyLPxKRbNEhO8cYsnBSLANyVW3tfpbGiwtYKpoq1B9j6bf6seAlqF/GooO0hzx0fhV5HCmrsc52RDr3j4biJZq8xrfnhaX0iYwUuAgjj0BK2uclYc+hTyWFs7Hn/j/9zyfkK16TwoWi47yAAlimhGEJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crqttqE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crqttqE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4358FC433F1;
	Mon,  1 Apr 2024 16:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989414;
	bh=DcUCwC4e56L0BTAvD9tUUtz6y0X+kwPykcntPmqBCp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crqttqE6y1lLqlseUKmXX4IR/zsGkyABKGnYsEsiaGKTSMIgHBZ0yLQDIz4JGl/ov
	 P5lDgVXLqbBx0sWQoQ8PEuCmht+Yu8y66o1Tc0TqSx/U7JL7jXrfkYVH8qAJktuzbH
	 skgj2njweZjEa9DKFXmVCdhjYCCeTdNg1q0YjldE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/396] block: Clear zone limits for a non-zoned stacked queue
Date: Mon,  1 Apr 2024 17:41:31 +0200
Message-ID: <20240401152549.184440532@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0046b447268f9..7019b8e204d96 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -686,6 +686,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
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



