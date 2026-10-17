Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5D638654F;
	Sat, 17 Oct 2026 16:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255754; cv=none; b=hh6F0XGkmtDko0RgY35ZtZe0t7mLmD7POspmHeeqeILvVQb9y13Ih5/6jJpV4+R65nmVklahw/M0sZQ6N59MzbnUDExKV1jU1wDTXXxFIc37OF95fd6NZA+cwrgBXjBW/q8dof8u7z0hI2NCT5EfUgy1TIcazHFngzfdz+WYeoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255754; c=relaxed/simple;
	bh=istSfazoKNPTwEzMse4iFOY2a3V+SEQB341y4J72yXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mq0xJCsh96Q0KfG+oBncp54cbfoC4+24bPySelGBPGDELe78+8o+pNZJTf/f1w3oiN6ONOvVyKsfSz1oVH+BgLjVv5u5MjXUi7r35sSkswEc2JtdEfJYfCpuKGhx0RNOqObMOf9lM25M1XRYfVkb6aEiX8L2M0dzDF/+moo3JAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNJqWpZE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNJqWpZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972081F000C4;
	Sat, 17 Oct 2026 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255753;
	bh=xzB4o76Kpk0xNABE1Yb161BxZGsIF9UjtESurYj1JqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TNJqWpZEbmU+jD+BFUN5BvgL+Pm1rteyPHkuXY8PNiQ/FqPsK6M3ZqvPzWSq64U0U
	 7EVlff3zZJ4QUObAjEjz6sJQc2J1na84CAA9mWC9tqEjhWnzRt9JC4+jrSsuiMhbKp
	 2LC+ondSV39F8hv2prVRENFNngzOUIbyWp7rw1rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0011/1674] nfsd: fix nfsd_file leak on inter-server COPY setup failure
Date: Sat, 17 Oct 2026 17:38:03 +0200
Message-ID: <20261017160431.429184330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 88a76145451d703eedd867b5989bf73d17340399 ]

When nfsd4_setup_inter_ssc() fails, nfsd4_copy() returns
nfserr_offload_denied directly, bypassing the out: label where
release_copy_files() would drop the nf_dst reference taken by
nfs4_preprocess_stateid_op(). Each failed inter-server COPY
leaks one nfsd_file, pinning file/inode/dentry/vfsmount.

Fix by setting status and jumping to out: instead of returning
directly.

Fixes: ce0887ac96d3 ("NFSD add nfs4 inter ssc to nfsd4_copy")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260531-nfsd-testing-v1-3-7bfa481b0540@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ adjusted cleanup paths to omit unavailable trace_nfsd_copy_*() calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index c82d96089da5c..1d87cf0c6b932 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1810,12 +1810,14 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			goto out;
 		}
 		status = nfsd4_setup_inter_ssc(rqstp, cstate, copy);
-		if (status)
-			return nfserr_offload_denied;
+		if (status) {
+			status = nfserr_offload_denied;
+			goto out;
+		}
 	} else {
 		status = nfsd4_setup_intra_ssc(rqstp, cstate, copy);
 		if (status)
-			return status;
+			goto out;
 	}
 
 	memcpy(&copy->fh, &cstate->current_fh.fh_handle,
-- 
2.53.0



