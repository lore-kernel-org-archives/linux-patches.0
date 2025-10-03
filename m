Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62B42BE62D;
	Fri,  3 Oct 2025 16:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507642; cv=none; b=qxTZUkHZBFkbeDrzqzpkIRKBG6opWfhETp8KatNGAgxIliM+2L9YKWycLr/XqI0jySOAIxv3SRQ0NOR25soUEhiP+EsIznyTMl5wi7dj5GBUogBcVqYVuKhkP82CTTmY6NaI00upEIXNXlMQgFQMxJlfK45AUxs1C99zkas86ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507642; c=relaxed/simple;
	bh=WugLzdtBugOx+6/jh4E0TynA6wpwzdVmi70Qj78SEiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7OQUp5qerIKd65eef9UUSlscnwSXeTQo6WvZbjWyEuZditQmPb7a+0Ep5PHen/Ag1GoymlLZ+S00Pfnhtz/rAYzdozoeSTrrMJNyWZ+Om6ycFM/86G+ApqpooCWYGqZ98AZBTaQ/dPTZkOnFZTPE/DSLLmqMtplHThvjTJ3uCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kc1kFRX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kc1kFRX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D38C4CEF5;
	Fri,  3 Oct 2025 16:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507642;
	bh=WugLzdtBugOx+6/jh4E0TynA6wpwzdVmi70Qj78SEiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kc1kFRX53G2CChvYNbeTqotwnTOs6vq8sibOlmMc4OQoWuxzFeYIAwAbVUsh+HOON
	 GqE+pNs5TLYVEt9LSXyJ4fP805/tjmy3QYwF2e6Ua7YbIOLKGK0Ug6nJkCH9ir7NV/
	 iNPTkciiWapunj66KrAMoSQN15poQS1vluxrTe/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Hannes Reinecke <hare@suse.de>,
	Li Nan <linan122@huawei.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 01/14] blk-mq: fix blk_mq_tags double free while nr_requests grown
Date: Fri,  3 Oct 2025 18:05:35 +0200
Message-ID: <20251003160352.757253991@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>
References: <20251003160352.713189598@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit ba28afbd9eff2a6370f23ef4e6a036ab0cfda409 upstream.

In the case user trigger tags grow by queue sysfs attribute nr_requests,
hctx->sched_tags will be freed directly and replaced with a new
allocated tags, see blk_mq_tag_update_depth().

The problem is that hctx->sched_tags is from elevator->et->tags, while
et->tags is still the freed tags, hence later elevator exit will try to
free the tags again, causing kernel panic.

Fix this problem by replacing et->tags with new allocated tags as well.

Noted there are still some long term problems that will require some
refactor to be fixed thoroughly[1].

[1] https://lore.kernel.org/all/20250815080216.410665-1-yukuai1@huaweicloud.com/
Fixes: f5a6604f7a44 ("block: fix lockdep warning caused by lock dependency in elv_iosched_store")

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Li Nan <linan122@huawei.com>
Link: https://lore.kernel.org/r/20250821060612.1729939-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq-tag.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -622,6 +622,7 @@ int blk_mq_tag_update_depth(struct blk_m
 			return -ENOMEM;
 
 		blk_mq_free_map_and_rqs(set, *tagsptr, hctx->queue_num);
+		hctx->queue->elevator->et->tags[hctx->queue_num] = new;
 		*tagsptr = new;
 	} else {
 		/*


