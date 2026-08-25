Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2575B409265;
	Tue, 25 Aug 2026 13:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665884; cv=none; b=gqUvJTxFqx4Gc9QTxvduuZ7eAhk6QofsFzcXxNW8g3OqUvvVJ8/IGrKBa79ZEi7oRzZNMAZDCTTNrG6SNR50qfw4OsT//FyUuEcB5Vls8KSSyH947MG8BwsUQfYtmCi5sR0t8LyQHsr6L6jLjBPlgxMwkTSBw2fhDVvEhANq2N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665884; c=relaxed/simple;
	bh=6wIcJZ0k5/ggJ+SDU4jbqh9DSu+uIaFdnFCo7JhLMqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3TVLDAt7U/hgLyKkDCQ+vMHp22CQoK0JTU6FR+pDdYOb+Y0A8tXPGmcK3+KmrxYeYdOK6QTm3XGgggd6Xjwke1ckyJaavjfyM/7Bj4hBfZrLfEUxUtC5fGrfio9U7LNyc82o1dXIBubRQoRI3YA1b4zJ30FH2riNn5B5DPi+vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/DLzURS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/DLzURS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C43A1F000E9;
	Tue, 25 Aug 2026 13:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665883;
	bh=7PAaC0juA1gdlrtAtvjnh7HHDygXfB6cCWpS68AF1/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/DLzURSxLtgDqIRNQ45kfr+LEerd2iCcmFnYKdjtX+So6IqaXr0HCsZNmfAXR49B
	 FwkpTiVzFrG5cOfNqNdtDn3OgNTmojI1dqiaypHwBy82BL3Haevx8dlDfdI0hq6I6v
	 csS3J35pRlY5VV0RoYE30/RUd0iVmvRgt1p61Pa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/79] misc: fastrpc: Rework fastrpc_req_munmap
Date: Tue, 25 Aug 2026 15:25:51 +0200
Message-ID: <20260825132542.105156372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 72fa6f7820c4cf96c5f7aabc4e54bdf52d1e2ac2 ]

Move the lookup of the munmap request to the fastrpc_req_munmap and pass
on only the buf to the lower level fastrpc_req_munmap_impl. That way
we can use the lower level fastrpc_req_munmap_impl on error path in
fastrpc_req_mmap to free the buf without searching for the munmap
request it belongs to.

Co-developed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20221125071405.148786-7-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 6102ceb4eab8 ("misc: fastrpc: Remove buffer from list prior to unmap operation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1657,30 +1657,14 @@ static int fastrpc_get_dsp_info(struct f
 	return 0;
 }
 
-static int fastrpc_req_munmap_impl(struct fastrpc_user *fl,
-				   struct fastrpc_req_munmap *req)
+static int fastrpc_req_munmap_impl(struct fastrpc_user *fl, struct fastrpc_buf *buf)
 {
 	struct fastrpc_invoke_args args[1] = { [0] = { 0 } };
-	struct fastrpc_buf *buf = NULL, *iter, *b;
 	struct fastrpc_munmap_req_msg req_msg;
 	struct device *dev = fl->sctx->dev;
 	int err;
 	u32 sc;
 
-	spin_lock(&fl->lock);
-	list_for_each_entry_safe(iter, b, &fl->mmaps, node) {
-		if ((iter->raddr == req->vaddrout) && (iter->size == req->size)) {
-			buf = iter;
-			break;
-		}
-	}
-	spin_unlock(&fl->lock);
-
-	if (!buf) {
-		dev_err(dev, "mmap not in list\n");
-		return -EINVAL;
-	}
-
 	req_msg.pgid = fl->tgid;
 	req_msg.size = buf->size;
 	req_msg.vaddr = buf->raddr;
@@ -1706,12 +1690,29 @@ static int fastrpc_req_munmap_impl(struc
 
 static int fastrpc_req_munmap(struct fastrpc_user *fl, char __user *argp)
 {
+	struct fastrpc_buf *buf = NULL, *iter, *b;
 	struct fastrpc_req_munmap req;
+	struct device *dev = fl->sctx->dev;
 
 	if (copy_from_user(&req, argp, sizeof(req)))
 		return -EFAULT;
 
-	return fastrpc_req_munmap_impl(fl, &req);
+	spin_lock(&fl->lock);
+	list_for_each_entry_safe(iter, b, &fl->mmaps, node) {
+		if ((iter->raddr == req.vaddrout) && (iter->size == req.size)) {
+			buf = iter;
+			break;
+		}
+	}
+	spin_unlock(&fl->lock);
+
+	if (!buf) {
+		dev_err(dev, "mmap\t\tpt 0x%09llx [len 0x%08llx] not in list\n",
+			req.vaddrout, req.size);
+		return -EINVAL;
+	}
+
+	return fastrpc_req_munmap_impl(fl, buf);
 }
 
 static int fastrpc_req_mmap(struct fastrpc_user *fl, char __user *argp)
@@ -1720,7 +1721,6 @@ static int fastrpc_req_mmap(struct fastr
 	struct fastrpc_buf *buf = NULL;
 	struct fastrpc_mmap_req_msg req_msg;
 	struct fastrpc_mmap_rsp_msg rsp_msg;
-	struct fastrpc_req_munmap req_unmap;
 	struct fastrpc_phy_page pages;
 	struct fastrpc_req_mmap req;
 	struct device *dev = fl->sctx->dev;
@@ -1782,11 +1782,8 @@ static int fastrpc_req_mmap(struct fastr
 	spin_unlock(&fl->lock);
 
 	if (copy_to_user((void __user *)argp, &req, sizeof(req))) {
-		/* unmap the memory and release the buffer */
-		req_unmap.vaddrout = buf->raddr;
-		req_unmap.size = buf->size;
-		fastrpc_req_munmap_impl(fl, &req_unmap);
-		return -EFAULT;
+		err = -EFAULT;
+		goto err_assign;
 	}
 
 	dev_dbg(dev, "mmap\t\tpt 0x%09lx OK [len 0x%08llx]\n",
@@ -1794,6 +1791,8 @@ static int fastrpc_req_mmap(struct fastr
 
 	return 0;
 
+err_assign:
+	fastrpc_req_munmap_impl(fl, buf);
 err_invoke:
 	fastrpc_buf_free(buf);
 


