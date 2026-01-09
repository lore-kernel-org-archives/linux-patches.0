Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885E223ED5B;
	Fri,  9 Jan 2026 12:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960686; cv=none; b=jwJlT9La0Ejp8CLFOUj0dXtTTzDA/oc4SRaR4k25GjzVbBuAFbzBuEPHZh5Rtjndm7IhQiCN2KOtbCDzbY07YzqVz+HQ1rwWO7cfSyT7zDqQAwvXvjmRZXtbExKi76o9gdY4oKWgpjdwQxSAupKl95AFU41gQqybmbXbmQ/qGwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960686; c=relaxed/simple;
	bh=OMjRsb6yrLYg7LqI4jdwyTXI3JrJrnc0IlSw/XP9mTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgwHOd+EJQn4LpJ/xc08iMveQNAQYovlr+YqOs+UXNt6BFuLPlrdeYs7nr3eXSpSLeWFVTRWzb12jQw5GHr9KPYrfqk9UWqltujqYgPnWitbqwVm96EBLQucQSr1TyTTOQ5uEv5UXeud8SS9oELTHiqMxgbcX4pG6mBipNtE2v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/blZzwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/blZzwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EC2C4CEF1;
	Fri,  9 Jan 2026 12:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960686;
	bh=OMjRsb6yrLYg7LqI4jdwyTXI3JrJrnc0IlSw/XP9mTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/blZzwc21e0CbtRrf5Tpb6gduF98cLFhLRl52m8aP2ShpOgpqrzEpCxOI2aZVGs1
	 c/U8RrfPbjOqBF8wHPYPKHJyAiNtamzOo8sb1qQ6lMeopeE3zU9waHSsNETOu6fy3+
	 PaW7omfZJBpqjg+A3zjhmMnb+gYqPOlkaF3k7crU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 488/737] crypto: caam - Add check for kcalloc() in test_len()
Date: Fri,  9 Jan 2026 12:40:27 +0100
Message-ID: <20260109112152.344961451@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 7cf6e0b69b0d90ab042163e5bbddda0dfcf8b6a7 upstream.

As kcalloc() may fail, check its return value to avoid a NULL pointer
dereference when passing the buffer to rng->read(). On allocation
failure, log the error and return since test_len() returns void.

Fixes: 2be0d806e25e ("crypto: caam - add a test for the RNG")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/caam/caamrng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index b3d14a7f4dd1..0eb43c862516 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -181,7 +181,9 @@ static inline void test_len(struct hwrng *rng, size_t len, bool wait)
 	struct device *dev = ctx->ctrldev;
 
 	buf = kcalloc(CAAM_RNG_MAX_FIFO_STORE_SIZE, sizeof(u8), GFP_KERNEL);
-
+	if (!buf) {
+		return;
+	}
 	while (len > 0) {
 		read_len = rng->read(rng, buf, len, wait);
 
-- 
2.52.0



