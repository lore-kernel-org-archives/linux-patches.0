Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39B815218A;
	Tue,  2 Jul 2024 17:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940307; cv=none; b=qgW1YA91gXewspMKdCDSvutZPVvyxYGqUDNiyPMoNZWwq1CpL2yMHVfrBVQ+4ktSfzHCPTDKOPE55QW2aZoTdX+6Gl6UlKd1vNu3UXr81LRN2TZdxDMR+mlIyy9tSyrIqNU3QZrqnGCsytgm/BJMQ1drEC77HRwloLnovE3nGWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940307; c=relaxed/simple;
	bh=U7QL8npQyD501adk6VQh+b7MVIUcpZJAXqyrY86ehFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUsjYvycXvVbuyetSDL7rN01VMbjTe+n1ZjLGHgWKvtl3TzdFYDBErGDUaOONbXmM27mYTiG4xhMrq8UAH9Q9qtk1ofJkU4rAZAZC5nqGWftGsztZDmssckiANu1MwR3gEXdK38nm4CHKeNhm6vwEnyEQI3xvHHAN4raTockX88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j55d7msX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j55d7msX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30094C116B1;
	Tue,  2 Jul 2024 17:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940307;
	bh=U7QL8npQyD501adk6VQh+b7MVIUcpZJAXqyrY86ehFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j55d7msXeuu45CCqYQu8N/elX6lB1Fkn7o7xMXmm4p1BCeQO/88enYEp6EyKcDKq9
	 xy4ikB3fP4G446S1ZOh0mfV+ejf3vi8FnExf4/FuCKCqGnmv3FJcEp+a9ig50l4/h4
	 qE3cwG54FNV3V2Y1OBInLGY1KqeiFaHpYGIJccZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joachim Vandersmissen <git@jvdsn.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 084/222] crypto: ecdh - explicitly zeroize private_key
Date: Tue,  2 Jul 2024 19:02:02 +0200
Message-ID: <20240702170247.188859459@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joachim Vandersmissen <git@jvdsn.com>

[ Upstream commit 73e5984e540a76a2ee1868b91590c922da8c24c9 ]

private_key is overwritten with the key parameter passed in by the
caller (if present), or alternatively a newly generated private key.
However, it is possible that the caller provides a key (or the newly
generated key) which is shorter than the previous key. In that
scenario, some key material from the previous key would not be
overwritten. The easiest solution is to explicitly zeroize the entire
private_key array first.

Note that this patch slightly changes the behavior of this function:
previously, if the ecc_gen_privkey failed, the old private_key would
remain. Now, the private_key is always zeroized. This behavior is
consistent with the case where params.key is set and ecc_is_key_valid
fails.

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecdh.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 80afee3234fbe..3049f147e0117 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -33,6 +33,8 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	    params.key_size > sizeof(u64) * ctx->ndigits)
 		return -EINVAL;
 
+	memset(ctx->private_key, 0, sizeof(ctx->private_key));
+
 	if (!params.key || !params.key_size)
 		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
 				       ctx->private_key);
-- 
2.43.0



