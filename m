Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A8C3F23D1;
	Mon, 17 Aug 2026 13:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974406; cv=none; b=N338QjaEKCqzpBa2EzfXv+utvjdfhUQBkCtvRabtG5jUuXn/k2eEShvqfcEaHGFUi0xGSx2ZD3doMkwNOv/CT+DeLXcensW6kZygO5XsyRl6kCxKGlJffxYRRImJ/+fWQSn11GqFImgfiQUmGeKc9AmkfIDLLlZ/H4e2n+mYIsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974406; c=relaxed/simple;
	bh=zHnClN9POHTRRSYOHYsmmWWi6d/emQ5bMbf8x8rurvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOtTxe93Aq50vAotkJv9QGXu9EwWmFGjb8l0IgWGiPOmlni0ZYdX80CyjwfcBQmCipl55qQKVRNHSna01+ze1/NTvmkU77Nwys94T5vhVbZxrmp9fPjjQuxRt0PnjVemF9HNNg2L8Vi67GgqfdHv+WYtAmbQq0eSNTamaFlfP9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kntdLZWC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kntdLZWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE3B1F00A3A;
	Mon, 17 Aug 2026 13:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974399;
	bh=UZmzfW6QgNAhsWy/DWoIKAvGehi+leNamRfueqNyrc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kntdLZWCcIBCqZN/wa+4npCIJdjQOxyjha1C2Prg69YDWx14Thjne9yotwZ0tQ0xg
	 vzXs8TxS+n3EaUAEGd797ikuK8c0oyY7FBikZVJ2tfNjq4DOv3/CFqF34jHxIRyL5u
	 bsorZUHjSfOrSbZjCa7PK41lzsOhA11eiSfAz95I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie Lin <eddie.lin@oss.qualcomm.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 7.1 192/271] misc: fastrpc: fix memory leak in fastrpc_channel_ctx_free
Date: Mon, 17 Aug 2026 15:31:57 +0200
Message-ID: <20260817132544.714152831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eddie Lin <eddie.lin@oss.qualcomm.com>

commit 2fae94ee14f7fea11d3f95e10383a87c01d21518 upstream.

The 'ctx_idr' is initialized but never destroyed when
the channel context is freed, leading to a memory leak.
Add idr_destroy() to properly clean up the IDR resources.

Fixes: f6f9279f2bf0 ("misc: fastrpc: Add Qualcomm fastrpc basic driver model")
Cc: stable@vger.kernel.org
Signed-off-by: Eddie Lin <eddie.lin@oss.qualcomm.com>
Reviewed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260724223342.629168-6-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -492,6 +492,7 @@ static void fastrpc_channel_ctx_free(str
 
 	cctx = container_of(ref, struct fastrpc_channel_ctx, refcount);
 
+	idr_destroy(&cctx->ctx_idr);
 	kfree(cctx);
 }
 


