Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046882;
	b=HHurA59pQn55AZRu4BpVomNU+zFzvU4t8dQBKE/qxgAucXxSrDNKiSUAixTXgIWpqsUR
	 RmBHU6JbCNN15yqa8WSs7OS4D8hZv5ZctK0VH3EN++cyR15RgPKmoVIjq/Wvbkfs9egdb
	 NqChFxRamxZ9PvE3pia8FZifWH48KVzRvQAlwoxEX/c+rlo8ck/oJ6QwzVuyIqVNZma1s
	 km3QpaeYtMy/LdJ13cEd2a2KsIA2LjT1+Wd0PNn1NznCXXBXb7G0w5d1cnGajVmQH5ppe
	 OyWFyKAF7MUzh8tDldeuRtUPArcu+fiTvy43xZr4gBat3SU/bT4pCWS1FdUDQU4qU/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hpr+yssYWhBMrrkZnOEDpD4NzCNYRdt/tIKUa02pJ0s=;
	b=1RwfnpSRY5EUeu1g+dP4ijn65dIsYsDYjdhX2HCinyynKRNBGfsulAuYtR+vJB0D7xas
	 OQnoOi+S8dGrdrxWTgTr116PCA8/RExEK/PwdalD/9cpmKfPhPHE/RwIofKE6drhyLEID
	 6iQ05j4eYXKW8ILZnDR7OZ9td8Z/wUaAJvRMLvFJFw5mweKdE9rqNOMBvD488r9wPR/vV
	 7GaYYrAiZKfT3qrh545dTm95tR1lvk/XF757DdU/o5jbkD/LGpOfB4tmGPKR+6kpg7T5H
	 9DnyJka+NIN6iL0prFmdQDgNXzCYYOIvtvKnQ4Ip3Y2TqgE1a55yXn3tChJLuzxerFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRYzKUSw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECBF606A330;
	Thu, 19 Nov 2026 00:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRYzKUSw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1ADF1F000C5;
	Thu, 19 Nov 2026 00:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046882;
	bh=hpr+yssYWhBMrrkZnOEDpD4NzCNYRdt/tIKUa02pJ0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRYzKUSwUfKpCk3obgW4OZGtfyN5RV74UqnwutsfBnu1DRwRFzz8LCAuZZHdMvvDA
	 NPIIx6VMf/w1lg+kjgCZJCevcRXXS04h+/ukZoBxZ7ss2+9LqMz2LE94vR6IPwEdE9
	 X9rRERW6UQ+17JW83hNdqNtv9fur9LbomIExEj4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Moulding <dmoulding@me.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1440/2857] init: fix early boot crash with bare hostname parameter
Date: Wed, 18 Nov 2026 15:41:14 +0100
Message-ID: <20261118150253.163324261@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit b6bec5b63a5b812145e53aaad1e63661c7214f93 ]

When a bare hostname parameter is specified on the kernel command line
without the '=' separator, early parameter parsing passes NULL to
early_hostname(), which dereferences it in strscpy() and can crash the
system during early boot.

Reject NULL values in early_hostname() and return -EINVAL instead.

Link: https://lore.kernel.org/20260826100904.296151-2-blum@kernel.org
Fixes: 5a704629f2c1 ("init: add "hostname" kernel parameter")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Moulding <dmoulding@me.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/version.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/init/version.c b/init/version.c
index 221ccede8902a..11cbd3fb60be5 100644
--- a/init/version.c
+++ b/init/version.c
@@ -24,6 +24,9 @@ static int __init early_hostname(char *arg)
 	size_t maxlen  = bufsize - 1;
 	ssize_t arglen;
 
+	if (!arg)
+		return -EINVAL;
+
 	arglen = strscpy(init_uts_ns.name.nodename, arg, bufsize);
 	if (arglen < 0) {
 		pr_warn("hostname parameter exceeds %zd characters and will be truncated",
-- 
2.53.0



