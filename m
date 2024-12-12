Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8CD239BA7;
	Thu, 12 Dec 2024 16:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022006; cv=none; b=TF7JrwxkujHJdyfD1lP2A+krcUv/ntgtmB+qm0QFwRjrquz0V/gnDKRJcOdIVHzJelStYlGSetxg4zk0tcVFuOrNRwfX+bGH6MYzZ/PcD/enxVK1siI93FRI/REveWRaLjbV/GkkIUhvTsh6uh14coYqtDIq5VFk/NJF4jZSnys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022006; c=relaxed/simple;
	bh=68oPjxCJeVEUvQfPC2Z7fl2nxjG+6hP8H/+KxG3vQXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3TWS4lvlx9L1kYnzntqBLk73gxq9uJwbWi1ggdhP6qHeOKNfAQs+9DqtuBImm0tjBZCXSVbZdg3e1our9ndp8+UMb1NZizTiXx9krLq2d5+a9ZPTurmuBKzBbSSK4uZBiVVUBAnwSnOjPfDcsZ9anDfQd7EV8Bm5Wx2KVWQMQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVDgVrZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVDgVrZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF7CC4CECE;
	Thu, 12 Dec 2024 16:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022006;
	bh=68oPjxCJeVEUvQfPC2Z7fl2nxjG+6hP8H/+KxG3vQXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVDgVrZlf8K+qpEMUdtVqng5kpM3I2s5OrAzCq92t54MWpV30wI+8R46ngKEp8O45
	 ZHDp/aDVgYA7cRGijxzzo3HRIfw/KdP96ZJud9+upBAp+onQHHGwbIIUuxXqhObNLy
	 GTWq7ZT+ADBexxJZdLRO4E2XJNENnN3gVgTB694s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/565] crypto: caam - Fix the pointer passed to caam_qi_shutdown()
Date: Thu, 12 Dec 2024 15:54:46 +0100
Message-ID: <20241212144315.083597148@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ad980b04f51f7fb503530bd1cb328ba5e75a250e ]

The type of the last parameter given to devm_add_action_or_reset() is
"struct caam_drv_private *", but in caam_qi_shutdown(), it is casted to
"struct device *".

Pass the correct parameter to devm_add_action_or_reset() so that the
resources are released as expected.

Fixes: f414de2e2fff ("crypto: caam - use devres to de-initialize QI")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/qi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 8163f5df8ebf7..2c52bf7d31ea5 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -765,7 +765,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
 
 	caam_debugfs_qi_init(ctrlpriv);
 
-	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, ctrlpriv);
+	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, qidev);
 	if (err)
 		return err;
 
-- 
2.43.0



