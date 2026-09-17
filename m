Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB1B3AB48F;
	Thu, 17 Sep 2026 17:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665081; cv=none; b=BrJypkKYxFsS0AHKfFHLCLTN5uPhD5nTeSMWogWI+4yK4WJAS4LjGFxhUBUeT1HG0acXDLtJyNMgIOmvUD0guqKYiJdpLkOzsQd2K2LPfF29A+M5wEnTQJGXqznuiSpCxJVMmgsRFjEyGVDusZS/U+Bds20TeIFpL3a4Tv8kH3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665081; c=relaxed/simple;
	bh=gDT90cTF8KFYNDc/9PJ89bp2O4H7nBJttWjqZMtJVZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gw65MKJuNpZ7eVlKSxbfeoS2hL1UJhCHPuQEYjl9Sm4Y/wWQ9+2ex1n1Ey0B+nC+8Et4/uJUjDRBlAKu/8HK3GiwPMrui4T3IgoGIik5fzXOxpwtcjkkchVbNgsVy31Vtt/1HSqaZq301FpnXGWVFw6AHkUOr+xYq7h5nI9rjIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rp2G4YMW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rp2G4YMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBCE1F00893;
	Thu, 17 Sep 2026 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665080;
	bh=jLOF2sWFMgTDuT+xZWKetMaG4RVTVg7B3kks8DoS1us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rp2G4YMWdrAjKYboLRY77qSjEsebkwhkHZzR1OZS9h8p/fp5HOGavlUJNGSpdBJTr
	 HbLrjtU+bsQDK4T3Vg9njD/KBaNj0bhUGgKaOjj0eErzpOuWf4rM8ZMsU7S8Fs7JQ7
	 OQyFLm5FGIXBes20VYKMMP507UhDZSH0AuzC0b5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0585/1250] md/raid10: fix writes_pending and barrier reference leaks on discard failures
Date: Thu, 17 Sep 2026 16:06:20 +0100
Message-ID: <20260917151607.742030128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit 393d687131d8aa8c7e4de2cb494438e145d20fc2 ]

raid10_make_request() acquires a writes_pending reference with
md_write_start() before calling raid10_handle_discard(). Several failure
paths in raid10_handle_discard() complete the bio and return without
releasing the corresponding reference, causing md_write_end() to be
skipped.

Call md_write_end() before returning from these failure paths to keep
writes_pending accounting balanced.

Additionally, discard split allocation failures can occur after
wait_barrier() succeeds. Those paths return without calling
allow_barrier(), leaking the associated barrier reference.

Release the barrier before returning from those paths.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Fixes: 4cf58d952909 ("md/raid10: Handle bio_split() errors")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260613182810.1317258-4-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c4c01619bf7e1..a60e4ba919a76 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1619,6 +1619,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 
 	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
+		md_write_end(mddev);
 		return 0;
 	}
 
@@ -1661,6 +1662,8 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		if (IS_ERR(split)) {
 			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
 			bio_endio(bio);
+			md_write_end(mddev);
+			allow_barrier(conf);
 			return 0;
 		}
 
@@ -1678,6 +1681,8 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		if (IS_ERR(split)) {
 			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
 			bio_endio(bio);
+			md_write_end(mddev);
+			allow_barrier(conf);
 			return 0;
 		}
 
-- 
2.53.0



