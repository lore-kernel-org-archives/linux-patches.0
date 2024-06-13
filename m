Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A948142E8E;
	Thu, 13 Jun 2024 11:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278941; cv=none; b=Vyaczj3fR1Gs4jDeZYH/I12cSTPTng0BHURoirNHYHha6fBncUQi2bUBIjmpqnCMmih2McM3D1QM0BpLA3TV0NUo/LndQEI9FnyLJXJjNOSqPl7Pg2UU7rykpA+Pqz/tf5VEf2vDNGfoGoBXYmNa+e8ryI3VnMLQO39xpqH+iSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278941; c=relaxed/simple;
	bh=ZasOFq/usb5XVh0ipb5F3TzRx/Y3Ce6vH4rArzviP2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ldr5vJtbrxOhxESVU/xHrwLvt9PHJBNs7tB2ndFGaMzOU7BM8OlevtKqjavfTQvP3NM/rBNdSjttlBsRxLN86MUCWz0T2rROzX/Ah+O1cD6aV0KZN53xJDd0M6XFYDonwDwz6ygvAtV5m1Fd2hhUbjyIetaRozHoznVNn6Qud+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWpuSj02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWpuSj02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8437CC2BBFC;
	Thu, 13 Jun 2024 11:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278940;
	bh=ZasOFq/usb5XVh0ipb5F3TzRx/Y3Ce6vH4rArzviP2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mWpuSj02Myra4vRN+hT3RtKOMV3MT4BZGCCmVi6i7kfuNNm7LvXTEDNAmRCIzULQG
	 ps72Jx/IRyWsqd4oaLRbdACBOe+aEi5BMlYu2FNud+DuNtWzayn+u0qx2ZRjsd51Nc
	 c/6uHSRtK9K0ImdoYY+D8EODbkCmTSCM6ZjEjtfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 122/213] ipv6: sr: fix memleak in seg6_hmac_init_algo
Date: Thu, 13 Jun 2024 13:32:50 +0200
Message-ID: <20240613113232.703386724@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index b801283da28df..9a077a4fa10e4 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -361,6 +361,7 @@ static int seg6_hmac_init_algo(void)
 	struct crypto_shash *tfm;
 	struct shash_desc *shash;
 	int i, alg_count, cpu;
+	int ret = -ENOMEM;
 
 	alg_count = ARRAY_SIZE(hmac_algos);
 
@@ -371,12 +372,14 @@ static int seg6_hmac_init_algo(void)
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
@@ -388,18 +391,22 @@ static int seg6_hmac_init_algo(void)
 
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
@@ -419,22 +426,29 @@ int __net_init seg6_hmac_net_init(struct net *net)
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



