Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD95615CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8FEC433D6;
	Tue,  8 Nov 2022 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915957;
	bh=+nYlQnR/QLElTGvp1KQIZmYiQYcvwRj3nd90FrZ/djk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7O6P7duPwR7x0KC51yUnj9ELZILlspNPwOuyDiOb6xYy+si68/UtC3cx4grqxizd
	 nToK+jC3KW6xUXpAIcEvzreC6Pmg6uwdoiJcxYln1xGcM5G+5ZQ9kHh5P2O2m/UHQC
	 Pdb/2P+3lSmh1zhxi17w8LOhlOKvqvMWxXzuXgyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/144] NFSv4.2: Fixup CLONE dest file size for zero-length count
Date: Tue,  8 Nov 2022 14:38:19 +0100
Message-Id: <20221108133346.224377463@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 038efb6348ce96228f6828354cb809c22a661681 ]

When holding a delegation, the NFS client optimizes away setting the
attributes of a file from the GETATTR in the compound after CLONE, and for
a zero-length CLONE we will end up setting the inode's size to zero in
nfs42_copy_dest_done().  Handle this case by computing the resulting count
from the server's reported size after CLONE's GETATTR.

Suggested-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: 94d202d5ca39 ("NFSv42: Copy offload should update the file size when appropriate")
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 93f4d8257525..da94bf2afd07 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -1077,6 +1077,9 @@ static int _nfs42_proc_clone(struct rpc_message *msg, struct file *src_f,
 	status = nfs4_call_sync(server->client, server, msg,
 				&args.seq_args, &res.seq_res, 0);
 	if (status == 0) {
+		/* a zero-length count means clone to EOF in src */
+		if (count == 0 && res.dst_fattr->valid & NFS_ATTR_FATTR_SIZE)
+			count = nfs_size_to_loff_t(res.dst_fattr->size) - dst_offset;
 		nfs42_copy_dest_done(dst_inode, dst_offset, count);
 		status = nfs_post_op_update_inode(dst_inode, res.dst_fattr);
 	}
-- 
2.35.1



