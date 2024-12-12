Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3442153DD;
	Thu, 12 Dec 2024 17:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022984; cv=none; b=Ge6mYWnOgGIHZ4IaXNQ0mkfzZhWWnCiVhp2tHJ/oDtSL1w05gbcPzRj3T0WVRm4eRHzSCbYeXTT279/33qyvX0p44mpNHGJ0w/VrIlax3N+4tK31z8zJQxl5PLbR2NlInc9P8dzoVeWIw0sZyzXEHnrNQ4yPpdcRoOLgjh5jgLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022984; c=relaxed/simple;
	bh=pPGD3p+vJQihMhus/ebdbn2SjF8vM0lx923pWnVa7EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8wv4GjV7Rd2W7ttjIFfp4G2z6bNCR+VXeR9Hn4Nktj+fGAaF0QQgg1mQSZYQNz3Cc44smymbFhwVonWBhj/pNglaTuhhQHJhRDL7Pq+LmX01Vunmiqycu2JDcqYUnqzeAzgB3uOyzqkpz+EWO/Zwv95u0b24rBMIoKbJNnvYOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rg9f/wYo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rg9f/wYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9BCC4CECE;
	Thu, 12 Dec 2024 17:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022984;
	bh=pPGD3p+vJQihMhus/ebdbn2SjF8vM0lx923pWnVa7EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rg9f/wYoBBXm9zkdjiCg4wVE4sAhlARr0KdQIBiJCxSekT3ywfhMd7wshYG3HW9at
	 br1MNL3fd95J+zbz8/3Op+9mz2RFyeh3K901TE9PUJD0Mivqm4ySTLbEk8Kae5vhTR
	 CUVef2Ur3wP2rS6u6QetzjCw+CKpcu2Vhmj5xwqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 357/565] NFSv4.0: Fix a use-after-free problem in the asynchronous open()
Date: Thu, 12 Dec 2024 15:59:12 +0100
Message-ID: <20241212144325.717651159@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 2fdb05dc0931250574f0cb0ebeb5ed8e20f4a889 ]

Yang Erkun reports that when two threads are opening files at the same
time, and are forced to abort before a reply is seen, then the call to
nfs_release_seqid() in nfs4_opendata_free() can result in a
use-after-free of the pointer to the defunct rpc task of the other
thread.
The fix is to ensure that if the RPC call is aborted before the call to
nfs_wait_on_sequence() is complete, then we must call nfs_release_seqid()
in nfs4_open_release() before the rpc_task is freed.

Reported-by: Yang Erkun <yangerkun@huawei.com>
Fixes: 24ac23ab88df ("NFSv4: Convert open() into an asynchronous RPC call")
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f1c351e40c7a5..4a0691aeb7c1d 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2537,12 +2537,14 @@ static void nfs4_open_release(void *calldata)
 	struct nfs4_opendata *data = calldata;
 	struct nfs4_state *state = NULL;
 
+	/* In case of error, no cleanup! */
+	if (data->rpc_status != 0 || !data->rpc_done) {
+		nfs_release_seqid(data->o_arg.seqid);
+		goto out_free;
+	}
 	/* If this request hasn't been cancelled, do nothing */
 	if (!data->cancelled)
 		goto out_free;
-	/* In case of error, no cleanup! */
-	if (data->rpc_status != 0 || !data->rpc_done)
-		goto out_free;
 	/* In case we need an open_confirm, no cleanup! */
 	if (data->o_res.rflags & NFS4_OPEN_RESULT_CONFIRM)
 		goto out_free;
-- 
2.43.0



