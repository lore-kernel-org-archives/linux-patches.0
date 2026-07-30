Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A293C3F4C;
	Thu, 30 Jul 2026 15:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424502; cv=none; b=R+IMDQI1ZigyFCfz8peemMC7Cr3kdPQHpRdLa2S3elCRnyvQAiMcy6G9WuN6thxGo7xmbAXGo+vEVASAWWK/ySkDEuUzqGvhp3cRpzOsFL2zS7gExu6pWHi596NJo0UqMX5uiMAD5bgtl5WPHZnDagWQYTlCpJ1ddoWx22LTxfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424502; c=relaxed/simple;
	bh=eS4vCGKdaee8fO20mqSB1m8fryAYmOnOZywJ0EbyN6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STQZu1Qcj32WE6oS6UTBhrj8SIYeLZ93Y6bUMasj0fLVyOogsH1zExJg63yIicofPPffYX/9MHW7pTAU2GDQAiIM9A9juj9dR/mbqh7IttDJ5ZdwEknryoReKFTP8NKsu5oPVyN3JC90g7WzRG08Fn8i6mMsZS3Mb3NxnkJifaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jz6RFyFV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jz6RFyFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107CF1F000E9;
	Thu, 30 Jul 2026 15:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424500;
	bh=i0LemTl5pST2wHYtlp0isTrAJimBnYRg3kgwzbKDBfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jz6RFyFV3tQiGLhSU1gb/+uLmb4GCiS2h3dP+iP7R0Hywf/9Gxj+mRMj1eyn5ZIXx
	 cJ3KP1uc+jL0N/tzolrHLzA3qDrI0Gw9scy9HXCQWI7UPI5QtgGuVAA1dcC6L+og0c
	 g8zTPdPxiposQ1QqROjcIfyC/19TsWTgHle9NisA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 417/675] media: nxp: imx8-isi: Fix scale factor calculation for hardware rounding
Date: Thu, 30 Jul 2026 16:12:27 +0200
Message-ID: <20260730141453.996709675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Guoniu Zhou <guoniu.zhou@nxp.com>

commit 5eb54da3f874b44149556542d949909898865e29 upstream.

The ISI hardware rounds the actual output size up to an integer, as
described in i.MX93 Reference Manual section 57.7.8 (Channel 0 Scale
Factor). The scale factor must be calculated to ensure the theoretical
output value rounds up to exactly the desired size.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guoniu Zhou <guoniu.zhou@nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patch.msgid.link/20260323-isi-v3-2-8df53b24e622@oss.nxp.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-hw.c
@@ -112,7 +112,14 @@ static u32 mxc_isi_channel_scaling_ratio
 	else
 		*dec = 8;
 
-	return min_t(u32, from * 0x1000 / (to * *dec), ISI_DOWNSCALE_THRESHOLD);
+	/*
+	 * The ISI rounds output dimensions up to the next integer (i.MX93 RM
+	 * section 57.7.8). Calculate the scale factor such that the theoretical
+	 * output (input / scale_factor) rounds up to exactly the desired
+	 * output.
+	 */
+	return min_t(u32, DIV_ROUND_UP(from * 0x1000, to * *dec),
+		     ISI_DOWNSCALE_THRESHOLD);
 }
 
 static void mxc_isi_channel_set_scaling(struct mxc_isi_pipe *pipe,


