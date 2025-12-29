Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6969D334C29;
	Mon, 29 Dec 2025 16:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025962; cv=none; b=LW8VzJZ/ZSNtksQKaK9Tdm7dXZ8nPA1ZOQpEH66KL4TOvXnWWQLYZ4abExYbxAZ9mO/PzX5QyzEOnAzQNoDQQtSLBcJLTyDsgFRCDf3ik8lto3HRLRrOAevUZYnvjYoKCMdT3qb5Pnxuj6qOKhkARo8ApJjXoMjThuFd9bNSxwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025962; c=relaxed/simple;
	bh=xMQ7qNpBYA7BfrMoXqDVqU53AYiwKPmzWiRfHC2em0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqGw20KMVnl1C23VcyYVvMN5AQqFxlGzE8rgDsrAEtHp//RL/wuxdGRSFzVu6NCyLG0I/kTkQXH1CU2zerajHmxUxbcgG88HznsU+GewBHj/MuvxXTdvi3X1HOBiW0T7YQZ+jTfUJga2MkNO+Igg6IoOAyL0il8an6Y+3lIr8Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+YxgbxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+YxgbxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38BFC4CEF7;
	Mon, 29 Dec 2025 16:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025962;
	bh=xMQ7qNpBYA7BfrMoXqDVqU53AYiwKPmzWiRfHC2em0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+YxgbxXrgbjZeaIe2H4K3WgvL8+6GHTMeddD5J+0bXN6p+LjY6WAuIQSFiT1oapV
	 jrm6g5edxpF3MfmKrm6smIDOqGZ9r9VgDZYfPYHMHxxNn5Mj/iICWuudN993WRasLW
	 lgpEfaBE2pv0Ah4zKSe6sSG6KM1R6Xi4wioQJjHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 398/430] crypto: caam - Add check for kcalloc() in test_len()
Date: Mon, 29 Dec 2025 17:13:20 +0100
Message-ID: <20251229160738.961767804@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



