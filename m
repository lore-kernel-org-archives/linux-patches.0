Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C029C26ACA;
	Mon, 27 May 2024 19:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836905; cv=none; b=JzmuE01z4ZXdK27GgS34S7DJiuQpbfy+F+ZUzEP4zq2sfrHuOzo3HsInJ32cQRbQoPsr2Yp1X1YRcuPtKnlDddZH/EolrMaRCt5NIIC8P//G8pY6ND2bHPu6VHoXhGlRBZyCpX5LIB+RaRnqsXbne0cIl+8o4g6UHp/CaEZ1AG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836905; c=relaxed/simple;
	bh=1oV1zNH+avPdYCwiU0t/L2ebPiZ9sYDy+W6i4oWsnpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZw4Enn5ZVlgRD0Eo3QxWhAG/MZIZcRGGgt2zi/GZEHmhSR+PDReTewdG+n+HC4wp6LRfwjxV9g/3V4SbNEixv6pPYWesTCrLrwWSxRnpelwsp3Vpc0dHfCnFI8s/GrqEdVUH9PkJM32qxCmk9JR3uSUytjXvYHcMLODtDIGJbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZkKxDeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZkKxDeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57864C2BBFC;
	Mon, 27 May 2024 19:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836905;
	bh=1oV1zNH+avPdYCwiU0t/L2ebPiZ9sYDy+W6i4oWsnpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZkKxDegwCns46/kdGUpQ3zBcIEr4YXtlT2OwGHL8J1ssau2tjWeP1wNHZ4dJaQ+E
	 OrpHhRqf+AOXt8hunMHVQkSw3eKm2UvqYaoP2Pf/69mJiYH8zWGeW67hf18qEYev6f
	 BvNLW0g2bxn+3xU2QOoyn90qQrNC3f6CuEKiaQk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 235/427] dm-delay: fix max_delay calculations
Date: Mon, 27 May 2024 20:54:42 +0200
Message-ID: <20240527185624.433384055@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



