Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E5D446AC;
	Mon,  1 Apr 2024 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988064; cv=none; b=oIKSh8u3cNtGyshhb9p+6vfA6pYmOabuxNckNHAPLCBGr77r5CNc7mHmRwIMH6o88qtFp7cVwinp5gr24BYte0ExL5XZZo6vGzi241rGv0JtnLptHf0S77xzUOP+EDABM0FY/DH6P1HF1j0xLP0Vxkst/36Dp8ojvCg+iOQ/ztg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988064; c=relaxed/simple;
	bh=C2JzIPx5jrqCoPMVT1Ku4OPHMbsEj5tcSH3q4y+BHW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soFfofQH1kTNLwRJVlhEMihqmSe9LP5P0aWK7v8gQ5s/C/rCVXAzUTKmc+BReZ8gry8EYWuzppL/XEOc+1JTd5rmePg+gdG6fTaX8QbAFOp4iMDcGef9khUoSdkISNQ6iJUpJED1nncIBnmwQGkS1xthyLJI9tg/LGdopYJ5Rvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PP4AbSqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PP4AbSqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E304C43390;
	Mon,  1 Apr 2024 16:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988064;
	bh=C2JzIPx5jrqCoPMVT1Ku4OPHMbsEj5tcSH3q4y+BHW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PP4AbSqkRMUzDxvIWt4uZx6Cmi8Q8mHS7xRKZZ+JwibAnVqnfg6LLkoy4/JtORTJO
	 Opxuuut4RMQ8XoUgxpGsGeBunmtAWJ2wYNPVmlFtMR+ES2iGnlK+Y5oOH5fzeGwKb8
	 4mEI3yaOiv6xctyejqgxr+Ft5tsPssr8TC4kKoDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 044/432] block: Clear zone limits for a non-zoned stacked queue
Date: Mon,  1 Apr 2024 17:40:31 +0200
Message-ID: <20240401152554.443365979@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



