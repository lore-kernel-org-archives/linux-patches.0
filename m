Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28029145A07;
	Thu, 13 Jun 2024 12:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280656; cv=none; b=qE4KuJF3y7yySE1NE0/o7CbhHJBBBk/bQMmMJBDQ7hqEAjdDDkKtZFhknYujtpkJBS6gpMMmLCX0hv3uBJqZP0vJFEDTGn1c8WOZqX5l2DdB/8bVzMqWx+GEQKHXGiwTGttRgWnGojNqo+ccfwzy8/kr0vZOG91bNUafpiEwLv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280656; c=relaxed/simple;
	bh=p07P1lOCplvjWiX8jYKUV6BcwZc4xzSbJYbrsmz4PC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnM/lCWzOIAfvtoPXpft7VDR26ZqLiOTfwQhf3dqddQWbBtrZpoY0n9QJogYDP6ZF8MzMKaAY4P9pPFhGMVLx0pqvaW5U98idUCV69DeTSDsUcPXx38lFq+Mj5xDmC3KZ6CSOT5shZL6XpSBHLG6W2XpBoUMAkzbLkcC0RxEkDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFpIU6F6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFpIU6F6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FE2C2BBFC;
	Thu, 13 Jun 2024 12:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280656;
	bh=p07P1lOCplvjWiX8jYKUV6BcwZc4xzSbJYbrsmz4PC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFpIU6F6ev6jHHkWBAkl3Uhp5451/LzHGaEhg9O2FgpQOBexbhZEdF8pd6JEzmy6g
	 BdheuQiJedoPpLRAkOL9d4nQZcpQ0c5jmRV+6xAWHlwVB8sK7T1ujmsDPi8PUg1noP
	 OZeGTNjCdOl0a3YYWaKewDF+p/ip78cIXcC+KtXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.6 127/137] NFS: Fix READ_PLUS when server doesnt support OP_READ_PLUS
Date: Thu, 13 Jun 2024 13:35:07 +0200
Message-ID: <20240613113228.225512396@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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
@@ -5435,7 +5435,7 @@ static bool nfs4_read_plus_not_supported
 	struct rpc_message *msg = &task->tk_msg;
 
 	if (msg->rpc_proc == &nfs4_procedures[NFSPROC4_CLNT_READ_PLUS] &&
-	    server->caps & NFS_CAP_READ_PLUS && task->tk_status == -ENOTSUPP) {
+	    task->tk_status == -ENOTSUPP) {
 		server->caps &= ~NFS_CAP_READ_PLUS;
 		msg->rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_READ];
 		rpc_restart_call_prepare(task);


