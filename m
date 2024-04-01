Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE92A487A7;
	Mon,  1 Apr 2024 15:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986656; cv=none; b=SBvRHSV87389X2bIhLcFRUHEYoTr5KZ3J2emffc2r9u38/Vdnz+1VBVgbcw6TTY6EEnvPJ4inPmUa5OJ5Yhp7fI4EulrUNdQB3K5aQIik8lPATGYR533k/H9sE0qtPUScPumWfI09JY4FmB4RaDflYQsx7zvmzcCHfBMpuV7800=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986656; c=relaxed/simple;
	bh=0WYzlUXjoZBYdUWwzn012m9DVXAe99aouYJabcLs0cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wr6WDqWMs6sdexuCueNRdDFk5WiqcPLM95AomkSBoPA/xUeY+qMq1r+lTPTgT1UA58ub8eS2bjAftENACPOOvCrdSu5QWbzuyALz4vPsH4b1XN8PdadXN8UCl9pAs/BAKSXAyyR3v+dTcR1gnXKpn+iom/RaQiMmi9/ep9NE/0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxIvbw/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxIvbw/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E3EC43394;
	Mon,  1 Apr 2024 15:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986656;
	bh=0WYzlUXjoZBYdUWwzn012m9DVXAe99aouYJabcLs0cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxIvbw/zTtsz83XSH9qTKt5EuA40ll+YIQJJaKmtt2w4AQG/8k623thmxaBhl3Dl8
	 CzuZ0rRUPuVzntS4OpRTGF8yyK4tkD5L1mZ+Sia/YrwkfUjX8ZdDEeZo8vDfZ5SqqV
	 VRShecSa784V6W6BFQ6OQ/cbtzgWG2d1O4fSg6rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 044/399] block: Clear zone limits for a non-zoned stacked queue
Date: Mon,  1 Apr 2024 17:40:10 +0200
Message-ID: <20240401152550.491203865@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 06ea91e51b8b2..5adadce084086 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -689,6 +689,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
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



