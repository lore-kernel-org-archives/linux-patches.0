Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130AD19922D;
	Thu,  5 Sep 2024 09:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529905; cv=none; b=uHKJ62KwlOvpDABTZkOFAXBb483Z0N+rii1UnLOEx4UGYgjcnyoRq3ScByNkg5bwpTqK91yPsK2YE8c61woiwgKJKHjy8G30JGoWkE052b/hrc4d1trbshNlFzGdfaMffERpXN9oLfl4yXDypJDC3oGm7/4BJi2S24XuZytrRU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529905; c=relaxed/simple;
	bh=yE0IHqc3dEH1WXw1hfTRgtFDWASDIzVgsRgGBiqylWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exVMBHw4VID7/1unKeB8yTZO05euu7f4m7uNS0yq5fmA4oG8sGxoWnEPykwMdTIf77dE1zm7ncDLYz4KZ9LEB5L9GQJlP4ORT7PgsCHzeeit33ZGnTxqtN+tuw5yW6LD414SleysgdUMNeDw9RuMMshKd0nszk/M9l0BTccH4YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8Vwj/lC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8Vwj/lC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4D5C4CEC3;
	Thu,  5 Sep 2024 09:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529905;
	bh=yE0IHqc3dEH1WXw1hfTRgtFDWASDIzVgsRgGBiqylWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8Vwj/lCAZDIEJngt1wdvt5sqtAQuoWNp9iqTs6CtC+6GBUDICPthITxFd442UyRx
	 cZB8dLkD18XMzohV8epaghREZJIQLHe7aItKRCGov0KQwMlTnSjG1pgT5pZI+xm98M
	 xu3o7zMSJM/QUrTSHGItnT9vRfgorkOij+uztiJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 178/184] crypto: ecc - Fix off-by-one missing to clear most significant digit
Date: Thu,  5 Sep 2024 11:41:31 +0200
Message-ID: <20240905093739.281717744@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Berger <stefanb@linux.ibm.com>

[ Upstream commit 1dcf865d3bf5bff45e93cb2410911b3428dacb78 ]

Fix an off-by-one error where the most significant digit was not
initialized leading to signature verification failures by the testmgr.

Example: If a curve requires ndigits (=9) and diff (=2) indicates that
2 digits need to be set to zero then start with digit 'ndigits - diff' (=7)
and clear 'diff' digits starting from there, so 7 and 8.

Reported-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Closes: https://lore.kernel.org/linux-crypto/619bc2de-b18a-4939-a652-9ca886bf6349@linux.ibm.com/T/#m045d8812409ce233c17fcdb8b88b6629c671f9f4
Fixes: 2fd2a82ccbfc ("crypto: ecdsa - Use ecc_digits_from_bytes to create hash digits array")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index fe761256e335..dd48d9928a21 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -78,7 +78,7 @@ void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
 	/* diff > 0: not enough input bytes: set most significant digits to 0 */
 	if (diff > 0) {
 		ndigits -= diff;
-		memset(&out[ndigits - 1], 0, diff * sizeof(u64));
+		memset(&out[ndigits], 0, diff * sizeof(u64));
 	}
 
 	if (o) {
-- 
2.43.0



