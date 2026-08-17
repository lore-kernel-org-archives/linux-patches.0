Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4C3282F1C;
	Mon, 17 Aug 2026 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975146; cv=none; b=US8neJRW74xvTBBHPj/Ab71+96K+DwB8Ple8FifCdFwkGpax/Hbxa0dnK46zHqQdSs616Yd4Nt9Cr/uUsT63q5/cRejqvTlmBUozBqie0ffSbiv97jzYQq1wcXZixqAAEJayTa+JLVNBqI9R4J/FqkhQxJNWmQ9aCXm+Hg3HmhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975146; c=relaxed/simple;
	bh=GD0f8NpVGVkJqum9L2BsWmx/lQfPCDcEUBVac5Uk6x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqQns6EFDRqvg+GSb7sh3rA9pzhDXeDLIxyDg4bFo99Mmyz8V3y6i9vsYZ1JvxiOShT8LBjYNE0WZHCXb1+P/dR1tvXR7Pst+DwB0tbtGT/n2k+JMqKZ5LUz5Od3TmNYMudPFHuFumRTp4GmaUboK3u+TK7vSrW6Ke7xMiDOoVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cR4gXqcC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cR4gXqcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD611F00A3A;
	Mon, 17 Aug 2026 13:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975145;
	bh=+ADy69cv5aFjeGwLrI44/pd4NYT/ibRfzGjDZz9BrAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cR4gXqcCtF6X95jfDyCvjNUNPeNVNJTLmG/gHIKDV3H1HzLgtd62+wjVgklA3HZVM
	 rYG3FIA2fDzv8AQ9LJp8b34nIBWpylj45u1Roo9BeDQ6YIBfBTkcCxW9fVYgrKfD9T
	 3r/WGLoQPCOEYWgShhkGqrUsQ2t9KJXnCW1oW/2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie Lin <eddie.lin@oss.qualcomm.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.18 178/250] misc: fastrpc: fix memory leak in fastrpc_channel_ctx_free
Date: Mon, 17 Aug 2026 15:32:19 +0200
Message-ID: <20260817132543.871361025@linuxfoundation.org>
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

From: Eddie Lin <eddie.lin@oss.qualcomm.com>

commit 2fae94ee14f7fea11d3f95e10383a87c01d21518 upstream.

The 'ctx_idr' is initialized but never destroyed when
the channel context is freed, leading to a memory leak.
Add idr_destroy() to properly clean up the IDR resources.

Fixes: f6f9279f2bf0 ("misc: fastrpc: Add Qualcomm fastrpc basic driver model")
Cc: stable@vger.kernel.org
Signed-off-by: Eddie Lin <eddie.lin@oss.qualcomm.com>
Reviewed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260724223342.629168-6-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -466,6 +466,7 @@ static void fastrpc_channel_ctx_free(str
 
 	cctx = container_of(ref, struct fastrpc_channel_ctx, refcount);
 
+	idr_destroy(&cctx->ctx_idr);
 	kfree(cctx);
 }
 


