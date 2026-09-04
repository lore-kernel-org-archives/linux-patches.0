Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB59132470E;
	Fri,  4 Sep 2026 06:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502635; cv=none; b=EtQJy51jalG/flZoe0QCAewWW9xPrDKjF/tm8egAWNqMHO3xMMf/8CEPp2jD16FcEI6nnwxFiD4l7wIIW4VskhhNcxNATRYXX64BItrtpqUXY259rwfTIpeixrRcgdzKMZb4i4jz31RvV6OvXFZZKw0Eab+ZXmimXAOYFTwnn5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502635; c=relaxed/simple;
	bh=LpX9jcgqFdD4sgSaL3MH2h9hXKhmSW98aQZ67NPwoIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/1lKhlNJrG5VSImaCSTQNqHlBIu92pDxKnMIphBdb1IVz49ChTrBrYLMix6Zace1clWX84szYANy8GDmUkzlx0eE4SpmKKo8H2K/TVGkfotGyU5GAZdjGZtRZ6o5JYLPzgnEPGyazGwd98lwc3re7sQPiZSanbJNHWyYI+oabg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oTLP7wJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oTLP7wJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF931F00A3D;
	Fri,  4 Sep 2026 06:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502633;
	bh=F+cQWbbUUXSp5BJQaYYi8Zs/hVgfd0jEiB9rlQKu2GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0oTLP7wJSx/aCwAlFuG8jnquqQPOhCu9LiY1zrF6mA+qH6SRa9Nk1/xT6N1YTCkq2
	 /R/gcJxUHFv0TC3cfCtx1i9ZTiPFn1lz7e2pTGZ2xL+91MA1jZwqtAiEMYuXgMOkiG
	 ejSB/RMHSB+aL7pcYSu/T9SB+RtaF4phb7mLV+Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 233/403] RDMA/cxgb4: Cancel reg_work before freeing device on remove
Date: Fri,  4 Sep 2026 07:00:36 +0200
Message-ID: <20260904045740.166553103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit a7100601aa1a39f799a566acce10db20eaf4b7f2 upstream.

c4iw_uld_state_change() queues reg_work to register the RDMA device.
c4iw_remove() can free ctx->dev while this work is pending or running,
leaving c4iw_register_device() accessing the freed device.

Cancel reg_work before removing the device.  The registration work can
tear down ctx->dev when registration fails, so do not unregister or
deallocate it again in that case.

This issue was found by an in-house static analysis tool.

Fixes: 1c8f1da5d851 ("iw_cxgb4: Fix possible circular dependency locking warning")
Link: https://patch.msgid.link/r/20260806130128.465460-1-fanwu01@zju.edu.cn
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/cxgb4/device.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -953,6 +953,12 @@ void c4iw_dealloc(struct uld_ctx *ctx)
 static void c4iw_remove(struct uld_ctx *ctx)
 {
 	pr_debug("c4iw_dev %p\n", ctx->dev);
+
+	/* c4iw_register_device() may still be using ctx->dev. */
+	cancel_work_sync(&ctx->reg_work);
+	if (!ctx->dev)
+		return;
+
 	debugfs_remove_recursive(ctx->dev->debugfs_root);
 	c4iw_unregister_device(ctx->dev);
 	c4iw_dealloc(ctx);


