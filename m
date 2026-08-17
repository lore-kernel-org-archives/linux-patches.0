Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388ED421220;
	Mon, 17 Aug 2026 15:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980554; cv=none; b=VGTDn7xLGTBy6OxbKTQWPvEC8JFgbeN+hUEsr1Dm61zW7cUymNzvVmVq+dzCj2pEekADjEr7rn2GPh+1ESBwWNRJgvINUg+C+XbJGbRmsCWlxirjYlXXsOegRoiuq8vGIua7OCaTkeP18HvuG44QwA1J2/CpRo9tgg/zfweiuyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980554; c=relaxed/simple;
	bh=YMdXaIxRjdrma+Iri0QY2VNvfWCcy4Kx/eqJRksMBG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLdjOACAYSijgRkib+A1Pz+gDA7wMd+pUeZQRq1CjfSkGkCjRinRrsYS3ZlxJw6bQpCSTVSIGT79ybyv9mEcXnqMMKtwQs5OEKGFod6jgRfALQ2MgB8XKTYc5jfnIOiqOTxf9MiGpO+aHzzl9rjoc+l567+WqnUkXkLV/2tuD20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ta22PUJ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ta22PUJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E8F1F000E9;
	Mon, 17 Aug 2026 15:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980553;
	bh=a7dnKPyZI3MZDlq+bgIK6ugwS355gpg1WkWB7oULrO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ta22PUJ2amfLAbB8Het6oxQ6pnXClv+mO3TtpZjg4aHXBd0oIpuksMIaBiZLQroTt
	 1TFYUinxt60eKiYvTkymWHIwjZ3sQvwAHRBpjmcSW8Ed4CuTDsK/K2xpczf9re4qjk
	 h7WFSqeRh2JU0kdUoEmaC+yJ4d7q216UpXPXrW9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie Lin <eddie.lin@oss.qualcomm.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.1 575/609] misc: fastrpc: fix memory leak in fastrpc_channel_ctx_free
Date: Mon, 17 Aug 2026 15:34:31 +0200
Message-ID: <20260817132602.956388717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -426,6 +426,7 @@ static void fastrpc_channel_ctx_free(str
 
 	cctx = container_of(ref, struct fastrpc_channel_ctx, refcount);
 
+	idr_destroy(&cctx->ctx_idr);
 	kfree(cctx);
 }
 


