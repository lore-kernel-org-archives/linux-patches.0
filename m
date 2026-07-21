Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B49647127E;
	Tue, 21 Jul 2026 18:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657761; cv=none; b=EQwzjXigYP17HVGoxknp8brWy3cXQT6/MUv9KCt1vOQiVn7uvjdAwOKkWy+W/hQ5ZVm+Lp8wzBPsHTMzxWlJq3OR/kLu27Kcr0p5LF3fBUFc+C2VNEItsWXUura6g+q4qw1CjtNSve6ygcWOew9IrCFuTUGJq3ZrAjcyZVTvHjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657761; c=relaxed/simple;
	bh=UwG644ELWXt6CNfVKVykSuAZM9z2kj/Pyn0BE0svO9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nd0ADercydoUbV6sdI1CYiv+mH92YjyM6/rB6GttXFsc6fdsJ/B8Qt2FLIDewZo+glKcpUFZ2T4Llzaw5GYEuxjs4q5VAofy8C1/k9wTNg6W8YxH74C52SRIc4OgNjoPEyFy0DtU67vc++7XAekJlOC4MLmZNF/kgUIiMqlgAcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIdNOGFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIdNOGFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEB91F00A3E;
	Tue, 21 Jul 2026 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657759;
	bh=DtbuP2xuY5YJp60a6uODOXNtrp4YqaFzou4Att2N5uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qIdNOGFQ8QTFwEf8k9vFTVFjTVmvktfM3wIyPvA2VJSCdb1MrxZP0x3wDZgRaA5GH
	 airPMeRgc8wj8jsJ5gD2sja+GH9z1hrIur3RCdMJ+EVYhybqzSHFvuGQc56Tey6YVX
	 6w665mJkR1xxDyE+8uANHG4N5AXdce6LpotH+19M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0835/1611] md/raid1: free r1_bio when REQ_NOWAIT is set and read would block on retry
Date: Tue, 21 Jul 2026 17:15:51 +0200
Message-ID: <20260721152534.170293428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index cc057ef1829ac1..16625b79788bdd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1334,6 +1334,12 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
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



