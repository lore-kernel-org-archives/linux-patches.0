Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79CF30DD1E;
	Mon, 13 Oct 2025 14:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367370; cv=none; b=PlZTC4Tqp6VrE8xwqGv+W10raWQUSbWzyDZ8iHIna/qIGllHO6ABHtHWQa6jrCEjF+x/19IknHciqu+QQDwj1c7lA6/Qo8FmgLj0WcRLYde+iA+Pm9ZdlpCJEwTNcVw+nWQMMGZ+tMd80kscVyeOE7XBYATX1A8uXcqgjz4qgOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367370; c=relaxed/simple;
	bh=maw307nq1PXyc7LvQmlZTdXZuEu4YqdRlMQEEH9Oyco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVgL796h7RoH6pe9I0ijjkf4NfCtGQfMa4E2J4vuNvkjLzMPSyMHtnj+1wC/flmLZecbi1PYGXXLnb/ZC+1RncEqwZJcw7ddaEwOvSTv9KGRMgv61xrPqR53bkXRvWDcqYrSHAXIa1vSTVWUjnZc7djUcnFO0D1EI/0GjJRQWOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6QKXjub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6QKXjub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBA1C4CEE7;
	Mon, 13 Oct 2025 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367370;
	bh=maw307nq1PXyc7LvQmlZTdXZuEu4YqdRlMQEEH9Oyco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6QKXjubGpl9Ljql8QN2wkCP2Ri6Ua5kfL7dOxbTtYQw4Tzhk1lPw80V3cMDQstRg
	 xrSOoGwvoaUTkgQKlchRJi0US27+6honwpXC8Yx/ULjecZ+38sD5Zjwrc4haoghsAl
	 Txr/PqalS4Qw6n9T+TlqgZWs+P5qg0J3gvZPJ9bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Ling Xu <quic_lxu5@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.1 185/196] misc: fastrpc: fix possible map leak in fastrpc_put_args
Date: Mon, 13 Oct 2025 16:45:58 +0200
Message-ID: <20251013144321.385730409@linuxfoundation.org>
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

commit da1ba64176e0138f2bfa96f9e43e8c3640d01e1e upstream.

copy_to_user() failure would cause an early return without cleaning up
the fdlist, which has been updated by the DSP. This could lead to map
leak. Fix this by redirecting to a cleanup path on failure, ensuring
that all mapped buffers are properly released before returning.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Cc: stable@kernel.org
Co-developed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Ling Xu <quic_lxu5@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://lore.kernel.org/r/20250912131236.303102-4-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1018,6 +1018,7 @@ static int fastrpc_put_args(struct fastr
 	struct fastrpc_phy_page *pages;
 	u64 *fdlist;
 	int i, inbufs, outbufs, handles;
+	int ret = 0;
 
 	inbufs = REMOTE_SCALARS_INBUFS(ctx->sc);
 	outbufs = REMOTE_SCALARS_OUTBUFS(ctx->sc);
@@ -1033,14 +1034,17 @@ static int fastrpc_put_args(struct fastr
 			u64 len = rpra[i].buf.len;
 
 			if (!kernel) {
-				if (copy_to_user((void __user *)dst, src, len))
-					return -EFAULT;
+				if (copy_to_user((void __user *)dst, src, len)) {
+					ret = -EFAULT;
+					goto cleanup_fdlist;
+				}
 			} else {
 				memcpy(dst, src, len);
 			}
 		}
 	}
 
+cleanup_fdlist:
 	/* Clean up fdlist which is updated by DSP */
 	for (i = 0; i < FASTRPC_MAX_FDLIST; i++) {
 		if (!fdlist[i])
@@ -1049,7 +1053,7 @@ static int fastrpc_put_args(struct fastr
 			fastrpc_map_put(mmap);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int fastrpc_invoke_send(struct fastrpc_session_ctx *sctx,


