Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D177C3749F6;
	Sat, 12 Sep 2026 09:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203823; cv=none; b=SOM6ckRdQW0mofix40G0Id0mvCR9jQ/22zPw64xmHl0IAHlt/xcsJQZC5x+aIp/1UeKjYx+l/2YVmohT8ATn6a0EJk5KYnKw+1V8bgW3QNC8hGmPdnGGhOwozEUYaMG6XOnb1RgVWtUxtM4/mttSDHYsgq7HWV4YXrLboiSo7dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203823; c=relaxed/simple;
	bh=0sgb+6EYnwAO/vEAEzEinrfi00jxaIRFAS0omHqppxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j963iwKpV/BxBzBODda5h7Hd2Mg8PgPX3R3+4MTd35wTnqP2i4DSXyugCrqXDc+hfYeIKtGxMc0GDZ3RrbLUM2O+9nyENj6IDZPFv+/xWZ1HT2JRM9cHpEYX+QTVi2oEkWUbzFQgWbm6QZoBpQiEiY1oCBsHYqsyYcZCoCNSMYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSVXgHMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSVXgHMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6541F000FF;
	Sat, 12 Sep 2026 09:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203820;
	bh=6iEQWORWJ7MsfBJ5VauI6BuBPaUGtbl9izAwph5Si64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSVXgHMt2qWjaqYPZl4451TuU+nnZdTrkEs/TKwq66T35dlnoqRcZ9lC8ErddUq9a
	 FWYJQnAq0cnvoqUMXFcwESljjsfLhUZ7vHodDxn5AKOrpe2wzBCEwwC90KFpgfT6fH
	 J5+uY0YobvMxxqwCsg727Nf4LpN/ui7zFBZqQir0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Zizhi Wo <wozizhi@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1486/1815] null_blk: serialize configfs attribute stores with the lock
Date: Sat, 12 Sep 2026 08:53:56 +0200
Message-ID: <20260912065723.890173515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 7e7fff51808237703a3a1df6dd5cae1dfd1db86d ]

The NULLB_DEVICE_ATTR _store takes no lock: apply_fn attributes
(submit_queues, poll_queues) get dev->NAME written again after apply_fn
returns, outside its lock; APPLY=NULL attributes are entirely lockless.
configfs only serializes stores per-open-file, so concurrent stores on
separate fds race.

For apply_fn attributes, once one store's apply_fn has reconfigured the
hardware, a second (losing) store can still overwrite dev->NAME
afterwards. This leaves dev->submit_queues out of sync with the live
queue count, which is later caught by the WARN_ON_ONCE() in
null_map_queues().

For !apply_fn attributes, power_store()'s null_add_dev() validates and
builds the device under "lock" but only sets CONFIGURED afterwards. A store
slipping in during this window can change a field mid-setup -- for example,
zone_nr_conv can be pushed above nr_zones after it has already been
clamped, leading to an out-of-bounds dev->zones[] access.

Take "lock" in the macro around the apply_fn call, the CONFIGURED test and
the field write, and move it out of nullb_apply_submit_queues()/
nullb_apply_poll_queues() so both paths are covered once. This serializes
stores with power_store's setup and with each other.

Fixes: 45919fbfe1c4 ("null_blk: Enable modifying 'submit_queues' after an instance has been configured")
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://patch.msgid.link/20260725022509.714271-10-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 6494b802756b5..0db0ac65cf49e 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -360,6 +360,7 @@ nullb_device_##NAME##_store(struct config_item *item, const char *page,	\
 	ret = nullb_device_##TYPE##_attr_store(&new_value, page, count);\
 	if (ret < 0)							\
 		return ret;						\
+	guard(mutex)(&lock);						\
 	if (apply_fn)							\
 		ret = apply_fn(dev, new_value);				\
 	else if (test_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags)) 	\
@@ -430,25 +431,13 @@ static int nullb_update_nr_hw_queues(struct nullb_device *dev,
 static int nullb_apply_submit_queues(struct nullb_device *dev,
 				     unsigned int submit_queues)
 {
-	int ret;
-
-	mutex_lock(&lock);
-	ret = nullb_update_nr_hw_queues(dev, submit_queues, dev->poll_queues);
-	mutex_unlock(&lock);
-
-	return ret;
+	return nullb_update_nr_hw_queues(dev, submit_queues, dev->poll_queues);
 }
 
 static int nullb_apply_poll_queues(struct nullb_device *dev,
 				   unsigned int poll_queues)
 {
-	int ret;
-
-	mutex_lock(&lock);
-	ret = nullb_update_nr_hw_queues(dev, dev->submit_queues, poll_queues);
-	mutex_unlock(&lock);
-
-	return ret;
+	return nullb_update_nr_hw_queues(dev, dev->submit_queues, poll_queues);
 }
 
 NULLB_DEVICE_ATTR(size, ulong, NULL);
-- 
2.53.0



