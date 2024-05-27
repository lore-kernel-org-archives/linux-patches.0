Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E608262BE;
	Mon, 27 May 2024 19:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838188; cv=none; b=CmK7pdV8CLB16wMCInU/hVXewRewL2oiezzzmJMdhPWUScJRb4HVeLA58y9VFgAXGR7XVY/QXtiwBYwsp0OAOwF0ozynPtS6XeNAbND9NaVQF5jCS+1Cf8tIgB7GMb6sy/RoAXkBtsPcFIVYh0Fx0Uqqkls4Sa5HXI0F7fi5NoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838188; c=relaxed/simple;
	bh=bn30opF9nBuBn/9PadUsxX+2H1NYDoVriHpDOwhDIFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJlpbYX9+QfPk7LHm7YKpJ+Q9mXOZIj/2HWdyaX9O/Ua3daEiO6mqAOyGnvF7Oehk5kq2J/nQEo365IIc/Ujo5KnoE9wRUgf+uEfWDEG03T/jd6cuYP8daNF+Q+yJ1H15NNyTjhBLZVdk3YaJVc5umiLfbbQcnXtHlP/qm49DAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jyq1Um4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jyq1Um4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24716C2BBFC;
	Mon, 27 May 2024 19:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838188;
	bh=bn30opF9nBuBn/9PadUsxX+2H1NYDoVriHpDOwhDIFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jyq1Um4YbaynlXkJ29xf3sXfIb8FqrvqPFGqELwMNmpE5b4bJGmTXlZcF90u8bkyT
	 AZp66vQl8mMqLBKYk4S03+mChTerng9OyGRl8lTGBDU9K5Es//5XK08dA4W/Va6Ldk
	 w3OzgHe9gdsx0qKj8cGa4rkQSO5MYCPbsnydA4fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 299/493] dm-delay: fix max_delay calculations
Date: Mon, 27 May 2024 20:55:01 +0200
Message-ID: <20240527185640.084628843@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 64eb88d6caee2c8eb806a68dab3f184f14f818a4 ]

delay_ctr() pointlessly compared max_delay in cases where multiple delay
classes were initialized identically. Also, when write delays were
configured different than read delays, delay_ctr() never compared their
value against max_delay. Fix these issues.

Fixes: 70bbeb29fab0 ("dm delay: for short delays, use kthread instead of timers and wq")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-delay.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 4ba12d5369949..2ac43d1f1b92c 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -242,19 +242,18 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ret = delay_class_ctr(ti, &dc->flush, argv);
 		if (ret)
 			goto bad;
-		max_delay = max(max_delay, dc->write.delay);
-		max_delay = max(max_delay, dc->flush.delay);
 		goto out;
 	}
 
 	ret = delay_class_ctr(ti, &dc->write, argv + 3);
 	if (ret)
 		goto bad;
+	max_delay = max(max_delay, dc->write.delay);
+
 	if (argc == 6) {
 		ret = delay_class_ctr(ti, &dc->flush, argv + 3);
 		if (ret)
 			goto bad;
-		max_delay = max(max_delay, dc->flush.delay);
 		goto out;
 	}
 
-- 
2.43.0



