Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625464;
	b=5XTdVWXEouLxFvp7RyuPTGFNeRJ6Mht9Xm9GZmpyCkraxX9/Z8/Po/WVfNmD6SkzYLT+
	 ckpTJOYh8F2fIlUN/oxacuQrpfQF1yBX3jh9+Ctt6HzWahYOsZmedPW55++vFqGT7XYbN
	 47UF5qOUi4N02N1DFZP9jOPDyMFKx1PgXvwzb20QK3wNiI/SfZQ51f2Z0aHnhoeNaA9sD
	 tbgjo/buLhbjxHleJ1grnVbnnMdgpCuKf/Hn2M/R5WNfRgtzNiLDM1in+8TO/b57+siZ5
	 tJJ3REBkQS9N058Oj/LKdq87xmeDNy6OXInmiQxWYCNGwIN+EZ6TVgQatoZRP4r/Ofg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YlXl8UzQ+eRL2OTMAfJYYLwezynukb1j31AKTXaHwHw=;
	b=m0uoE3I7w73Tn+g02wAgCk1kwADYINRjpAkCpZxdEmS2TBk9vJRlpxkHg/OzE5ENLYlJ
	 sJOFCfYX78TpJT/F5Ytixdr8K19Et0Hap+dHT0cEhexS51nWvFk4h/yn7Gbr2Hgwi77rS
	 vvIi7Qg0SgYyDR1I92552IlW32T+LmvAPXRNJx7743hdQZW8QpC+bJxLj6XkYJWyYD7J8
	 ggHj1rmNsYXqpR1IYp+NM+kXOpSGYr7chv9+G1n5h95gEfLwT7kG3gepgzJ/tNe8eE38F
	 HLrjN0dBS90yW46RKtqGfz9eKIK6toOzFP1Po0tf7Rm9kp3PnJJgPihJyCC+rRja9wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVE2Wg7y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB992606A31E;
	Wed, 25 Nov 2026 16:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVE2Wg7y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184461F000C4;
	Wed, 25 Nov 2026 16:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625464;
	bh=YlXl8UzQ+eRL2OTMAfJYYLwezynukb1j31AKTXaHwHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVE2Wg7yLghXoZ5kFhj/g9bc4Z+WDHeAFTKAAaITWLsT9Ghp8Zji6q5NR/OLHuJCi
	 TyMTvavHzau0lduzjVdUazFpsaFyTy5APKXhaTPRbuNFZU86ckhH+RlaLxetN1/vTQ
	 RruwCP0aJLKpiwkn5quf4gaAE57+ftkw3kkSTFOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 526/816] exfat: take bitmap_lock at the start of exfat_alloc_cluster()
Date: Wed, 25 Nov 2026 15:34:34 +0100
Message-ID: <20261125143901.363840627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit 48acff2eedef7fecdfbd39be1b6f4463a9e43e3e ]

exfat_alloc_cluster() checks sbi->used_clusters against the total
number of data clusters before acquiring sbi->bitmap_lock. A concurrent
allocation can update sbi->used_clusters after the check but before
the lock is acquired, making the check stale. This can allow the
allocation to proceed even though there are not enough free clusters,
causing it to fail partway through.

Acquire sbi->bitmap_lock before checking sbi->used_clusters so that
the free-space check and subsequent cluster allocation are serialized
with concurrent allocations.

Fixes: f55c096f62f1 ("exfat: do not zero the extended part")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/fatent.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index 5cde58a4a503c..d855d4b4c720f 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -326,19 +326,22 @@ int exfat_alloc_cluster(struct inode *inode, unsigned int num_alloc,
 	struct super_block *sb = inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
+	mutex_lock(&sbi->bitmap_lock);
+
 	total_cnt = EXFAT_DATA_CLUSTER_COUNT(sbi);
 
 	if (unlikely(total_cnt < sbi->used_clusters)) {
 		exfat_fs_error_ratelimit(sb,
 			"%s: invalid used clusters(t:%u,u:%u)\n",
 			__func__, total_cnt, sbi->used_clusters);
-		return -EIO;
+		ret = -EIO;
+		goto unlock;
 	}
 
-	if (num_alloc > total_cnt - sbi->used_clusters)
-		return -ENOSPC;
-
-	mutex_lock(&sbi->bitmap_lock);
+	if (num_alloc > total_cnt - sbi->used_clusters) {
+		ret = -ENOSPC;
+		goto unlock;
+	}
 
 	hint_clu = p_chain->dir;
 	/* find new cluster */
@@ -408,8 +411,8 @@ int exfat_alloc_cluster(struct inode *inode, unsigned int num_alloc,
 
 		if (p_chain->size == num_alloc) {
 			sbi->clu_srch_ptr = hint_clu;
-			mutex_unlock(&sbi->bitmap_lock);
-			return 0;
+			ret = 0;
+			goto unlock;
 		}
 
 		hint_clu = new_clu + 1;
-- 
2.53.0



