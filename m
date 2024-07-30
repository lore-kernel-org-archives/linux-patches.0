Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E30A1BA86C;
	Tue, 30 Jul 2024 15:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355011; cv=none; b=Z/twl3+h7NrpZl2m6vjtSqb+IVH4LQDEIIekoUyS9QmiUcBuQatEm4uuI+2vKJeZ+V0Tkm+NG+dIaMcCjHabotD/AiBVwn+easFTbDjapLRc1iIKbMXHNqs1R36fzfWO9xn/zdaN5QLeGm+qfBpxc630UwfU8Cvq5l8oJYSnv60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355011; c=relaxed/simple;
	bh=25jUiS6Jo76fEuupoPz7IMdIhBK2i17S7evuMdYTi1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gc0AJ7M7x7KJGsGyKPDHZnKyCej6XhsuZOZ8SJeR9kvKnPOzUU/EBmyuydwy+CB07II4zJ+l+na+R+4J9hPaPh9ZF4HojBemUkk7VIHLsjTP0sN/awGS09BHE7k0nyGRiBgRHRxgeZXdlJb0DBCgHbNnY5MJcqNhPpBB4nD9bKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrY3gISS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrY3gISS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18BDC4AF0C;
	Tue, 30 Jul 2024 15:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355011;
	bh=25jUiS6Jo76fEuupoPz7IMdIhBK2i17S7evuMdYTi1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrY3gISSRm4kwwhh4nhaFFgkiQ0664dystqRZJcG3LVKpwIF5RI+7s4yqbhrOI9mJ
	 4e+t5wOdjfwjrhGelj8JWG5xMn7KluzgU9nLOPMdvR3s0YIuWhdMgrcbglz75cXuNo
	 /5CJqE8Mbf5INS+tYf+nFonRKAOB/EuyqMVPNtGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/440] nvmet-auth: fix nvmet_auth hash error handling
Date: Tue, 30 Jul 2024 17:44:16 +0200
Message-ID: <20240730151616.670578016@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 89f58f96d1e2357601c092d85b40a2109cf25ef3 ]

If we fail to call nvme_auth_augmented_challenge, or fail to kmalloc
for shash, we should free the memory allocation for challenge, so add
err path out_free_challenge to fix the memory leak.

Fixes: 7a277c37d352 ("nvmet-auth: Diffie-Hellman key exchange support")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index e900525b78665..aacc05ec00c2b 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -314,7 +314,7 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 						    req->sq->dhchap_c1,
 						    challenge, shash_len);
 		if (ret)
-			goto out_free_response;
+			goto out_free_challenge;
 	}
 
 	pr_debug("ctrl %d qid %d host response seq %u transaction %d\n",
@@ -325,7 +325,7 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 			GFP_KERNEL);
 	if (!shash) {
 		ret = -ENOMEM;
-		goto out_free_response;
+		goto out_free_challenge;
 	}
 	shash->tfm = shash_tfm;
 	ret = crypto_shash_init(shash);
@@ -361,9 +361,10 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 		goto out;
 	ret = crypto_shash_final(shash, response);
 out:
+	kfree(shash);
+out_free_challenge:
 	if (challenge != req->sq->dhchap_c1)
 		kfree(challenge);
-	kfree(shash);
 out_free_response:
 	kfree_sensitive(host_response);
 out_free_tfm:
@@ -426,14 +427,14 @@ int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
 						    req->sq->dhchap_c2,
 						    challenge, shash_len);
 		if (ret)
-			goto out_free_response;
+			goto out_free_challenge;
 	}
 
 	shash = kzalloc(sizeof(*shash) + crypto_shash_descsize(shash_tfm),
 			GFP_KERNEL);
 	if (!shash) {
 		ret = -ENOMEM;
-		goto out_free_response;
+		goto out_free_challenge;
 	}
 	shash->tfm = shash_tfm;
 
@@ -470,9 +471,10 @@ int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
 		goto out;
 	ret = crypto_shash_final(shash, response);
 out:
+	kfree(shash);
+out_free_challenge:
 	if (challenge != req->sq->dhchap_c2)
 		kfree(challenge);
-	kfree(shash);
 out_free_response:
 	kfree_sensitive(ctrl_response);
 out_free_tfm:
-- 
2.43.0



