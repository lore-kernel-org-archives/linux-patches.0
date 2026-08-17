Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297683E5EC0;
	Mon, 17 Aug 2026 14:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978655; cv=none; b=aiWL2pZayecDr/AEvhuFXLq8EohYnN37Iz3U/VDKtCOcJTJLMi0vk+m7XeO0nmwXUDcaBJQj2YMo0tOnRNYridMv20nYouiuOMGNmJrimwHBzVwkrNOC8vrTd8qIHypYc/B77rcm8F/RVei947XVg+PMPbuHuRWNAWrgr4you7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978655; c=relaxed/simple;
	bh=6zl2ZIkUqGTjk4ze8OlDdW9o6Lh1wtoIlfuQ11wfXWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OP2FVKw6j0p3xB5SGMeI/Yzlaef1YJC7mmqaH/E5ibmQRilSu2mjW8ncaX6QDm9/oNVatl62OL2iQllnC/N9F0h3ILyulP5ui51KOeRjTBVrkTrglZjqavvOpakB8jzOXxroskXtEBSD18RrOsOlLbv++eBUvd0Ira9JcRC9114=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlNEtyOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlNEtyOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250F31F000E9;
	Mon, 17 Aug 2026 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978653;
	bh=4yrVu3l/FvzltuYIXxdFXRk77znvyh8/i+uSAEP3+qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlNEtyOrIIfVJ5VOlx9CoHaazT0iibfR5xQfUXoXqgXGFkCGA7DVFGQpT5axvV3Sh
	 M4GLKBjtfh/+bvQzs8PfSazaAPESc7v7WFXXRZiAwvIQiH/yL4RrnuoirdUNMMHGhN
	 MKwMsbmjjPP6Y/2evYksQ08NCYSIQFmYhhkmxBdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Jianping Li <jianping.li@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.6 110/156] misc: fastrpc: Remove buffer from list prior to unmap operation
Date: Mon, 17 Aug 2026 15:34:04 +0200
Message-ID: <20260817132538.924034253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>

commit 6102ceb4eab845743ee57acd3863fbd06e93c927 upstream.

fastrpc_req_munmap_impl() is called to unmap any buffer. The buffer is
getting removed from the list after it is unmapped from DSP. This can
create potential race conditions if multiple threads invoke unmap
concurrently, where one thread may remove the entry from the list while
another thread's unmap operation is still ongoing.

Fix this by removing the buffer entry from the list before calling the
unmap operation. If the unmap fails, the entry is re-added to the list
so that userspace can retry the unmap, or alternatively, the buffer
will be cleaned up during device release when the DSP process is torn
down and all DSP-side mappings are freed along with remaining buffers
in the list.

Fixes: 2419e55e532de ("misc: fastrpc: add mmap/unmap support")
Cc: stable@kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Jianping Li <jianping.li@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260724223342.629168-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1872,9 +1872,6 @@ static int fastrpc_req_munmap_impl(struc
 				      &args[0]);
 	if (!err) {
 		dev_dbg(dev, "unmmap\tpt 0x%09lx OK\n", buf->raddr);
-		spin_lock(&fl->lock);
-		list_del(&buf->node);
-		spin_unlock(&fl->lock);
 		fastrpc_buf_free(buf);
 	} else {
 		dev_err(dev, "unmmap\tpt 0x%09lx ERROR\n", buf->raddr);
@@ -1888,6 +1885,7 @@ static int fastrpc_req_munmap(struct fas
 	struct fastrpc_buf *buf = NULL, *iter, *b;
 	struct fastrpc_req_munmap req;
 	struct device *dev = fl->sctx->dev;
+	int err;
 
 	if (copy_from_user(&req, argp, sizeof(req)))
 		return -EFAULT;
@@ -1895,6 +1893,7 @@ static int fastrpc_req_munmap(struct fas
 	spin_lock(&fl->lock);
 	list_for_each_entry_safe(iter, b, &fl->mmaps, node) {
 		if ((iter->raddr == req.vaddrout) && (iter->size == req.size)) {
+			list_del(&iter->node);
 			buf = iter;
 			break;
 		}
@@ -1907,7 +1906,14 @@ static int fastrpc_req_munmap(struct fas
 		return -EINVAL;
 	}
 
-	return fastrpc_req_munmap_impl(fl, buf);
+	err = fastrpc_req_munmap_impl(fl, buf);
+	if (err) {
+		spin_lock(&fl->lock);
+		list_add_tail(&buf->node, &fl->mmaps);
+		spin_unlock(&fl->lock);
+	}
+
+	return err;
 }
 
 static int fastrpc_req_mmap(struct fastrpc_user *fl, char __user *argp)


