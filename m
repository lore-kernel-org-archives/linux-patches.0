Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0E41CD1F;
	Tue, 26 Aug 2025 14:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218861; cv=none; b=LXQRuu4U1vQ9fqZkTnxKWlgLUY6nIz45qdXQwj9RVRunx87I/MsYv6r9OGoSOgZ2sNSjSeNDLKxxJL4kSS8bQsghQrJyU2inOUSVsORI5ZKO8i59clqXJX4gnIyt/eaV46Juo3QOi1aUBZxZwumcpGwBIUQ7sQJ7QfyPb7Gtges=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218861; c=relaxed/simple;
	bh=C1oxVsv/N84F24UFHO7k78oAKWdDov5erW0HcD/XUKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgOWiuYgOkUg1IoM/JuxjmQkhqe3anVaSMPdEwI6Zd5yXkiVz+HFxvONopcdNjSplDa2pfvdaFdUT1Sbpyk3GCK80PaE9kkOvBm7eivogxDmkJfVlJbqRx4tssYF2NXX0XdvRl1nbfwFOt9WCL99QJ4FFkCSdQFE+JbvyX+yMLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7ZNs/HO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7ZNs/HO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5395C113CF;
	Tue, 26 Aug 2025 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218861;
	bh=C1oxVsv/N84F24UFHO7k78oAKWdDov5erW0HcD/XUKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7ZNs/HOh8/y5ec7YBAg7GGCkwZ99cUzguq8/cmXxVrdgOAACL/Zv40MdDxe9lPYh
	 xdB3DGu4s11JGiZAlnIWgsCvSOVARJzTPjSNsFZME0OGkJqvyMeawOrTgEPsazIb/9
	 LDdmVxARl0/IOlVvX0C3xDtMXA1/KzVDf8Yhhocc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petro Pavlov <petro.pavlov@vastdata.com>,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.4 162/403] NFSD: detect mismatch of file handle and delegation stateid in OPEN op
Date: Tue, 26 Aug 2025 13:08:08 +0200
Message-ID: <20250826110911.366258520@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

commit 9c65001c57164033ad08b654c8b5ae35512ddf4a upstream.

When the client sends an OPEN with claim type CLAIM_DELEG_CUR_FH or
CLAIM_DELEGATION_CUR, the delegation stateid and the file handle
must belong to the same file, otherwise return NFS4ERR_INVAL.

Note that RFC8881, section 8.2.4, mandates the server to return
NFS4ERR_BAD_STATEID if the selected table entry does not match the
current filehandle. However returning NFS4ERR_BAD_STATEID in the
OPEN causes the client to retry the operation and therefor get the
client into a loop. To avoid this situation we return NFS4ERR_INVAL
instead.

Reported-by: Petro Pavlov <petro.pavlov@vastdata.com>
Fixes: c44c5eeb2c02 ("[PATCH] nfsd4: add open state code for CLAIM_DELEGATE_CUR")
Cc: stable@vger.kernel.org
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5081,6 +5081,20 @@ nfsd4_process_open2(struct svc_rqst *rqs
 		status = nfs4_check_deleg(cl, open, &dp);
 		if (status)
 			goto out;
+		if (dp && nfsd4_is_deleg_cur(open) &&
+				(dp->dl_stid.sc_file != fp)) {
+			/*
+			 * RFC8881 section 8.2.4 mandates the server to return
+			 * NFS4ERR_BAD_STATEID if the selected table entry does
+			 * not match the current filehandle. However returning
+			 * NFS4ERR_BAD_STATEID in the OPEN can cause the client
+			 * to repeatedly retry the operation with the same
+			 * stateid, since the stateid itself is valid. To avoid
+			 * this situation NFSD returns NFS4ERR_INVAL instead.
+			 */
+			status = nfserr_inval;
+			goto out;
+		}
 		stp = nfsd4_find_and_lock_existing_open(fp, open);
 	} else {
 		open->op_file = NULL;


