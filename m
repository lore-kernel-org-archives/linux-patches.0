Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179DD1FCF7D;
	Fri,  6 Dec 2024 15:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498450; cv=none; b=ny9G87hx4jyWiegvBKD2YdlCwoeqyT2EzAnTbQFvGuW5fJaJkD2YXfR7t7VDqBWvXpc7ywfW07Wl6GcdoqDCH8bh8TG5kc8FqG9185nd/BaNLo2NhgvaySIDN+v/7VwAn8L9z0PLXVZFjb48a03dm7wZZJNA4hJ8U2NzL3C7pvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498450; c=relaxed/simple;
	bh=+TsUQVhpR8D3oKK4voG3iNv2lvJYUpPLG/gpHM4aCQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzewzwYf/dk/fDowgWum8YgEJimXLCcSfvnXtkPUutlPB9wfZlFwEa2zTw+9Cc0iB+zJena3KsSBz27LDjSMlSdN1glpRn01FwKSpjsYp6MYN8ZKc1Kar2azGWbH5GbFmghYIi2LH6Ttz3OSkY7FRvqjsVHFUgAtjTii6+fI510=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MifeVz7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MifeVz7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753D5C4CEDF;
	Fri,  6 Dec 2024 15:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498449;
	bh=+TsUQVhpR8D3oKK4voG3iNv2lvJYUpPLG/gpHM4aCQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MifeVz7zMS95NyXlMiRmr22eLQMJPEcYrzjJVArAkLPZaSPFi74fiVPxMQsgdrKLy
	 UzsolYRhn5McOmpGo5tWPAT8joocGOy8bBCWiHVbkJHny/vIBTb2JZgg953rf1r6Ok
	 LqGuC34E6Gd6J/V++bRnH+8qLIAlF+PLacwlLXSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 557/676] NFSv4.0: Fix a use-after-free problem in the asynchronous open()
Date: Fri,  6 Dec 2024 15:36:16 +0100
Message-ID: <20241206143715.126620272@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 299ea2b86df66..4b12e45f57539 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2528,12 +2528,14 @@ static void nfs4_open_release(void *calldata)
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



