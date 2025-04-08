Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA12C2673B7;
	Tue,  8 Apr 2025 11:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110679; cv=none; b=YesMQsR3NhDmbjjg5cpM7fOV3MoJzE7tH6qGUthlgIWHqNXw50GaBoRSkMOXNP4tpnzvOqBc/pn/GdO8o+bAHTjmCPAgiVMIsFJX4OkzviaGBNu6F2yx/0iOAUHds77NiiBDPri3kjAp/K9+x0uCX4EVkDdE+uQuXSlo5N9nTec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110679; c=relaxed/simple;
	bh=q7YBVi48GSpzE0uG1DjQ4FAesL/ApjjLufCKXXA4/BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=npgsWgoTbJ3CfWmgUL25e9udlLbAMsyBmyV7+CB+smGl2FW++PZvFJ7+bDX8uJLdQvho3rMICDdUn0Gos9lYbmJ9qr3nGETE2YIiv0kRtXLY6xCrDn6pCZ4aUs8n63YJBHd3iejtdKi9HJYTi6SRdeiFlaaMUR5Vz4HBPMGYyZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ms9zS/WN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ms9zS/WN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0EBC4CEE7;
	Tue,  8 Apr 2025 11:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110679;
	bh=q7YBVi48GSpzE0uG1DjQ4FAesL/ApjjLufCKXXA4/BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ms9zS/WNEGsW6VHL7fJn0cOuefylFtB0ggw5raVNhQ9KWFIsi90mWoldo6eYCf2Gy
	 FQW6ZC4Mu/r1kbbb2GYZBlXtxtuCFKsTXzt5MNl0Yq8LcXVtOASgapHAkB48MQ3omp
	 6nGz2jDsL3wFNWQ0fh1WHLL9s3LrTh7DvrFnmqr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Coly Li <colyli@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 153/731] badblocks: return error if any badblock set fails
Date: Tue,  8 Apr 2025 12:40:50 +0200
Message-ID: <20250408104917.835340784@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 7f500f0a59b1d7345a05ec4ae703babf34b7e470 ]

_badblocks_set() returns success if at least one badblock is set
successfully, even if others fail. This can lead to data inconsistencies
in raid, where a failed badblock set should trigger the disk to be kicked
out to prevent future reads from failed write areas.

_badblocks_set() should return error if any badblock set fails. Instead
of relying on 'rv', directly returning 'sectors' for clearer logic. If all
badblocks are successfully set, 'sectors' will be 0, otherwise it
indicates the number of badblocks that have not been set yet, thus
signaling failure.

By the way, it can also fix an issue: when a newly set unack badblock is
included in an existing ack badblock, the setting will return an error.
···
  echo "0 100" /sys/block/md0/md/dev-loop1/bad_blocks
  echo "0 100" /sys/block/md0/md/dev-loop1/unacknowledged_bad_blocks
  -bash: echo: write error: No space left on device
```
After fix, it will return success.

Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Coly Li <colyli@kernel.org>
Link: https://lore.kernel.org/r/20250227075507.151331-6-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/badblocks.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 1c8b8f65f6df4..88f27d4f38563 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -843,7 +843,6 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	struct badblocks_context bad;
 	int prev = -1, hint = -1;
 	unsigned long flags;
-	int rv = 0;
 	u64 *p;
 
 	if (bb->shift < 0)
@@ -873,10 +872,8 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	bad.len = sectors;
 	len = 0;
 
-	if (badblocks_full(bb)) {
-		rv = 1;
+	if (badblocks_full(bb))
 		goto out;
-	}
 
 	if (badblocks_empty(bb)) {
 		len = insert_at(bb, 0, &bad);
@@ -916,10 +913,8 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			int extra = 0;
 
 			if (!can_front_overwrite(bb, prev, &bad, &extra)) {
-				if (extra > 0) {
-					rv = 1;
+				if (extra > 0)
 					goto out;
-				}
 
 				len = min_t(sector_t,
 					    BB_END(p[prev]) - s, sectors);
@@ -986,10 +981,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 
 	write_sequnlock_irqrestore(&bb->lock, flags);
 
-	if (!added)
-		rv = 1;
-
-	return rv;
+	return sectors;
 }
 
 /*
@@ -1353,7 +1345,8 @@ EXPORT_SYMBOL_GPL(badblocks_check);
  *
  * Return:
  *  0: success
- *  1: failed to set badblocks (out of space)
+ *  other: failed to set badblocks (out of space). Parital setting will be
+ *  treated as failure.
  */
 int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			int acknowledged)
-- 
2.39.5



