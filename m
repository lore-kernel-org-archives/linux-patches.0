Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1143D396572;
	Fri,  4 Sep 2026 06:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502240; cv=none; b=LpCEk5B2+N3cxoOyT4aTSVPNhOzVsrXEFa3jBGH2ZyepI94fJla8SSsCB8RUGsW8viwFQM8+aLp1mjGE3IT/cShPItYpees9J+CwvvwULqwEdaZQfR6Kcv0fbc7SgctEF8ifFcnXxxMCVxI/XiQEOpLhFVMuyyb87AqUVWu1AJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502240; c=relaxed/simple;
	bh=ljSo44fm7uoFtvutO6vd9VtubenJFzODxLCIp6GtIDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkOZzant1gQJPAzsIGvDcbobUMQiwzyLreoBGhvPYk3TRJUByK8l46wTfEf6OaB4DyOuvC8cD/zRuvK0aM4cKYJdtzfvh553WbiL/P7zmADbaqMbH0sUGP/EB+tvhCbXigXGmqIYH43XuoP9aL8Bq/QXkMegMZTMKRWLWhx+fC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJfz3QHl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJfz3QHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610141F00A3D;
	Fri,  4 Sep 2026 06:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502236;
	bh=k6pZvY+1KiRmR7pFesSGx/WAAFXrjoT2M+q40QNgTJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJfz3QHlYV6Q7OMlERW4BCOBi1TykZ7N4nAJC0QT3uuqwFVUf6a0CqvYw1cyts1CK
	 PPKzZmC90RA79Ml6E9m5gj1bgxkeiJkDE4JGR+xElI0ON19RsQqS+Qxi9ZubJqAMty
	 7cTi25Kd57jvvOVa0091R+br9LImC+saTt19X+eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 094/403] nfsd: fix nfsd_file leak on inter-server COPY setup failure
Date: Fri,  4 Sep 2026 06:58:17 +0200
Message-ID: <20260904045736.971105920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 88a76145451d703eedd867b5989bf73d17340399 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1828,16 +1828,14 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 		}
 		status = nfsd4_setup_inter_ssc(rqstp, cstate, copy);
 		if (status) {
-			trace_nfsd_copy_done(copy, status);
-			return nfserr_offload_denied;
+			status = nfserr_offload_denied;
+			goto out;
 		}
 	} else {
 		trace_nfsd_copy_intra(copy);
 		status = nfsd4_setup_intra_ssc(rqstp, cstate, copy);
-		if (status) {
-			trace_nfsd_copy_done(copy, status);
-			return status;
-		}
+		if (status)
+			goto out;
 	}
 
 	memcpy(&copy->fh, &cstate->current_fh.fh_handle,


