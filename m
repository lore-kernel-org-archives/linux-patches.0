Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3017C33B945;
	Mon, 20 Apr 2026 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701450; cv=none; b=gJHiz75EIehJ8l7iMRNtWDQMJzAStBBNisVZuPa5cT4l4sVk8afoL/Ef61k8I5qYGJuKBNEU5a1YN3NR8HE3F3JMSbCFl7YmFxOwYc5dNpeLfTdRjp1XyoeHf1Eo4SS2qSnOgYTEBy86TOBq/SC6iifBN6gv+4OdL2gWpbroaTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701450; c=relaxed/simple;
	bh=8NVmexDXbALKT7yGDh3n1Dc8dmzuznUrnRkZySrI99s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gS7NpAj0k2dVJdIJimKcX6/oJXc3METNy3PKBdC3NHHjra3gSYp6C0WUOncytgsj2NksV1Y7Lqc/vcXc/XH+sumSojdeb1J2g3MxiaHdlXl6/fj+gGKRdjSBBYdCNH8D1Pt+5pamO7tPk/jY3rVIuFJm2yJPri+XYEb58dtWku0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kl2cr3hR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kl2cr3hR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A44C19425;
	Mon, 20 Apr 2026 16:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701450;
	bh=8NVmexDXbALKT7yGDh3n1Dc8dmzuznUrnRkZySrI99s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kl2cr3hRcIpUqZqI01VbWC95itsqrn+9pNQyD2gPNUoZP9rJtZ50FVfXQcXip+PrC
	 H+XWgoC2MGXwUcfRjf6+rlwfIrmgLuKmBgBvbh0j/FDOMIPcWNysvlynsZZoE/xrx8
	 kV+C2iY0qM0dvdOYSWQGO6hBo3eiz+hfcp3kKP7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com,
	Daniel Pouzzner <douzzer@mega.nu>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/162] crypto: algif_aead - Fix minimum RX size check for decryption
Date: Mon, 20 Apr 2026 17:41:57 +0200
Message-ID: <20260420153930.113240857@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 3d14bd48e3a77091cbce637a12c2ae31b4a1687c ]

The check for the minimum receive buffer size did not take the
tag size into account during decryption.  Fix this by adding the
required extra length.

Reported-by: syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com
Reported-by: Daniel Pouzzner <douzzer@mega.nu>
Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algif_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 7d58cbbce4af2..481e66f8708bb 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -170,7 +170,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (usedpages < outlen) {
 		size_t less = outlen - usedpages;
 
-		if (used < less) {
+		if (used < less + (ctx->enc ? 0 : as)) {
 			err = -EINVAL;
 			goto free;
 		}
-- 
2.53.0



