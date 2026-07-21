Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF5C3B9927;
	Tue, 21 Jul 2026 20:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666966; cv=none; b=qb0AnXR93LMUo7XBN+z9eDBEE1h1ZP8IibE0BEIJhvX6jBkF2EK43csA+pRDGdJZlKGIMMVNGfxe98tUUg1mQtltANzp3kGR5bXzplZfPrJTxCxL/GDp2xnMcjNUAbldrs96LfJsgihzZvOmeJkmG1iqqAncElWa0VIuzR200Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666966; c=relaxed/simple;
	bh=S2wkP5yjN1Sg7t2REilsAcfJ7gy1EIRd1QvXEEbQS8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ud9Puuzkie/5pSu1aHVaxcZ9QpWujWtWCLcc7LGVkDT3n7Uf+VgMulP5SBcJ6S4Kaehc4JrUBlbUVyOL+aATDKnn+EHI/TCPsk5hhyr6lFvcrzGFbJWQ42hHs6GaO13NXLmuA8KZkMrjmz5ZldQJa6FUr0iwKobFw5RKnF/abdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdxaWz92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdxaWz92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197A81F000E9;
	Tue, 21 Jul 2026 20:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666964;
	bh=tjjEnxgsBdt6oct4wehXWdUfozlMb+61Qa9BWaI9srI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PdxaWz92f1owr+xdL5cESko0JcYW6CeXwEM6qarDgA6s84IufGD9l6nHsCuXNbv4A
	 UKrfCQ2uWCy5dv65EA4UxZPzFW6j0W5R5fadHgYhYZFyUDrHAWBjycBXJRPExeySG4
	 4fh1qYK3jCP+bSD70XrpdkVV++8gMV/StovtG+5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Su Yue <glass.su@suse.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0883/1266] dm era: fix NULL pointer dereference in metadata_open()
Date: Tue, 21 Jul 2026 17:22:00 +0200
Message-ID: <20260721152501.607320009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6acfa5bf97a400..807d22c58189d9 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -810,8 +810,10 @@ static struct era_metadata *metadata_open(struct block_device *bdev,
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



