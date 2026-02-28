Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B9337702C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301639; cv=none; b=sy5VVE4HhB6/RjvRFvZgpBV7xRcRy2TiCXJdEeqhq//2n872yWAmhiGHWs5yDXI1DUsQuHuV2uyR+yTMK6qFNXRaoQLMzUrHV76CDkyClo5B+wVPWk48KJ22RVMxJMf8GEFHOl3Wy5IYsTtQ53aJlwbyRdRr68f4hXlApXEw0S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301639; c=relaxed/simple;
	bh=IrbKkHbNtqVJHrMW9k3sWL5TlkGEm0pfXEipIj1+QgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZ6M8xNvcV0XeGcy67vRfzryQLp2avcwLiyT09MfrIGJeKIC+s67JmIRYQVB8lTOJ/1z4+/AUG+A8SzwwQdkE9F6RcI2RZQ1fJllk/fVTjhRrE/muHwtpBcS9lgZcWVSS0CfziuenRkteU0K+X4rvtemJvKfTgl+DXdGxjnqmGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fTph2Og2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTph2Og2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE22C19425;
	Sat, 28 Feb 2026 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301639;
	bh=IrbKkHbNtqVJHrMW9k3sWL5TlkGEm0pfXEipIj1+QgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTph2Og2bU9h0PuRJERX6ukHrZgQgkjjE3d6DxA+MG5aix2sIh9e8gRTLqIIV1rIn
	 is6Ds9WdksGMMaHCB3/KoqlDtrdmUfdvFqHsLSNFK+ZZhehJy8c3kLasplMTKyv88i
	 FhlHZhO4VNE3c+LEJ73LnsQkgL9YpSgM1JsFCoZ2Dsz/F3hVycO/+bydQbUACBcCf2
	 RUizmF89cXKLNlke3VJBdGtNqEs2jzh72koL3m7nkeM4uTgAFnScN+BQr/DTHQP5zn
	 WGsdA2jbkq4KnD/opxL07ByMRcp9auOzSNTrHsQQ93RiRrzrRZYcfSce8zk8t5evni
	 hWv7u8n+RR/iA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yu Kuai <yukuai@fnnas.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/385] md/raid5: fix raid5_run() to return error when log_init() fails
Date: Sat, 28 Feb 2026 12:54:15 -0500
Message-ID: <20260228180011.1568201-33-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit 2d9f7150ac197ce79c9c917a004d4cf0b26ad7e0 ]

Since commit f63f17350e53 ("md/raid5: use the atomic queue limit
update APIs"), the abort path in raid5_run() returns 'ret' instead of
-EIO. However, if log_init() fails, 'ret' is still 0 from the previous
successful call, causing raid5_run() to return success despite the
failure.

Fix this by capturing the return value from log_init().

Link: https://lore.kernel.org/linux-raid/20260114171241.3043364-2-yukuai@fnnas.com
Fixes: f63f17350e53 ("md/raid5: use the atomic queue limit update APIs")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202601130531.LGfcZsa4-lkp@intel.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7262b77a8e022..5079943046743 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8049,7 +8049,8 @@ static int raid5_run(struct mddev *mddev)
 			goto abort;
 	}
 
-	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
+	ret = log_init(conf, journal_dev, raid5_has_ppl(conf));
+	if (ret)
 		goto abort;
 
 	return 0;
-- 
2.51.0

