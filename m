Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042591;
	b=F7muytfIZznGer3vf35c/DJfkwBhv58D7ZsWHqAmpzL7uNlQZNrqHyAFTPY6aX58pwvg
	 b8H2W1GgKiieOsvACAq/c+gSFigwFzMqMZEqiqwSSXSlFn9VnmhkrxpRl+xrLYITjUOKC
	 UZ78tgti3+CSd6Bjrgru/4w1Ln0pFQZzJR7ojAUfkhUGZ50e1W5xAkxn2wDGdGtQRzfH7
	 KIoD3cPnOlhYJyuoeHHhgVa+MId+q1PAZJ9xXDeJ9gCPoVqGGF55ilmFoGuBIBzmexlzZ
	 dfI4m/Ez0pR5gdaQ3bcCqYmjIihlcFEfAuMalcfIMJ49siwuXoI9YsM1huhMd2MLaTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rrTQNoJgXwlt8DQtOSiaSC4601L7nt7APqfe3OcI9GI=;
	b=YSC7GSJeK44O2paPlPTbV0MOcuqQs+Bag2MT/GZ6oZQzkKVLw1c230K6kEHRTO69JWh1
	 VhLOaH46S+SvounucHWWacPJy5KzwDOwy9XIlMiFoLmmGawi3pqp4gZI9VHlpmuniN+By
	 yIgCGVg0I0rUP4M3G9X7VUT+Gx431hJcX/8hAUd+5bNvg/E9M2r/U1Y2r93Dtrquqw62Y
	 H78FcTmqc0KsMp+GPnXY5neU2dK6mkKpC5YLbDbAL4OkzMVpatXZqqZ93FRvP7kYQ1B0D
	 5tBk6ifjcqVp3jcXmiPuCKRXZ2uA80qM6n6G8b670GUEQEGkF6HaypZU7JKq+e3FA6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=muDuUBqk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C8B606A31C;
	Wed, 18 Nov 2026 22:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=muDuUBqk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717BB1F000C4;
	Wed, 18 Nov 2026 22:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042591;
	bh=rrTQNoJgXwlt8DQtOSiaSC4601L7nt7APqfe3OcI9GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muDuUBqkcQqC3e7UVQf0xLSnA9SkGWRuy8ZVS0AC1FIyoCbO0aJU4kMbiQz6YD7ix
	 rgFbrxsz/wBfpKrFLTttWaBwV/5zNb2qz0S6tBkcgFyqWRJZLFFjeFWsiF86G974PL
	 oWSEDXbPMPZEQ0fXx9bdTtiCFDwGWqkd/ID2rGqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3225/3318] blk-throttle: dont truncate the cgroup v1 iops limits
Date: Wed, 18 Nov 2026 16:04:07 +0100
Message-ID: <20261118150456.470611747@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7d96874ba80ba7a2ab578ea9139c2af79c353b88 ]

tg_set_conf() parses the limit into a u64 and stores the iops ones
through an unsigned int, so anything above UINT_MAX is truncated and a
multiple of 2^32 becomes a limit of 0. The next IO of the group then
divides by it in tg_within_iops_limit().

Clamp to UINT_MAX, which means no limit, like tg_set_limit() does on the
default hierarchy.

Fixes: af133ceb2610 ("blkcg: move blkio_group_conf->iops and ->bps to blk-throttle")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-4-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ed6fa1e7b8624..a765db9fc46da 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1403,7 +1403,8 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 	if (is_u64)
 		*(u64 *)((void *)tg + of_cft(of)->private) = v;
 	else
-		*(unsigned int *)((void *)tg + of_cft(of)->private) = v;
+		*(unsigned int *)((void *)tg + of_cft(of)->private) =
+			min_t(u64, v, UINT_MAX);
 
 	tg_conf_updated(tg, false);
 	ret = 0;
-- 
2.53.0



