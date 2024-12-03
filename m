Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04A61F667E;
	Tue,  3 Dec 2024 14:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236666; cv=none; b=us2jqXDitaDBLuIpJTw4R8itY/1W+MKNoStCoNleFt/8Qd+eAalXzGjs+qzCndNwDCj1oo1L54T/RN50wwLATLUcnnsG6r/rgs+tdd4C3mqmqRvPF2a002EBL0fxDZP/ZKpMUA0y6m+yGkn+VRkUJI3LqPRQYSMLYnTR446cb94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236666; c=relaxed/simple;
	bh=7uDM3u/65dPMV4mZ7hGOAHym57U8fA5aRMHJOFAis9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoWBgUM+/OwcCRPiz2z7nNQ6rbJIFCPvqeq9SyrDYnz+YDCTr1ydJoUMNmO+7ybUxRjwt9QdgyymGfNbBrYyW5qkfYA2zuAE7YtvAiIEwW9K91EuJyeRjQ+mcKik84dHTLPJItr66+n+Og9GyZ8DtIB0/KEciSIUOlJXehdBank=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmJe9qAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmJe9qAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4856EC4CECF;
	Tue,  3 Dec 2024 14:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236666;
	bh=7uDM3u/65dPMV4mZ7hGOAHym57U8fA5aRMHJOFAis9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmJe9qASefxitLPpoAltuEpw6swZh/UG8+pPkwk2pV3vzb3W0mFKl/XLZzzvKinXX
	 b6x/urSkqjKcup94vXsHWOLJg4LEO4Dri0gcQm7wJxCvA33RHDBG2eMuAVboa1fJqp
	 ReQmOj72lmZowWHE0L4E453EIvEHzbsGxUogpiEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/138] NFSD: Prevent NULL dereference in nfsd4_process_cb_update()
Date: Tue,  3 Dec 2024 15:31:54 +0100
Message-ID: <20241203141926.819882670@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1e02c641c3a43c88cecc08402000418e15578d38 ]

@ses is initialized to NULL. If __nfsd4_find_backchannel() finds no
available backchannel session, setup_callback_client() will try to
dereference @ses and segfault.

Fixes: dcbeaa68dbbd ("nfsd4: allow backchannel recovery")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index e6c7448d3d89a..8ca4c12dd22ec 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1134,6 +1134,8 @@ static void nfsd4_process_cb_update(struct nfsd4_callback *cb)
 		ses = c->cn_session;
 	}
 	spin_unlock(&clp->cl_lock);
+	if (!c)
+		return;
 
 	err = setup_callback_client(clp, &conn, ses);
 	if (err) {
-- 
2.43.0



