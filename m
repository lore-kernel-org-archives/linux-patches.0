Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0516F1DDDB;
	Thu, 13 Jun 2024 12:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282802; cv=none; b=V2GWWOCNk+XXd4l3WQnj8B74ONh1RhTl6Nb8yUrZpn5RR7GCg6+vAhhiOXewuVq1zRqhhffiEJy0pJit0JZvEDgTzUMFJ2AZfwJVJ/KnS8GaTnwSjTqjJlWqnp9vEW4iMaqdAZNRk1NVlQkn6g4f7w3Odt5tV97AzeYZSQ3pnDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282802; c=relaxed/simple;
	bh=lwtZa4lPWtdIGFaeHpZoSxp4A4VJgE8H66wkSI3MHj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9HxAlLeldxQfRDvUFOK1ds+IGfCEY6xKKkFrTZA0UMXJ2vtZJCoT09gEDa95KQtUzKZ7xDXC15QiS/Go0KGn9pPPwyE3Y3oHGrhTQdn9bk8HPV1hdtfLHHx7vabLdKWXINBcSxiap75+sFZmGW3ObV6Rl1dk8x87sVrxavzRos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCs9oPLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCs9oPLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F28FC2BBFC;
	Thu, 13 Jun 2024 12:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282801;
	bh=lwtZa4lPWtdIGFaeHpZoSxp4A4VJgE8H66wkSI3MHj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCs9oPLe5YCaEZ0kqsfytituHnPWFp0vkkyDSaFf0jhfZaU/da6Zb7LMwToZFfWJI
	 cV0VlHp0eZP5y1F99m9grCxBoG6CNRfT4XjTr8YWxi+d/GrXQBn4LPvazazMHd1ieC
	 8xYwYoBGEuIrji+US75rgVgfzdyICZa1biSNduhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 401/402] NFS: Fix READ_PLUS when server doesnt support OP_READ_PLUS
Date: Thu, 13 Jun 2024 13:35:58 +0200
Message-ID: <20240613113317.792897912@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

commit f06d1b10cb016d5aaecdb1804fefca025387bd10 upstream.

Olga showed me a case where the client was sending multiple READ_PLUS
calls to the server in parallel, and the server replied
NFS4ERR_OPNOTSUPP to each. The client would fall back to READ for the
first reply, but fail to retry the other calls.

I fix this by removing the test for NFS_CAP_READ_PLUS in
nfs4_read_plus_not_supported(). This allows us to reschedule any
READ_PLUS call that has a NFS4ERR_OPNOTSUPP return value, even after the
capability has been cleared.

Reported-by: Olga Kornievskaia <kolga@netapp.com>
Fixes: c567552612ec ("NFS: Add READ_PLUS data segment support")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5421,7 +5421,7 @@ static bool nfs4_read_plus_not_supported
 	struct rpc_message *msg = &task->tk_msg;
 
 	if (msg->rpc_proc == &nfs4_procedures[NFSPROC4_CLNT_READ_PLUS] &&
-	    server->caps & NFS_CAP_READ_PLUS && task->tk_status == -ENOTSUPP) {
+	    task->tk_status == -ENOTSUPP) {
 		server->caps &= ~NFS_CAP_READ_PLUS;
 		msg->rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_READ];
 		rpc_restart_call_prepare(task);


