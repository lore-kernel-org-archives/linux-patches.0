Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C1130C36E;
	Mon, 13 Oct 2025 15:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367936; cv=none; b=GzeiENpG0m4QvzeAyQYQBG6f1NYQTQwBu2OWqBZ59uX93al3EIV1ESltVeKifgajCO6CqdtI3BK8ppmduhpkH54YEPOMY3IXY0GiWXXE/ZN64t6pc5fI1mrUPVyjwqGr97+RBy0hjU7AjahRzrP8/aqQbzSB/cHz3Vzef77rNMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367936; c=relaxed/simple;
	bh=5HR/iwMS+zG5GwjepctXO5JQ4r2GqXxvtEcVPcE+i/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvb5jnwp7YzjrP1rG0xlgZKjKwkqCi/ZVgMZRVDgqN1rrQvglrPTN5gMqLQNLP6uENdPM0l3s8BtOer4bwoY/+flm42YuyQh7Zw9jVblLNW9Xfb5tSoPKosXfVrNYw+GOjbQES//yIaB5aWUNoIEz3J5W0U/5v8zkd0GgIBwV+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuajIONj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuajIONj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D96C4CEE7;
	Mon, 13 Oct 2025 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367936;
	bh=5HR/iwMS+zG5GwjepctXO5JQ4r2GqXxvtEcVPcE+i/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuajIONjcjt0ThIJ/6ioSaHHreRTxpJU3RPIA9ocSHDUjd38sbpRWjzjAakLRhfoi
	 oT2KNmNMgVGTZZzvHFTSWaSEXy9ENyMcXuR0XQxnsi5bHmFr0Rqpd5fQ0cgS2lqviu
	 kUWL37YcwbQfOE+OAFc/TPzNgCK5XSEFVKKh5b5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Ling Xu <quic_lxu5@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.6 185/196] misc: fastrpc: fix possible map leak in fastrpc_put_args
Date: Mon, 13 Oct 2025 16:46:16 +0200
Message-ID: <20251013144321.999935125@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
@@ -1072,6 +1072,7 @@ static int fastrpc_put_args(struct fastr
 	struct fastrpc_phy_page *pages;
 	u64 *fdlist;
 	int i, inbufs, outbufs, handles;
+	int ret = 0;
 
 	inbufs = REMOTE_SCALARS_INBUFS(ctx->sc);
 	outbufs = REMOTE_SCALARS_OUTBUFS(ctx->sc);
@@ -1087,14 +1088,17 @@ static int fastrpc_put_args(struct fastr
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
@@ -1103,7 +1107,7 @@ static int fastrpc_put_args(struct fastr
 			fastrpc_map_put(mmap);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int fastrpc_invoke_send(struct fastrpc_session_ctx *sctx,


