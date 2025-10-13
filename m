Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B0726F2A0;
	Mon, 13 Oct 2025 14:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367101; cv=none; b=skuZkmDYqYgGFffLUn9DKww59LcaU/rJ6JlVsQdTtejf4t41MHVAHczE9smjGZVz7FV3XsesxvEtYBO/htC7rXnL9rRWacctXviuwXty1kcABxpmWBaz4Cq5QFm2VnlYSP1gEGZP8dipVnJL0FtK79nTAzIhZ8WQInSNcODZocc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367101; c=relaxed/simple;
	bh=/gELB85Facq97UNnhWZ1U74WY119jXukpobHojdx8AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFwgb4AJsjoMnTzUbtBpF2PuUK39sSuxCjoh7c3u7nh/cHy+ttpsQI514rOfgxcDdQYFGEsdhu+AOx6ubfjtRzWmMLqadUFsiJs2E5DNmVQ1QfBWhGt9YTXOROhrc/uqEiC5K857503NNSsYO0HryqBNjrAiLX+dz4SgaZtoP9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlpitBJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlpitBJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CEAC4CEE7;
	Mon, 13 Oct 2025 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367101;
	bh=/gELB85Facq97UNnhWZ1U74WY119jXukpobHojdx8AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlpitBJK/Nd8EYIpCbvwNO7kT7b0O/ZPDWEeLv8DHfRmQd3s6EX1I+XSzJFowjeQn
	 BUrMy0s9tLjN5xrvoMmoTmfy4roViJ08N2pFupHmDwdwIOGdKjd/Txo0b3y8oD1hq5
	 Vm1Bur+LrNOoT7Z4yfoceO5f6JUbUdiVCdmRjqyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/196] selftests: arm64: Check fread return value in exec_target
Date: Mon, 13 Oct 2025 16:43:42 +0200
Message-ID: <20251013144316.359423266@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>

[ Upstream commit a679e5683d3eef22ca12514ff8784b2b914ebedc ]

Fix -Wunused-result warning generated when compiled with gcc 13.3.0,
by checking fread's return value and handling errors, preventing
potential failures when reading from stdin.

Fixes compiler warning:
warning: ignoring return value of 'fread' declared with attribute
'warn_unused_result' [-Wunused-result]

Fixes: 806a15b2545e ("kselftests/arm64: add PAuth test for whether exec() changes keys")

Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/pauth/exec_target.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/pauth/exec_target.c b/tools/testing/selftests/arm64/pauth/exec_target.c
index 4435600ca400d..e597861b26d6b 100644
--- a/tools/testing/selftests/arm64/pauth/exec_target.c
+++ b/tools/testing/selftests/arm64/pauth/exec_target.c
@@ -13,7 +13,12 @@ int main(void)
 	unsigned long hwcaps;
 	size_t val;
 
-	fread(&val, sizeof(size_t), 1, stdin);
+	size_t size = fread(&val, sizeof(size_t), 1, stdin);
+
+	if (size != 1) {
+		fprintf(stderr, "Could not read input from stdin\n");
+		return EXIT_FAILURE;
+	}
 
 	/* don't try to execute illegal (unimplemented) instructions) caller
 	 * should have checked this and keep worker simple
-- 
2.51.0



