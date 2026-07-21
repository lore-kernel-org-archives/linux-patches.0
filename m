Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C10407CDA;
	Tue, 21 Jul 2026 22:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672233; cv=none; b=JWqo4mmtB3mo2190J2515rQpC4LiaSYhg21OhZlYul+6UmIWTP1DtBk+7tZ5DL44dIJsJEc4Va9eQVXgMT5fAZn5KDgyj100f9S027nN3vGpubf+az4Z0mBF0AAgBm1AdhXhQ50dfrqglySniu8yNNkrxuRkosbc3L7RMGvnqJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672233; c=relaxed/simple;
	bh=M8a0UEKV1Lk2AT2UYF29MSEEW+NK0b90oiDJpH5rV7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UalMB/1F0HnH89AJIKGZd7hJ4BtcaAD3+lor5qtGVVZjeHEnj0CYT8GX7KakS3/bnb7+5Y2FN7EwVSRCOULgUSHur2ckKjJUy8oVRsH2HIW0n0NSsxMEZQwcvPjAz7yA1YarKhGZyDnpd9MZmTbhkHpeE3n9d+cx1rcP31qVKgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEOX6JwJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEOX6JwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3171F000E9;
	Tue, 21 Jul 2026 22:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672232;
	bh=6MCgRE8E3WdAvk2GkEH8XIDdTiLF04BF8kVquQnqApM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CEOX6JwJ7Xt8QjE+uQ0R1BjGP8diL/JdixNN1qyY+VgH1xwmAANde9jJlc3R+aIto
	 ph2JQVZQFpldQbcbHJ+oWBR7KD34hz9YFvkvVSh6TV98mkqmV09aWSiCOys07XXbib
	 mx1tyWO5w5iWZrHUaJgTYiiLkiUq7U+hm4NJjAA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Su Yue <glass.su@suse.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 548/843] dm era: fix NULL pointer dereference in metadata_open()
Date: Tue, 21 Jul 2026 17:23:03 +0200
Message-ID: <20260721152418.372558830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a56df453660594..4f7edfe009e0f1 100644
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



