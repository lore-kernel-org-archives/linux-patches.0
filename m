Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B4D2F619A;
	Tue,  6 Jan 2026 17:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720562; cv=none; b=AgmNr1aR/JSyUDs8xctS2P02+V8/NOaY7z8xusZAzt2HOnoQAtAo58XTqK0RxrxfTslxUVKFshIRvGel4K5oBqop+C6YxEBxbMVTmn0bn5N+oFUdFlRlUdEZCe3yy/zodZP2Ww2Ma75mFw/eAQV9yengMQ3e5IrfEB3S7bN+Kxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720562; c=relaxed/simple;
	bh=rvnZG8+ItI9N2h/ZUyh7amFrQVbRdXEe2G3iZmoXU+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wy+n1EKh8sMvEHBa+Y3oH9eNehnRJamGNyr5B5A4R43zNxv+WQ/Zwh4h9hVvwNxXeYxGCNO/tgippf47gNWtOhUeFGD/UM0YogXzTs5Vombxm46AawUOVtHUDbJDgJu6FscxcOFdnhr8YFlmeZOUNZWpzmfEW08MHEQfVP82gFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3irs37l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3irs37l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD64C116C6;
	Tue,  6 Jan 2026 17:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720561;
	bh=rvnZG8+ItI9N2h/ZUyh7amFrQVbRdXEe2G3iZmoXU+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3irs37lgjHNTEc5z8lWUMYVpzHq1h9wX6J57+0NY/d5aDN42JJMwNaU/P/C3q7CU
	 M0NUYMlUwUELR2prRCnDWunRWKkH2/CgxK+mpcMH5wTMrTbj3k64GIJ4guEXcbyPdw
	 XcVDzi1eGQpqqMGyj7AE+xZWhSvfYE4Hk1Ijc6Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 273/567] crypto: caam - Add check for kcalloc() in test_len()
Date: Tue,  6 Jan 2026 18:00:55 +0100
Message-ID: <20260106170501.425978090@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/caam/caamrng.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -181,7 +181,9 @@ static inline void test_len(struct hwrng
 	struct device *dev = ctx->ctrldev;
 
 	buf = kcalloc(CAAM_RNG_MAX_FIFO_STORE_SIZE, sizeof(u8), GFP_KERNEL);
-
+	if (!buf) {
+		return;
+	}
 	while (len > 0) {
 		read_len = rng->read(rng, buf, len, wait);
 


