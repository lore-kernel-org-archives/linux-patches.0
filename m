Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BCF3EC684;
	Fri,  4 Sep 2026 05:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498777; cv=none; b=Yzd0JxY7VfdFGAfTUhJZ9jyih9pERBBUb8rlM5NOZETRNkJfdasNfJRr3orLwT8MOKH4sVeQmWlgCJynFHj7p+0irq9uYx6xcIXIAOeFIXTz4xS77WEnAgwF4OIhRkytrNR5MP2UzJUb+TPwXwvaEQiDsc5HkpkiGe6g+TdobI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498777; c=relaxed/simple;
	bh=5Fdh2IwtouiwKNUF+HOEYH0kJqAsxWx9Zq7o67YOZcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHygeO/52A2Mqp5PZzZuvt6yK7wzI+7qvWOeVFjuE1eaHf//8o7NAwUBfTD1QEzCncPAqUmTvjUjejehGJq5hZP3q6aNzuFqLNqii1brRNynyqm0i/QnJr8IG79bvFyByiRRIAoFWh5aCQfvueVjm3Ge130X3RcZWWmV+HLWD3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUPYAHDk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUPYAHDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645431F00A3D;
	Fri,  4 Sep 2026 05:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498775;
	bh=Q3PbpoCmsZIyziBXZWpXJPE+YPMcgZl3sN7eKQN92jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUPYAHDkcF++QdsRRfGzaRwayQ0/AJV42qFHdWJ2kp8y+A6vSMzSXRhhShHFiTd1K
	 pak33nOTFPPavvZX5WnD3fxH/MnwqEJnUO+rzBIkFL1s7g1k+ErWgr+K1p1TAUACgp
	 Fwa6oCBsxc8O3+5/bnRJrHBgJAxDvf68dU/0ZVl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 184/713] nfsd: fix nfsd_file leak on inter-server COPY setup failure
Date: Fri,  4 Sep 2026 06:52:32 +0200
Message-ID: <20260904045807.940838056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2171,16 +2171,14 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
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


