Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426363E9281;
	Wed, 20 May 2026 16:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294438; cv=none; b=t/RtzUwA1/qgovkvzvdc5HFke9v/7Sw9f4Ocp15qlBWKfeeQmBx859tIh084aeg4bZf2Ds+Y7p6gZO4guUjiCpEWIGoQyDM7BO89yVdBhW45qPxZbwQ1MUb60zhxB1QdtrpQzJ46pRHRIhDeGapwjtzKbQFbo5HA3JnR1nPEXFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294438; c=relaxed/simple;
	bh=hH7WpIM60XdDN8l/l/Hf0haj2BnVd58t65GbzZPGOM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E0PzEfVCc/OeAroYKpYpqQMINZd1eqx/TyoFmh2fDpT5hocs2qHYQSx81FGw44RGo9I4y81yGUh79owI0c+RGHK2Ruf1XAHvhoden0CLsI4LhqWnzjINdgorpQ7oSTglozVnqELTmMyzshCuweF4zOrKgp7gTC2qshNa8bMgZcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqIDW3RV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqIDW3RV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBC71F00893;
	Wed, 20 May 2026 16:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294437;
	bh=/ZRvNojWz1wbgnzf9iN6PG5mnIkUpx6htklP56nscqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JqIDW3RVLeysxTH4rNbwBBqOro09J3yKhgS6ubGvyCqW1rMzLt0AuVRvsnQJO7Qtp
	 HvdPrLWIbK91OYqSTZxw6FGE/4UiumHL+jgbkzDjCanCWNXtfSf8Ga5wokNTU3ygxJ
	 3exsDRGBkCZc7qVn9JicYj6HpxYszGp1Iu9IMmC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0007/1146] drbd: Balance RCU calls in drbd_adm_dump_devices()
Date: Wed, 20 May 2026 18:04:17 +0200
Message-ID: <20260520162148.561175760@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 2b31e86387e60b3689339f0f0fbb4d3623d9d494 ]

Make drbd_adm_dump_devices() call rcu_read_lock() before
rcu_read_unlock() is called. This has been detected by the Clang
thread-safety analyzer.

Tested-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Fixes: a55bbd375d18 ("drbd: Backport the "status" command")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260326214054.284593-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_nl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index e201f0087a0f7..728ecc431b38d 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -3378,8 +3378,10 @@ int drbd_adm_dump_devices(struct sk_buff *skb, struct netlink_callback *cb)
 		if (resource_filter) {
 			retcode = ERR_RES_NOT_KNOWN;
 			resource = drbd_find_resource(nla_data(resource_filter));
-			if (!resource)
+			if (!resource) {
+				rcu_read_lock();
 				goto put_result;
+			}
 			cb->args[0] = (long)resource;
 		}
 	}
@@ -3628,8 +3630,10 @@ int drbd_adm_dump_peer_devices(struct sk_buff *skb, struct netlink_callback *cb)
 		if (resource_filter) {
 			retcode = ERR_RES_NOT_KNOWN;
 			resource = drbd_find_resource(nla_data(resource_filter));
-			if (!resource)
+			if (!resource) {
+				rcu_read_lock();
 				goto put_result;
+			}
 		}
 		cb->args[0] = (long)resource;
 	}
-- 
2.53.0



