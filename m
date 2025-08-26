Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A881A76B1;
	Tue, 26 Aug 2025 13:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215009; cv=none; b=ca5mnCM8GK2E83nuklZTtdjBfo/DOKnQh1RH35BnYNlkJGNWbRyPILn+OG4ztGbIbBh4pt1KTUDnwS+waEjl+ptaEfjKjxvXyWjmdH71tgV7/H2N1sRIok1iafBpt+ZKp3sjvuMwVpCkspeEcE9YiG6zyyWcEhCH3IpIWnHetos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215009; c=relaxed/simple;
	bh=XVAkfETrq00uCCcCdyPcebJSHn+wFPIhuH7S0HS5+to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsgnYOkyKEQaaw6CIulWbOdXeUQ06CYLmYYSjTmi4SrLUJ9XWHJNfma/N+q5rTcDHTQqb7OMJBQCBl49JllInPk57lJVI3k+m9R8vQfxYCc8fV7m9etMOJ1AJbqchCNE9twSi/2yK2OelerMLSvcUeALFau0H4yN3Z/LTlizZd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXNnFvqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXNnFvqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E7CC4CEF1;
	Tue, 26 Aug 2025 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215008;
	bh=XVAkfETrq00uCCcCdyPcebJSHn+wFPIhuH7S0HS5+to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXNnFvqtK8zgWiS9ztnPNMrCd+6C/+Kf/in8t2VRcO6QsjMxMZHlilpUlUkUGrVQe
	 EaqtNNpe9kZGn1Xh2fTDYZTtq9QcF3lwEmn5P0NBT2qNsCcsbaTG9GWUrzwAU+Zt10
	 SwxwlQXfakhDUyQwiHodYO/egy/V2CarUzO3e2lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 321/482] media: imx: fix a potential memory leak in imx_media_csc_scaler_device_init()
Date: Tue, 26 Aug 2025 13:09:34 +0200
Message-ID: <20250826110938.739805906@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


