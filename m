Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC802D023;
	Mon, 10 Mar 2025 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629316; cv=none; b=cXJd0fxZd/dE4l5YaO/Y7suh9RW7GH4jC0yGH+aIOKW4rTHd/a+Rs9INWGhpymyzn3ZFRWwe8ooExlk8drTr8fyHc3EvoSyzKYy3AQru3CcP/pKzNQ0li+h/AwEbt+rbaVRf8ZBws/9rN02c02Kn1MB9/O8ePTUQpPYu41ho+6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629316; c=relaxed/simple;
	bh=SmPCecALW9OUxm9MuBSM3QRtPZsqojZEj538q/4ytDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFeDjneQOHq+OBIk0k1xRTltPCp3sd6OA4ignpcQbD84q7IxJCX5ik/h+tp7TLdjAhMF9Bk4ZXKqkoMISx2VNsxt4VaSzcKdZgrXpQgxNYEkC8KOeBmhVeI5Zpa7dSBijUjWYdJTiNWZtavOOnE2r68qLhM24PG1Vsp1YsaKQtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zv4GSrGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zv4GSrGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2FFC4CEE5;
	Mon, 10 Mar 2025 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629316;
	bh=SmPCecALW9OUxm9MuBSM3QRtPZsqojZEj538q/4ytDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zv4GSrGTs1jnFRuv0NyChwzeHvo6bD3zghyTOilXjvGkqZKlPbE0pvAQBs7zjc1Iy
	 besms5RvfAO6X5Iz0Ok9npyh/hjdkjJ7TwEAvWNALelTJl2uk0QVgfO3XuSoc8JXoO
	 csExP5YuG8nMKyduOdbAnUsK27t2n/9Pq0KE5ZB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 221/620] tipc: re-order conditions in tipc_crypto_key_rcv()
Date: Mon, 10 Mar 2025 18:01:07 +0100
Message-ID: <20250310170554.346021160@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 86d1e782b8fca..b09c4a17b283e 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2304,8 +2304,8 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
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



