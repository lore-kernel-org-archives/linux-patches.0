Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018996;
	b=Iozp61hzgM193BH2eFCnDjG7kX2qbIwQcG3BOldCZze7ra/OQVIJi3lKIcL2UiNtBfXW
	 PGA9ikFYTFCeEz6iG2sKp7tM3yzgaVZ2qz5j70mz76IYiw3ARCOdxdgoM9U03rGUsgFXn
	 8ZtaMoV0hk1Lafn8q1pZTSaoqXmEtLb6JB/jyteQ7BO1PsboRmi+l7knChO2v0+K/JilL
	 4DwY2GpRgfHLCx0MojoUmtGy1Q7riVvt9dwGirvkEQ91p9rK3O4ZuL05JmoyxRdPHXybu
	 O2CqWX3UhHElwEZI3ZxfSPruakTgrR5r8L6kKntGhPaRjSEqFJNTOTaE5Z06oOdGoeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=34lOFlT6kh7vD4qW3uqYCfTTecjvRkRWIgXXXglUUjA=;
	b=LyTxKeGP4fA8PN5rJz+zuRQenwnve3729PBlFoyXJCXTJ9cHmRs6L9gah97E6LqBUS53
	 cYtjnUNQVa7cP3oRPnjdapWpuDsJYO7gB/LjoiGnNM+hABxRBE0zp8sQlBM1vIpdEITju
	 YmCXzSV9tjZM8Fm4kiTwz0gyJAG0498l7p+DK8jI9TRheeVSDPQZnyTqrua9NLqbGAWC+
	 26vWQmWLIZvzNIJg0i0RfwL2oKcJYFfCSPd9gzsLKA/x/CVtbdQE6ZoMMVCZK89/1AgcQ
	 Z3sfgmomIfIo7uwCSaEBezs1zh+BQjIQpX2tpuqa8TqvnhiKVABPNML0/JFsuJF9UAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwq035IQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520C8606A31C;
	Wed, 18 Nov 2026 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwq035IQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47621F000C4;
	Wed, 18 Nov 2026 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018996;
	bh=34lOFlT6kh7vD4qW3uqYCfTTecjvRkRWIgXXXglUUjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwq035IQ/BBA+m4/r75BLJsov/TDwxEWaYJiRQXrTt/bzM/senUj6whO0zT0XDkh2
	 LkbG1vqpJzTNzBhDqqlTZWDAGDUFrngcvNULLf+34SOx0jCCHxr/0zpo1OdkAmEOHZ
	 hg8gYWpmKUA+7BplGiE4rDO/GvFfSkvJFuy1KfHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1397/2651] init/main: fix false-positive kernel panic on environment variable overwrite
Date: Wed, 18 Nov 2026 15:43:57 +0100
Message-ID: <20261118150338.306984752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index fc2c8000f49b6..46c1fb7c04dfe 100644
--- a/init/main.c
+++ b/init/main.c
@@ -548,12 +548,12 @@ static int __init unknown_bootoption(char *param, char *val,
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



