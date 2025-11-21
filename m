Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC1B34FF50;
	Fri, 21 Nov 2025 13:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732745; cv=none; b=bDVchc/pZ2OM0JvOJI4AyuV8FTcQtq7+G8gjQMi5Bbo6zJDpEM3jqih6IHy40GyU2tvLvv3TxgWfox2CXQNx77JinY03MDMSeQ+xHtrMQ4NAja7y8MsVpbhI0Ww2vJOYOy70cKhU6tzAnQxa13PKWRDwLIVmXYSWfj4qm9O7mJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732745; c=relaxed/simple;
	bh=dhPQwAVhXdrdxXQe6nHD5t130i7XPfLhi5QDNjqBr/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp7zRRCrnB6FOZD2pLt5uDYdlCxKvTlFSkkfYVtChfdv8VQ428OKmYbOYoCmNLfNyYSHYTph4Jqb1agXlPFT4yCuich85xORdKG9mmwuYuc75UgKL+AvLPbSykQf1Qjb21wUkPYMWH7n5H0LgaQHBGHjqGG/mbQS7DDXIb7EJRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwOW8S7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwOW8S7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D698DC4CEF1;
	Fri, 21 Nov 2025 13:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732745;
	bh=dhPQwAVhXdrdxXQe6nHD5t130i7XPfLhi5QDNjqBr/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwOW8S7ZFVmH+iK0zC/g2R8VOEadcoLe7tgaaKz8vMWGKny1pVzr8TfuJ6MyGLj9/
	 aPp2+V8q/t+frq4jSuepwJoM83wtakcnzy6FKvh1aEn5ILAlhymSu3367ifGJkCY+o
	 3cHgnZWu+gybbjEFCQz2EOHT0aPTkbeB3qhp+Da4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/529] crypto: caam - double the entropy delay interval for retry
Date: Fri, 21 Nov 2025 14:08:47 +0100
Message-ID: <20251121130239.131734860@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Gaurav Jain <gaurav.jain@nxp.com>

[ Upstream commit 9048beca9c5614d486e2b492c0a7867164bf56a8 ]

during entropy evaluation, if the generated samples fail
any statistical test, then, all of the bits will be discarded,
and a second set of samples will be generated and tested.

the entropy delay interval should be doubled before performing the
retry.

also, ctrlpriv->rng4_sh_init and inst_handles both reads RNG DRNG
status register, but only inst_handles is updated before every retry.
so only check inst_handles and removing ctrlpriv->rng4_sh_init

Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index bdf367f3f6798..eb880f0435ee9 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -692,12 +692,12 @@ static int caam_ctrl_rng_init(struct device *dev)
 			 */
 			if (needs_entropy_delay_adjustment())
 				ent_delay = 12000;
-			if (!(ctrlpriv->rng4_sh_init || inst_handles)) {
+			if (!inst_handles) {
 				dev_info(dev,
 					 "Entropy delay = %u\n",
 					 ent_delay);
 				kick_trng(dev, ent_delay);
-				ent_delay += 400;
+				ent_delay = ent_delay * 2;
 			}
 			/*
 			 * if instantiate_rng(...) fails, the loop will rerun
-- 
2.51.0



