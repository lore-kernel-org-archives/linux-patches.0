Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B5D342CBA;
	Wed, 20 May 2026 16:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295391; cv=none; b=ObOeX7jWNm0w4St9+k83v8UjqzHenYESgJPzAmOB5unP2Bgi0DDh05iAikv8tY6VVjtli5QZEtLxGoF2dy1NgentaqgrBXIbKT1maUpuVyYQJvFE9SlSfRoYOTvglFeFphJAfzkgwiV9BQZNUdYnWKSzFfnm+ahtQtyv+ePXGU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295391; c=relaxed/simple;
	bh=SkVnDH9lvTraXxb1AP4kOzNtSWl22detHosNXctXwjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3Z0xHThPrtp70JkIcThw/SpdeOj+uxU/7oCwJZ/G9O4B0kCvr9lhJe8xTpUSGRBxlRw/nmDBIuT+Yj4UhwEhxM9GBX1vrxmbVmyh9Ul6nGAAIsjSr1sReawCdXXMDTTq2apbr5ClzmRlBZflBvAAYlK9o0Fi3wa2r2vyn5OnBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xK1JYe9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xK1JYe9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7D61F000E9;
	Wed, 20 May 2026 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295390;
	bh=/eUrGjIpUge8mQCCDRF3+DfKlTpmfemV3FR45OlqZUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xK1JYe9bhM6QtdXFrvfJeb8ojAdL2OGno994pimTYIbUgiP7dfTAjCbLPYxytSI9D
	 EbR1MlBDzvHTVlotb5ttvo6BVPwJc/sKP4X8y+2uLi486DmRf2xeHiaKUeBzWS5lw5
	 ttjwn/ZiyN6XcY3UGG91pTSzEdH6lVKm+N5s3Ehg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Brian Geffon <bgeffon@google.com>,
	gao xu <gaoxu2@honor.com>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0402/1146] zram: do not permit params change after init
Date: Wed, 20 May 2026 18:10:52 +0200
Message-ID: <20260520162157.297902549@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 241f9005b1c81c2637eef2c836a03c83b4f3eeb9 ]

Patch series "zram: recompression cleanups and tweaks", v2.

This series is a somewhat random mix of fixups, recompression cleanups and
improvements partly based on internal conversations.  A few patches in the
series remove unexpected or confusing behaviour, e.g.  auto correction of
bad priority= param for recompression, which should have always been just
an error.  Then it also removes "chain recompression" which has a tricky,
unexpected and confusing behaviour at times.  We also unify and harden the
handling of algo/priority params.  There is also an addition of missing
device lock in algorithm_params_store() which previously permitted
modification of algo params while the device is active.

This patch (of 6):

First, algorithm_params_store(), like any sysfs handler, should grab
device lock.

Second, like any write() sysfs handler, it should grab device lock in
exclusive mode.

Third, it should not permit change of algos' parameters after device init,
as this doesn't make sense - we cannot compress with one C/D dict and then
just change C/D dict to a different one, for example.

Another thing to notice is that algorithm_params_store() accesses device's
->comp_algs for algo priority lookup, which should be protected by device
lock in exclusive mode in general.

Link: https://lkml.kernel.org/r/20260311084312.1766036-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20260311084312.1766036-2-senozhatsky@chromium.org
Fixes: 4eac932103a5 ("zram: introduce algorithm_params device attribute")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: gao xu <gaoxu2@honor.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 85943da0cdca8..aaaef8dd82538 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1748,6 +1748,10 @@ static ssize_t algorithm_params_store(struct device *dev,
 		}
 	}
 
+	guard(rwsem_write)(&zram->dev_lock);
+	if (init_done(zram))
+		return -EBUSY;
+
 	/* Lookup priority by algorithm name */
 	if (algo) {
 		s32 p;
-- 
2.53.0



