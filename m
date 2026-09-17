Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA55D3921DC;
	Thu, 17 Sep 2026 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668622; cv=none; b=JPHT1jY2hbphi5SZnLwNirbtmEjM9CbGfm2Ev8CGjEL3zetseCOAp76pELhcwa5SiFtMasjTT7QLkuBp9ryglmystl0qfuh+MionohuR0I7TDFUEmA5oghdJGZyBWO9Q8xjU7DAM60UgjCkWj+ZakuTHb64MW0xZKgxIH4HAzA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668622; c=relaxed/simple;
	bh=TViuKzajK96cngWUltpmS43H+5Pqx9v3Z9snA2FMisQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/CTuvxiszfw8dsBTjdP2GX4DlJQlSvnB1zY2AYXDffnwFYVBEKNvMS+F/jnZHs+JGHbJo1OuwY5oFvEYW8hxS2j62kzbZz6bvU6sQ+Bt0sXnOl4psEbUDom8gYIZ4fD+hQKPOmwxPEAPuwrmj800fe1fYRWUzmXjdKEIHz00TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8DprssQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8DprssQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036561F000FF;
	Thu, 17 Sep 2026 18:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668621;
	bh=BfC0bkbr7YA79sw5l1mMk2M3bnJgxRkreCES2SMmipw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8DprssQvlbysqJuEJAyewMT3JjdzmbgU5S5/n/xYyTvJ52Dq4sBReAzcMdo6lRF1
	 Nmr5+INWPU2NjdGIITBcLXEjy46uZAfvW9Z9hWKMahrQ5+3iXpyMfiwhDPnyxdeoKN
	 5RRBlOXd9gRK43NLsZ4TXMjRGBYxvBx/OIOLCyCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0486/1102] md/raid10: fix writes_pending and barrier reference leaks on discard failures
Date: Thu, 17 Sep 2026 16:07:09 +0100
Message-ID: <20260917151551.903464916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 06189fa95490b..468c1dfa9d6fe 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1628,6 +1628,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 
 	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
+		md_write_end(mddev);
 		return 0;
 	}
 
@@ -1670,6 +1671,8 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		if (IS_ERR(split)) {
 			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
 			bio_endio(bio);
+			md_write_end(mddev);
+			allow_barrier(conf);
 			return 0;
 		}
 
@@ -1687,6 +1690,8 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		if (IS_ERR(split)) {
 			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
 			bio_endio(bio);
+			md_write_end(mddev);
+			allow_barrier(conf);
 			return 0;
 		}
 
-- 
2.53.0



