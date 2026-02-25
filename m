Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15A6280331;
	Wed, 25 Feb 2026 01:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983769; cv=none; b=EEZ0sKxfGJBbsgp729rvOUcC2910F0/XycsjUn3Gy6iSV2NHdF0o5CV3EE7fzvUa5Qa5uhICsSeLSatRMwNXWtRt7RY51mf1JIh9mhZQEBbPpt6bM+MC/llUyrVRiFkHwhCw0QgJSbL7qIkNhKnuCNTWf6Hqi3ENkqBNh+v/lVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983769; c=relaxed/simple;
	bh=WLTePBfmfaF57PSlY74imcSkk9IS4WQG2c2vzZEnuWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFheupvjM7EsaO1jq8C5Mx3PK8wGSpDiPZ/QMqlbw+jOJST5Tm00TNVNye4kuo5VL1s8+PkkWG14aD3LBn7AaLVDdo1+tTQsJe6JvCDbvjlyOLoIkXtYfRy7gxw1LN83XuFnX7dFq+BhcOOTHJz77I9A+PGGO6I3JXgU8nnTRgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DChlZnzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DChlZnzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7236EC2BC87;
	Wed, 25 Feb 2026 01:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983769;
	bh=WLTePBfmfaF57PSlY74imcSkk9IS4WQG2c2vzZEnuWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DChlZnzS9YcdNN/StqBRxYRAExaUgQlXoBDfZCyJQ86Wt5lfNSCaXcz//2geKpQc4
	 2FxZJTnwV0vJyFZ8wSpCGhuAscKMbLwcU+02YaGegrWLo9epC/dNwJOfhUxeMceU1z
	 PMybr7dQ3hD70T700aGST2aplKrTCISoYVzDjlqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/641] md/raid5: fix raid5_run() to return error when log_init() fails
Date: Tue, 24 Feb 2026 17:16:09 -0800
Message-ID: <20260225012350.072261139@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 41de29206402a..1041788a54c20 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8056,7 +8056,8 @@ static int raid5_run(struct mddev *mddev)
 			goto abort;
 	}
 
-	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
+	ret = log_init(conf, journal_dev, raid5_has_ppl(conf));
+	if (ret)
 		goto abort;
 
 	return 0;
-- 
2.51.0



