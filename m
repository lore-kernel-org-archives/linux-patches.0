Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061341;
	b=iy/9xKKfTLPdAd7LJy/mgGJ7Mc8bEsPDyum3hD8totVtQ4oCIa2qa+6xr4pf/QK/oOme
	 H6ChAqBrNJF5Gx2BsutH0FRycdnHRy3plL2ojbzg5yvfcEhBfXR2BikpkKNnwmYAj3VF8
	 9NK2Qie8fhk6TfP7lvWFgX1ZOoFWIqcKgJ9Swuum5ifSuIzNNVgWqGf7gZgi94MF4UZN0
	 sFKbXNLFjySp6KUtWUJTSsZWqSwt27C+TC/J8SQq4q+AzlScqd8WZ7l8aFOCIAEpJKbDb
	 kMTxjfTTMZFluL44pi4lndJE9K0slr4olCEDYdLM3W/HPCgqwYCvZv5sSuitpkNuqWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2TAvWE4SYs4kIg9+dX/qY4vCjvBehl+S/VpufDUrKD0=;
	b=pr7C89xkFk0gBymRX9ah3jQsZ0eoKhRGOBzZBSUWO/UJZP8Ji+AxqDwQZVdRip9NTIBw
	 4eo5QeYTtJ/DHbxc6OV5CRmjYF1vVlp3LcaiEaPYxmOEraBsr2T5o5BY+AgajomLdPsy4
	 wN3OjkXaIRlpwJaYqS+rFKe8PN6NRcpmCkVnmDBZ3ij6UYxbhyf6SoJ7yZlFctUrfIyhY
	 u7RTwdwgVekdDazs8Q6S7bfQDtdciY6bINKUuNurCa7W1t1IjIf3KweLrgmBf8BJFyb8T
	 IwJkDyN3g9XRNITMJ8Oa6gf1u62WCd/JzxEu8vuR1m5L6iM0pvtE4KxH4JRibZMXR3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJswX9aS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C496C606A320;
	Thu, 19 Nov 2026 04:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJswX9aS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F501F000C4;
	Thu, 19 Nov 2026 04:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061341;
	bh=2TAvWE4SYs4kIg9+dX/qY4vCjvBehl+S/VpufDUrKD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJswX9aS/5WZ5Zrd6bf8F1gxJY6OOqiP5TmStCpxyOd0FByZlFz92q+Ijpi3BiVP0
	 W+eivzJDX9buJWGSoLR1nnDCBiqGkkku+tTfMpZc188hiscVLl2YRGjLAlN2rrNXNN
	 2bKRfm/rF6N9HR41PkR8Kpax2NskVFB5e9dGygwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1519/1848] init/main: fix false-positive kernel panic on environment variable overwrite
Date: Wed, 18 Nov 2026 15:59:17 +0100
Message-ID: <20261118150022.850076692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a0142d0f6e1ae..501d2a6a9ce26 100644
--- a/init/main.c
+++ b/init/main.c
@@ -524,12 +524,12 @@ static int __init unknown_bootoption(char *param, char *val,
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



