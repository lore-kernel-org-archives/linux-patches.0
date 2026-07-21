Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0652146F48B;
	Tue, 21 Jul 2026 19:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662831; cv=none; b=IirToGEsF0yljj+VtM5k4GIDY2LyLXsUu7MsGMQSMoexYgW8nJb+0VObnyyOrvwFIuqsiV2c3No4NAYJ9CdNLm43NySS9EwCR2xkuf65eV2OznK5RE/R+oy6S+qdBkXLmfjAyHpb3iRUkRur7dsNJpYAXSJUBeNcuAPdvUB9afk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662831; c=relaxed/simple;
	bh=PRFqiYqfGmreaNbTvFL4fDLUM+ZDK/dx0Rd0vELnZcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToyiMo43FQnOjWIwlfW2CUdI4hEsE64lBOLrUiTI/vWHoGEr3dIREHQhBbDOA/BqMCwRwsoK/sD470XSet+WgzQiTDl/vTnBq36nItnCkEhACWBg67Sn3HQU8mAbmGGBH3Q49qyDFkWURiUkP1s7FPufNGRE6v2PdO4+oE47KXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxQM84kC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxQM84kC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6EC1F00A3A;
	Tue, 21 Jul 2026 19:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662829;
	bh=FsxPalyFf+I4P7jhe5zzSNZA2hL3KtVD6i5w+X2rj1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GxQM84kCQDt8teciRMHpCHFhkWtVFhxJ6rKp+K6hHV7y2aIPELO22t6LizlF5++1O
	 QEYbfpGR72KMsBvOe5mQ/JbKQATp21vH58buISk1oF7QYRssdvTwRW3/QZ4D/RrVAy
	 Yc5Xt2ObtdcVpvg0BODpGev+Snk42huf12Uw0I/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0591/1276] md/raid1: free r1_bio when REQ_NOWAIT is set and read would block on retry
Date: Tue, 21 Jul 2026 17:17:14 +0200
Message-ID: <20260721152459.339634759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index eb583df45ecbc8..4b18151cd81365 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1335,6 +1335,12 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
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



