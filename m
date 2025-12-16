Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35894313E13;
	Tue, 16 Dec 2025 11:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884245; cv=none; b=dhqfYMeOMeIB2a18RFevJb82t9fAyfkx5DNqv6psD5TojRJrs2VnfM8MvWJkb3C542Zv84jcxbrGV/FuGFR5dJqE/7q3STvLVN4I7fIaHUvunt2Xoawe4f6hpujXY05IBt+nIBuj4xCwAxjeQZq3dEyMEanQKt/jr43/QLp8Z+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884245; c=relaxed/simple;
	bh=2oEC1Gjmmlw2fIG4OOhMOPqCISVXzJ//twW6/ld4/MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xn9eoq0vKVaoM/V9SCYTuMYMCCkDhdW7KkdfmkmKDua2HTt1Qbuk74Mw6/exruxcnWHumtqKAUkHjOkgWaOxv4kAK71lSjb626aM6NdbCS6c/pcaVBUqqxkR3hCOv4llCGGwRyOmKNLfPffJros7RKs3K5tW7UMBgCql9qxP6QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1AO7Hcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1AO7Hcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CC8C4CEF1;
	Tue, 16 Dec 2025 11:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884245;
	bh=2oEC1Gjmmlw2fIG4OOhMOPqCISVXzJ//twW6/ld4/MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1AO7HcdG5WwBJeI77J6t+liNuwJRvw03C7axB23mCVUzy6Mwz6+vFvadYMdXdr1v
	 3IEF9X80vG6A1+otTH3zhkOEHdSXYDSDEcvPNn6HlPjbKA0HIEIBrKJWCuWV3wmCwU
	 mpe1YY/fL35BIMIGFR2KhyW52yOvtgEjSn1nYsfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/354] RDMA/rtrs: server: Fix error handling in get_or_create_srv
Date: Tue, 16 Dec 2025 12:11:41 +0100
Message-ID: <20251216111325.774998996@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit a338d6e849ab31f32c08b4fcac11c0c72afbb150 ]

After device_initialize() is called, use put_device() to release the
device according to kernel device management rules. While direct
kfree() work in this case, using put_device() is more correct.

Found by code review.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20251110005158.13394-1-make24@iscas.ac.cn
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index ef4abdea3c2d2..9ecc6343455d6 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1450,7 +1450,7 @@ static struct rtrs_srv_sess *get_or_create_srv(struct rtrs_srv_ctx *ctx,
 	kfree(srv->chunks);
 
 err_free_srv:
-	kfree(srv);
+	put_device(&srv->dev);
 	return ERR_PTR(-ENOMEM);
 }
 
-- 
2.51.0



