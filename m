Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511F84418CB;
	Mon, 17 Aug 2026 14:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978182; cv=none; b=VX3APYBGKu3XvFghLe1Z+QSCPnVu4hysLKzjpsxNI6DfjqQ/PttZpLf9iQRDIV2JZSqZcIXmDQg0ux9gyxUhyWiu3gLowyiIa4IPsJB1geUBP4tpcerrRCIPtrScQxGLhuFiibr5wRy7I+q97F665y+ZWyObpWcgDOCb81ODKOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978182; c=relaxed/simple;
	bh=SWxh6xw2GSmnbcVROP6DxE4WZmuIJvdQBqk1QlnF4KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4gRDA8WLnZmf1ibJz49XCjLMakuTPEukM2dsKK45APQ9rnrVNm1+Fs+ut8cbYsBUGoXRN6Th+wFyT8HjZ8kAdIjlMLPgGFyIToFM4uQ7lS4VCqALdrhzTjAO8O2PFk7hIm3aW4nCS82V7XL3VIoIIVSuNgVSm7L8fVuLgJrz28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Xk4mlwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Xk4mlwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3E91F000E9;
	Mon, 17 Aug 2026 14:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978179;
	bh=twJqOalebkNoGZTP+NMw2xR4S8ixCNv4DSCkxbDHyG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Xk4mlwAdGXhNQOECXj5QV7BB6/DkFbtTVMeZFzQJnTmrlw30eOu3/JYgRktkYTXQ
	 JgiTumrG78+WL+EagdfiWhgr51beHoaqdIKs/0fNK4yDW3/m1mR/x0+imVsq0VSaJp
	 BK9j5AJYwQwOyNoSiJCnQP3enp72BHISIIpA/K+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Anandu Krishnan E <anandu.e@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 130/181] misc: fastrpc: fix channel ctx ref leak when session alloc fails
Date: Mon, 17 Aug 2026 15:33:44 +0200
Message-ID: <20260817132540.715961707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Anandu Krishnan E <anandu.e@oss.qualcomm.com>

commit 310f7868399668c6d99d88acc9c4cf3462e69d5b upstream.

fastrpc_channel_ctx_get() is called in fastrpc_device_open() before
fastrpc_session_alloc(). If session alloc fails, the error path
returns -EBUSY without calling fastrpc_channel_ctx_put(), leaking
the reference. Fix by adding the missing put.

Fixes: 278d56f970ae ("misc: fastrpc: Reference count channel context")
Cc: stable@kernel.org
Signed-off-by: Anandu Krishnan E <anandu.e@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260724223342.629168-5-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1643,7 +1643,7 @@ static int fastrpc_device_open(struct in
 		dev_err(&cctx->rpdev->dev, "No session available\n");
 		mutex_destroy(&fl->mutex);
 		kfree(fl);
-
+		fastrpc_channel_ctx_put(cctx);
 		return -EBUSY;
 	}
 


