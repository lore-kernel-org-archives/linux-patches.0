Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDF130DD1E;
	Mon, 13 Oct 2025 14:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367374; cv=none; b=lUXkl0+X+wUTf2vCTTzGJI/rPVkDhWMbHVqTXJe3mEoKKQA/JZtijg1i7MWwYFdLfUJdc3E9FyXysoo2GFbRbLkOYaUk5M4wdQW8yYMS7cD9/NakiDLbWMMyw+ORyUY8EZHfT7MFuaJaaUqTqk36LHKzwzcNBKU7LoxpxPCs03g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367374; c=relaxed/simple;
	bh=Af8dOZ/wOGYaWvYUBNBGjgnK7UOCrHArNAgGlvCfRnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YocS2rFhOTLYkLIODk4ZSBQDIzcVLePwqBp3b4epRf+ql7IsaEOpI/N8yyBRY3i3QY66wO0+tGn3MZpRTrz7/ZnwtuDe6WftRzlAyAPpuPF2GoJmHhn3SIZrzUt5wpEIta+EXbD08VkJggQ45wBkgfUgvCHig0/HxBHNZAmsmAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAFW2wKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAFW2wKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1A8C113D0;
	Mon, 13 Oct 2025 14:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367374;
	bh=Af8dOZ/wOGYaWvYUBNBGjgnK7UOCrHArNAgGlvCfRnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAFW2wKHe2Q4R9DhxiW43+mjgAw2iswqiImZpEHYLu1MxVoKBgdnV+yyKXoj///U8
	 lAF+8AzJEuJeT2Qx0k2QzpMsr/8iCLTArMtQ6mSZZEEDmwgg2aLU55eDY34r2XAhOm
	 1Pj18+1uJi/haLvy+OeQff+qx6Cf3LpPfWxJF1CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Ling Xu <quic_lxu5@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.1 186/196] misc: fastrpc: Skip reference for DMA handles
Date: Mon, 13 Oct 2025 16:45:59 +0200
Message-ID: <20251013144321.421474060@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

From: Ling Xu <quic_lxu5@quicinc.com>

commit 10df039834f84a297c72ec962c0f9b7c8c5ca31a upstream.

If multiple dma handles are passed with same fd over a remote call
the kernel driver takes a reference and expects that put for the
map will be called as many times to free the map. But DSP only
updates the fd one time in the fd list when the DSP refcount
goes to zero and hence kernel make put call only once for the
fd. This can cause SMMU fault issue as the same fd can be used
in future for some other call.

Fixes: 35a82b87135d ("misc: fastrpc: Add dma handle implementation")
Cc: stable@kernel.org
Co-developed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Ling Xu <quic_lxu5@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://lore.kernel.org/r/20250912131236.303102-5-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -342,9 +342,8 @@ static int fastrpc_map_get(struct fastrp
 
 
 static int fastrpc_map_lookup(struct fastrpc_user *fl, int fd,
-			    struct fastrpc_map **ppmap, bool take_ref)
+			    struct fastrpc_map **ppmap)
 {
-	struct fastrpc_session_ctx *sess = fl->sctx;
 	struct fastrpc_map *map = NULL;
 	struct dma_buf *buf;
 	int ret = -ENOENT;
@@ -358,15 +357,6 @@ static int fastrpc_map_lookup(struct fas
 		if (map->fd != fd || map->buf != buf)
 			continue;
 
-		if (take_ref) {
-			ret = fastrpc_map_get(map);
-			if (ret) {
-				dev_dbg(sess->dev, "%s: Failed to get map fd=%d ret=%d\n",
-					__func__, fd, ret);
-				break;
-			}
-		}
-
 		*ppmap = map;
 		ret = 0;
 		break;
@@ -711,7 +701,7 @@ static const struct dma_buf_ops fastrpc_
 	.release = fastrpc_release,
 };
 
-static int fastrpc_map_create(struct fastrpc_user *fl, int fd,
+static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
 			      u64 len, u32 attr, struct fastrpc_map **ppmap)
 {
 	struct fastrpc_session_ctx *sess = fl->sctx;
@@ -719,9 +709,6 @@ static int fastrpc_map_create(struct fas
 	struct sg_table *table;
 	int err = 0;
 
-	if (!fastrpc_map_lookup(fl, fd, ppmap, true))
-		return 0;
-
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
 	if (!map)
 		return -ENOMEM;
@@ -789,6 +776,24 @@ get_err:
 	return err;
 }
 
+static int fastrpc_map_create(struct fastrpc_user *fl, int fd,
+			      u64 len, u32 attr, struct fastrpc_map **ppmap)
+{
+	struct fastrpc_session_ctx *sess = fl->sctx;
+	int err = 0;
+
+	if (!fastrpc_map_lookup(fl, fd, ppmap)) {
+		if (!fastrpc_map_get(*ppmap))
+			return 0;
+		dev_dbg(sess->dev, "%s: Failed to get map fd=%d\n",
+			__func__, fd);
+	}
+
+	err = fastrpc_map_attach(fl, fd, len, attr, ppmap);
+
+	return err;
+}
+
 /*
  * Fastrpc payload buffer with metadata looks like:
  *
@@ -861,8 +866,12 @@ static int fastrpc_create_maps(struct fa
 		    ctx->args[i].length == 0)
 			continue;
 
-		err = fastrpc_map_create(ctx->fl, ctx->args[i].fd,
-			 ctx->args[i].length, ctx->args[i].attr, &ctx->maps[i]);
+		if (i < ctx->nbufs)
+			err = fastrpc_map_create(ctx->fl, ctx->args[i].fd,
+				 ctx->args[i].length, ctx->args[i].attr, &ctx->maps[i]);
+		else
+			err = fastrpc_map_attach(ctx->fl, ctx->args[i].fd,
+				 ctx->args[i].length, ctx->args[i].attr, &ctx->maps[i]);
 		if (err) {
 			dev_err(dev, "Error Creating map %d\n", err);
 			return -EINVAL;
@@ -1049,7 +1058,7 @@ cleanup_fdlist:
 	for (i = 0; i < FASTRPC_MAX_FDLIST; i++) {
 		if (!fdlist[i])
 			break;
-		if (!fastrpc_map_lookup(fl, (int)fdlist[i], &mmap, false))
+		if (!fastrpc_map_lookup(fl, (int)fdlist[i], &mmap))
 			fastrpc_map_put(mmap);
 	}
 


