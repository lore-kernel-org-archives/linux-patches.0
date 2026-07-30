Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3B84519A1;
	Thu, 30 Jul 2026 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427271; cv=none; b=UFbdj761UGhFxYJ/K4b6J/B5SINtigWm27BTSYeUApRZmHGXK5R6Z5ESuOzhR23qUsGtzcbacWUr3vD9M1hm8FE0IcvZEQ9heQ9IO5kqyE1lumJ+fMruO+ZRwYg2Qc5GrgadctrBPsou9I7+2hK0DoiDwgw0ZnVYi2zV8YFBIFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427271; c=relaxed/simple;
	bh=Ln/tp4I6cDuVj6B5/eM9AoLL01ylrZ00nKUDoOzIjlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGIiGmvFibXby18PRzq2dpqFO6DULspmJqHWgl+EQNdMOp+29i10ewLpIfp2oTlv75LAYTwzlSnzWBKOSoJf/1CbeJo/aj8H8gS19g1xByfME7SKUMnV2d7sqe402+mBqKSU5DcEfTkrchJVkkNdKZyUKbXjNfW96/JZxblRVF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obX35TPl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obX35TPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC4F1F0156F;
	Thu, 30 Jul 2026 16:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427269;
	bh=JKRa8kHt6AjZyy3e0aA8xKd06iU/bqaC61LnCTx+tDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obX35TPllVU3ng4nmMRTVCHpdqOTRcef/8feI6loUWn5lkftP2LJZYbbm6+PEulED
	 CZ962/QBFeQ5PsGeXLU1V/2WRJ9oxR4vUU0A24IdZIxCYKcMhFsSSQxqBArXJAhpJU
	 +aTKJ/O+YQY33XjQzqJTq74UY55iZBJoZpPlnVrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/484] crypto: rsa-pkcs1pad: Dont WARN on an empty digest
Date: Thu, 30 Jul 2026 16:10:08 +0200
Message-ID: <20260730141425.872278035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

KEYCTL_PKEY_VERIFY lets an unprivileged caller supply a zero-length
digest (in_len == 0).  keyctl_pkey_params_get_2() accepts the zero
length and the request reaches pkcs1pad_verify(), where the empty
digest is rejected but only after being passed through
WARN_ON(!digest_size).  The warning is therefore directly
user-triggerable, and on kernels built with panic_on_warn=1 an
unprivileged process can panic the machine -- a local denial of
service.  Reproduced as UID 65534 in a setuid sandbox.

Keep rejecting the invalid request with -EINVAL, but do not emit a
warning for the user-controlled length.

Mainline does not contain this code path; commit 1e562deacecc
("crypto: rsassa-pkcs1 - Migrate to sig_alg backend") removed
pkcs1pad_verify() in v6.13-rc1.  This is a minimal fix for the
affected stable branches.  It applies as-is to 6.1.y, 6.6.y and
6.12.y (identical pkcs1pad_verify); the 5.10.y/5.15.y form is sent
as a separate patch due to the older req->dst_len spelling.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: c7381b012872 ("crypto: akcipher - new verify API for public key algorithms")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/rsa-pkcs1pad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index d2e5e104f8cfe3..8172f0b0b481d7 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -534,7 +534,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	const unsigned int digest_size = req->dst_len;
 	int err;
 
-	if (WARN_ON(req->dst) || WARN_ON(!digest_size) ||
+	if (WARN_ON(req->dst) || !digest_size ||
 	    !ctx->key_size || sig_size != ctx->key_size)
 		return -EINVAL;
 
-- 
2.53.0



