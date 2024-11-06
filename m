Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AD61EABD0;
	Wed,  6 Nov 2024 12:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897079; cv=none; b=HMswvN2urTBFvfE5/QeBcrE+ZD8yXUbr8t7Iea5u9I79REoioISPtHTCpz6kWnSdC8AHThUZgy2zPXSVQSjCTMK5F2NcTt4lxmRkUt2Rxjte12nIsRTniZDNyvgGaUAi8851E7W2tcpMu0eL1MnRe8CKM+C56n6efDRSi94pHao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897079; c=relaxed/simple;
	bh=jZqQq4nvDudpjhpHXbUgVMBUZg696ZDCRq10S+oEBJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3pFzDnbG3fYAVrR8FIKX3c8wMtKfa20igkG0X7lP8zodX6Eg9hTApsdmKUoiv877vqsEo0b1yrpWsi9QWakMaXfst+SuM4IEDms/fZeW/R01vQGP45scJgHpuoQ/hYvcmbp4nu/3SXMOVMCP6xZNIq9P4VYHudNZ1JAcca+lac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q15rHRWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q15rHRWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38753C4CECD;
	Wed,  6 Nov 2024 12:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897079;
	bh=jZqQq4nvDudpjhpHXbUgVMBUZg696ZDCRq10S+oEBJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q15rHRWSshiQ5Z/6cyscoIvsd2S7XnNa/PtHsbnjBBOUgkXiYqpepFPewtpoyi6C8
	 3jui9natnQ0JEkWzT15qiqoFLnhnLidbXtSoE5w7Z7wLbS3hKqDCMTDcNROu7saY0h
	 n/x0N2RrfOGvBg0XdQxKVIF6kCNAhaEI4+GAfh1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/126] NFS: remove revoked delegation from servers delegation list
Date: Wed,  6 Nov 2024 13:04:20 +0100
Message-ID: <20241106120307.691378896@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 7ef60108069b7e3cc66432304e1dd197d5c0a9b5 ]

After the delegation is returned to the NFS server remove it
from the server's delegations list to reduce the time it takes
to scan this list.

Network trace captured while running the below script shows the
time taken to service the CB_RECALL increases gradually due to
the overhead of traversing the delegation list in
nfs_delegation_find_inode_server.

The NFS server in this test is a Solaris server which issues
CB_RECALL when receiving the all-zero stateid in the SETATTR.

mount=/mnt/data
for i in $(seq 1 20)
do
   echo $i
   mkdir $mount/testtarfile$i
   time  tar -C $mount/testtarfile$i -xf 5000_files.tar
done

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 2ba4d221bf9d5..39c697e100b1b 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -981,6 +981,11 @@ void nfs_delegation_mark_returned(struct inode *inode,
 	}
 
 	nfs_mark_delegation_revoked(delegation);
+	clear_bit(NFS_DELEGATION_RETURNING, &delegation->flags);
+	spin_unlock(&delegation->lock);
+	if (nfs_detach_delegation(NFS_I(inode), delegation, NFS_SERVER(inode)))
+		nfs_put_delegation(delegation);
+	goto out_rcu_unlock;
 
 out_clear_returning:
 	clear_bit(NFS_DELEGATION_RETURNING, &delegation->flags);
-- 
2.43.0



