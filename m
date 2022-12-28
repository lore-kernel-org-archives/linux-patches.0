Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD26F1868
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8FCC433F1;
	Wed, 28 Dec 2022 15:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240590;
	bh=ZOFxuwlQiRYgKhrX6MeJJgLFOdLm9A8VsApIXOSl6uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K72SSgDqjUrZ+YOXP52NYDX0+E+vEbbN1MNs+Nn6kZGnHV5aFqP/hKfxj2sIQqnMZ
	 f9OSRKYiyVoU7sdiA56TxV25kadkJb+vlbR5BXHBAovrQIM0zBRaF1V70CKqMRppBm
	 IqaS6a06QOVcdPNKq8LZBn51JzXcwp15R4y3E93M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Brown <neilb@suse.de>,
	Yongcheng Yang <yoyang@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0178/1073] nfsd: return error if nfs4_setacl fails
Date: Wed, 28 Dec 2022 15:29:26 +0100
Message-Id: <20221228144332.844403978@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 01d53a88c08951f88f2a42f1f1e6568928e0590e ]

With the addition of POSIX ACLs to struct nfsd_attrs, we no longer
return an error if setting the ACL fails. Ensure we return the na_aclerr
error on SETATTR if there is one.

Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
Cc: Neil Brown <neilb@suse.de>
Reported-by: Yongcheng Yang <yoyang@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 6ba25a5b76e1..b71a3c2d9409 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1141,6 +1141,8 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 				0, (time64_t)0);
 	if (!status)
 		status = nfserrno(attrs.na_labelerr);
+	if (!status)
+		status = nfserrno(attrs.na_aclerr);
 out:
 	nfsd_attrs_free(&attrs);
 	fh_drop_write(&cstate->current_fh);
-- 
2.35.1



