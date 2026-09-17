Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A31A519DFB;
	Thu, 17 Sep 2026 17:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664670; cv=none; b=GXUQGsd5H8AzsPfi66Cs8/bAJbndSkLBKIOWITwXa6i/LbgK6FJDRpyDIHWTmZl66Iv2vQvQzmB5WzayUvXnLEgylCP0YPgwWAiI+wAuGG++IwN4UyIKclb2J2K+f/b93OFy4kTV5fEUngGDo/F8yZr3d97++pXn23kbvwSEG8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664670; c=relaxed/simple;
	bh=FUxi+kYOUa/NXl5xvauhtjkO1P62ja1ZzJ2rqPFhgGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgozrOaPB7RhHrj1BYblPPNPMNa17l3pz3t96sYFmuoQSzEe2/KYAJZh3K8H/RIw5eNWk3Jfz654Zq5Je0SOpdGQubuIWUiSQXrRoUW0CnhZ3imYV6+Q+8Mie3CjELlrDI6J9HGIvoW9OXGFUEziwFQa2HFnMrbDsQfXs02wEKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caeExAN5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caeExAN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8EA1F000FF;
	Thu, 17 Sep 2026 17:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664669;
	bh=ELbUobDn5chCfxzHVwkWsQYDffwmO4HAEySvkQDbeTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=caeExAN5YJl1IY+UHwfupJ7iYMVmk5q2aycUgwnwzb6k1t8wG0O7ehSvpmx9l4J6M
	 a17nBFngUaY+VWiqoRVSZktT0oesBz20LTwlN3lkPwvC6ELNxp/5/AO0+dGHi0bbg1
	 nKag53rHK/GTOiE+Nb4VVvvLIhz4JJ3J8HiIikxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0449/1250] md/raid5: let stripe batch bm_seq comparison wrap-safe
Date: Thu, 17 Sep 2026 16:04:04 +0100
Message-ID: <20260917151604.167442987@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 00e93faf4cea9e8802ac5dfee0952d84fc95c40f ]

Once the 32-bit seq wraps, a newer bm_seq can look smaller
than old, so .. covert to wrap-safe calculate way.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Link: https://patch.msgid.link/20260618025735.915113-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bf30ad2a9e177..03d11f4420b09 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -996,7 +996,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf,
 	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
 		int seq = sh->bm_seq;
 		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
-		    sh->batch_head->bm_seq > seq)
+		    sh->batch_head->bm_seq - seq > 0)
 			seq = sh->batch_head->bm_seq;
 		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
 		sh->batch_head->bm_seq = seq;
-- 
2.53.0



