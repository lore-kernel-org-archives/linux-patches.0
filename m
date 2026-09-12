Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7F11F1534;
	Sat, 12 Sep 2026 08:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201612; cv=none; b=b0BIkA01jZW1hvrz9uFtex58/Nsmh2cJ5NEz+ohYHTo6tKkFdYcdYntTbyvYP0vFxbTARkZ0kVnXXAzJapu9r2b5V/5+H2HmvrfZp9yE5jY+Sl67l1MTr9xfrA0UV6c8rN62Iie20CDq0hvu/8bQZvNt3YByUVFW6Nb+LTbHaoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201612; c=relaxed/simple;
	bh=36OUrU5tJNYPUh1kGOcFvhvR019HCcqJuw35uS+EiyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhNpTnQNP8TR3ftvviG76T+6PBW1m/ZgpesP63BIMFuqA27N7Lo7h5iMrPgVrUAo3qgcJzvhlZCgN89AX9px4IbSXXoxSYpAPJ4swXEBrd8VQ9HArJjBN49dmeC1IwBVnzIC6N5pF06LWIba2KwBYHeFWUHSYrpTC7cDB4tlF/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFtjE1tx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFtjE1tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3C21F000FF;
	Sat, 12 Sep 2026 08:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201610;
	bh=Bu8DJ/cwn5q5SrL0zZBg6+cUmoaqZqp4KCm4Xd6C1iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFtjE1txcyKvqIuIOmv2e01T5JwzIwlEn3ppQPm+IllJdMYdozoB0SjNwO67DylsA
	 lAp6v5wZQq2xXjKriWyVpegACgR5mVkcRrF4fVxonOa6diViZLCCc0cfNvP1vKV310
	 d52+mf5W6Y629egHEaHPM/PhTJqVMx8DkteEEDH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1031/1815] block/blk-iolatency: account per-cpu latency stats over possible CPUs
Date: Sat, 12 Sep 2026 08:46:21 +0200
Message-ID: <20260912065713.223644469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit e0698304bd4a833d6d5a7b6582515e36b1ec3ea7 ]

iolatency_check_latencies() and iolatency_ssd_stat() iterate a blkg's
per-cpu latency stats with for_each_online_cpu().  When a CPU that has
accumulated io.latency samples goes offline, its bucket is skipped: the
check loop (which also resets) neither sums nor clears it, and the show
path under-reports.  On re-online the stranded samples are flushed into
a later check window, which can trigger a spurious throttle/scale
adjustment.

Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Fixes: 1fa2840e56f9 ("blk-iolatency: use a percentile approache for ssd's")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260720093726.28965-3-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iolatency.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index cef02b6c5fa91..9eb69010c34e6 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -523,7 +523,7 @@ static void iolatency_check_latencies(struct iolatency_grp *iolat, u64 now)
 
 	latency_stat_init(iolat, &stat);
 	preempt_disable();
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct latency_stat *s;
 		s = per_cpu_ptr(iolat->stats, cpu);
 		latency_stat_sum(iolat, &stat, s);
@@ -925,7 +925,7 @@ static void iolatency_ssd_stat(struct iolatency_grp *iolat, struct seq_file *s)
 
 	latency_stat_init(iolat, &stat);
 	preempt_disable();
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct latency_stat *s;
 		s = per_cpu_ptr(iolat->stats, cpu);
 		latency_stat_sum(iolat, &stat, s);
-- 
2.53.0



