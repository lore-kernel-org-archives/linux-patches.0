Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062030;
	b=htp4kkDEIA53J63DL6ENPVvlOixZIQQ91AH6WR7bvO7tXLt2ynL1vBuWtb2JVTGUWoN0
	 UbPUgEgwBs4JL/Ylebnov6VjjKuRFkgMyJ6LcWKcWqI72E1LwWQgBP4tnaa/j7YYiA4Rf
	 6EG4kSnndzqpeTvS/dwyenhqgKhHXJR55jyz5Dj5NI138QoJUeZ6BWkaYZZbFTzdpDEGH
	 jCRUgDrteYl5DFjGAcQg+QMFh9i/B0RarakXXBHYQZ8mAcnfa9HHdBhsCmkElBKoVVpdw
	 giyNmdoop2RPyPGprLGEUy0d2tmGl238usIIsJ/EaLjy1EzZo7JQ4oWTpebzVPDPyhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2YEKIISKE19RycURzN168DIBNveit5mA5znzFEiDFvE=;
	b=j87k2i+nM5ZoUIWg+GDyPQS/aXfb3TXPR14HdUqBNjGvWGDvqeb0ofv2jh+VhwMS/KEK
	 Y0VgWetD8vmKpYoNb4FRYuXGPwWim+6kU1F3EpgNWtEtesl4SR2UH5q6E+G5Ejk85cPAI
	 vAocG5KPvES6ptwzqDsyKf/h3gKzL/LK6fdhajN2tP+luziY0AzOeWtt7aCZNHGfMXZ8p
	 A5GCckyMmDZQCT6jmMPsDcgi4JU3mAMduy/vTJ8zqSdKQVj6ccCIzL8IxVIHymLvUFuYP
	 pIF+gzlB1DUIze8WxvsKzBFWfsilzYuR8k2QWBcPFSQ80dJGGM2mcZo2kZFAnmCqWCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HASlUfSE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B731606A334;
	Sat,  7 Nov 2026 14:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HASlUfSE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9961F0089F;
	Sat,  7 Nov 2026 14:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062030;
	bh=2YEKIISKE19RycURzN168DIBNveit5mA5znzFEiDFvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HASlUfSEP9U1oDqVDtv7AhZTBrSKZSC2INBAeIlPqHrAkNprcuaSWTzvD3eGe1Y1n
	 j+33dcAljA9Opv17YqEEs4X+VOvWLAnX2iMiELI4da+IWu1MznHUzL62GXACCU/Gf7
	 wAWfWvCAx7s+ADOYyO5R/g/P1a05MLgo8OnDo9Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Cong Nguyen <congnt264@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1015/1536] staging: media: imx: csc-scaler: fix ipu_image_convert_run leak on queue error
Date: Sat,  7 Nov 2026 08:50:31 -0500
Message-ID: <20261107135026.186877768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit 07643be7b1eff94f7a49e142c1e92a1029d3db21 ]

device_run() allocates an ipu_image_convert_run object and, on the
success path, hands it to the IPU image conversion core via
ipu_image_convert_queue(); the run object is then freed asynchronously
by the completion callback ipu_ic_pp_complete().

However, if ipu_image_convert_queue() fails, the core never takes
ownership of the run object and the completion callback is never
invoked. The "err" label finishes the mem2mem job and reports the
buffers as errored, but never frees the run object that was just
allocated, leaking it on every queue failure.

Free the run object in the error path. There is no risk of a double
free: the completion callback only runs after the object was
successfully queued, which is mutually exclusive with reaching the
error path. It is also safe for the earlier "goto err" on allocation
failure, since run is NULL there and kfree(NULL) is a no-op.

Fixes: a8ef0488cc59 ("media: imx: add csc/scaler mem2mem device")
Cc: stable@kernel.org
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-csc-scaler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/imx/imx-media-csc-scaler.c b/drivers/staging/media/imx/imx-media-csc-scaler.c
index 07104e7f5a5f9..6643f09aa44d0 100644
--- a/drivers/staging/media/imx/imx-media-csc-scaler.c
+++ b/drivers/staging/media/imx/imx-media-csc-scaler.c
@@ -144,6 +144,7 @@ static void device_run(void *_ctx)
 	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 	v4l2_m2m_job_finish(priv->m2m_dev, ctx->fh.m2m_ctx);
+	kfree(run);
 }
 
 /*
-- 
2.53.0



