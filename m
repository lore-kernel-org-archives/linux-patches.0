Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE087352067;
	Tue, 26 Aug 2025 14:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218061; cv=none; b=DOaE9SKRJaO1mmTEEntHXwt+zQW5N9Tki2wfzfNB/SSXDj6B+pXWlByoFeRhEfYK3a6bFKrvxjkucVxd0c1yFu84VGsamT8noNhOqqBMyxM0vvawSPAkIP0hKD+WRTV92IBkSg9kjtEHEWtRNrWEpZPJY+6zfnFXRWzVlQuOMB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218061; c=relaxed/simple;
	bh=pnEmDrQAVSicNV0h4RYYRhWVg3Rc2rQA+fh6zqohI0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AT7YLi6Ewt5wsFddrgiQiAwTMzOyTYxDEKqwyUphF3ogypC+bN030Pf2V1k8L2iJP6UXIAOrw41NCHA973CVOiadC/S5xB44jel/odcIt1QvzdjdhZn0SDYjZ95QmSw9YHjhnqUZiT2jImMaVCettMapc+vUJ6MpBB3KXfcZW9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfcnd1EQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfcnd1EQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F480C113CF;
	Tue, 26 Aug 2025 14:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218061;
	bh=pnEmDrQAVSicNV0h4RYYRhWVg3Rc2rQA+fh6zqohI0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfcnd1EQ2DC8KzZICaQwF11KPlfQG5n/NcMp841Ujr7ExkciGxIiaoPkgrJ3tpPJT
	 BOhJmPCFDsC7PpkNtXvHRkm8Udk5aUC7FtZGu1RxhZf0qYmaH48AOkCuR8Pm2tWVQI
	 AmEm4hGs7UdMQtlYLwM5xvcIImHjZDh8sxxWuxwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 379/523] media: imx: fix a potential memory leak in imx_media_csc_scaler_device_init()
Date: Tue, 26 Aug 2025 13:09:49 +0200
Message-ID: <20250826110933.812025094@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit fc5f8aec77704373ee804b5dba0e0e5029c0f180 upstream.

Add video_device_release() in label 'err_m2m' to release the memory
allocated by video_device_alloc() and prevent potential memory leaks.
Remove the reduntant code in label 'err_m2m'.

Fixes: a8ef0488cc59 ("media: imx: add csc/scaler mem2mem device")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/imx/imx-media-csc-scaler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/media/imx/imx-media-csc-scaler.c
+++ b/drivers/staging/media/imx/imx-media-csc-scaler.c
@@ -914,7 +914,7 @@ imx_media_csc_scaler_device_init(struct
 	return &priv->vdev;
 
 err_m2m:
-	video_set_drvdata(vfd, NULL);
+	video_device_release(vfd);
 err_vfd:
 	kfree(priv);
 	return ERR_PTR(ret);


