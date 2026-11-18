Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025723;
	b=RjFxeMGPA7nHy22r/+FAeGqfCtqkUzlFoBaGB4Tc3J0H84ZpCpspFpwimBsIJjVaJL0O
	 awcldyCb2iOid7yogUkz4UFyZ2dUuAWmQzfjv6gfv+jLgKfiKQJK9vVGQGXPBvDuwNTRp
	 Hse1OMREfCfYsZgR+U5Q2gTVIoK/UxSTCVRDfgWeHQ97ij+vDjS8YWCbUcrN3zXE5zpFm
	 4DWReFGTVwaqVE10seyh7ZFgdxuQUhD+L/Jn0Mai97eutomMfr0PPtbbj51clcPp3EGfQ
	 BiEFdmKVRnHOlBcNMbR9RGL+GOBrs2kAtSTXI+npZ0lrjzOFjztzwX7uP46m7Vhmm9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O73BCMYsQslati0GDvOvNI3CtCvaXh5tpM49pfVPK68=;
	b=Cn843cN6y2/806fgrEUOoXvVLNC6GbI3yy3Dh4J6pDaed6o9885SanQDS47CDjo+yKVn
	 ltlEmdEIKX979coDAyc+7n6mmyk0tKPMQEIXmw5YKgAT0Q+rgN9rjTd3jQ5nXuIGkBL3Y
	 JngCdbHXt5bOkSfZ9sT60MlNnaZgAMSviqfvSuekB6joTWBqNRyIfT8hvPQmhHIEyh39t
	 GE3PKKVyElGD1taQa7vxYQQ88kHbGVAOpnyLgbqKjd9sM1v86qry+2kHgCuLdGdNCXstP
	 XDfylDrEkxeuDaI/56JDfChny2VNwZH9IAew3EsqHYiiY2GfUL9TGUGU1ujbE34WuIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BswvpvV7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA218606A330;
	Wed, 18 Nov 2026 18:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BswvpvV7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8BD1F000C4;
	Wed, 18 Nov 2026 18:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025723;
	bh=O73BCMYsQslati0GDvOvNI3CtCvaXh5tpM49pfVPK68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BswvpvV7gGeIEa25lzFfLVwUMWg/L8A300IQQBW9ohzxhKLtRZ+kfyYcbO1+O5qxe
	 InKuYwEoeIq9Xh5qwpO24WGrzCcOav0FLoDhKGFxt3wxk1xbqdjL9t8WcM2VZgYBBp
	 B4GL7bLTfen7juebx5/bHSLW92LlPsn6RC0fdyd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1180/2151] init/main: fix false-positive kernel panic on environment variable overwrite
Date: Wed, 18 Nov 2026 15:48:35 +0100
Message-ID: <20261118150205.113198722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 71977bd3bc3c0..6985bf93b055d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -540,12 +540,12 @@ static int __init unknown_bootoption(char *param, char *val,
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



