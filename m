Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AAB646;
	Tue,  3 Dec 2024 15:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239894; cv=none; b=mSoQevD3RX6i5OZfaA62PtVrQ0XVkPoXJtNO6uIJ/okHAN5NzuEeg+/TkuCKeNjA/lc/C1rTs4+s4E4xLvERHA0kVChqEBEF8sz6P5zUverMD7TIBK+HlOqwd+TFSRKLcFz3czbzWWW1pE53mJWd9T34gIOITMdVLqQ+3AQrVNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239894; c=relaxed/simple;
	bh=Yo3Xtw7LVsGFVRtOifnOSWNdU80iv7AX1buPN8tuD8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQkDnpCzmgA+jMpBAEPrhx/KB6Tc0TUkQMxN+/xDPsW4+O0H0Fd+zTV1HAmbEfMEOiz8hxstUTPFgeSHLSOlzXiZOQoZzPseyBk6xyqvM5Rx5MLQTX6ZzDekZuYOqHVG4JwTh6v+LGnRxEDyLBK7YyqFW94S4iMzvNqbXRUrfmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aow66meW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aow66meW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A20C4CECF;
	Tue,  3 Dec 2024 15:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239894;
	bh=Yo3Xtw7LVsGFVRtOifnOSWNdU80iv7AX1buPN8tuD8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aow66meWtMeQfc3Qn3Ce7dgE+7/rYnajTSawaCfM6NperHV8WpzTQsUtr2mA4k4CH
	 Fri8D9IC9WHk8pnAt8flsgCc8DwVQU5uobl0vAbJTBwK28gv0+JMwG1R1p2lJ+TYPz
	 gkVG+VArC6OVnyob08CAqvQI5MAQ2SdU3jfE3rvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 770/817] NFSv4.0: Fix a use-after-free problem in the asynchronous open()
Date: Tue,  3 Dec 2024 15:45:42 +0100
Message-ID: <20241203144026.070778183@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



