Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3989539A7FD;
	Tue, 21 Jul 2026 19:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660881; cv=none; b=cqO6h+8IL5adBIFaBQz4lzcLztfLtI5dQZFFfj/6kywM8ij8i+nzsHP+uaUu0XVxRAex/Kwz0Czcip2fEipM5rkvlcJba3Lu02TtWoKTU/YOGOypewwd44heygzjPq7c1v26B/I/2/B8kGQJG4IDNVt9TyJxgImG4z4v2G5O6yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660881; c=relaxed/simple;
	bh=STzDG2SCZG/D/m0PdbFRr4j+n6TmNIrSbj4Sj9KKRh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=begHhHVNez2erst8gBH1YV+zV7Gw66yec8aZZbRS/t6cVed53OmuNQsGRxuT5LT6AwC4YgXJ7WZILiZWAz9jshwK2iACC3caNlhQCMQxa7Rysr0eJQiLUXCigST9iyazE0Lo2XDVLc4uEfctjHW2cd6wcgmOyWzjqtLPUQmgIr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wI0snYkt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wI0snYkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED1C1F000E9;
	Tue, 21 Jul 2026 19:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660880;
	bh=M5Bw38Fb8JwJ5dmHTF0K4JBn6EJupcKVW+c7s9/1HiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wI0snYktKez7EDh02+utXAcc4aJkSnllAogFK0vUxt1GnoUqTZZ7npM5zNhYd6WvG
	 YMMuT7a0He8EKNJo2M2DSkmF1zWB3XbUZXZu0L5uviDrL00OvAMiSivCQJi7ZHvKBT
	 tCdZA/LHnURZEnoURqQR/lfbQKlDtJUvv7rZipyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1145/2077] md/raid1: free r1_bio when REQ_NOWAIT is set and read would block on retry
Date: Tue, 21 Jul 2026 17:13:38 +0200
Message-ID: <20260721152619.827520373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9a3df3cb7bdfe8..1f67e4efa09afb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1363,6 +1363,12 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	 */
 	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector, nowait)) {
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



