Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B161D47B5;
	Tue, 30 Jul 2024 16:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355264; cv=none; b=fM/xCdG+BhRfp94HSV3zg+6wiGfIRNQAY3PGmbGFvZdhLl9zT/fp8E5NBAXv7iweXkRwP5ZZ68WC+zOU9boxPg6G/kdGx9yHSrZCPGNDBKQJAODpaN3GutNA7740JQS9J1joAnV32Eh2P8go4JmHQJtXoZRtea0MW79EKN59KTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355264; c=relaxed/simple;
	bh=85oQ8eM+XxZcofLKmTPKx0YizaxquY4fjkaCl8vfu/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnjqkOLE30LEETRI7KOy08CHkv99EaZmzTTfCP4Iv/uWxKtnLv6ziTabvaMOMPeeqi/OmDTwXIGCSYBSMgk1IEsD58ic8VOvrOo8RDyDUMQCS9ErxdZgGAWymqfdEAiaskZHAaYMk28mYvAN55XARSrRHZtYuZrZLK1sZBmR+Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz2XLS7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz2XLS7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01350C32782;
	Tue, 30 Jul 2024 16:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355264;
	bh=85oQ8eM+XxZcofLKmTPKx0YizaxquY4fjkaCl8vfu/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vz2XLS7tOXVce1X3mKW+cC8RhA9nE/72O487FgqxmfN9ampEGe6HRxN6fa7fXKQac
	 zSakO2wsAqc7jWv4FnrMH4q+SzPexN8/jrEOfKgt5sLOu2E1KZJQ6oZGgFC8mKWDIq
	 e3j6VUkOHdHUr3VRaX/dqk9tISaqQultBL+CxGLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 035/809] nvmet-auth: fix nvmet_auth hash error handling
Date: Tue, 30 Jul 2024 17:38:31 +0200
Message-ID: <20240730151726.039906476@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7d2633940f9b8..8bc3f431c77f6 100644
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
 	nvme_auth_free_key(transformed_key);
 out_free_tfm:
@@ -427,14 +428,14 @@ int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
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
 
@@ -471,9 +472,10 @@ int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
 		goto out;
 	ret = crypto_shash_final(shash, response);
 out:
+	kfree(shash);
+out_free_challenge:
 	if (challenge != req->sq->dhchap_c2)
 		kfree(challenge);
-	kfree(shash);
 out_free_response:
 	nvme_auth_free_key(transformed_key);
 out_free_tfm:
-- 
2.43.0



