Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DD9129A63;
	Tue, 23 Jan 2024 00:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968729; cv=none; b=f5RqyRTzBvS3QpSMNbn+30mEmVvXA00ixyoGfIBmpr+eeqX+AqIIlN9I6szckomMzjKcGfFS48i0Gcdeu1Nup/vekha//sjcOB91URccf7OUPotWtIAUlPHvme+VgaGn/IIdPqx2bGL+fS1R7PiS3Oj2p/gBKlikUPY4G5Ld9y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968729; c=relaxed/simple;
	bh=4ttioyCrV43EPU4fLErzTtJIZYwpK3LJQE5kE7FRCoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lklZZzcmh/nZw9HX4PG06bLwzZk+sMyt0wg/GkVn24dZjLP83yxLAdN/3pXdaMuJ3vocBF9Mifqmvk2NKYbl9Dmie0WVjjXvPVCebh+lITlUDzRSl8fni97w9pzJgg4UhXVr8R9W+AJWJ+CvlaqJgZFnU2qwaaXLhZM/wdb8KEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QY7STQK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QY7STQK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54433C43390;
	Tue, 23 Jan 2024 00:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968729;
	bh=4ttioyCrV43EPU4fLErzTtJIZYwpK3LJQE5kE7FRCoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QY7STQK/+pebef0WJ2p9PwBWpZX5n2sRtdit3T4piAz9gNMuFzJENWj+Cf9mG15L8
	 kOXf/knhhAkqf8YWPvGQCmSFNd+Fm6TgFePt8gTqmiqmk6dcVpU1+gpirNZgZRRw4t
	 wqdu9SwaATVGmj8EQ69CCmKNLXwS1I7V+h2s+/xI=
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
Subject: [PATCH 5.4 019/194] neighbour: Dont let neigh_forced_gc() disable preemption for long
Date: Mon, 22 Jan 2024 15:55:49 -0800
Message-ID: <20240122235720.042209447@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9d631b7adb7b..e571007d083c 100644
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



