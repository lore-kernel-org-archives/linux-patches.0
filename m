Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7BF2D739C;
	Sat, 12 Sep 2026 14:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224649; cv=none; b=ajOJTm7SHh4Wlqxoi1rkpbQnTQpEAB1QVKO4eR1UNsswMzpkAPg9FtzM6pySGneBfbbgrOFtOZxRYGmoB2KRJ1jIHzgpN6/Oqj7ucRNofhWgHw/N3Okl2IW7/OBrR9hmmfhK4MwGUxMMRx7BDGZ4grPbr7t9mhWmTpUKHe9RKS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224649; c=relaxed/simple;
	bh=B2XMVK7QJUDqhsZvTJMtBf7Z576Ir4gw/0Nd1Hak73U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7TybAy5Y2fSx4D4ZVoIAdhGrgQ2t5+J41OMU12w97LH895FcNMS1Z3jPdpiH3na+nwTNtymv2p66nBUM4cN3hK9pjtm7G9szpqFVtuPqbT4hI5+0qR+NR4ALt16ZTRKrHHpLcF/UEpFK4dzw/m19j4JV1VHtwPuKXI5ZipsiZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSIN5Dlg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSIN5Dlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA351F000FF;
	Sat, 12 Sep 2026 14:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224647;
	bh=FiKxCyP2mbVRw6MWIacOkBDKVJlfxdnL9lRUKRj3aC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSIN5Dlg1xjTGYnZEnMTtUpUopw3W1dyr/uj3RwFr3WVJIAUtIPuY4UWGp8DyHoxN
	 u1yMM7WMz7axsNs1O3xySC54Twn3Gx0V2Y4ydzxKZtf/kL7usGHTuE7kJ2AW40dHvA
	 VCmocJxZZxFI+zmBpW/y4Sdm9986mNQqNzROvx/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1035/1424] block/blk-iocost: collect per-cpu latency stats over possible CPUs
Date: Sat, 12 Sep 2026 08:57:47 +0200
Message-ID: <20260912065630.489801195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 4e050c5b92c1600415b2cd452583e543036f3d73 ]

ioc_lat_stat() walks ioc->pcpu_stat with for_each_online_cpu() to
compute missed-ppm and rq_wait deltas.  An offlined CPU is skipped, so
its delta is dropped from the period and its last_* watermark is not
advanced; on re-online the next collection sees a delta spanning the
whole offline interval, corrupting the latency/vrate picture.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260720093726.28965-4-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 129732a8d0dd9..7291f59986b80 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1603,7 +1603,7 @@ static void ioc_lat_stat(struct ioc *ioc, u32 *missed_ppm_ar, u32 *rq_wait_pct_p
 	u64 rq_wait_ns = 0;
 	int cpu, rw;
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct ioc_pcpu_stat *stat = per_cpu_ptr(ioc->pcpu_stat, cpu);
 		u64 this_rq_wait_ns;
 
-- 
2.53.0



