Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909711420A7;
	Tue, 23 Jan 2024 01:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972118; cv=none; b=TUGECm3Bbo06kVPiaV/5lP3VEp+kjEYg7Ov5aEDUYb2sqZB9ol7guE5+U/xqtXhljHrm4Bv76pK7zqqAzpCnNdEZD6/VAfWABD0R/77kydrx8T/WE31a9GZZf8tuw6gwS24rsCZ+b2Wf/Hhb5gV16Bsc84L/gcF3Aw/K6UwO7Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972118; c=relaxed/simple;
	bh=7jq9Bj0J01V3NWPNk46+xBdaahRC76FA3UjPFsZzOyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlTCR6zFByp1a57rq+iyq0PWwVZrYJPaDTe3iY2btGoDVLFjrI1Ha4js0WmSXWp69s56qaAoIRJmosi6DU1DO6XEG2vNO5/L1fAOE1elFdKbjsrrdvxhX3ourncrdQBcr22sNDlZYPQc+jafK+6YovsgnMX1Kr0uTbf2pToAG28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9JZDF+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9JZDF+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F05EC43399;
	Tue, 23 Jan 2024 01:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972118;
	bh=7jq9Bj0J01V3NWPNk46+xBdaahRC76FA3UjPFsZzOyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9JZDF+q3KuMORncsNDuxJOzo+CHd7FrqF4QD9v5jTLkG7RfignzH0uc64nxUxoSL
	 y0R1vsI4nwh78swPVvyg2Il7ITnGK3sT7ecFhOPd7HZetgD+hAVISBbZW+Em5Vj6qd
	 AaqzOjZ5vUEmL5Snq/n5w/LjRnoTrS9F7tt+yFf0=
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
Subject: [PATCH 5.15 028/374] neighbour: Dont let neigh_forced_gc() disable preemption for long
Date: Mon, 22 Jan 2024 15:54:44 -0800
Message-ID: <20240122235745.616749539@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 927c4db2703f..5829477efbba 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -225,9 +225,11 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 {
 	int max_clean = atomic_read(&tbl->gc_entries) -
 			READ_ONCE(tbl->gc_thresh2);
+	u64 tmax = ktime_get_ns() + NSEC_PER_MSEC;
 	unsigned long tref = jiffies - 5 * HZ;
 	struct neighbour *n, *tmp;
 	int shrunk = 0;
+	int loop = 0;
 
 	NEIGH_CACHE_STAT_INC(tbl, forced_gc_runs);
 
@@ -250,11 +252,16 @@ static int neigh_forced_gc(struct neigh_table *tbl)
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



