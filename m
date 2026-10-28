Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208161;
	b=E59y95fdcxfKUdVlbTiTd7ep4kELApcNeYV+W426cjGlrAIw/0mPIMQtftxcUf2jNHqi
	 6ZRrWpZQV4Pt3SRYxhP2O+NzQ8h0ZJNwv0O1/c54GLF3ISQxryWMeDhUIu+nKjYypk38g
	 9b2i9vXSBrgXmTFdTvAPZ4peCeMZWqfiUTuICTwuDOMgBSz/H5+CtedYe6vzhrW3KVNub
	 /Yp3AFOqr9cCLGdREevIJKgYexccSJdDOkmfyh1uWJcuiPK+Xzlb1Pw/WbmuvWeGme17M
	 6gTTOFXT6Avp7BKroAPy6voQCTEbyTE/YEVMpVA6DANidZg1PFGcrMUjyo1qYAEGmLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RPL2p3+aA/HANLBeaqVu2RC7FobHdKkaI4OLV7Awi3c=;
	b=ggrVOTtTsvwEstYbqi4svzpuTjaOECd7zlqUt8DjVYbq0UqQqPNp+QZGMhSk2XQW9Ibl
	 mwMqSPV/YTwNb9v8Z7H1WbSfa/QW1xzYwf/fmRkNUGD3lXw6lf20pkACI38xzK1H4ovM/
	 gxS0XQ2ftT1a3ZAhi5/wyKVb4CozvI9ywATTj88+5kUWflTSs1x9vS+oiTqZU2wGDaXnZ
	 /q3WsoNc9ptrE7o4dq+iFbn0/rnGH+etHP10k2o4Ad+A2Frq9N6S1cUa6DK7Dy60F7oCl
	 UC+Uy6XARjOkGXx3zmQGoLXkby2BAWEjYp+JxomgFZ96XN+KliaxEBa+LiZeJSZJYOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AItjB+EA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD17606A321;
	Wed, 28 Oct 2026 17:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AItjB+EA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8D81F01825;
	Wed, 28 Oct 2026 17:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208160;
	bh=RPL2p3+aA/HANLBeaqVu2RC7FobHdKkaI4OLV7Awi3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AItjB+EAJscV3kC7Pz/iHHPpY2JUbGsfHCZWamwr8/iiOrT+DY5ptT7Nq6E1hpiZv
	 i9O8HtGuaGIIVFd/G5fk3zf/05W9DYqJKr2ws3KlvM1GXA66qJerTjhGn5jmjCo3oV
	 /fgI9vw9y5cHtuhd/NHgt2f+aHZBacDtcUDNSDpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/516] nfsd: fix nfsd_file leak on inter-server COPY setup failure
Date: Wed, 28 Oct 2026 17:52:37 +0100
Message-ID: <20261028170003.653972153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9095bd7c145c6..2ef88a7d22e37 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1778,12 +1778,14 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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



