Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038669;
	b=X9kpnHpcgP8mG5i8X0W+b30EqlNG+xXXT9LpgWpoawmyVtZXnp72AZyLQk+N1dn/KWFM
	 bYAHMG+24XXJl9xt9JWV/jRSFjSVPtSFlirXSzAGafb+cTtn0s0/dO9QZUaKgGEuS+wg1
	 83vNwB5hkhd9xNMqRBQG+wEU6jWlwCh478vSWUMZ0rGt37ASMpYiHzzGYt6ewANBaxqLi
	 Qo69Oy+iZ15bV382Ldec7QIUeIU3np4xqRJPpDqbphnnbm01SaTfgMPB4kl2lxO03zPY3
	 SeBTwQIxvOWNBFh4plZ01Cz27yqFvbSFwBsPpVT8rH5FBqkxUNf8YhccGVRfBV80z3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xoDg/j4oXZkcfzzsW7h866DhTzv0DJ2iSfmwIe2dVBc=;
	b=aFmF+cHeW2LJwV973ynw2I7OHRqfu0dwiiCYFeh/GJTmnU40nb46H4t0jt6UmM7uX6at
	 Jj3TMLScCFp+Tz5rGiODKJ8a2w1Xx8PZMelX0KMPG6DE0lp7QvB1oCDGsj9X1glf7xwXa
	 X9vm+Cb3fJbrv9X927L8mNNztyAunhf905qiU8SMdpAyASawcgjnqI1AZAO31ms2QpkMJ
	 Mn9g7YkJ9WmP3/GuBvq4zLl/llmUGlnC7651XluoC9S6PC03e/+iiPtwu41c3jEnESMUx
	 aB9Vf7xXUzpc1MzeV9YJhbbCfxEWX2F8OJA0r1SGB8ckGy6NKIXsOtpMQGMC/YDoIMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1B0MqW0G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4801E606A31C;
	Wed, 18 Nov 2026 21:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1B0MqW0G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A261F000C4;
	Wed, 18 Nov 2026 21:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038668;
	bh=xoDg/j4oXZkcfzzsW7h866DhTzv0DJ2iSfmwIe2dVBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1B0MqW0GP49c0BXdIfb60BHohU9GIk9wriJMcWdnd7KFuFk+0zxWcXNj0yz3iz78m
	 jlT1fAu58R9HyRvxFu8Yq+yjQeRew5y+brRyGINVLFreeLWvfqZ/pjKLCnWMbaoKzt
	 8EKpmlJTxju2cMiP6Ht/B+kZmFEH5C0T55e9HgfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1823/3318] crypto: omap-sham - fix crypto engine cleanup
Date: Wed, 18 Nov 2026 15:40:45 +0100
Message-ID: <20261118150416.552838776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit be51ea091c6563158531e8c74e040552fdb1e28c ]

omap_sham_probe() allocates and starts a crypto engine, but the remove
path does not call the matching crypto_engine_exit(). The probe failure
path already performs this cleanup.

crypto_engine_alloc_init() creates a kthread worker for processing
requests. Without crypto_engine_exit() during driver removal, the
worker is left running after the device is removed.

Call crypto_engine_exit() after unregistering the algorithms and before
tearing down the remaining request handling resources. This stops the
engine and destroys its worker.

This issue was found by manual code inspection.

Fixes: 133c3d434d91 ("crypto: omap-sham - convert to use crypto engine")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ sashal: adjusted cleanup context to match the existing inline unregister loops and tasklet_kill() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index a6b4a0b3ace30..81f178ca426e6 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2216,6 +2216,7 @@ static int omap_sham_remove(struct platform_device *pdev)
 					&dd->pdata->algs_info[i].algs_list[j]);
 			dd->pdata->algs_info[i].registered--;
 		}
+	crypto_engine_exit(dd->engine);
 	tasklet_kill(&dd->done_task);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.53.0



