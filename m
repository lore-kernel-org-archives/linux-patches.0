Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B71222173D;
	Thu, 13 Feb 2025 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458814; cv=none; b=uHC7Rbk7h0YnluxUpOy9b1/g3kuwy27z0rXcsBeoMTWbBf7sv9F4+KRfUwDCBeTlYgkbTDV3shhUk7snMBmBcz5ioHY7tpLwToqMYrMWJf1s3Sgkk2dRtfaIVeD8p2lnfylR4YvD5JHBBt9VydzxPrpdfH7XUlTH6otPJ2yf++A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458814; c=relaxed/simple;
	bh=Lnw4m7/7AuylB0i40WzcqC6uB2UvZcIdJBmfZuQQer4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rd7KsRZIJfVnSW03KawDcCOBl0OL20Bno4I/8nmw+gfYuCSdV27g0bzgLxfxLkqp6s5NvtHTDjsQGb82HMdP4z7FUUihSoseyxMD/s83lbAI4sa9khNottgTvyUn9bpUb3fa8wvEWUkI9t+NpvpwWH+dZxDjVl3/LOJeUd08tL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSEf1gXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSEf1gXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4122FC4CED1;
	Thu, 13 Feb 2025 15:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458813;
	bh=Lnw4m7/7AuylB0i40WzcqC6uB2UvZcIdJBmfZuQQer4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSEf1gXK5Nmtka9xezIxgTLf2KYOSOiHRf8TrSzWwbJlOj+jE4a9hoEIFQz7W4RHm
	 k19pCeB1I+1k75aBQuR8R0oEu84Xd/snm5LgP3f+dYWG5btijiK3An1r07cgFZoG3j
	 bIm5k+mmt9QXROln+zYyRd85HYj7CTblNopd2z+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 084/443] tipc: re-order conditions in tipc_crypto_key_rcv()
Date: Thu, 13 Feb 2025 15:24:09 +0100
Message-ID: <20250213142443.851685501@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5fe71fda89745fc3cd95f70d06e9162b595c3702 ]

On a 32bit system the "keylen + sizeof(struct tipc_aead_key)" math could
have an integer wrapping issue.  It doesn't matter because the "keylen"
is checked on the next line, but just to make life easier for static
analysis tools, let's re-order these conditions and avoid the integer
overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 43c3f1c971b8f..c524421ec6525 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2293,8 +2293,8 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
 	keylen = ntohl(*((__be32 *)(data + TIPC_AEAD_ALG_NAME)));
 
 	/* Verify the supplied size values */
-	if (unlikely(size != keylen + sizeof(struct tipc_aead_key) ||
-		     keylen > TIPC_AEAD_KEY_SIZE_MAX)) {
+	if (unlikely(keylen > TIPC_AEAD_KEY_SIZE_MAX ||
+		     size != keylen + sizeof(struct tipc_aead_key))) {
 		pr_debug("%s: invalid MSG_CRYPTO key size\n", rx->name);
 		goto exit;
 	}
-- 
2.39.5



