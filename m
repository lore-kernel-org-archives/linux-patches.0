Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B3C472091;
	Sat, 12 Sep 2026 12:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217146; cv=none; b=sAQsewc+H/NGvh1ZlEAY9OlHovgympme93i8hvePMyL5JWbZ4hABo+EvtFOH6uY6mCks80YyG0OfZ1G9l39z1nDJEec8mHWEJCEywrwDDTyp+HUQFP9Hwz47zRlTaPbk7pDyz+3JQYkbmOZa5YX9EOuNLipUWj0EYlYFvsyVC0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217146; c=relaxed/simple;
	bh=wmHNCp13Z0HPX1dR3s5zBcxxwXoaSb+blFkFidcAXAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zh6gqa8TzQzg7A38Lshb/JpSVXsKBHQ0rRNIJFgokK2b+cUWdE6TKRJxdAYW/N0TqTJVeS0BLo89D9BDIveDsByQ3L3mPMJTuxklPbS8VVqnZGGa7jeqn3lmqmU5v7Mq+LR461DtzDvR6J9+CumAFnuRz5In3kWWACvR1jixtMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oph16lGu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oph16lGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF471F000FF;
	Sat, 12 Sep 2026 12:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217145;
	bh=gDLvGRCaQau9xec+z7AC1E++yxRMBVQJkWRm+knnFNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oph16lGui/tNq8h3ynQH+XsMTLWhWlM42YYXf3Fsa4yoblh9J8fdKd34TcvWjC46k
	 dKOMKLnFQK+/i2pF8gU8f4PUYF6NSd0rYfXtKx4JuEzcy2ub4EcUJAAPTJ9LvRUSZq
	 tFVKMbb8F3ZTDWeijkYaZvNNOVteQuSaIgdjiAG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0879/1376] ublk: check for ublk_unmap_io() returning 0
Date: Sat, 12 Sep 2026 08:55:05 +0200
Message-ID: <20260912065627.154082219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 24fd3706178f1ae5501fd1ff9036e170ed0665ba ]

If the userspace ublk server passes an unmapped address as the data
buffer for a completed ublk read, ublk_unmap_io() will return 0
indicating no bytes could be copied. Currently, this will result in
calling blk_update_request() with nr_bytes=0, which doesn't seem
supported. Fail the I/O with BLK_STS_IOERR in this case instead.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Link: https://patch.msgid.link/20260729171041.45061-3-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index df177ea0a47e6..aecac3b6749bb 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1072,8 +1072,14 @@ static inline void __ublk_complete_rq(struct request *req)
 	 *
 	 * Re-read simply for this unlikely case.
 	 */
-	if (unlikely(unmapped_bytes < io->res))
+	if (unlikely(unmapped_bytes < io->res)) {
+		if (unlikely(!unmapped_bytes)) {
+			res = BLK_STS_IOERR;
+			goto exit;
+		}
+
 		io->res = unmapped_bytes;
+	}
 
 	/*
 	 * Run bio->bi_end_io() with softirqs disabled. If the final fput
-- 
2.53.0



