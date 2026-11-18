Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040298;
	b=WkR1OiBHGH3ioVQsZwUKe/pEL1Rf3TM79tErh3h5+Gp+BtfTTB7YSTdN3iq0PJKAkA2j
	 gNBwXbSTsC/+vG4NXTyvgnQ+n1fC4idWE7SJy6pfbWwzKj5irAy1qTiHoVpBn/XTjl/hK
	 qssRkYGPTvybBIWMVD69YTuWayxaN9iM80a+tovvtj9sU1GhA7zuKa/iEbsAlY2d/6UZ0
	 Lx4WShsyL5TPIjS5tpEqgqgqydf+/NzAcS8cpGUdfaCcZqqbk1l8SaMrnKZ7GnhRNCW/j
	 xc9PTIkuR6iTlvyavUwfe7PM/IGXjdBbewHpCLj4KNbX44352ifmVi7mG/MeiaD/RIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mcsgR/+Nhok5CcB6uMxug4FrSXh8I69HzoEkgGwM5p0=;
	b=vV2SRJnECyvEKwZiEqVKoeIVCkx00lIQG2RlWEQ3B1jwiFMXbzSZRrnk/ZdqwppK4vtR
	 AhOVasLn7QHr7jv9S2kd3oEnLjm/9g9kb7EjS+u78QWssDYoBTX+dk9rNGfu3jfXbwlOF
	 w3NmCrBu91HbxqnLhNydNdfQByHwzwjDqgScNd986BpJUBfshcwwy6uerTALTB4hom464
	 v1UTaNl5mqZPvD/5rRarLvHLsuIVZZlT/il4O1VD0FueZ3wQtG1CTRpGulU7ok0iERvNx
	 1PAyrH0tQpH7B8OlUiVPiuglovHeTHSR9etCtcDc0s6kiBqzQDaKZUeESqUg0LPzclA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mu4f2p8b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C181C606A330;
	Wed, 18 Nov 2026 22:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mu4f2p8b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2093D1F000C4;
	Wed, 18 Nov 2026 22:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040298;
	bh=mcsgR/+Nhok5CcB6uMxug4FrSXh8I69HzoEkgGwM5p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mu4f2p8bmMERGzchcdXXsCrk6jxsGeABY3P2gIlgRFqOMIK3cRinTiCDrZkkbSxnr
	 PR4hUzX1v8eAMGaTZCIYFAe38+uCgwQgJ07p9h6ec+1zKdM2AjwCMjeiMqeU+xTu1V
	 d5wT08C9Ve6hB1pDKBeWeKPHZ4c/EpwXizpDGcss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>,
	Xin Yin <yinxin.x@bytedance.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2367/3318] writeback: size foreign flushes by target wb dirty pages
Date: Wed, 18 Nov 2026 15:49:49 +0100
Message-ID: <20261118150432.579932552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Yin <yinxin.x@bytedance.com>

[ Upstream commit 168a8c13159c6e3f0f08da6f8fa2f633a91ba9fd ]

Foreign dirty tracking records the bdi and wb memcg IDs of recently
dirtied foreign inodes. When the source memcg needs foreign writeback,
mem_cgroup_flush_foreign() queues WB_REASON_FOREIGN_FLUSH to the
recorded target bdi_writeback.

cgroup_writeback_by_id() currently sizes this best-effort work from the
target memcg's NR_FILE_DIRTY counter. The work is scoped to one target
wb, so a memcg-wide dirty count can over-size a single-bdi flush when
the target memcg has dirty pages on other devices. It can also under-size
the flush when the target wb has dirty pages charged to other memcgs.

Over-sizing keeps the target wb busy longer and can delay later
writeback work. Under-sizing can finish before enough pages are written
back for the source memcg.

Use the target wb's WB_RECLAIMABLE counter and keep the existing 25%
headroom. This keeps the budget aligned with the writeback object being
queued.

Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Link: https://patch.msgid.link/20260924065443.1650126-1-yinxin.x@bytedance.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 85d9d97e486eb..738991da1fd9f 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1124,7 +1124,7 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	struct cgroup_subsys_state *memcg_css;
 	struct bdi_writeback *wb;
 	struct wb_writeback_work *work;
-	unsigned long dirty;
+	long dirty;
 	int ret;
 
 	/* lookup bdi and memcg */
@@ -1153,16 +1153,13 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	}
 
 	/*
-	 * The caller is attempting to write out most of
-	 * the currently dirty pages.  Let's take the current dirty page
-	 * count and inflate it by 25% which should be large enough to
-	 * flush out most dirty pages while avoiding getting livelocked by
-	 * concurrent dirtiers.
-	 *
-	 * BTW the memcg stats are flushed periodically and this is best-effort
-	 * estimation, so some potential error is ok.
+	 * The caller is attempting to write out most of the target wb's
+	 * currently dirty pages.  Size the work from the wb's reclaimable pages
+	 * and inflate the count by 25%, which should be large enough to flush
+	 * out most dirty pages while avoiding getting livelocked by concurrent
+	 * dirtiers.
 	 */
-	dirty = memcg_page_state(mem_cgroup_from_css(memcg_css), NR_FILE_DIRTY);
+	dirty = wb_stat_sum(wb, WB_RECLAIMABLE);
 	dirty = dirty * 10 / 8;
 
 	/* issue the writeback work */
-- 
2.53.0



