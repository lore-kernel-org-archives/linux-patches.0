Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAF5446C18;
	Tue, 25 Aug 2026 13:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666128; cv=none; b=V2Qi1+lsxEuNY+2PNhdLSm5sUlatWOd5UbUKd1Ke0lnS9pIL0TZE159Eu6Si8KsnS62NRctA2s6yADKq1fNsK1nWWkkwgXIGarjSrrzrzwr8stHpFWbzA/xsso8pDNcMDImetz6E0bgOi6wdGvc5F7MOamVIuKRzkEG8Likhwv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666128; c=relaxed/simple;
	bh=/YC9gFRhhAy9GuZFoLI2UoPIbJZLwsVrXBEqpBuNUJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sosEhw1WVFQZGdyQZnZoF2NzSeF/KnX3obcGWjSpOuQB0sHWFjsXCNh9JZqjrsGePNT5m5sp+Xzpg3HK9gRmUpu8Whr6BkY2XU/r4HrAym8QbylpwjyFckAmPytdn27kxxWYRohNyNGMxv5Z7zanz0/xrJxb2gTmZK7fV5Rc7Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xX1iIG4U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xX1iIG4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73341F000E9;
	Tue, 25 Aug 2026 13:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666127;
	bh=5n2p9sAum1SPkoGI4SdYdrc6gqezdPRVvszNkYy1Ny4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xX1iIG4U20//CnitA8yE4VOS7bXXeLxG88rfsZRKTJtetkv653C3itxiYnY6Id5Vo
	 CwglUQ62PYbiwcowmSJmSE6KnqItM/AgX5fxDSl9u2Slk1utdPzsxD0TDYlVnFm3wp
	 vDi++LSQlo0YjNmu62TsP/LehlJobUs0S7ZOQqD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Jianping Li <jianping.li@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/76] misc: fastrpc: Remove buffer from list prior to unmap operation
Date: Tue, 25 Aug 2026 15:26:07 +0200
Message-ID: <20260825132542.089908319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>

[ Upstream commit 6102ceb4eab845743ee57acd3863fbd06e93c927 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1409,9 +1409,6 @@ static int fastrpc_req_munmap_impl(struc
 				      &args[0]);
 	if (!err) {
 		dev_dbg(dev, "unmmap\tpt 0x%09lx OK\n", buf->raddr);
-		spin_lock(&fl->lock);
-		list_del(&buf->node);
-		spin_unlock(&fl->lock);
 		fastrpc_buf_free(buf);
 	} else {
 		dev_err(dev, "unmmap\tpt 0x%09lx ERROR\n", buf->raddr);
@@ -1425,6 +1422,7 @@ static int fastrpc_req_munmap(struct fas
 	struct fastrpc_buf *buf = NULL, *iter, *b;
 	struct fastrpc_req_munmap req;
 	struct device *dev = fl->sctx->dev;
+	int err;
 
 	if (copy_from_user(&req, argp, sizeof(req)))
 		return -EFAULT;
@@ -1432,6 +1430,7 @@ static int fastrpc_req_munmap(struct fas
 	spin_lock(&fl->lock);
 	list_for_each_entry_safe(iter, b, &fl->mmaps, node) {
 		if ((iter->raddr == req.vaddrout) && (iter->size == req.size)) {
+			list_del(&iter->node);
 			buf = iter;
 			break;
 		}
@@ -1444,7 +1443,14 @@ static int fastrpc_req_munmap(struct fas
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


