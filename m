Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062904;
	b=Re+A4NDZ5BkTnO12JIsA4LgRC+pGq7wzXIubCmZ+LjbiBnKQxDZvNofYOkOmTALMFE0/
	 mcqiWWEgtWrg5ahu9sVr22hEMZbACgG91c+oS/7N/KXqh+PBmxi5Xwez2mR1MTF7AoItR
	 kz8hCZwq/nKkm3+dXPtrWZL0+acs4OrVRat79Ub6YzSTMk95wb3e9wr3qDCuS9xfsKNZB
	 VF3q7OQBThy9OVCihqv3poJXLBM5jL2eN0+zk0yzrLYoUtyk/qXpgdTiSvHICAabY3cf9
	 jb228J888F8qpfUPvLW9NPCS/J1DumihdxYRSmHCsQN+g0qOa2m0n1rMfjgNsBT3FnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JyhUIaE3OCHDLA60hVvgr7Rsh9xMMA7fKMAtgdkBsrs=;
	b=qlfZzCCWcJubG5Ejv4vfmOb5CwEW+OAHDqAtQq27jwtFGipTxFNCH25seZubcvWPHKdm
	 0WqMEi90N2DwDj1u9iSj54YbvgYkhakAmTWpN2Pd9iVPspniINs5gdfaRgKUWuHh5/fn8
	 lcMgUupo8+0w+KqCUAoo7eox31wGt2uTf2oPMBy3xl7SQIEFsCP5ntoEz0e89r12i7qIp
	 rHTyoEopbtrnNn9M/tMpCUkJ9Z+oB+5SfcAzQzE2B6pI6IdwV12mAmDG62bSanO8OvOz9
	 Gns9rntZvOBvmeiG/2Rem8awlkMoL280QT76o41jZKWXf2Tbd4qGIJVMiIS9BfE963w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="S08R6yk/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299CC606A326;
	Sat,  7 Nov 2026 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S08R6yk/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1E71F0089F;
	Sat,  7 Nov 2026 14:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062903;
	bh=JyhUIaE3OCHDLA60hVvgr7Rsh9xMMA7fKMAtgdkBsrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S08R6yk/k5Z8uLG/i3JZTjuf48wVH9rlTVjzfYjquc/m6236sstW7rChGZzzpdNCr
	 yj/OsXlr5yCIGANBrsTxuZ/Af7/2LEsYXTf5MsppvJLLX5x+m/+8wxrAnWugarB+SQ
	 bCpxycNzQWuPj1erRszcdA10MDeUB4PpnsZudJ98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Cong Nguyen <congnt264@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/869] staging: media: imx: csc-scaler: fix ipu_image_convert_run leak on queue error
Date: Sat,  7 Nov 2026 08:47:40 -0500
Message-ID: <20261107134858.197008020@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1869c5792ecb4..085f4f8eb8bde 100644
--- a/drivers/staging/media/imx/imx-media-csc-scaler.c
+++ b/drivers/staging/media/imx/imx-media-csc-scaler.c
@@ -147,6 +147,7 @@ static void device_run(void *_ctx)
 	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 	v4l2_m2m_job_finish(priv->m2m_dev, ctx->fh.m2m_ctx);
+	kfree(run);
 }
 
 /*
-- 
2.53.0



