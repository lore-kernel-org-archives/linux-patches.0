Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FCD4FB9AF;
	Wed, 30 Sep 2026 16:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786201; cv=none; b=Ad2ywNOSpfStQ7VTeG/py6A4j9pnC6kkODzPu1R9PvHC9tYjM30ARNzMvjPrV11l1qVCqMcl/CPYRBlNFoqHr9igcpieNRgowtqL7Ib7oEdw5ZbPbbTvF3cWZ28esQhiW5x0aeZBbY7rTKpxUVWVBRjR0dZS/VNXCzXXXOXadO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786201; c=relaxed/simple;
	bh=eZpeFKMPjmR/N2lVOnqSrWjdmCwXmKGSjtNo34b4uv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRTMKqdKECq1v3TLN8wHtLh9bcmX4FQzlz0kfB6F2ISjtPtLOsT6axeMOqJXyOEFS3RtPAyLsDXkG8zIBI29oTDl0v/HDTRrGzEvkeRZ4DVZ0dqWYK8pILKzzICZmVWMT8if8BWO7h26kan58vPRvr3Vx2noHyJ7tRhrcBzSEyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGRnwtp5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGRnwtp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E123E1F000FF;
	Wed, 30 Sep 2026 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786200;
	bh=jQ53pbNxf82P3kTsfE9E3556yNauTVb6xlxE9JOXyDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGRnwtp552dy4R1Du88FgepyoMHiwh2SxRG0qFBWfmH7qWiL1APZui1Gp7HPKumMo
	 FqLmR5/BOsMpDBa0ia0Ldlu6RNllgYfRhbe/c/TSt0zv61IT/OU5ZB/gdUS1s8l3UV
	 qC4ZLJenP+UbX/eIujFhJa2sI1LHuNLEfPuuAxTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 6.1 776/982] smb: client: fix smbd_connection leak on cifs_get_tcp_session() error
Date: Wed, 30 Sep 2026 17:25:12 +0200
Message-ID: <20260930152433.421720785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit e75c96157d45e498970158c8f7373d90102e33b9 upstream.

When an RDMA connection is successfully established via
smbd_get_connection() but cifs_get_tcp_session() later fails (e.g.
kthread_create() returns an error), the error path frees tcp_ses
without first destroying the smbd_connection.

Fix this by calling smbd_destroy() in the out_err cleanup path before
kfree(tcp_ses).  smbd_destroy() safely handles the case where
smbd_conn is NULL, so it can be called unconditionally.

Closes: https://sashiko.dev/#/patchset/20260912165503.521597-1-pc%40manguebit.org
Fixes: 2f8946464b11 ("CIFS: SMBD: Upper layer connects to SMBDirect session")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Stefan Metzmacher <metze@samba.org>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1894,6 +1894,7 @@ out_err:
 		kfree(tcp_ses->hostname);
 		if (tcp_ses->ssocket)
 			sock_release(tcp_ses->ssocket);
+		smbd_destroy(tcp_ses);
 		kfree(tcp_ses);
 	}
 	return ERR_PTR(rc);


