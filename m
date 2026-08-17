Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA22513C9C4;
	Mon, 17 Aug 2026 14:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976501; cv=none; b=aFQT39lYcJcRS1+gPb3uoQwNnmCM2qMzwWP4mCT2Lpl4zb2jFTad8uRdJ/7tBrIzp4OU5gyg7xnVeCIjDdXsu2cN+4hq2lTZRVLPXonH9Arjhl/GFhjQcFWB1rm3B8RZZA9MoKm8Ltgx3+1URc7Iw/fizUAnM3MoR9LSnEXnehc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976501; c=relaxed/simple;
	bh=gAQ71n4+65Bf14AL+3WX+iwym0/vfX85gR4fSPYx+58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIJqY7XuxE3fIssJ2/pM/KZaxcn85O4j13d2tXJt52t+7A7bnw4uPRtgAA5mkkn+xiwD+zTkYY0gcU9PZeP9LPtUrIdVyl309xG4edROiWAYWzO0e2LXWyuSLX0vuFPeK2kr3C+A5jKkBJnFkmp19qgizPvmHDlhK8yBtgZXUf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYyW04bM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYyW04bM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148481F000E9;
	Mon, 17 Aug 2026 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976499;
	bh=As1WmEitKUqGFA2ur/kF4V4KmeU02ussBWsKwBHUxyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYyW04bM7bHEohDCHv4ZDL2Up4pIf/dFVhbSSyXE5b1ALkbG8rG0kN7R4L0eFATED
	 IICuPzMyPMoyzaB7MxEEWbZXIxrlMbLl98ofXAr68Ek4TIGdnWdT0Vw8DpydD2J77U
	 DtTXMuGeXQbDvpU5oNivndr38At0QvpQEN8Ocwfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Anandu Krishnan E <anandu.e@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 5.10 368/389] misc: fastrpc: fix channel ctx ref leak when session alloc fails
Date: Mon, 17 Aug 2026 15:33:27 +0200
Message-ID: <20260817132553.065238984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1273,7 +1273,7 @@ static int fastrpc_device_open(struct in
 		dev_err(&cctx->rpdev->dev, "No session available\n");
 		mutex_destroy(&fl->mutex);
 		kfree(fl);
-
+		fastrpc_channel_ctx_put(cctx);
 		return -EBUSY;
 	}
 


