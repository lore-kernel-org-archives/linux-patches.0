Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060758;
	b=xWW6E8UGX8FhHihiNGjyv4J0s2JSdT030FbauVCrOx8nKUL/IfdTrORXB6p1OY+IEoFS
	 keWAtBmAS+Xc7ntZ2S11+dhE6QTvA96m3IAF/XYs89x+NGU2HyvsDyJyBRN/klI9/y9HA
	 8+W+SoglPsm5XjmIDJoDbbfI3WCQa+5J5+/7FrsDh7Bnk6MjwDd1L/G905ZCoM9Gah9iC
	 O2n8LClB7Qd/Gz2TN8RpRqyhSk1fjPV9cSiD9xQeF+Cju4oKKNz3SxuAKcLawQ3s8lZ/e
	 MiLaWvJP9R1vATIYiEZdLC8e/2P0ybrl3iHlE5n/56JWl91JeQ0EWtEEGEJpMf1Uh+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TmofVcCi6upDO9mHcw846trVAuCAv4ZUa+wsyOtVnQw=;
	b=XNZmdZt/UATXRDyzmypDFxu6QZWqmiAkXjwcHXtQGdBicUlZb3hsdvZ2P8atB72fMX3u
	 Irg9osOtI9Zopr2hYRaBDsm1q/JVYx6fgyY99Yb2MbolqCJA7aIgb6QdcQLtqbAQDFF+a
	 s8EuXW5Bi7cH6B4zV8hFbF/L8lFu2EnPupq0+KeaLLDn2MsEBWKFWycGg9sOOfKZ9Vo99
	 TlKtZPpEotO2Y386ICUoBo9mpXu33O3U/SKO2CVpJYAWbWQsquKM0rm3RgrUmiw4CSD58
	 rA2NsLpfZ+9DBd/QISb1oDmJ6kvzGCt24EXgrgqo5FQ3Ni3Pent5lORVmWvXeuX2mJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQipQwNP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3867606A320;
	Thu, 19 Nov 2026 03:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQipQwNP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1582B1F000C4;
	Thu, 19 Nov 2026 03:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060758;
	bh=TmofVcCi6upDO9mHcw846trVAuCAv4ZUa+wsyOtVnQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQipQwNPyDDtjG6CiFphUj4pC2DxZPlNdEs0G8VRoDMw1dRF5c3cyrJa8LrLMFfDs
	 YKr0t2zYDuuaVSR70ac+LYE1LUBalI9BURAOwWfjkJRPlvCYVmx23bupRe2I8j+MWl
	 PMIuGMq0ypmS+p659m9QGlhlPOMyIgbQ1k+lBkkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1287/1848] pstore: dont leave an ERR_PTR in the ramoops zone pointer
Date: Wed, 18 Nov 2026 15:55:25 +0100
Message-ID: <20261118150013.460184521@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 70fec428c845216da98041b1ae9f16a8f54b3d68 ]

ramoops_init_prz() stores the result of persistent_ram_new() in *prz and
returns the error without clearing it when initialization fails.
ramoops_probe() then cleans up through ramoops_free_przs(), which hands
*prz to persistent_ram_free(); that treats the ERR_PTR as a valid zone
and dereferences it, crashing the kernel.

Clear *prz before returning so that cleanup sees a NULL zone.

Fixes: b5d38e9bf1b0c ("pstore/ram: Add console messages handling")
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20260921202317.70595-2-parri.andrea@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 44fc3b3962882..7a367222a4086 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -590,6 +590,7 @@ static int ramoops_init_prz(const char *name,
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
+		*prz = NULL;
 		dev_err(dev, "failed to request %s mem region (0x%zx@0x%llx): %d\n",
 			name, sz, (unsigned long long)*paddr, err);
 		return err;
-- 
2.53.0



