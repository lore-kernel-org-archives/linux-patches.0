Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040970;
	b=lFt3jv+wMIex3vdsfrwVYnV2cZVUpZ2jm1domqm+9cQPfBFuAC7aXGVI83X6a4Jr9ub0
	 ZFAX9Di8xXLDeLDBBzl22HiJa+Xs6GN9eqpi+rX0eDrko/sOzuwFxrSwsJMYujIu4em0+
	 2I6stpHBkEk4B2x7YKkkSWzsoemGweTIFs31BZlcnN+GurNtyakZ+N9HaDead4zZovjcq
	 5PKwwJCOLI29ngg3nmjauwpUue87bY4SVbEaINpfposQAzqWh7sHRv/e2H+6C3VW+3+T/
	 ep/FG+yHiEakt+TpmJTQ/Q7sLGc8+4hzyHkwAgOH8gY95qTO1k2Tbjpxa8T3ELWcGgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S3UKDMQI7ywPSnVTG7MZ0+ublbU0+GwcI3gxbVwHWvs=;
	b=a4L0G1Wvw02iU5m6Tmuk2i9LPtitmeOQjlHrTVQ8OP3JJ2Z6YRwjGm9/M2vR2EocUEfB
	 2S2KjdojrGL8ha+mCQhWxNVwuxmEUveKBRkG1QdMabcY9bCdYMBehDzJt6omfQZwmdZyi
	 gk7jDhywpwNRztxzxR1UvZmjLzmJE8oj1xqRkaaHL4ehpmn4PccuoKJupPR352sCsRRnI
	 pg507SkSi+5e40QiZ2We7Dd+pxcT/+EGlOyPSJwJO9pxSohBEdNLP0aim+xY0GrRYuYP4
	 avyM4YUNSsv8DU3adgraohECA7lv8SN5odwTZL5w+DYvzwyyaU3ztf31q/9ALa4ZamQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmpo7UQo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3503606A320;
	Wed, 18 Nov 2026 22:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmpo7UQo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599FF1F000C4;
	Wed, 18 Nov 2026 22:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040969;
	bh=S3UKDMQI7ywPSnVTG7MZ0+ublbU0+GwcI3gxbVwHWvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmpo7UQodxu2CJEN174SXi8lJfxYSLhWoakNVWHM/vvC5BcWtijR8UhWY81HGV1sb
	 yi46RonD3NSTv01/XsEwZYgVyTMCeeuNcmmLW8qj3Rq+nSpUzEoirqxzItdwbTGkRB
	 U5/ommLu4G0NebA74zp83e0/Tfl2jpKL+c1x0e2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2646/3318] init/main: fix false-positive kernel panic on environment variable overwrite
Date: Wed, 18 Nov 2026 15:54:28 +0100
Message-ID: <20261118150440.438833813@linuxfoundation.org>
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
index 968c93ea14fdd..ef4966765738a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -530,12 +530,12 @@ static int __init unknown_bootoption(char *param, char *val,
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



