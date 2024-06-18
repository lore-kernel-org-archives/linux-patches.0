Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B4D176AB0;
	Tue, 18 Jun 2024 12:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715452; cv=none; b=UCUdXzkuzHGmJjX+1yA+RDgkTs17nLswrhDu0KTinfNV5nOV/Jmnbi1graG9Fq6dQXl0WmsO2YE5/xYBcDbWXCV/ZRimuuV/z+sfFwBegAwe/FwSYTbVTuamZZJ/6DpXrnXBq4Ucec8oEP+WuW7qZ8Ar2kuQo9XiIyVUa5E9BTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715452; c=relaxed/simple;
	bh=boKllEj1vrhHM0E8yra4keeLDJigVz1jG+cOYPr15dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIONgQ2JV3S9kIeKi+oq8dnChcK/mPG7uZbeoPXiaBv8gCDBvnhsT7tIbvD7j6dE3sVuNW8nHNquJddFcpJfcnHK2r0fci1FMZP7KwoSeAxTLVXM8knxxhyHYpwS1Y7S3eP3urmjDbGnNEoyp4JHMSdCy6VmCrbXsg8hVqGI17g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evnrvOqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evnrvOqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DF4C3277B;
	Tue, 18 Jun 2024 12:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715452;
	bh=boKllEj1vrhHM0E8yra4keeLDJigVz1jG+cOYPr15dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evnrvOqVDp82HlwZUeZ/xN25s0a7f0MudaKcN3oiD2aMOSmsndPGdIN3za6Mtw9iJ
	 1siazvprivUPv4YpX/+OibMQRLX14x0pBZDFKwrFSaV+8BYoQh0Apn6e370ORU8wZJ
	 PbibmuPFFX8cS3+fhy1HIsz29xJ5BS8i3pFt0nu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 282/770] NFSD: Adjust cb_shutdown tracepoint
Date: Tue, 18 Jun 2024 14:32:15 +0200
Message-ID: <20240618123418.149781588@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b200f0e35338b052976b6c5759e4f77a3013e6f6 ]

Show when the upper layer requested a shutdown. RPC tracepoints can
already show when rpc_shutdown_client() is called.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 2e6a4a9e59ca1..2a2eb6184bdae 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1233,6 +1233,9 @@ void nfsd4_destroy_callback_queue(void)
 /* must be called under the state lock */
 void nfsd4_shutdown_callback(struct nfs4_client *clp)
 {
+	if (clp->cl_cb_state != NFSD4_CB_UNKNOWN)
+		trace_nfsd_cb_shutdown(clp);
+
 	set_bit(NFSD4_CLIENT_CB_KILL, &clp->cl_flags);
 	/*
 	 * Note this won't actually result in a null callback;
@@ -1278,7 +1281,6 @@ static void nfsd4_process_cb_update(struct nfsd4_callback *cb)
 	 * kill the old client:
 	 */
 	if (clp->cl_cb_client) {
-		trace_nfsd_cb_shutdown(clp);
 		rpc_shutdown_client(clp->cl_cb_client);
 		clp->cl_cb_client = NULL;
 		put_cred(clp->cl_cb_cred);
-- 
2.43.0



