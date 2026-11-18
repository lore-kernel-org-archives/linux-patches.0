Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055868;
	b=LuKln25m2oU5cqAQntXoCBWHqqF1nxXEHqs982w/42RW9enMx1WqZCOCQGJ5b0BgUBjH
	 NPGFbrmuNKf6i8V/KwoTa0fr0I7UgwKvWk6nGccEOCOKGMUYgQFwIdAp3u5nGQwuTaEGy
	 bc1gvNo6pAm8OqkiYQUAiFK82ROz/JKVN2Tgp7S3nqTUVp4hZ9WHFlmtLlHr4nB4OtFVK
	 3OSNeR5A7wJCAKY5qmsZuEkl1+Bfbw/nBSrCaDhxBAFm7KL9P0PFOuXVmTUHnYDjKhtvS
	 wcbp71JeMN2s7Xjw2rUTyF75km+BoLGdRSmS+R3x5ZBRlr4WTQ1VaSO8VJXNHhHmMMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LEqzqrI+QipGkWiv40gYTpIyrFywxwrVn467T/z/iGQ=;
	b=GBj/adQtVCtJLNwkPbRICabCdwdlRjJIANYUdVfBceMTvYOH2eJAgVpr/hmlHBFSWPAX
	 T/ta17/B8YqEsc8AmZtq9yXPxgNPtE63MZ1RA6QS0FeuKR9fS4QCh28gIWLCR9cEzynJA
	 10JzkNG82pW07l8wA5s7HCgK2RPvjVr/x6RGbC92IPpbftwKFE3KddVR9qRwGTSQ7RMU4
	 sVA5QEbS0FajrbBcvqXbbV03078ZJGb3ye0JRfiHmhuoOrNLpxHe1y67xoidOxs6JJcIM
	 bhhbyJxsXL5yJcYg/06Es5tPnBGJKgWETBmEMjq7+ZgW9vPAf04+cMLo2pxO1wj2N8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e3bQSINe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AAD606A339;
	Thu, 19 Nov 2026 02:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e3bQSINe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40151F000C4;
	Thu, 19 Nov 2026 02:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055868;
	bh=LEqzqrI+QipGkWiv40gYTpIyrFywxwrVn467T/z/iGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3bQSINeYbkbgUSnlhZcpUt7URWg8MCXzOwnakgerpTmZvBXv6BoI5Oa3iCQ3mxix
	 tAQtr3xYEF6ksQYPvSjQrXlBKmE/fiw3vXVtlFMpzoWn3EMzk4GVTTeD5puSFETF+I
	 QcoiLGsbBF+1BSV+McNH9nKjWCx5ui9D1/HoGRxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1786/2214] init/main: fix false-positive kernel panic on environment variable overwrite
Date: Wed, 18 Nov 2026 15:57:42 +0100
Message-ID: <20261118150122.920771403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 12a6d38adb7ed..9e458e0b1357a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -537,12 +537,12 @@ static int __init unknown_bootoption(char *param, char *val,
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



