Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7691437DEBE;
	Sat, 17 Oct 2026 16:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254649; cv=none; b=h/cAI+o7S5b/CQe+hmZP1huX6o148f1jt05ZeDqlgWnfRtMdLD1ngvNedcmJ8i4E66MHaB2Wryy5LdHLGt9luw2F8j8/dCDC0EljRr3fSV9BBCRDdFpeoof5WGyL5+S1piX/EMBn9Eqv/pMTPxp7me5v6R9xGvTj26w19LZz+5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254649; c=relaxed/simple;
	bh=gQELq+37oZQ8DMoVQ57k8ooROQ4ZIo0Pp8/5TJnmLDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSP5Z5rsJMC5xMwCnCUAbZ/DZIq0yg2won87rt2i/LAj6IfwheNszTfMb0F41jCP5Y73f4jFBCaDoyuX7mSNY0P9DMmR71qOdu8Es8zOd2ujEeoYpqEkMIXiPvfYgmG2W9N+YDx86LiTm+zL4Kr/rx+8hHfXHG9T99ppkaR2Cro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzVpqlYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzVpqlYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3AF1F000C4;
	Sat, 17 Oct 2026 16:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254648;
	bh=JgB94934PedEqyuJEkCjD3T9496JYnSNOwcNwkvI2eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xzVpqlYDHHF3O8JB8JhT0/df9uqBlKOyhct68WiWyXLiyQ1JZh1L0JQVWbLr0LCM1
	 PEHDQjKHZJonIzMTdzgVKRd4kUSQv+K1FYOcLsuk5RgKkzC2xArkOviZjcjayisYJB
	 Tb9CtMpIZYIfvgoRVL4SGBl4D36V1UhprCfbQ5Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 473/869] md: replace wait loop with wait_event() in md_handle_request()
Date: Sat, 17 Oct 2026 17:55:14 +0200
Message-ID: <20261017160049.252330555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit 8e8278ac702e2d5d44211b4b10599aa3b2cb0555 ]

The wait loop is equivalent to wait_event() and can be simplified by
usaing it for improving readability.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://lore.kernel.org/r/20260415140319.376578-2-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Stable-dep-of: ba976e350111 ("md/raid1,raid10: fix bio accounting for split md cloned bios")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 55632055196f0..424ee03f47429 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -381,20 +381,12 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 {
 check_suspended:
 	if (is_suspended(mddev, bio)) {
-		DEFINE_WAIT(__wait);
 		/* Bail out if REQ_NOWAIT is set for the bio */
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
 			return true;
 		}
-		for (;;) {
-			prepare_to_wait(&mddev->sb_wait, &__wait,
-					TASK_UNINTERRUPTIBLE);
-			if (!is_suspended(mddev, bio))
-				break;
-			schedule();
-		}
-		finish_wait(&mddev->sb_wait, &__wait);
+		wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
 	}
 	if (!percpu_ref_tryget_live(&mddev->active_io))
 		goto check_suspended;
-- 
2.53.0



