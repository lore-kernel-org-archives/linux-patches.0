Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA921E2613;
	Tue,  3 Dec 2024 16:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242681; cv=none; b=rajGNCa2oDySpGsyN9C6tUimq7Ds/5MocVjjO4EVDPWEkO5rC+lzGjfXzJ0vDZ2K3fs+HT6e2vLN8Foa+W1f7X6gfBoGMJZ/eY4UR1O+O7IDJb48N3SmVvee1OU8lkzOChm5kAi+pQYfSqpBayeEVCwD6wk6JidLOk47guGujsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242681; c=relaxed/simple;
	bh=oi2y8Qdn6h4gLT3gjWWyo327eY0P+Ewqinfk1cvdPAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cY5oYyALbkkuZJnO9eKyQRv2MDB0mvNu+f4NK+v6QvOxag+T8ysnSwchfDD8/gNRxhEyyVABi2u5CeGuQP5WD3om9pLeHNRxs33bi9/YKbE7xVJtHx5ym2St4shJpIR7LAEgKICjbX4HfLx9J1t982q5jVU4ifnbxLZEpE0+jlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q5Ag9Nr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q5Ag9Nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B0DC4CECF;
	Tue,  3 Dec 2024 16:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242681;
	bh=oi2y8Qdn6h4gLT3gjWWyo327eY0P+Ewqinfk1cvdPAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1q5Ag9Nr9cZSQZUIqENc0+R3UwsPMXv6JM3OtHOJTrdLYaruF4SNH0XDBE43pDEUE
	 /9CFucih3rdRke+ukEKj95Tljlet/YIzM3neba0zLWcx3YNPqFMZfio20mFV7iZ28m
	 rdmdj5kjCv+bsNNZ3e3q7mLLG83OW/1XXf36otzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 777/826] NFSv4.0: Fix a use-after-free problem in the asynchronous open()
Date: Tue,  3 Dec 2024 15:48:24 +0100
Message-ID: <20241203144814.075677959@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9d40319e063de..405f17e6e0b45 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2603,12 +2603,14 @@ static void nfs4_open_release(void *calldata)
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



