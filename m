Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C0A3F327D;
	Mon, 17 Aug 2026 13:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975138; cv=none; b=T/2SdPVqFiT+1WMojokLLBzybnMxgQu2l9trLKh1XlZOnzk0gWlcORYj+YTKhu7TY+f5dmbAVFW8xWBppX1bK0PXvkJmq1vuy3LvAdVm4MEhpvhylxMn35lqBNt20U8bq2zweuwNZ2hXNHF5NVl7MPkl94asqFKVHcAQWlx1aMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975138; c=relaxed/simple;
	bh=wJ11uOAU/6MEAaBCBdGx3lJF7aD4xWd8oVAnvhn8bGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckR2H7jRSCC5xwz0zpQr6K/BW1ckBdweb4PrRfAGLG5o6z/fBxIEQkLcJ47pj+tEsa6RgMNHMKs+HkGJWn1CjwT/CH2pitWNr2U5zT93EYIt0NOkGeYyM3JhcMcsMuC/fHRybM9f2b9AhV81LrJn2f5xhwUdrzJSuhRlcVruvE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AszQUTm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AszQUTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE561F000E9;
	Mon, 17 Aug 2026 13:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975136;
	bh=3per0yfDgiAK/hDEckDbVdbLckSzjl/jIQMhREbQ18M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0AszQUTmJ8bJ4v5xew5QrawbZ7xomRnpo3kP4fc+Sf6xT7FCfkq6bSYqHtI4W5Ahf
	 ITdz+IAESZKV4BDShX7thMK/Lfwz/6wr/yjdpCGeAIK/Py4Pb9FIsicGpdEX3Wh+ae
	 IT8bqMZ3RAq7gqAEkd9rru7v47YvOGUpOPM4xMco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Anandu Krishnan E <anandu.e@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.18 175/250] misc: fastrpc: fix channel ctx ref leak when session alloc fails
Date: Mon, 17 Aug 2026 15:32:16 +0200
Message-ID: <20260817132543.761731058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1642,7 +1642,7 @@ static int fastrpc_device_open(struct in
 		dev_err(&cctx->rpdev->dev, "No session available\n");
 		mutex_destroy(&fl->mutex);
 		kfree(fl);
-
+		fastrpc_channel_ctx_put(cctx);
 		return -EBUSY;
 	}
 


