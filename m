Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A3A43BDCF;
	Mon, 17 Aug 2026 14:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978652; cv=none; b=b2URUrESVMjU/55dTMJUoPRPQqn/XgJTnNyLhEtrKL+TNVLMj1Neg0P0+E8cJ551GIjr1+XzdAZq8MMcC98K4LoUdHkVznuQO8QvgCWx8RL2bYr34n9fcWnJrmmuXo6JCnIx4RLBlk0q6uVCQchtqj2D+77nY61QVu7vdRmaZOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978652; c=relaxed/simple;
	bh=DOYe8oQVMbhGsikVgvr5cK2qhOXuDKon642rp7DM3Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1+GvCEINWK+Lwx4/oFbTOxu8b13+em/uMv4jl/aDEnqjQpKUFtMWa0sobZrte4/wZOZyhT+Qn6df++BH/IB3wRylJ6AG+4xXN85BfsDqyrRWH0CdnHY/HVs6ps8hHJN7oBT+pfuslEum4ggCcgoG/Xol94giKHwSJ97PvaKNiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlFanmKS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlFanmKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3931E1F000E9;
	Mon, 17 Aug 2026 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978650;
	bh=NsmaFukl4Gq2VmgUEA74OsTfEiKiEhdCoIwxpMUcLo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wlFanmKSTUhW5MKA9xiWtCLByaOrp+RCv3dcmoyv4LvFkuC+COyO5eaxNgomesUz0
	 BAUClMTZPecOzqjuhoWZ52dgZPmxUpF0hXv6cDtimA4nJOcWxV7mrqp1jbbcS1m/Ot
	 hxdZ+Efq+SDOmOdyU0o2mSzXIUh10dpA/5TSPazY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Anandu Krishnan E <anandu.e@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.6 109/156] misc: fastrpc: fix channel ctx ref leak when session alloc fails
Date: Mon, 17 Aug 2026 15:34:03 +0200
Message-ID: <20260817132538.883556263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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
@@ -1644,7 +1644,7 @@ static int fastrpc_device_open(struct in
 		dev_err(&cctx->rpdev->dev, "No session available\n");
 		mutex_destroy(&fl->mutex);
 		kfree(fl);
-
+		fastrpc_channel_ctx_put(cctx);
 		return -EBUSY;
 	}
 


