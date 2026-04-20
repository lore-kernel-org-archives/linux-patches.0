Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C708A2DE6E3;
	Mon, 20 Apr 2026 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700941; cv=none; b=lMxWkraVnV6xtdEXkqvVsBn92Qe6mI+AFEBr9Fc3vnwYybzAQ227ddZ2gjU2fMpt2k7Fy92KQJ+JrMEQ/3fsHua8rvIELEQ9andW5UC3H0sYOaWqxIoZRvSxOPLHaWlz7OIFjZquVOQTaSWBnXg1lHgzJw+3Et12tcy7tdYn3go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700941; c=relaxed/simple;
	bh=owNnJ00flc9aQS9bgHynrgFhnh3Aede45vOHer+q+bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHWvgeeCqOnfWsbbOMRnE0LJ9NTAC8a28YmEvDIFWGQQIPU47Iqm2N5PmSfHIbr280UUsvXBovK6Zc5QOaCUD7Ku0RACkigsAvYOwHn4MidmXs/STTJlGtUXHc34f7aETUu6edAKwwmTMLITbI4KksUUltvZUJizK4FDz10Ffo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2BI+jS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2BI+jS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A0DC19425;
	Mon, 20 Apr 2026 16:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700941;
	bh=owNnJ00flc9aQS9bgHynrgFhnh3Aede45vOHer+q+bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2BI+jS9vTojCQTIqOGpKeDTq/xgUBuU9o0HlFAHH5wsVDOvs1+IzXs7Vqm596pDp
	 uaRvEploEPbmWEUZiG+pOdFH7mshlObb83auM/bR/tsSQX9ACUHna5L/0gJk9nkxzN
	 JWmrac1z0AgWbFkAGwMRs5gEcyv7tiBwDwfF1Er4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com,
	Daniel Pouzzner <douzzer@mega.nu>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/198] crypto: algif_aead - Fix minimum RX size check for decryption
Date: Mon, 20 Apr 2026 17:41:39 +0200
Message-ID: <20260420153939.927133221@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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
index dda15bb05e892..f8bd45f7dc839 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -144,7 +144,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (usedpages < outlen) {
 		size_t less = outlen - usedpages;
 
-		if (used < less) {
+		if (used < less + (ctx->enc ? 0 : as)) {
 			err = -EINVAL;
 			goto free;
 		}
-- 
2.53.0



