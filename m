Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103333B774D;
	Tue, 21 Jul 2026 20:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666703; cv=none; b=dx9pR6ZyL8Hyw3C7U0tC1q7qELvgDupnBE6iE4pTbjGYOvYVpIB3KXsDe2Nnb6tm72qLbsZyWf6uCoi7vhou0GKzfdFyCFGSQ0s0K8Oqd1/nTUQ+8eniCWr/pm5MjwBttLwuYu2PKkIHKT0c8YxyVX1WqSTXkWOUPRJPNEYW7Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666703; c=relaxed/simple;
	bh=ngQdpQfks6c7KOvSFCSm9qxxoQ57M43Q8Ov8d54n7Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Etn3rXXuj+uCspUA8t7uIetXpdIoD0uvBPpUTvbU9cJCdDerUwMesQEk+QQPIzEnTnEdfluHSpr2u9X5rq/KXgDo/toXtq0wn70p0mNUNOAPUrITwGWhy8QEd4HD47kyTfo5tPubH/SkW25kMpnH6am0N5rNrdYKQNnlj2iRfAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3c79DUo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3c79DUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C01B1F000E9;
	Tue, 21 Jul 2026 20:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666702;
	bh=nC84FbfXhhzMNj1+xGf7WghI5AiVOeMbQTjLB+mi8hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r3c79DUo7Fmyrj6K0ZrC6aTli9elmrTp14tVBlabqQlPloUgYUmIHO8rC3QsAB0BL
	 gDocJQIMaz244g81RRA1WC28e58M7Pg0cAuzqrfa3OOadkHOO/bpIDwjCfW2MUdvg7
	 vj41t/Vat8p6F03Vv7dZd65mGIzeBSHGX07z/lNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0740/1266] md/raid1: free r1_bio when REQ_NOWAIT is set and read would block on retry
Date: Tue, 21 Jul 2026 17:19:37 +0200
Message-ID: <20260721152458.432178778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit 69ad6ce47f9bf2b9fe0ed69b042db993d33bbf12 ]

When a read is retried, raid1_read_request() may be called with a
pre-allocated r1_bio. If wait_read_barrier() fails for a REQ_NOWAIT
read, the bio is completed and the function returns immediately. In this
case the existing r1_bio is leaked.

This fixes a leak of pre-allocated r1_bio structures for retried reads.

Fixes: 5aa705039c4f ("md: raid1 add nowait support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260611083514.754922-1-abd.masalkhi@gmail.com?part=1
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260611101350.759154-1-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 259cc8a97348bf..836123f2929a58 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1245,6 +1245,12 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
 				bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
+
+		if (r1bio_existed) {
+			set_bit(R1BIO_Returned, &r1_bio->state);
+			raid_end_bio_io(r1_bio);
+		}
+
 		return;
 	}
 
-- 
2.53.0



