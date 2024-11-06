Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7768F204F85;
	Wed,  6 Nov 2024 12:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896818; cv=none; b=I0Rg/JJACzKkOo7ksn3iHv9aXw7DW7E2+grykELKeVcWGFpjMKiIaeKMhAOHtlxTpVspzKwTpGEMBUUWrQ/xjhAyQrePLidDFebmQjxUkuqFFaT0XOBGLZ4JN9OTi55ImrYKncw+e/XRbaKpDzNxji90E6L+HaAjMnZ4dMF+D34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896818; c=relaxed/simple;
	bh=jOFIL3t70iBOeQjmsm4zijHh81e4aTWf8Zr9mgoOZVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9znwCcHbLOUscb/C0lr7fx6LZr5/D0E//bOr1JTP77pK1s5aZDUNszhHKKDiVJ5i7LGmY7tgEG8XRN/3CTWmcAZ5YfhSE7tgAqjM6jvHXJ1rL8ostZVBGfYZ8+nlz4MZm6XG0fDCpvPMarpk9FQ30ObtqCpCKnaWGK1f8aBFWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeX6oAnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeX6oAnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F021AC4CED3;
	Wed,  6 Nov 2024 12:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896818;
	bh=jOFIL3t70iBOeQjmsm4zijHh81e4aTWf8Zr9mgoOZVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeX6oAnNknWF1dIG/j568kVHXU9HmgUYSufKiXdhe4pour3kn2+bcighq3fmgMTv0
	 IH1NuUFIGCbNtutP1C+r1tqKnoCC4jg3+T3IPBL89e1R+gwgLs3EngVqBJZt7szyuD
	 Pt0btx8xak14vFBGj6RaaLgxD2OTQyll4t3Cm6oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/110] NFS: remove revoked delegation from servers delegation list
Date: Wed,  6 Nov 2024 13:04:49 +0100
Message-ID: <20241106120305.481332845@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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
index c15188d0b6b33..02d9af026ad15 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -960,6 +960,11 @@ void nfs_delegation_mark_returned(struct inode *inode,
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



