Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C1437AA7E;
	Mon,  9 Feb 2026 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647398; cv=none; b=Vu55scAWhTdJ3QztgIWx4QnrWlKB8HsvikdhC3s1PLajQXVd8NaMyZAFSuYRrF/xNDOx8cDzwNhWP4AffrDNzIS/P4H+6UjPnMolBKqbgAi/Yk2WpBli7ii0EeBRomEFwSC14CVKzf5mhqC6wl08jzFi8VQ/6OOA/ynQQsOlpZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647398; c=relaxed/simple;
	bh=mpXruYHluAmCpZdps/0S872dFp+1R+4ckRvuAGWNu00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+9G6K0wDyrWHhZmqOQIazpKu9oBSwy44W12j4qbNxI9PFXIkRM+h3ovApMki5ZS67wFr+yE5NRy5hVdGHSGYzsGOIm/X2TlTrQEHgSpkk9jK7qWh5uuKAi7h0JAks/9kKtcUuCMfUB9Tj6NHwUJ5LyhECOwlpG1Tbm1KS66dy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jv+6nCQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jv+6nCQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8336C116C6;
	Mon,  9 Feb 2026 14:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647398;
	bh=mpXruYHluAmCpZdps/0S872dFp+1R+4ckRvuAGWNu00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jv+6nCQy3zxfX2mDPIfbEg35/ewDXgIsVH8Fso0yUmKbepeFdxybUifYufzhrNguE
	 JZtkF0Jx2XaiXcuH4qmZwTLZvkUdsPPErRfkcvK6cT1El/6CrhOX3uKBdhqsUCy8Jz
	 oi6cW/WXwwyXojyQ04T1pcfzHjOqCc+7I/YUKEcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	shechenglong <shechenglong@xfusion.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 054/175] block,bfq: fix aux stat accumulation destination
Date: Mon,  9 Feb 2026 15:22:07 +0100
Message-ID: <20260209142322.412751369@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9fb9f35331502..6a75fe1c7a5c0 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -380,7 +380,7 @@ static void bfqg_stats_add_aux(struct bfqg_stats *to, struct bfqg_stats *from)
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



