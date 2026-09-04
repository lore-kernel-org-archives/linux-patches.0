Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B052F3D6664;
	Fri,  4 Sep 2026 05:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499515; cv=none; b=dkYTqqnVc55t/tlHrY5gsF0JZhvM9w3AMGfX/3Oti6U5N8cAGGg0eKrmRuS7kYKlzWpd3EtDWPgSHjd+G/YIzbCqNOMIMj8nVVAnyleTIdXvFt2MFKlcQkUGtwlaCD1NdXzQvpUk4y5MXXqEDZ1xqKVNNRQBHAkiAL36T5PuWVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499515; c=relaxed/simple;
	bh=6lHlxcMKknI23tvnFj1oH9nlNQIUm8aOo2n/nfcK5xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjfSciOgkTg48SCVI4grlyHSvBNIB9de7M1R5IOinyf/6ekjJMDIwxDX3ql2P7fHB91uolU8mTEV/L/9Y6/id4VjfqykoO/xckg+iQr/ZEVHz20U/HMP8P54sP6XEyXR18AxWrog5fq8nCr8o73M1aT8aewP+7JHYgkR1aWAD9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZnHtIJL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZnHtIJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147B01F00A3E;
	Fri,  4 Sep 2026 05:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499513;
	bh=KINPChKr/5wvhSyDaJJmIcKFHu60HFhgacSUnaOk6yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZnHtIJL+UB950cBqTdea09GIiUqDzrmqPd9eFiyizIhtrFfRpDtqfC5dhNoQYKqX
	 wZAj7HaTVR/QSfqsymIUFlB+uPgjmf4fj46x9ueUuZjhElWyh+IHW3j8qvF/sGW/O4
	 KftWFuaZO6CkPSEx1Ty75Puh5JAC4LtrOYZ8Hjd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.2 442/713] RDMA/cxgb4: Cancel reg_work before freeing device on remove
Date: Fri,  4 Sep 2026 06:56:50 +0200
Message-ID: <20260904045813.739506379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -951,6 +951,12 @@ void c4iw_dealloc(struct uld_ctx *ctx)
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


