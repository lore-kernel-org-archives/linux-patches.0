Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FE01E525;
	Mon,  1 Apr 2024 16:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990057; cv=none; b=HvoTo7XRA3Yd7i/779UHmAHvzbIhJpZWpXC207G0CEmtM01zlpib04RyHodePADCczqj1hTiwxxB7bU18LTMRI/eOcuENqS3k1fQBXeGRR2mddSawgXOx3cnurSmDUVRFTjNh9rYhtu8SlTMB9XI5ySyfpQDz5oquFUawnxMJss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990057; c=relaxed/simple;
	bh=XzL4BJnuChXQeTl6MbL2CNyEwU8ZGf7YlowQcitomng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Idhex+nDJeT1pZgXc9fwOOJBVzD3PWFBGpP32rpCE872BkRvsCjMIRe3nBuZ2trdxT9vxty2E8URrB4gvgiShFm/1cIF/g6eki7iH2mA4I9uTHTL+jeIB75+74vD/pi37C8Xqa72bXPBZTxswqnOaZ7XxoGPAJKefSf3yyPV0VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y74eZF45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y74eZF45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F09C433F1;
	Mon,  1 Apr 2024 16:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990057;
	bh=XzL4BJnuChXQeTl6MbL2CNyEwU8ZGf7YlowQcitomng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y74eZF45GowE9tgFuNXyYxRX1LnKQK+/sR0jCUGlPvyNoRr2JZ949yGlZLpNqfCK1
	 L+VdNvWhuaAZsuCG5IyllddBl+baMdVANnRCkmNIvE4NRYB0QoO1FwygI0KCWImvqB
	 +aoaQHQkHaAI6lOkziSbOJp41+hhodTNHrYuO4E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <nico@fluxnic.net>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 233/396] vt: fix unicode buffer corruption when deleting characters
Date: Mon,  1 Apr 2024 17:44:42 +0200
Message-ID: <20240401152554.863276297@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nico@fluxnic.net>

commit 1581dafaf0d34bc9c428a794a22110d7046d186d upstream.

This is the same issue that was fixed for the VGA text buffer in commit
39cdb68c64d8 ("vt: fix memory overlapping when deleting chars in the
buffer"). The cure is also the same i.e. replace memcpy() with memmove()
due to the overlaping buffers.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Fixes: 81732c3b2fed ("tty vt: Fix line garbage in virtual console on command line edition")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/sn184on2-3p0q-0qrq-0218-895349s4753o@syhkavp.arg
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -381,7 +381,7 @@ static void vc_uniscr_delete(struct vc_d
 		u32 *ln = vc->vc_uni_lines[vc->state.y];
 		unsigned int x = vc->state.x, cols = vc->vc_cols;
 
-		memcpy(&ln[x], &ln[x + nr], (cols - x - nr) * sizeof(*ln));
+		memmove(&ln[x], &ln[x + nr], (cols - x - nr) * sizeof(*ln));
 		memset32(&ln[cols - nr], ' ', nr);
 	}
 }


