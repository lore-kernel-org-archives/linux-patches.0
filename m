Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC55253356;
	Mon, 23 Jun 2025 13:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685685; cv=none; b=IfKgLnmEXRFD2NtR3ZBOFj9crmMKh/pdEsUtKIxsHFHjAyqonrAiSkQl5PvsczQ8HM00A3omLMcZ5VYut/bHlTj8Hj5WOLL6RwQzyIzLuzyzF7fD8TuCNYfUjK/Zow8DJdWF3j/52ploHv9A06JYrKCHSia0SCG0RtIGBuO+K0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685685; c=relaxed/simple;
	bh=myFPOPTbObbwNm63iOF+LVbD7D5BcqL4BpXAEoat1M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3w4bSnzfmFjqbQXJ2Mt0VA7zgBlM8NUDeF/WBW3Q8rh80WTvHlSdy3KUlefVgaIufB8shOx48JArh5eZEUKAa80Tk4CQlVK6e0QYvG5RGPHrYCZmxmb78DBOn4dU87peNVeOKPH1L1O1NetiTJ3u2Rbx4ovgKjnWvhHfCW7KF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjUP8K38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjUP8K38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4480C4CEEA;
	Mon, 23 Jun 2025 13:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685685;
	bh=myFPOPTbObbwNm63iOF+LVbD7D5BcqL4BpXAEoat1M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjUP8K38P8MxXKI5JN6jrIAt3vKM0zUxrVPn1hRtE433kTaicxnnfs/kFleIUsHjt
	 ZwcGZGoV8ZLozpOjt90q7vtkaLsRUF6g1DbHOwMF2/MnA1m1OBTWeNUIuZZfjzNCyl
	 PBlgtIJxiW30u7R8+p/xS5X34FjEmGAqSnuwre8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/508] crypto: sun8i-ce - move fallback ahash_request to the end of the struct
Date: Mon, 23 Jun 2025 15:01:09 +0200
Message-ID: <20250623130645.845133520@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

[ Upstream commit c822831b426307a6ca426621504d3c7f99765a39 ]

'struct ahash_request' has a flexible array at the end, so it must be the
last member in a struct, to avoid overwriting other struct members.

Therefore, move 'fallback_req' to the end of the 'sun8i_ce_hash_reqctx'
struct.

Fixes: 56f6d5aee88d ("crypto: sun8i-ce - support hash algorithms")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 8177aaba44349..a1658722d886d 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -297,8 +297,8 @@ struct sun8i_ce_hash_tfm_ctx {
  * @flow:	the flow to use for this request
  */
 struct sun8i_ce_hash_reqctx {
-	struct ahash_request fallback_req;
 	int flow;
+	struct ahash_request fallback_req; // keep at the end
 };
 
 /*
-- 
2.39.5



