Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1CB3E63B0;
	Mon, 17 Aug 2026 15:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980551; cv=none; b=JDkgUKnU7DdaBzv7rudcOxJMujQGnfT5vyuETjBM5vxsC+azHfvtarhCwnT6LNZLGOYPBoGuLr3NPaBZz0dc5831Sgve9hLalZUaKkbQG3qtdlfzM8zECzkRMgEzNX8BLuG5bOA6tyaYq9Lh+tvZAtnN0xCsCnVGqaRGPfQ+Gcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980551; c=relaxed/simple;
	bh=NCGeiGXH137Crf4QHGR510V1phjnzL/V7feS0ZnwkHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twYC3sYn2EFAGA1yz0x0Ixm2IlNEk0/tMvP/81XDhEgc2nvz56VH2bl1MyStOX/BmCBH2T5owQ2OSMIHBeYNVi+JlimJc8mMOlldQzsNkRk1FcsHoNP6IcVoLgxDhooH0BazJbZcAdjkAjyEYoQ+d3BxuGvjwcmrzJEE5RQmAP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIuk7ffy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIuk7ffy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAFB1F00A3A;
	Mon, 17 Aug 2026 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980550;
	bh=0AyZeKmpMsRNXR3l6aFwfSYoPSv9o/aqn2HA8ht63t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uIuk7ffywC5oOBh0Tx0TEnU0w9WZ9179hJI0wUxq2nZKN6FDz0YJRLRFjKXPsnrS6
	 fgDQ/asW1tsbOdNSfx2bPSNqYAQDGYMui6LwSWmj0Fq7miB8V2ACZDf2um23gtKkwF
	 IAGaW1DVsouVR+wNnuvIOMBodB9kBFHW0EsBLAUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Anandu Krishnan E <anandu.e@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.1 574/609] misc: fastrpc: fix channel ctx ref leak when session alloc fails
Date: Mon, 17 Aug 2026 15:34:30 +0200
Message-ID: <20260817132602.928276153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
@@ -1448,7 +1448,7 @@ static int fastrpc_device_open(struct in
 		dev_err(&cctx->rpdev->dev, "No session available\n");
 		mutex_destroy(&fl->mutex);
 		kfree(fl);
-
+		fastrpc_channel_ctx_put(cctx);
 		return -EBUSY;
 	}
 


