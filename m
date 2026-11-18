Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049268;
	b=u5PghmCWT4w4smP3EaUv5aebRWvtZtCsUC3tIb3HZRB+gtDJhprQn+J/UE74G5vBV45T
	 Bt09dWtwlNfbiRi3/PPFXA+d1VtV8MK3SbAd5+LWi4jG06w5EAPSAk92YemMIKFEnDv0+
	 dw9kmLZHQ6hbSQId368DekEB2VFwX7GTcf9wBWe7vcdk97lopBACKIfgYQQq4y3BktQ7/
	 STDymA6cPULPToxMiKmNhZM4ho72X52molPvMqFmFx6lTwyRfXvSnbMN+fVRJCJefBQBP
	 cSgcc/rQGQ9aQ1w20BISUDToADnMJHxcvp7XCiYq/kg2Vfebb+9siSV2KacHmRoYzJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7rpl8AnChyGKSSQV3ULOy0LisWC7Yi7PNvxYMArPyGY=;
	b=EiQi/CsQSrWIvRXY0S7/xHTY9rVkiaJuLHNAeZtkZ7idUIl/MBGG0zbi/lNbdfYpwF0c
	 PZv/SBYPx4d7d6aOgckfI+AqhYgZVTX3mW6KRiARqTxijd8GwAPUiSLj5k49lPpfZm1EH
	 czM98Gk6Gtgbjh2sSc7vBRq7MRSXLnn7zXm3CwuBnjup1UCiFBxZ27dZvyBgMV6hD0nal
	 FG+bSkqsRnmdpJzVot90Oyj6EsmF1oMwmjFL9ZvRCwN9TqsPj7HYpojZYUZ7r1E8sjePw
	 NOWGganlESHBvJvDrjCSujtVXzbneTqkIRNwfCItI2YIEB8jUH0s01QPwnhltFnEi5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZXDHJOI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F3F606A31C;
	Thu, 19 Nov 2026 00:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZXDHJOI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225C41F000C4;
	Thu, 19 Nov 2026 00:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049268;
	bh=7rpl8AnChyGKSSQV3ULOy0LisWC7Yi7PNvxYMArPyGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZXDHJOIGz1bDDq3iFVCX0A1QR/1ad5CGjSQ9ATkaF6REP0ZQ49bHIKK3XZzMOWli
	 l4klpV6xoJkrWI+FIUrNv6ybMMn8BsPUy1NIvZOJXW2mnmAO9kE0Ko8OLF36Eo1lmo
	 qY4K/R59sA33r8/bEeGUW+cbDzez3OEYndGxI1eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2291/2857] init/main: fix false-positive kernel panic on environment variable overwrite
Date: Wed, 18 Nov 2026 15:55:25 +0100
Message-ID: <20261118150323.965586205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wilson Felipe Pereira <wfelipe@google.com>

[ Upstream commit 51e766bcd35e706d8df29dd0fac98871fdced261 ]

In unknown_bootoption(), the limit checking for environment variables sets
panic_later *before* checking if the variable already exists in envp_init.

If a user passes exactly MAX_INIT_ENVS custom variables and then
overwrites the final variable by matching its key, it causes a
false-positive hard panic on boot despite not actually exceeding the array
bounds or increasing the total variable count.

Swapping the order of these checks allows the duplicate check to break out
of the loop before the panic flag is erroneously latched.

To verify, boot a VM with 31 custom variables (filling the array up to its
limit of 32) and then overwrite the very last variable:

  ENV_VARS=$(for i in {1..31}; do echo -n "var$i=$i "; done)
  qemu-system-x86_64 -kernel bzImage -append "$ENV_VARS var31=overwrite"

Without this patch, the kernel crashes instantly with:
  Kernel panic - not syncing: Too many boot env vars at 'var31=overwrite'

With this patch, the kernel safely overwrites the variable and boots.

Link: https://lore.kernel.org/20260818045357.4123784-3-wfelipe@google.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 168d11ff45d7e..86f0cdcd3d050 100644
--- a/init/main.c
+++ b/init/main.c
@@ -533,12 +533,12 @@ static int __init unknown_bootoption(char *param, char *val,
 		/* Environment option */
 		unsigned int i;
 		for (i = 0; envp_init[i]; i++) {
+			if (!strncmp(param, envp_init[i], len+1))
+				break;
 			if (i == MAX_INIT_ENVS) {
 				panic_later = "env";
 				panic_param = param;
 			}
-			if (!strncmp(param, envp_init[i], len+1))
-				break;
 		}
 		envp_init[i] = param;
 	} else {
-- 
2.53.0



