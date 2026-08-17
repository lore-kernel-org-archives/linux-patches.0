Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3383EC80D;
	Mon, 17 Aug 2026 13:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974394; cv=none; b=u1CAhHlCi41Vnj8Oc0Mz1t6ZXjnJaPRF76RXTpemRGgLThc/bg9kzIU1yf0Zv9l/60Uywr9xNa5Hdc4OSVFxbML8WePby7KLuIDnciafZnwsrK0Jkj+o6LPMR30W5unvRSG3mOt89WLmJFE6bjTNSo9gXPpqGGKsRIifp4rMnek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974394; c=relaxed/simple;
	bh=p6JS7iEYEdxqlF4KDReo2HV4HF1JnQrdkXSKm/zd3zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvrJtoMNnGpFOzr8t6x+j9beo/TzQHMMhk5ayrCvnMFrsNkgze1zGPlfA1dTeGBGSpMrH42a5GWYkbxK3p5nRL3JNonOcb/f4MuasLqLg2g3E5xMw+xPeibVfdaQZ1KCsLBMiyZ4TufmJBHCZhX1xOX68ziGoZZSqKP1vEt9xCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKLajmTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKLajmTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB5F1F00AC4;
	Mon, 17 Aug 2026 13:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974388;
	bh=kHFMd0dZYfcisBhdPd3JCEtWimF7YaonsNuOBw3K6yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKLajmTVPYG5wclg1PtdSGyGPjvB0W2qaOus84XxKU0glwYnH8bDiSnR6NDNeEo26
	 BNEnaK6wbzreCzDoRfFTPTVFR2PtAWKg26IEP0OTefoeI+q6cju4OxC57ope0jV8+M
	 xVrhKqj3nJ8CGeZV2resTQFw6i8wnObXsvSZ1YU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Jianping Li <jianping.li@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 7.1 188/271] misc: fastrpc: Fix initial memory allocation for Audio PD memory pool
Date: Mon, 17 Aug 2026 15:31:53 +0200
Message-ID: <20260817132544.542989387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>

commit ab99eaafb0c4b412cfeb895a8cf091626e2bbd86 upstream.

The initial buffer allocated for the Audio PD memory pool is never added
to the pool because pageslen is set to 0. As a result, the buffer is not
registered with Audio PD and is never used, causing a memory leak. Audio
PD immediately falls back to allocating memory from the remote heap since
the pool starts out empty.

Fix this by setting pageslen to 1 so that the initially allocated buffer
is correctly registered and becomes part of the Audio PD memory pool.

Fixes: 0871561055e66 ("misc: fastrpc: Add support for audiopd")
Cc: stable@kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Jianping Li <jianping.li@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260724223342.629168-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1370,7 +1370,9 @@ static int fastrpc_init_create_static_pr
 		err = PTR_ERR(name);
 		goto err;
 	}
-
+	inbuf.client_id = fl->client_id;
+	inbuf.namelen = init.namelen;
+	inbuf.pageslen = 0;
 	if (!fl->cctx->remote_heap) {
 		err = fastrpc_remote_heap_alloc(fl, fl->sctx->dev, init.memlen,
 						&fl->cctx->remote_heap);
@@ -1393,12 +1395,10 @@ static int fastrpc_init_create_static_pr
 				goto err_map;
 			}
 			scm_done = true;
+			inbuf.pageslen = 1;
 		}
 	}
 
-	inbuf.client_id = fl->client_id;
-	inbuf.namelen = init.namelen;
-	inbuf.pageslen = 0;
 	fl->pd = USER_PD;
 
 	args[0].ptr = (u64)(uintptr_t)&inbuf;


