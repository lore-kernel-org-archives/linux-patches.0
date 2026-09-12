Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB2B37C906;
	Sat, 12 Sep 2026 12:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217136; cv=none; b=B1p3so4MSTxFrLa7jOfakZMA0UKKRyy2Gh7/9bbNwV9L/543LyrvEpGV5GdOENIVyvObeUX32DjrTh4zEVi7sxFB266hkkzP415BQlPTLFen4E3+57Pg4KZmAMO3QPvdlGh3YUAT8N3PnC3iGsNskugsdbXhe5KZrbz9NA3zVIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217136; c=relaxed/simple;
	bh=fKExAb/PC6LYad1vW+HLS1aXFnp13TUEedHktHu1dgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFFXG+xVyvWGE0Nl1/AmyJkog77pJ70rCg/X0yqICfCABHuHRXPCQEsVJ0xyP+EwMC9AkMQN7xHz61VnzO6Fq8a8w1OCcRkt09ErDkmhmIV2merXNgkPhpfXSeTyNxKKsfDrVm35A3FwW4RsjhoxiaB4fEoTLCu4Skr7Iw0mCkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnJeJvJT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnJeJvJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5D61F000FF;
	Sat, 12 Sep 2026 12:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217135;
	bh=fFUH8mTS1dDjWzenJsNpKiwkVnP3y0eUESoyZxQD69w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnJeJvJTLQQfhTrPGK+e1buqnEazKuMd73LJNq9oebFV10PdQ7z6+80SMq5gaO9xe
	 ksfNNt4wdYys9Vq9QOr0e0US9H1i1ajepjmIOE7zk3oqRmkN2vfyqEgVLOTfhopOZe
	 mWjePNSTGTQUGQgg+L0FF2bzBB9c/P/WOryRckrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0877/1376] block/blk-iocost: collect per-cpu latency stats over possible CPUs
Date: Sat, 12 Sep 2026 08:55:03 +0200
Message-ID: <20260912065627.106184296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a5894ec9696e7..61a347f504d73 100644
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



