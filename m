Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD95D1E0DBB;
	Wed,  6 Nov 2024 12:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897491; cv=none; b=V30RmoTvmam6v6LAypzhw26WMQ5+9hjhbUbbym551Q/QhAXlT2ZWbKMwga2eVV04rNv0qgSd3cQAxMkvNOIQuDtm+JhQlCcbaLA9yjWuPQ8Oxw13ucvxzjrIGqdASxdUmopMb/AOJXM5Y9/1GpjP85ieb9lbBEIjyeCR3JsRklM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897491; c=relaxed/simple;
	bh=QKm21WQXHqO0CXLIEA7HGIHfkItc5A43YLzge1O51+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8oDub3XEmWJMo/nOxtwPE8yYaoupnoc/4W32L/ePiCxgWursaWvmOdILKdDoppVGZRQL8H6n1loJhJkC8LmAjpGSPoBFsZ4nx/PZ/Wu25vNAj1RhNTQiz0Sp/+H4dUicBOIcPZfOaw9oannXxJqgDtw1GSoGveVplPZrK/PrAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDfIitaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDfIitaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BE0C4CECD;
	Wed,  6 Nov 2024 12:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897491;
	bh=QKm21WQXHqO0CXLIEA7HGIHfkItc5A43YLzge1O51+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDfIitaT3oQSUTn4rIzzpPiaciDCH+ksMIGD6EbvQLl2ZimVnXDRifqGtDZrbCYpp
	 6c9V5/MoaGkXssRAfqmL6DFH7k5BHQsoUEMHSZ4TTLzdA4IuBqO7/1Fr5i7KDOcPQD
	 320OGI6OeKCrTRihu8c+VSs+miwH3tTV2LUu9Ggo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/151] NFS: remove revoked delegation from servers delegation list
Date: Wed,  6 Nov 2024 13:04:18 +0100
Message-ID: <20241106120310.769206064@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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
index a2034511b6314..4bf2526a3a189 100644
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



