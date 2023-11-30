Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8C83AC1A;
	Thu, 30 Nov 2023 16:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEBp72FW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE14C433C7;
	Thu, 30 Nov 2023 16:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361903;
	bh=t3DBteq2V0bKgU1XdAvCRI0SSPbx17F3bf1bk78nz80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEBp72FWfbIKhvbCQgeh2kJjrIOoCoD/Ee03l3+WaTk3U3SQ6Ocgk6GWAVDtdk5aM
	 rxSmk+yMkuAlaT1nvitfpNC3ZdHglL94gRk5kS/huHG4ACCJ1ip1RAI/+qnVbAPENw
	 rnf8SLGzeCR6mG8V7+yP2ywo9QHLnVmOQEFJBTEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/69] afs: Fix afs_server_list to be cleaned up with RCU
Date: Thu, 30 Nov 2023 16:21:58 +0000
Message-ID: <20231130162133.087572211@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit e6bace7313d61e31f2b16fa3d774fd8cb3cb869e ]

afs_server_list is accessed with the rcu_read_lock() held from
volume->servers, so it needs to be cleaned up correctly.

Fix this by using kfree_rcu() instead of kfree().

Fixes: 8a070a964877 ("afs: Detect cell aliases 1 - Cells with root volumes")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/internal.h    | 1 +
 fs/afs/server_list.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 567e61b553f56..183200c6ce20e 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -556,6 +556,7 @@ struct afs_server_entry {
 };
 
 struct afs_server_list {
+	struct rcu_head		rcu;
 	afs_volid_t		vids[AFS_MAXTYPES]; /* Volume IDs */
 	refcount_t		usage;
 	unsigned char		nr_servers;
diff --git a/fs/afs/server_list.c b/fs/afs/server_list.c
index ed9056703505f..b59896b1de0af 100644
--- a/fs/afs/server_list.c
+++ b/fs/afs/server_list.c
@@ -17,7 +17,7 @@ void afs_put_serverlist(struct afs_net *net, struct afs_server_list *slist)
 		for (i = 0; i < slist->nr_servers; i++)
 			afs_unuse_server(net, slist->servers[i].server,
 					 afs_server_trace_put_slist);
-		kfree(slist);
+		kfree_rcu(slist, rcu);
 	}
 }
 
-- 
2.42.0



