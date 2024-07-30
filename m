Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B461A2C20;
	Tue, 30 Jul 2024 15:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355047; cv=none; b=L4ASj8yqlh5amFn2ClV2D4RjlJ77gdzI9nXMYMJ48+tZQRbUNYhQDl7DoClCPXhyrm7Evf/MrWjBngel/2KV+t1QUq66Uf3q6EfefW9RgCleDENmJyV3vrGgSIBWrUChdYNi1EqNvlE8eCjdTYPRTmJtqKN4J7cA2J1uSKQAB/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355047; c=relaxed/simple;
	bh=EY3WhqzbUrJAzaCs2T9+kSr/XvRhRJ75w/zTCwUjtTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLYxyWw1KX6heAxzgw3jLvorH5kYn/GsPU2eZ2DI3BQCoyWid9NbiayC7pzbHpjcFbnMoj9PF40F2nBx0gATuY+0Ox49Ek9v5WMa06JElO5OjW1GPfiXuWOLHujXETVpvLNCMr6uwRO4fAfO963afxhj8azuxdRu2AZ0yeRGSY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAB2k5lT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAB2k5lT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D6CC32782;
	Tue, 30 Jul 2024 15:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355047;
	bh=EY3WhqzbUrJAzaCs2T9+kSr/XvRhRJ75w/zTCwUjtTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAB2k5lTXocG3wJVMM4qoyHWEJRzt0Z6XA2W2mW3/UznJf4LdmkqZh+OiK7qs0sG7
	 o5A3V9bFe/wPcucgWk7g/cPI0VbpkyFVko4oiI1TCSgbd9ZDQSzRASrIQXCOlA2OZA
	 BjcufGtqQ5Qx7RgVRLAF4SlFJ8b1vY7l/TBcnqrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/568] nvmet-auth: fix nvmet_auth hash error handling
Date: Tue, 30 Jul 2024 17:42:10 +0200
Message-ID: <20240730151640.738653954@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



