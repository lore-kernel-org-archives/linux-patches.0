Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFCD3ACA43;
	Fri,  4 Sep 2026 05:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501188; cv=none; b=WlF1FeCtdGuZxa5WZFLtN//zS3Dtn1KLAzpd64hNjRnHIGvnWZgk33qbtgZcO1TLFO6fFt0jLXaHT/dK4BOSQj9KGM4SbsFrafd43n+iD6Drb7mNM88QLqhN/AvobG+mbKDmQ+uP9YBnAzwE1q+A9GmqZlQdXloz6kZSvDTgas0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501188; c=relaxed/simple;
	bh=RSl47d+7rtjTB8kfXlzzpzNlhFWrata55x8L8OV1U6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jM2zF6cjzITv1PJVRcDq70nmunfLsTZhfeWAM8ooWtMA3LdvTFDhHYeAVQlFgaFNVlJU56B7FBcoecAwxiIpbt8bUr/2dZvId0pNo9rvOjxs11acHrIC7nxiHM2I2JCATKAbfpRCrbmT3UD/X9GrWOadRFNt9+OF70xWsjjd5v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wbo0Bm50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wbo0Bm50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DAD1F00A3E;
	Fri,  4 Sep 2026 05:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501186;
	bh=g5GUPShUquYL9gosY0/Mq77wsB2z41ROgkiv/vi5sSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wbo0Bm50vOAklw85TpqhZuondS2L7Iaw7CCFb/Z10hdvaq8KQftl8sXrETrvtUa1B
	 VFdTQC0BbbRtbZJsX+LNkBGuEpvkZaAKrjSs35NTLr1A4m8KSNUNKsLPH6HloxLR+F
	 m6Pkb3Lx2KNPs/qH3oDBpFaT9g4ZQ/9XR66bYr1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 321/552] RDMA/cxgb4: Cancel reg_work before freeing device on remove
Date: Fri,  4 Sep 2026 06:57:58 +0200
Message-ID: <20260904045757.548362209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -952,6 +952,12 @@ void c4iw_dealloc(struct uld_ctx *ctx)
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


