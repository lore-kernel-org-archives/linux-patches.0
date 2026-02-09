Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242B43446C7;
	Mon,  9 Feb 2026 14:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648941; cv=none; b=AoZt9wnRfvSVA7PjMn4cKY8r2MveJ/OsGIO5l1bFGvCDXBYJsSvXriyJargBWXYxs17AZw88dfAcWmOZPipMJWqtbl3q27QdQSP6oqFFDAekKYF+MmdwnxThzXUFz2lOHmTxDEuHES5QsyEPhMRMJ1ywA6mQJJLL3wjYp3Ilk+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648941; c=relaxed/simple;
	bh=/mFVqkGjseDAnDJGxs5kxyp14cERzyXISRQzQpJxqis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsRBCufPUtCfyAshfxK3+hPexwU+GFQ3ASM4rqLeyDwFHM2TBBsoaAWj9m46ueTKbHqsYBXF4BerHvG33ZlBde22dBTToZizIiGrvbCC7hhzD8wShfSe/wnqho+lbWxDSN2vqU6WlFHdoF5bKszu9eQDeelG3eVgqYYCXPUPQXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jf9inf3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jf9inf3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD2BC116C6;
	Mon,  9 Feb 2026 14:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648940;
	bh=/mFVqkGjseDAnDJGxs5kxyp14cERzyXISRQzQpJxqis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jf9inf3DYG09RfzLqysyyHI5acdjFWBNqIJlle8CtRMJmB/C4qcCDsoflx0F0qw6j
	 2uqsBaVlVbFgtbF10CxgcvzbhV3pVxNaWsQiAJlK0Y71c16MQbgmMzo7m7bp/7YsoL
	 6fh5VHn1c9s6BJyo2C7319JQ8BAnbdHlcuqHrUBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	shechenglong <shechenglong@xfusion.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/75] block,bfq: fix aux stat accumulation destination
Date: Mon,  9 Feb 2026 15:24:24 +0100
Message-ID: <20260209142302.825497850@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: shechenglong <shechenglong@xfusion.com>

[ Upstream commit 04bdb1a04d8a2a89df504c1e34250cd3c6e31a1c ]

Route bfqg_stats_add_aux() time accumulation into the destination
stats object instead of the source, aligning with other stat fields.

Reviewed-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: shechenglong <shechenglong@xfusion.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 53e275e377a73..2d804ab595dcb 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -387,7 +387,7 @@ static void bfqg_stats_add_aux(struct bfqg_stats *to, struct bfqg_stats *from)
 	blkg_rwstat_add_aux(&to->merged, &from->merged);
 	blkg_rwstat_add_aux(&to->service_time, &from->service_time);
 	blkg_rwstat_add_aux(&to->wait_time, &from->wait_time);
-	bfq_stat_add_aux(&from->time, &from->time);
+	bfq_stat_add_aux(&to->time, &from->time);
 	bfq_stat_add_aux(&to->avg_queue_size_sum, &from->avg_queue_size_sum);
 	bfq_stat_add_aux(&to->avg_queue_size_samples,
 			  &from->avg_queue_size_samples);
-- 
2.51.0



