Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3996415E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcUl669S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A77C433C9;
	Mon, 23 Oct 2023 11:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060392;
	bh=tdxar5AS5jH3GyRLxO35dXMvuUhDRuBtf8dpycubntk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcUl669SxwxEoE5tLhXALSW87RwsXZ9ftweymlqv/0N8udR7RXIBCDre/G0y/t2Hk
	 dc9hc9MuLs7IF/oV36pL5LRucH0gzW1JDHFx1fNfYVAYL51XEkQkcN9jKFuvqFCCAs
	 uy4ORwWv+NicXQIpn89kLCyv0BHSaIXW+bClRY7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 6.1 156/196] NFSv4.1: fixup use EXCHGID4_FLAG_USE_PNFS_DS for DS server
Date: Mon, 23 Oct 2023 12:57:01 +0200
Message-ID: <20231023104832.870706878@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <kolga@netapp.com>

commit 379e4adfddd6a2f95a4f2029b8ddcbacf92b21f9 upstream.

This patches fixes commit 51d674a5e488 "NFSv4.1: use
EXCHGID4_FLAG_USE_PNFS_DS for DS server", purpose of that
commit was to mark EXCHANGE_ID to the DS with the appropriate
flag.

However, connection to MDS can return both EXCHGID4_FLAG_USE_PNFS_DS
and EXCHGID4_FLAG_USE_PNFS_MDS set but previous patch would only
remember the USE_PNFS_DS and for the 2nd EXCHANGE_ID send that
to the MDS.

Instead, just mark the pnfs path exclusively.

Fixes: 51d674a5e488 ("NFSv4.1: use EXCHGID4_FLAG_USE_PNFS_DS for DS server")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8875,8 +8875,6 @@ static int _nfs4_proc_exchange_id(struct
 	/* Save the EXCHANGE_ID verifier session trunk tests */
 	memcpy(clp->cl_confirm.data, argp->verifier.data,
 	       sizeof(clp->cl_confirm.data));
-	if (resp->flags & EXCHGID4_FLAG_USE_PNFS_DS)
-		set_bit(NFS_CS_DS, &clp->cl_flags);
 out:
 	trace_nfs4_exchange_id(clp, status);
 	rpc_put_task(task);


