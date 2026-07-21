Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157BC46DFF5;
	Tue, 21 Jul 2026 18:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659018; cv=none; b=cM6bts0w/C3X2+pmhRsWNZDhHmSSy3rLfF3stdnR31cZk5fHtMXd3ICqs7UYLJC0TwGwA6/Aa9wsvX3ohR5bFoh9rgRLocEk1c4SO9PUMKwNZTgeuvxDuXm0K8Q7AEANsDeMjY3A8HMwGu8RgrX1u/18zwtK5cEM37yHudcjjKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659018; c=relaxed/simple;
	bh=pt/zL6da4uLeJof38EYKDeDNuvWVO2z5Wc7xTl1lZ+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWx2CrtZ2DGvn1sKo18W/yGT4nUbS4xXyhv03ZkF53ckXta0Il1SQAZFDg3zDcZkiEr6GFixYwylqPuYY1M1F9ftJVOub5vBKNc0H1h1QJN6CP7zOpd8dpD6Xv9dWBBCOQSkrCqp+TKz9fj992oWOX3qa+Hcgnm81xPgmLbXPZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkhGOLcU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkhGOLcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9B61F000E9;
	Tue, 21 Jul 2026 18:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659016;
	bh=6KbQfBOjCv5YpFmNqtJLy4KVUUlhErS9DUhKbA5lnLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VkhGOLcUqjfeISx68nKCviKskQpFe7kiJ/nin2rqFHxCqu6SJOZSTGEpeyYM2xYx+
	 whZgl/vPfJhUSlSKwTiKCCSm10eEk6+DPQwU0rGERMdlGyqSZF+5NlcYL/7jYASsuJ
	 pw1I23Imv529nJNqrhI0iAcv7rOzPIF00EBy7HGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1345/1611] dm thin metadata: fix superblock refcount leak on snapshot shadow failure
Date: Tue, 21 Jul 2026 17:24:21 +0200
Message-ID: <20260721152545.708482867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Genjian Zhang <zhanggenjian@kylinos.cn>

commit 4b22d0801fadfcae2e106e6ba32e49439c7c7ebf upstream.

__reserve_metadata_snap() increments THIN_SUPERBLOCK_LOCATION in the
metadata space map before shadowing it. When dm_tm_shadow_block()
fails, a reference is leaked in the metadata space map.

Fix by adding the missing dm_sm_dec_block().

Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: cc8394d86f04 ("dm thin: provide userspace access to pool metadata")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin-metadata.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1353,8 +1353,10 @@ static int __reserve_metadata_snap(struc
 	dm_sm_inc_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
 	r = dm_tm_shadow_block(pmd->tm, THIN_SUPERBLOCK_LOCATION,
 			       &sb_validator, &copy, &inc);
-	if (r)
+	if (r) {
+		dm_sm_dec_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
 		return r;
+	}
 
 	BUG_ON(!inc);
 


