Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3048472541;
	Sat, 12 Sep 2026 11:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211361; cv=none; b=tETkKVz6ENFt2JQhKJvRiM25fPE++nytbSkll5RJjZ5RU+c3bL2SfSlfiDQpDys6vacrua+X7rY+/GiDHB8ih3Bpf9LANoLWYmHgA/R6w/JNywAirBL441oQ1ze9DBgoK5fHUcQ/g9ljKLoy2Bi8IehxDPwVns+nYycAunLT93c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211361; c=relaxed/simple;
	bh=yIO7yWcxBQJofZTjKdQwd3tyaxE6rrhrOPJ3+xFsjz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSRnt+aU+nIEQNuD2phgeTp+XlfXvQ67SYjt9nB4BoQzaDL0NhnBggBuY7TpTP/Ti/IHEbrPxplrte1L/i3kTwffGABaeyC9DuhuYjBd5OmLwtXy/+5RkrWQNkBJeFS5CbtCx1Gt9VYnHHACBobp9V2HuB/3/tGW32MKnYQ9Elg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0Pd8yJT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0Pd8yJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2371F000FF;
	Sat, 12 Sep 2026 11:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211359;
	bh=I0XNkJ4g7uDoqtwgumCVri9DUWi51hPRBncTTJ3FMCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M0Pd8yJTsrRt2rK7HArumwx+fi/amfV6RJ9SQmvwyF7Gi0aKluklz/dHMDA9evIaH
	 SgCVxQb5EI/sowJU5OddIEliYW84KQ0JD5LUqhtPndMrIPcYvPXr3O53o0Wd0otVV3
	 1VvWbWoS2e8ROgIvPBgaRzro15L7EW5n6rZI9Jdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1215/1518] null_blk: free global tag_set on init error path
Date: Sat, 12 Sep 2026 08:56:24 +0200
Message-ID: <20260912065650.974783753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 5a1c5ff3a49ba93a1fd0b70537e7a0164071760d ]

If shared_tags is enabled, null_setup_tagset() allocates the global tag_set
via null_init_global_tag_set(). If device creation later fails, err_dev
destroys the default devices and calls unregister_blkdev(), but never frees
the global tag_set. Since module init failed, null_exit() is never invoked,
so the global tag_set's tags and maps are permanently leaked.

Free the global tag_set in err_dev, matching null_exit() which does
if (tag_set.ops) blk_mq_free_tag_set(&tag_set).

Fixes: 82f402fefa50 ("null_blk: add support for shared tags")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://patch.msgid.link/20260725022509.714271-5-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 3d7e379b4b687..830cc0ac05e4f 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2186,6 +2186,8 @@ static int __init null_init(void)
 		null_destroy_dev(nullb);
 	}
 	unregister_blkdev(null_major, "nullb");
+	if (tag_set.ops)
+		blk_mq_free_tag_set(&tag_set);
 	return ret;
 }
 
-- 
2.53.0



