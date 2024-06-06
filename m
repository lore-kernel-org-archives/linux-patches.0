Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A07919645B;
	Thu,  6 Jun 2024 14:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683026; cv=none; b=UuaYXTIHgNCQW02ndgn+aBR9ZXyJL+pO/iojgNL8LNfgsWWH/6iZ9b5zn38sl5T5N+0kIrXouAJcojnobrrdVfOvF80DvLCZSQJfJej54XU4iGow7qrOyYiWm95VXrQCtnhGPNVHby2KPSdE0MSIu71VIzKJYr0ObPOkq5K9row=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683026; c=relaxed/simple;
	bh=KOCdQPigM/b0LaTDKuxxtSXIMhzRZBlrBRQ7iB6Cy1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CN2CevQuM+qiUQ4PvEVBGITfhfssRMb+nRIav7UOYJs/2hhOIPNLWYFJRf4NCg7YJSNF7pJ4Vo3lvnukbkHSlQu4tWz7KuAm2HNVCI+ZoYuFOqU9o3K1KvfZQXuoVOv7A0q6DgtgKp+P5hsKZuF/qQ5kBgZhnzQqwLhBHoSwGJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8IxaZi1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8IxaZi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370A6C32781;
	Thu,  6 Jun 2024 14:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683026;
	bh=KOCdQPigM/b0LaTDKuxxtSXIMhzRZBlrBRQ7iB6Cy1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8IxaZi1DjxjKM3mYOvwsX9T9x4MZ11OqdsrnzSgPJuRYaYfQY6P/mRCYk1omPWCD
	 4bH7SdTaObeyag1AA2wxIbyCnF2gTtPNX+JNwP8/NGoI0wLdtfoZt/daq1CyqGe5V3
	 nesciCMz4mNijfXYRWJPFEEk2DtYUwVKUB2F5eZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 246/374] ipv6: sr: fix memleak in seg6_hmac_init_algo
Date: Thu,  6 Jun 2024 16:03:45 +0200
Message-ID: <20240606131700.063255893@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit efb9f4f19f8e37fde43dfecebc80292d179f56c6 ]

seg6_hmac_init_algo returns without cleaning up the previous allocations
if one fails, so it's going to leak all that memory and the crypto tfms.

Update seg6_hmac_exit to only free the memory when allocated, so we can
reuse the code directly.

Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Closes: https://lore.kernel.org/netdev/Zj3bh-gE7eT6V6aH@hog/
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/20240517005435.2600277-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_hmac.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 861e0366f549d..bbf5b84a70fca 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -356,6 +356,7 @@ static int seg6_hmac_init_algo(void)
 	struct crypto_shash *tfm;
 	struct shash_desc *shash;
 	int i, alg_count, cpu;
+	int ret = -ENOMEM;
 
 	alg_count = ARRAY_SIZE(hmac_algos);
 
@@ -366,12 +367,14 @@ static int seg6_hmac_init_algo(void)
 		algo = &hmac_algos[i];
 		algo->tfms = alloc_percpu(struct crypto_shash *);
 		if (!algo->tfms)
-			return -ENOMEM;
+			goto error_out;
 
 		for_each_possible_cpu(cpu) {
 			tfm = crypto_alloc_shash(algo->name, 0, 0);
-			if (IS_ERR(tfm))
-				return PTR_ERR(tfm);
+			if (IS_ERR(tfm)) {
+				ret = PTR_ERR(tfm);
+				goto error_out;
+			}
 			p_tfm = per_cpu_ptr(algo->tfms, cpu);
 			*p_tfm = tfm;
 		}
@@ -383,18 +386,22 @@ static int seg6_hmac_init_algo(void)
 
 		algo->shashs = alloc_percpu(struct shash_desc *);
 		if (!algo->shashs)
-			return -ENOMEM;
+			goto error_out;
 
 		for_each_possible_cpu(cpu) {
 			shash = kzalloc_node(shsize, GFP_KERNEL,
 					     cpu_to_node(cpu));
 			if (!shash)
-				return -ENOMEM;
+				goto error_out;
 			*per_cpu_ptr(algo->shashs, cpu) = shash;
 		}
 	}
 
 	return 0;
+
+error_out:
+	seg6_hmac_exit();
+	return ret;
 }
 
 int __init seg6_hmac_init(void)
@@ -412,22 +419,29 @@ int __net_init seg6_hmac_net_init(struct net *net)
 void seg6_hmac_exit(void)
 {
 	struct seg6_hmac_algo *algo = NULL;
+	struct crypto_shash *tfm;
+	struct shash_desc *shash;
 	int i, alg_count, cpu;
 
 	alg_count = ARRAY_SIZE(hmac_algos);
 	for (i = 0; i < alg_count; i++) {
 		algo = &hmac_algos[i];
-		for_each_possible_cpu(cpu) {
-			struct crypto_shash *tfm;
-			struct shash_desc *shash;
 
-			shash = *per_cpu_ptr(algo->shashs, cpu);
-			kfree(shash);
-			tfm = *per_cpu_ptr(algo->tfms, cpu);
-			crypto_free_shash(tfm);
+		if (algo->shashs) {
+			for_each_possible_cpu(cpu) {
+				shash = *per_cpu_ptr(algo->shashs, cpu);
+				kfree(shash);
+			}
+			free_percpu(algo->shashs);
+		}
+
+		if (algo->tfms) {
+			for_each_possible_cpu(cpu) {
+				tfm = *per_cpu_ptr(algo->tfms, cpu);
+				crypto_free_shash(tfm);
+			}
+			free_percpu(algo->tfms);
 		}
-		free_percpu(algo->tfms);
-		free_percpu(algo->shashs);
 	}
 }
 EXPORT_SYMBOL(seg6_hmac_exit);
-- 
2.43.0



