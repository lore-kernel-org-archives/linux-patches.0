Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969B6168C4;
	Mon, 27 May 2024 19:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837681; cv=none; b=Gbr1gQe+MqZxjwI5epcAwz/BU7+e5pSOP4Z0xzVXE3uHCz8Quj/JKM1544eN5m8RZfDXClT6OehgzNGFy0JbQXnrYDkC6YREgabV9FiQWYGF0nbF3qlY31F4i9ob6jB4G9NvESNMA+/wkt/tKu7778NJQwDuTrJiUIaVT+XaCpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837681; c=relaxed/simple;
	bh=YOInyP9XLduKf9jEnPonIYyRQ+oEfg2Nlqv/ryZRZiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwgY6IO1LDrUClGHTNEpYGKe7X2VQ5xDZD0ve8Bk8UYPsEIwcDTUSlMa8UBReyoU9LzIjR64NXHDIp3dVVjP7ULKRpOwFNcpvDGchptBRQfrVrcjW5qGkyDjgNkyLUMUIIV7b6y1l/zIly4qTlCFlcwXI24PyTGuuBIPSx0D6Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+zvHBta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+zvHBta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAFFC2BBFC;
	Mon, 27 May 2024 19:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837681;
	bh=YOInyP9XLduKf9jEnPonIYyRQ+oEfg2Nlqv/ryZRZiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+zvHBta8+Q+FcG2ANhmjZte/+3DQOHenJVEnIWq7WnaaOmwFONm+Km9o4RLTWhP3
	 TlaS7PovwbBfesJy3tubelITXvtNfatjfj3utoht2b4NvASbewWE3JwRxP6wd9M22v
	 OYyks0IFUfsnm6H1+IFmvsWGBkhjHLsZ1XDtwItU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 103/493] nvmet-auth: replace pr_debug() with pr_err() to report an error.
Date: Mon, 27 May 2024 20:51:45 +0200
Message-ID: <20240527185633.880316361@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 445f9119e70368ccc964575c2a6d3176966a9d65 ]

In nvmet_auth_host_hash(), if a mismatch is detected in the hash length
the kernel should print an error.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index 9e51c064b0728..fb518b00f71f6 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -285,9 +285,9 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 	}
 
 	if (shash_len != crypto_shash_digestsize(shash_tfm)) {
-		pr_debug("%s: hash len mismatch (len %d digest %d)\n",
-			 __func__, shash_len,
-			 crypto_shash_digestsize(shash_tfm));
+		pr_err("%s: hash len mismatch (len %d digest %d)\n",
+			__func__, shash_len,
+			crypto_shash_digestsize(shash_tfm));
 		ret = -EINVAL;
 		goto out_free_tfm;
 	}
-- 
2.43.0



