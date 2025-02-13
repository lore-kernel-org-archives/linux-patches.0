Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C45613D8A4;
	Thu, 13 Feb 2025 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460198; cv=none; b=eKUvfrze9jsdkSIlEqyAxQLq0TzSIuReZDAl6od//XYckH46Ic4aU2gZ9D81xv4Y5mQjOq16Y2nYuv/LvXm6TMW7Z8bwoftDzdY1VttaA9Q7Ue6+m0PYt9gEMDHTjna+a6wAsVFN3QaEvS3C3zCwFbG473C0LKEluYpl4ALRKGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460198; c=relaxed/simple;
	bh=gSy35Ex6mGhP32KJy+E8TZMXR7gNBFiZyGIGfY4w33s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOltR4gYMG+S66XZ3dIGgeTOI/4ygwp+mTOYfWEGFyR4HYK+P4GvvAsVRu1z3BawE2jLUF3MDME8Xy/quGowbhrqjQBNsy3lSoV8qwIgbGyuExJDz/epELRnSrxnOf5JA/pLpaRzM2fIJtpgbFf2b6A9g2jLAC5GgV6SCfTzpRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MaqS1lee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MaqS1lee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51483C4CED1;
	Thu, 13 Feb 2025 15:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460197;
	bh=gSy35Ex6mGhP32KJy+E8TZMXR7gNBFiZyGIGfY4w33s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MaqS1lee3ileARjbpFLkMy970MoRtTxlcNvl50O4cQAF2dxPQLOBuV0NEMm9rCwyV
	 s7kJE3ZP5a7gRnwsf28oV6YeX/zgrTdwC6FzICuPIeL0fNB2DsvRLl+CXDwFngr+i1
	 TLeXFlet1LVPSekxMzzbnAB6vmuk9RnTiBvwXOEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/273] tipc: re-order conditions in tipc_crypto_key_rcv()
Date: Thu, 13 Feb 2025 15:26:56 +0100
Message-ID: <20250213142409.094832330@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



