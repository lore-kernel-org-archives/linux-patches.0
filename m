Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499482FE564;
	Mon, 13 Oct 2025 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368732; cv=none; b=An0tDasPFDPfsO9CgL6RgrCAwfLuaA/I9ODjsw3csNog9oYaukX6ve7FxQ19hyOtKz8Q9KzYNumTi8q4fGy8F7zNrfHvxLjD3DsZAr8XEIIzUsvnil2MAxwyKYS0mVhfCE7eOxTQIP9KKk2jp4zX7POFk1PZdmeSsiZ8KN3MEfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368732; c=relaxed/simple;
	bh=r4slTj/as8ygRiHfUJvK0Krxz5msInM/pghMKKSf8jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvxYN+Cw41yl+9fTK0N4pcXiWviRPDPpUrItWAsDmumhrNn1SL061WGktewucqpiUPb0wtHRqSXw8o+LITQmu/hHSBWDewqaW4J/fke7uIMMw2B5HCNBAsfJZhzqT+cKfKmfZ9hfDnwzRrT/xk/0PJQDxOVuR+uQ2VSFffoj0+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gc1l1u4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gc1l1u4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD30EC4CEE7;
	Mon, 13 Oct 2025 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368732;
	bh=r4slTj/as8ygRiHfUJvK0Krxz5msInM/pghMKKSf8jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gc1l1u4GdsAeX+Y0oX77FClu1nUi+8kTcqOzUi5c3NQAmL8KftkqN4rrDHND5IT2M
	 iS4CB7mQJQBsDkIXVsSlftu2gye99MpdYJI3PYTr/QWtsaFgVXSed8YYU7Q+wCIoGr
	 APARVqwkj2EJ19glsHKI4JdrJSPZjBzdvPZlxNJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Ling Xu <quic_lxu5@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 249/262] misc: fastrpc: fix possible map leak in fastrpc_put_args
Date: Mon, 13 Oct 2025 16:46:31 +0200
Message-ID: <20251013144335.205016861@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
@@ -1085,6 +1085,7 @@ static int fastrpc_put_args(struct fastr
 	struct fastrpc_phy_page *pages;
 	u64 *fdlist;
 	int i, inbufs, outbufs, handles;
+	int ret = 0;
 
 	inbufs = REMOTE_SCALARS_INBUFS(ctx->sc);
 	outbufs = REMOTE_SCALARS_OUTBUFS(ctx->sc);
@@ -1100,14 +1101,17 @@ static int fastrpc_put_args(struct fastr
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
@@ -1116,7 +1120,7 @@ static int fastrpc_put_args(struct fastr
 			fastrpc_map_put(mmap);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int fastrpc_invoke_send(struct fastrpc_session_ctx *sctx,


