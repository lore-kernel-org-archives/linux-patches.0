Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0610343B3C6;
	Tue, 21 Jul 2026 21:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669845; cv=none; b=WFyfNO7oZc83NNEnXTjkNMCOELMEex7r4BvlnZh0VbQQLhRoqp9pwPUF1Lb0pSvgDP3GMrdkht7aD9oZafX1ec9Ma3eC3PdFp7yocWXsXd1cZMCZ9fB4nst48tGfbuXK7YkTOLGalE29Uo1PqDxIxpHa93HbGOBNC6Lu4PDamOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669845; c=relaxed/simple;
	bh=MuS5pnWDSsL8vX91bjWlkX87WyR7pxdKLgDFoGi+074=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxCMCysJhm8FF+E57MISsFhj5nNxlab8QzCpEpZtf/h5ketClvn6h6EwCXtZ9R/QrFh28ADpuu5MeTUMn+JORRopq7F4oz9mMFWFa144pMlTGnIQCPSDG7MBeEwL0AvZZ8NpEucLlUjdiYco5U6GOfRFr8pRKZPQy6yH8JRZGxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3TOdXZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3TOdXZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C43B1F00A3A;
	Tue, 21 Jul 2026 21:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669843;
	bh=IUqhNajWnyq8dXpzHnl7LQxvp7Lee71z0437MzT0fPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3TOdXZj3HkexfjtbnQOBWUEZ/9KZTNk2evO3SN1jOk+/Exd9RNN2HBIORRTdYT9K
	 IVRIs+wmCNe1+h4l6upcVEgo7/SMHaKPvsh55mgqnkzE69YtvwRGCbKceAXjuf3Bms
	 weZBrcLnKfttp/g7hz2y6W24GuKZ78OQF045nCCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Su Yue <glass.su@suse.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0709/1067] dm era: fix NULL pointer dereference in metadata_open()
Date: Tue, 21 Jul 2026 17:21:50 +0200
Message-ID: <20260721152440.453164715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cao Guanghui <caoguanghui@kylinos.cn>

[ Upstream commit 9ae672606c17891d90b282e3490b817620549599 ]

metadata_open() returns NULL when kzalloc_obj() fails, but the
caller era_ctr() only checks IS_ERR(md).  Since IS_ERR(NULL)
returns false, the NULL pointer is treated as a valid result
and later assigned to era->md, leading to a NULL pointer
dereference when the metadata is accessed.

Fix this by returning ERR_PTR(-ENOMEM) on allocation failure,
consistent with dm-cache-metadata.c, dm-thin-metadata.c, and
dm-clone-metadata.c which all use ERR_PTR(-ENOMEM) for the
same pattern.

Fixes: eec40579d848 ("dm: add era target")
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
Reviewed-by: Su Yue <glass.su@suse.com>
Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-era-target.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index a96290103cca89..8e4e3b46dae00a 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -795,8 +795,10 @@ static struct era_metadata *metadata_open(struct block_device *bdev,
 	int r;
 	struct era_metadata *md = kzalloc(sizeof(*md), GFP_KERNEL);
 
-	if (!md)
-		return NULL;
+	if (!md) {
+		DMERR("could not allocate metadata struct");
+		return ERR_PTR(-ENOMEM);
+	}
 
 	md->bdev = bdev;
 	md->block_size = block_size;
-- 
2.53.0



