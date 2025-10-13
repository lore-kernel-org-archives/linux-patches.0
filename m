Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98391314D16;
	Mon, 13 Oct 2025 15:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369224; cv=none; b=l4L4XCf9MpkzFhu3nlq7NsZ+yDayAbN78/25W3ALGVz9Ue34gl54OrWFJQsY3GDDIx0KEWsnqKTAi/E5uYeV9jtGgVRXEJBGBbZAkJpNqP7bomKJpNPB6MTbwNlDkDrZv48boQzgNJMTsMVIlG86J5xorWKk8OsnQOdiRz0zeQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369224; c=relaxed/simple;
	bh=H5wjjLNruY6/cSC/elI9joYxf2kVzBI6i0qa62zH9Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=capHTBfQO2m+rgNGvjv46IeNaJ0igHO9p2DpJhTeZNnjsV8ocfefTX8wdVObhZ9PQJ/ztW3uaU3tk+E39ajuXK6QlG8EuvAXrwaZK6QQIPdomN5akT5JNmQBsjAD6NrK+QpPJ0Xa+s2E4Jat+xGmwvkhBigkqXRDLJt+xzGFICE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4/iZIDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4/iZIDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD6CC116B1;
	Mon, 13 Oct 2025 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369224;
	bh=H5wjjLNruY6/cSC/elI9joYxf2kVzBI6i0qa62zH9Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4/iZIDl+iXvEU1nDhsRzlMw7l0T9Yc97KNMiU8D71tgZGcsjE4gQgtoP6kwydI4y
	 UsclcXs8MROIFsQkiUbyiB8N66s+vTxY7GB59aPGKBtVzMHdibqW1zFLAA1QkWzjJx
	 qjLmwCiReymWZFIs6exMqWJBrbpheYXAifX0sdJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 172/563] blk-throttle: fix throtl_data leak during disk release
Date: Mon, 13 Oct 2025 16:40:33 +0200
Message-ID: <20251013144417.518763645@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 336aec7b06be860477be80a4299263a2e9355789 ]

Tightening the throttle activation check in blk_throtl_activated() to
require both q->td presence and policy bit set introduced a memory leak
during disk release:

blkg_destroy_all() clears the policy bit first during queue deactivation,
causing subsequent blk_throtl_exit() to skip throtl_data cleanup when
blk_throtl_activated() fails policy check.

Idealy we should avoid modifying blk_throtl_exit() activation check because
it's intuitive that blk-throtl start from blk_throtl_init() and end in
blk_throtl_exit(). However, call blk_throtl_exit() before
blkg_destroy_all() will make a long term deadlock problem easier to
trigger[1], hence fix this problem by checking if q->td is NULL from
blk_throtl_exit(), and remove policy deactivation as well since it's
useless.

[1] https://lore.kernel.org/all/CAHj4cs9p9H5yx+ywsb3CMUdbqGPhM+8tuBvhW=9ADiCjAqza9w@mail.gmail.com/#t

Fixes: bd9fd5be6bc0 ("blk-throttle: fix access race during throttle policy activation")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/all/CAHj4cs-p-ZwBEKigBj7T6hQCOo-H68-kVwCrV6ZvRovrr9Z+HA@mail.gmail.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index f510ae072868c..2c5b64b1a724a 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1842,12 +1842,15 @@ void blk_throtl_exit(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 
-	if (!blk_throtl_activated(q))
+	/*
+	 * blkg_destroy_all() already deactivate throtl policy, just check and
+	 * free throtl data.
+	 */
+	if (!q->td)
 		return;
 
 	timer_delete_sync(&q->td->service_queue.pending_timer);
 	throtl_shutdown_wq(q);
-	blkcg_deactivate_policy(disk, &blkcg_policy_throtl);
 	kfree(q->td);
 }
 
-- 
2.51.0



