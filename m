Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2A176C9C;
	Tue, 20 Feb 2024 21:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463444; cv=none; b=EEGIXWkZrIVwScBjK8Sv6xuTbgBtupJjFiT9W1ElBMpKMSOsF7OMaprjbrPeKTIdBAOF9qAt35NcljCi7yiQ/+58i/OHsNNfFuwXA+pofZEgW7SkUKySJ7CcNbWFkj9ihi+d3uUagCCBhHqZZCClP0t+ZPTFko2cshMRZXsJSYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463444; c=relaxed/simple;
	bh=c4LLxQ4FlzcLzMe57cCtlHAPCP3EQ0F+SA4V/P0YrPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTp1jZJuJQ+JqPYVe3YuYK7+7L3or2cidDUEEcIb9Fy5KsM2Ox8zKjE1KBtILuEnc8eJ+uE4Jr2xbw+2o6VFWyzpSl3mqkz3emDN5HrimWBru+Hq8pSYUC3TjiHRkxbesmzY69dUPnuYBFqBaN5BgJbNoEkU+1LlYV1/bzPhaGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPLRZBZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPLRZBZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD017C433C7;
	Tue, 20 Feb 2024 21:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463444;
	bh=c4LLxQ4FlzcLzMe57cCtlHAPCP3EQ0F+SA4V/P0YrPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPLRZBZIEiek6eqVt3h1jxorclPEegM6zazFK65XNQMo6UUOxHxsACOQ3I7mkwdj2
	 CkYC1dFKTnwwTnwZCn8jo5wrdr0C2746+wkOKmpdiCZfwluyVWHltyijgafVfboZjY
	 4VvCQhICDcvz11HNG6WpGA/18gWY2kaFTABbPemg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/331] net: tls: fix returned read length with async decrypt
Date: Tue, 20 Feb 2024 21:52:41 +0100
Message-ID: <20240220205639.022407327@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ac437a51ce662364062f704e321227f6728e6adc ]

We double count async, non-zc rx data. The previous fix was
lucky because if we fully zc async_copy_bytes is 0 so we add 0.
Decrypted already has all the bytes we handled, in all cases.
We don't have to adjust anything, delete the erroneous line.

Fixes: 4d42cd6bc2ac ("tls: rx: fix return value for async crypto")
Co-developed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2af8b0873da6..e1f8ff6e9a73 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2132,7 +2132,6 @@ int tls_sw_recvmsg(struct sock *sk,
 		else
 			err = process_rx_list(ctx, msg, &control, 0,
 					      async_copy_bytes, is_peek);
-		decrypted += max(err, 0);
 	}
 
 	copied += decrypted;
-- 
2.43.0



