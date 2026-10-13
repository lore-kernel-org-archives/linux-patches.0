Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337C14F393E;
	Tue, 13 Oct 2026 12:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893697; cv=none; b=ciiD+wYgiXPiq7Lh6I7WkiKWd/3lXPT7+yGNQeBgjNG/nV6/dUdmAZCwry9Iip1k6LGUMuw5eRTuKm4/EdGs+BMoaS9Ml9A5vaR5jiBonlkhrwXgbsPXNMBd7ZG6oojlkmjOsxVN2inZXlhdSsfOcD0ypjFyy0ybB/+2rQUfIxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893697; c=relaxed/simple;
	bh=N0JFy1MTyA5UXDA8pms+NpLsK2zJbUKVbGJb5jp0sCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czCqn9Q29McCPk59ht2q+LqLNLR/ZeJaJdHk6ZFH3GNnssF8gui9wdb67vQmaml6Ld7bgepJ+Se1GtlYpD1Zn0x4oYpNPJ8DtHb+aCLeXTJRVgR9xyp1AoRN4St7xfiKtfWn40y+Crr0HpioZn+j87RZRxKwC+QiYKlWWrLMIMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnSZiR85; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnSZiR85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852F41F000FF;
	Tue, 13 Oct 2026 12:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893696;
	bh=T2V7NO0Zn+KRnadmfvvgAFOM5a8ZOHdTo+sHWGZDJyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnSZiR85P53P43b06C6rykGqLRhW5YCoW52iGjor/E8Gv9qNi6OAHJ9g/DR5tueCx
	 ETTnH6dnNTWUyhFyRqB+iueCDuy1bB24dZjMzro9+CivqNkGFql3DcCAHCNd5nsXeI
	 1hRj+tdnPvcwlBGtIAFoxxE0vqKWbGxavM8aQb9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 313/621] md: replace wait loop with wait_event() in md_handle_request()
Date: Tue, 13 Oct 2026 13:35:08 +0200
Message-ID: <20261013112928.281681133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index d03d0fdf763db..8e96a0ff2b267 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -397,20 +397,12 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
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



