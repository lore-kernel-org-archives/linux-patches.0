Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2739E370D5C;
	Tue, 21 Jul 2026 22:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674130; cv=none; b=AB5SQNngN4EWjbE/8ckTo7fbCDMY/bU0RlEKE+1hXU8zKPBrFKEQ8Jck5s10O8n9MebgMeKuxLQC4GxcBBonFGqkStYuBrvLSMVcul7VCwYutA2DPCwOtfxyxiD4uy/tCd1EwgOPZ2HOKIIkrEULXzRYFbDMyCxMiyaw2qHtkMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674130; c=relaxed/simple;
	bh=GxjrTmQrhTn6/ds0tfVaXqWUTaVdJru5S7DRLSqa2u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnikhHEaB/8SoMVghdiXIY2hLW1DolBayhLBBdQLqzdUdhjGhcOYft5UV57ZjGV5iposmrQ1tngDV7P2BP7YRaYUm6Ez8qmlcGkw/JuoOFdfm1n99vqLw2jvCA+EpGWGN3FcFLkujvfF6oYgdIxYfFZPdol56Udbpp0+2ZJ83tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDTnGXj7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDTnGXj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076651F000E9;
	Tue, 21 Jul 2026 22:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674128;
	bh=gqOFj2IKPzRnhyN5qzYkC9GRnTrPVRw1akZmNdNhlXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDTnGXj7vPrFdGmCpsyKyDRIoYW4CST/Bmi1FjNjXiMYwbxZjwM8yVrJhFEHKk/pY
	 uEv251r+z+7q+C85uB6/Y9RSamSV6uBXZ1qr3Sm6My40WXy/QLs+gT35CHQVjyvqAD
	 zHEoLpMTIxXxH4LlFlCWbrvPdOaIXKIM5xiXsyWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Su Yue <glass.su@suse.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 424/699] dm era: fix NULL pointer dereference in metadata_open()
Date: Tue, 21 Jul 2026 17:23:03 +0200
Message-ID: <20260721152405.256462350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 96bad057bea2fc..28350c2337fad3 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -791,8 +791,10 @@ static struct era_metadata *metadata_open(struct block_device *bdev,
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



