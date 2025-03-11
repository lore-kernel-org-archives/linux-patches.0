Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1467E25E83F;
	Tue, 11 Mar 2025 15:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706739; cv=none; b=dK73VoydsCOANYU4dW/7/muO+Lo2uSyPBtRtwbrJTLB4WbcOCqh/e44+9kzSHmQjqlWlOLp5ag3h6osvl+ncqSrqNd2iY6gKute/WClOtc/YzuJvBlti6cNU5YVKu5gepSrhkdADI4wkazv5NwQ8I3RjZQdPjASKNnH6F9Z/oOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706739; c=relaxed/simple;
	bh=yzf0UoDGisbrU4dfmdptap/uAvos1QKhIIePzd/Wd04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tw8UkgB/El8I/dyXWeDzzC78hsCPglech8NcGPMXIJzKW/6MpcWRBUQoTnM95TkGnMbv0j1CuE2R7RDUXYxMH1LJhXp25ERF8zX3+xRF7/Zo4p4b+Ri1tn6BL4qhdoR7SUkWUsq1jTZSf/BEtBAw8LYUPt/LsmhN3CcUA3JR77c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5HkFw1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5HkFw1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCE2C4CEEA;
	Tue, 11 Mar 2025 15:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706738;
	bh=yzf0UoDGisbrU4dfmdptap/uAvos1QKhIIePzd/Wd04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5HkFw1NoxNhUPZ9aqiuRQ1pTATftMO0bg7/2lewI8Hf65k56S450zou1to/fEFO9
	 zhLPWu9E7593SJKFxEz2naQBo2AqAzp+JvfvHD1SsE2gyNk0YWOjY+60ufO0UClbm8
	 v19uPvACEuCeSNKWcSYtbOYU0mvKCw9vpBira5OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/462] tipc: re-order conditions in tipc_crypto_key_rcv()
Date: Tue, 11 Mar 2025 15:56:49 +0100
Message-ID: <20250311145804.006240850@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b5aa0a835bced..bf384bd126963 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2297,8 +2297,8 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
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



