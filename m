Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569C71FE471;
	Mon, 23 Jun 2025 13:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685206; cv=none; b=mYHk212Nvau7TXFOc3FQZfw4ssGNw2xt568d2L/EMHVw+aWqNSS+z2G10QCY1s82QVuznB1kaoIxR+WIRIo1j+sRcHk1+UZTgUpFyn/5q4EGK9L4CYbi7otOb/NtmDL0gXYfaAXXlcSwt61l3+Etf+yDRX9qNlqUgBjlnnzofZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685206; c=relaxed/simple;
	bh=8OYFSUadody3n17+mRkyPo63rzSoKyGFTQVIUMA+99s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FT/cdfZLcqmYc0Gglb/rS0qX2roPtcfrS7qjsDV+1LMhfp5jmKslBhYLn1PEXdRmAAi1lM0WVIkEh4JF6z5vlcKB3dOcDabXlhbtvBTGLilifGzxzIfqXljK46bbE4eVjhKIsMtO00CTTM8Wt0uLBHkA+2xktXhMvMOxfmmL82o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUZNBpjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUZNBpjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC08FC4CEEA;
	Mon, 23 Jun 2025 13:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685206;
	bh=8OYFSUadody3n17+mRkyPo63rzSoKyGFTQVIUMA+99s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUZNBpjEjbAgKGqieiGWSKT87HopnZpGQmWpcoloB561AbGG8ijTHYcQ/23zcrcx5
	 euIQZtXJ0xkog99Acc1LMgdIZZfa3hzyJKi1qdwZwE0Ee7uh+YhJ+w0QhnCe/DDOXX
	 Eae8htNKHH8QMVlP94xz1MIlGOs7AUPw2WFWbvZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/411] crypto: marvell/cesa - Handle zero-length skcipher requests
Date: Mon, 23 Jun 2025 15:02:40 +0200
Message-ID: <20250623130633.480005043@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 8a4e047c6cc07676f637608a9dd675349b5de0a7 ]

Do not access random memory for zero-length skcipher requests.
Just return 0.

Fixes: f63601fd616a ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/cesa/cipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index 0f37dfd42d850..3876e3ce822f4 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -459,6 +459,9 @@ static int mv_cesa_skcipher_queue_req(struct skcipher_request *req,
 	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
 	struct mv_cesa_engine *engine;
 
+	if (!req->cryptlen)
+		return 0;
+
 	ret = mv_cesa_skcipher_req_init(req, tmpl);
 	if (ret)
 		return ret;
-- 
2.39.5



