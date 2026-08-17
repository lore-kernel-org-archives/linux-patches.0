Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D3843B6F2;
	Mon, 17 Aug 2026 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978190; cv=none; b=i6gIfwhUtukh+2srZldWZsJ0i2ap5Dc+2ax3argSrwqU8h2Khpp4T0OZUsO4qOCPSRNF9/SrouCEmfdvv9SebrHrsZ91RpsKv9yqxqVW1yxb1ToPcBrYouVS5opH7xyd5grBBKbjQh3UvY18M1qf9gFoufZgtt95H0M62egeymI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978190; c=relaxed/simple;
	bh=pzppQvYENv7XYv+Qvo9kcNAF+L+zXCnEH5I1/csA6gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjAokaUfZyFWgqdU9ZYunnovxNTPgL7RybMazg5PHG2PoGzlMDng40i8leAn4B1ct2nQtEk1+U086FbfspKlHeU8a0sr2omkHCt6/iRYvsUOML4xOwqGH1Mv9qnAifMmI44zVHVsoMdMW0xIrF2PQIvs922r7b3xOtLjnle+Psk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N04a8uTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N04a8uTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57861F000E9;
	Mon, 17 Aug 2026 14:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978188;
	bh=DKxr9QWyJkSGCBnLVspcP1DhXocW9s39dfZR8Wo1nYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N04a8uTMRTsfFtUNg/Ykm7a9tsyOyIrj992IZzFVyakYLuGl50UpyCDKUk7ydEqLa
	 XNrklTuUw6J+SNxevx0xHlgCxACpRQbwPp1N/QpnQbuCWWsncl/E1S3Xk6OnbQpwso
	 c2iMKeZjxM8RLCdhfKrJZ0l4XEbWjQRvwhBJjXt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie Lin <eddie.lin@oss.qualcomm.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 133/181] misc: fastrpc: fix memory leak in fastrpc_channel_ctx_free
Date: Mon, 17 Aug 2026 15:33:47 +0200
Message-ID: <20260817132540.855066544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -469,6 +469,7 @@ static void fastrpc_channel_ctx_free(str
 
 	cctx = container_of(ref, struct fastrpc_channel_ctx, refcount);
 
+	idr_destroy(&cctx->ctx_idr);
 	kfree(cctx);
 }
 


