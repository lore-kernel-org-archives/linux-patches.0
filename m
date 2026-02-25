Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CD3265CBE;
	Wed, 25 Feb 2026 01:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983822; cv=none; b=KVr01OUXrdI2xol+3Emz3E+40JcPZwK26tBjvW6+P1UtkxRvZJ8KJBb5+ligkcecIrbHMdakL+t8iSXByy4YWTQh5de4vKpEpdKSpuPX0YozEh2x7F8MZFSg4BsK+Nf3lgTpyOHWLdXqoqGChsXxHLMgCj8bUTFM/YWXEx68LJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983822; c=relaxed/simple;
	bh=Emi3e+tIDuebKsnlDDEmZd0c6LpiFfJFouEPTl+MycI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBzq7sM8UC57OwXLA5Ik7ibXet7O9ZJ8kLINnktMygbTln+xDUwHsdyipIgKl324fP3cepJlP9q62ZJ0GZ1tP5v9p8WhZD/SEeEGuC5Wo5cwKGI0fuGN0HBFh+xLJcwKX5CC5LXIxNm3DMe3bsUJ8qQq7+d7IX5AlkwgZOAN54I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJgTZM/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJgTZM/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26CAC116D0;
	Wed, 25 Feb 2026 01:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983822;
	bh=Emi3e+tIDuebKsnlDDEmZd0c6LpiFfJFouEPTl+MycI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJgTZM/u43hGRyPNwJ/1g0CGDswJM44o5i4Qb4R3zVPzFbXAAw7BOykESACD95Yw5
	 pRl+zkDgE7l4Nfms2tQIOtz4GsS8FN++3vuvpH2BGrEAOuzlb86iNR/95fiB/kAM7+
	 SO5mAjiQyfg0AkRsH1CBUIsDDP4D3mGpDzl9h+Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 088/641] crypto: inside-secure/eip93 - fix kernel panic in driver detach
Date: Tue, 24 Feb 2026 17:16:54 -0800
Message-ID: <20260225012351.228994279@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit b6e32ba6d32503440a3e3e16c8d0521cbb7e0c5d ]

During driver detach, the same hash algorithm is unregistered multiple
times due to a wrong iterator.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/eip93/eip93-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index 0b38a567da0e0..3cdc3308dcac8 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -90,7 +90,7 @@ static void eip93_unregister_algs(unsigned int i)
 			crypto_unregister_aead(&eip93_algs[j]->alg.aead);
 			break;
 		case EIP93_ALG_TYPE_HASH:
-			crypto_unregister_ahash(&eip93_algs[i]->alg.ahash);
+			crypto_unregister_ahash(&eip93_algs[j]->alg.ahash);
 			break;
 		}
 	}
-- 
2.51.0



