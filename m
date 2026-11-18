Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058356;
	b=rhPSwMXCYqvBQYHndb1oq7naAqjF5Vs2F6DoaKEEbuiboNrK93VsTohTUGv+DfHSGk0U
	 5hQw8Ty1AeKlkKtBJSEycZvSgRKrg3//uk20HwQ9Ladg+1fBvyxixV20zv+r0wy6nTxcA
	 cm7Y1Bgk2qJFJzqXryhtHxf1uIiu/Bel3/Zr1hmBnWjMM+wsTdBW431HcO/GvtQxL8ha6
	 m2SqBSTXu1HDxXG6ouJBB3XRREzWcT1tsd047sVr7xnhWdcmK10mzqKCDq4PTqsqQqEXn
	 YFXACy9le+t2WxeTrBnLV2ZX6AZEhdr2iTmCKGcNHMGG0h8sdoYF43lJ1fc4wG8qnQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/AAxoR/AD0jgQzuxsqNWv6dUp22UIkC5dW9xIjhm/hs=;
	b=ZDOi2BNZThmVWSmxDw+eUZiT6VVe4KU87cXkxzQzs1RW6/p2Zh8EufH8O/D/9DdDZRGw
	 A58/uS5YNjZiMbVz1s1aypFQ8zCAeRP8GgrsxzMl+hCqytLM1ip42vBJkRX943B4xuIX0
	 fK9CZY4NYab3mV2YU9w4k+ABhYWSMMxTXZKytknT3W464F7nzphW+X4v87l5OFnQvWUl8
	 3+ZXrpknatIIzc4Txtz+kY2mAhmX1vriPpOv4J/NxVMKTdC8eAJ7kaUS7sExxpE7c8vFY
	 UKLLlLB4Qv1pu1KFq4+xWHZ5oT0d2w/2TpQRZ4yaxOatD/yh+rfF+Yz0ikyF9L1oi2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yUj5DEhN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B446D606A320;
	Thu, 19 Nov 2026 03:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yUj5DEhN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDCC1F000C5;
	Thu, 19 Nov 2026 03:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058356;
	bh=/AAxoR/AD0jgQzuxsqNWv6dUp22UIkC5dW9xIjhm/hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yUj5DEhNF4yjCzTZTmB3bbUrB2NyNJuyfomawViMcHuqtynnVKU/R0CHkoi0u9U3L
	 u9AxXGUg9A2HkgcvcrnojqXQBKIYGIa2rtisxsOsifBz53/jscQPdFxNFjYKhXYOEf
	 IYyBeGFW7sUIgurR2KwhxNKbtaWGl4N0TIJjQ0Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0457/1848] dm-writecache: fix uncommitted_blocks underflow
Date: Wed, 18 Nov 2026 15:41:35 +0100
Message-ID: <20261118145933.601545450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 8a0cc5f3446a324b13f62020eeddb32d6ba1c2db ]

Revert the commit 39495b12ef1cf602e6abd350dce2ef4199906531

writecache_bio_copy_ssd sets wc->uncommitted_blocks = 0; and then queues
the flush work: queue_work(wc->writeback_wq, &wc->flush_work);

It may be possible that discard is dispatched in this window, and the
discard would decrement wc->uncommitted_blocks to -1U.

Note that this bug is benign - wc->uncommitted_blocks is only used to
trigged autocommit, so decrementing it to -1U will trigger a spurious
autocommit, but won't cause any data corruption.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Fixes: 39495b12ef1c ("dm writecache: correct uncommitted_block when discarding uncommitted entry")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 5124331a66f8d..1b7d89794c6a3 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -874,8 +874,6 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 				}
 				discarded_something = true;
 			}
-			if (!writecache_entry_is_committed(wc, e))
-				wc->uncommitted_blocks--;
 			writecache_free_entry(wc, e);
 		}
 
-- 
2.53.0



