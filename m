Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C72BA3F;
	Mon,  1 Apr 2024 16:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990688; cv=none; b=Xrrb0icB6cRdFtoyqy0GS5cmDVyu3U9+xK4vdqFKBtrOEohDiwBLabY/OENWVlXnBNwuFATbJlN91G+Bw38Vm7rBSt4WUN6gz9KKLweLA+mN+qyT6oPvfzpL6t5Hjl+HOcpIDxuVIa+H6pnzXHewscL20oSI8xPCjUAeKrc/AZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990688; c=relaxed/simple;
	bh=BfvTd+x6dOWDhT6Ry7pxTJK8/1EmukK80UTC1pfFo0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgnFj/OYR9nBty/lDmn29xuWcpJc+QRKE9gKXJACeePiM8jw4csgW4L7PeV6x8GBd98ruA1rZKZJG+xbVcIDHvstSFH07wM+TGchAdEvMItjcGCiPheVSQBlnQFzmsq3dSZWVgf0IG2xBGJB4LRZ68yg3LZB20QtWwTi86QJcr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRnJmw7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRnJmw7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A2DC433C7;
	Mon,  1 Apr 2024 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990688;
	bh=BfvTd+x6dOWDhT6Ry7pxTJK8/1EmukK80UTC1pfFo0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRnJmw7cCXrxEnJrVQKvAbm2mpSnW2VcWfuRDW6L1g3orK2sm6roIIdrkUg08wZUo
	 9GPGx5tWNtT+CwknSCgPYYAO/TFQfB+1GZCLnMm/sYDx6Ql0wfk5SNyWkhdXQu6FLV
	 Isc5Zi3UF5qsZpWqqo2H3QlliF4YnKIeGrwcoF1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/272] block: Clear zone limits for a non-zoned stacked queue
Date: Mon,  1 Apr 2024 17:43:46 +0200
Message-ID: <20240401152531.505016431@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bbca4ce77a2d3..c702f408bbc0a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -680,6 +680,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
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



