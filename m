Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44013FFE;
	Tue, 23 Jan 2024 00:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970937; cv=none; b=qLORBoMx1q02tqsHyaxsi305z6SNJZ7ZwD+xxPQZJ7ZU0at3ijLZuATdV+8bcXi8AIJzz+te6lcpkWI+m18w/dHgWstHlokOweEcnSGMpVT5bud7RVvjocmrBSdM8uqTu1kP6mf2RtgIyTexOLQb1dswL8ZpETbzIS6SfOiltTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970937; c=relaxed/simple;
	bh=VAhjB5lgdxLzRVJ6y1vox/0Qz2E+q7mqoYJ5XZ8g6H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diagY1D0uW14rq3FS9eDBGNhOhPaaeJJpjPp72pHE5cKrW2HPsNOUEAyCGmlAKKm1XKf5vOk7BWm3FuI2gi0b0BExAYg7kEdylK3LVVOF01R7c4cmvbTbZ1FdpktErIV5EOVo1XqnmxHAFpI3bam9sCGLnd93W8F0HQEbQzqGx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3OhOQaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3OhOQaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9B8C43390;
	Tue, 23 Jan 2024 00:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970937;
	bh=VAhjB5lgdxLzRVJ6y1vox/0Qz2E+q7mqoYJ5XZ8g6H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3OhOQaz01Afn01SGNt43vNSlC9DEvkAQtGGMvSnYMCkIO9DN2MEnLDbdtiN1ANQV
	 QD0M/2GoBx0AfTIhzkPzfkrzLZFJoMi9DnP9eyvkzHB7tFCDBOnVqBomrAD9QIOUPF
	 zqGwTpWQvIMWhd8W0l0HDLLwlS1CAgjfLp7UQNN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Judy Hsiao <judyhsiao@chromium.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/286] neighbour: Dont let neigh_forced_gc() disable preemption for long
Date: Mon, 22 Jan 2024 15:55:30 -0800
Message-ID: <20240122235732.955186938@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judy Hsiao <judyhsiao@chromium.org>

[ Upstream commit e5dc5afff62f3e97e86c3643ec9fcad23de4f2d3 ]

We are seeing cases where neigh_cleanup_and_release() is called by
neigh_forced_gc() many times in a row with preemption turned off.
When running on a low powered CPU at a low CPU frequency, this has
been measured to keep preemption off for ~10 ms. That's not great on a
system with HZ=1000 which expects tasks to be able to schedule in
with ~1ms latency.

Suggested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Judy Hsiao <judyhsiao@chromium.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 4c43183a8d93..432e3a64dc4a 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -226,9 +226,11 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 {
 	int max_clean = atomic_read(&tbl->gc_entries) -
 			READ_ONCE(tbl->gc_thresh2);
+	u64 tmax = ktime_get_ns() + NSEC_PER_MSEC;
 	unsigned long tref = jiffies - 5 * HZ;
 	struct neighbour *n, *tmp;
 	int shrunk = 0;
+	int loop = 0;
 
 	NEIGH_CACHE_STAT_INC(tbl, forced_gc_runs);
 
@@ -251,11 +253,16 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 				shrunk++;
 			if (shrunk >= max_clean)
 				break;
+			if (++loop == 16) {
+				if (ktime_get_ns() > tmax)
+					goto unlock;
+				loop = 0;
+			}
 		}
 	}
 
 	WRITE_ONCE(tbl->last_flush, jiffies);
-
+unlock:
 	write_unlock_bh(&tbl->lock);
 
 	return shrunk;
-- 
2.43.0



