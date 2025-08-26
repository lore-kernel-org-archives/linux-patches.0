Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AC92248A5;
	Tue, 26 Aug 2025 11:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207257; cv=none; b=XKDIjj0mhWTwqEVUlbYLKPQuxH6/U+h12PdzPnaNdBm5v0hfT9pLgkd4DhDbF59DD/ohqMTu1zfHTslrg2ZvNmDBEZIruyaLmTOD/nFlsj8uP6jLetzIXsmmfj3GQUnkW1Ngrja4cpelXlpDu84u4bSh1fxnvkeEOJWipxMrAjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207257; c=relaxed/simple;
	bh=g7hDztYRr4I/8SrnsyjsP3aAUBIA5GRra0VdNyg38jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpH4lFK8enzonSmgv4vDkj1nq7l7aj/zTLnvIkXsrEoBHpTLxRQJe9IW2g1y2PxBaLfXV60+EqF7M7eWD4So7DGSR5ySRYnruJ0Io8jpG52gfinznESrjBof3iQOMcLQtF4izi8CCOOvC5f2RAuUjqRta4DJn5aLzS1NJS/Q8Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXRm1f8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXRm1f8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56BAC4CEF1;
	Tue, 26 Aug 2025 11:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207257;
	bh=g7hDztYRr4I/8SrnsyjsP3aAUBIA5GRra0VdNyg38jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXRm1f8BQVuTuFKct6zdebKxf3mgAB0WOHF+P8rfoQPOuHOI07HgcSy/0z7aF6fds
	 ezZKwLTqLBaSt5j5Ppee8Df//mX8Oc54wqbiYaUbw06QAB2548WDXGlct/jPfiUuFo
	 hlOeRNg4cK7m6UB75qGAH0p+Azzf5eRguDGoveZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 110/457] block: restore default wbt enablement
Date: Tue, 26 Aug 2025 13:06:34 +0200
Message-ID: <20250826110940.089643504@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao2870@gmail.com>

commit 8f5845e0743bf3512b71b3cb8afe06c192d6acc4 upstream.

The commit 245618f8e45f ("block: protect wbt_lat_usec using
q->elevator_lock") protected wbt_enable_default() with
q->elevator_lock; however, it also placed wbt_enable_default()
before blk_queue_flag_set(QUEUE_FLAG_REGISTERED, q);, resulting
in wbt failing to be enabled.

Moreover, the protection of wbt_enable_default() by q->elevator_lock
was removed in commit 78c271344b6f ("block: move wbt_enable_default()
out of queue freezing from sched ->exit()"), so we can directly fix
this issue by placing wbt_enable_default() after
blk_queue_flag_set(QUEUE_FLAG_REGISTERED, q);.

Additionally, this issue also causes the inability to read the
wbt_lat_usec file, and the scenario is as follows:

root@q:/sys/block/sda/queue# cat wbt_lat_usec
cat: wbt_lat_usec: Invalid argument

root@q:/data00/sjc/linux# ls /sys/kernel/debug/block/sda/rqos
cannot access '/sys/kernel/debug/block/sda/rqos': No such file or directory

root@q:/data00/sjc/linux# find /sys -name wbt
/sys/kernel/debug/tracing/events/wbt

After testing with this patch, wbt can be enabled normally.

Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Cc: stable@vger.kernel.org
Fixes: 245618f8e45f ("block: protect wbt_lat_usec using q->elevator_lock")
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250812154257.57540-1-sunjunchao@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -876,9 +876,9 @@ int blk_register_queue(struct gendisk *d
 
 	if (queue_is_mq(q))
 		elevator_set_default(q);
-	wbt_enable_default(disk);
 
 	blk_queue_flag_set(QUEUE_FLAG_REGISTERED, q);
+	wbt_enable_default(disk);
 
 	/* Now everything is ready and send out KOBJ_ADD uevent */
 	kobject_uevent(&disk->queue_kobj, KOBJ_ADD);


