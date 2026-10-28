Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212062;
	b=NpgiqdEGJ0ovh9XOZHVVp1qg7LkqbjRtZQR0lMBTmjsM5h0OrHXyvO830TS/t5qcF42E
	 PQF0pON2zG5I2e4bOkFA0z9IS6hQs6svxmEW7np1A+/PDkwYN4inCU8WfFZtAr0UUy0Bu
	 9cvVtIrILZLznDjrmb9uXdX5L6vCddeR+j6y9T9rgieuVz5H3UR6iH8kp3TlZ6ZdfDO8b
	 D9VYjHOu3KweUb2XHcNXC2Ugq+50lXQZ2PQ9ZIR08lZHykXl4VObfdYwuORApB1tjxhzD
	 mCl9w+5qTZ6oYfsl2oWGWf5Plipp0EjHK7rpEykntgWWMOyHiHepp5Q6e0sOIZLdtsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bIwhjuP30lg0ZLS2xFanhdI2fsc0PuqiixETm77ii7s=;
	b=EgIQpkIa0UWUDQ6CMt53S3Tw6KU++Z5SW9Cz7/H1oWuMgIpqwcAcHNnqcnX2lZRgOuIa
	 vS0d/0ukKTa0hDYFznkKWi3hggiAiiyk/dHY6wDlzNV5yzRgHfxzc8EYBbc92aOsBHCQ9
	 ZZ2CVpK+GnypHVFrlyjZNr5qnor/ukTaLC5fEdHCuU6PunX25mK7MgOPlGU2UPsl/tMxM
	 lCIuSq5S1gbrbjK/kpykpfNT1aXvUcyjiJvoO14JB8At5JDXRytbud9fAPw8vR4RzXYOU
	 ImYcwER3C5B9EGML3ktnTD2WHidekKou2B0fVJqkUJYLJhe5q8Hc0XHLEKmVdbx+a/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=csE4Gvy9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE01606A31E;
	Wed, 28 Oct 2026 18:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=csE4Gvy9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278F81F031E3;
	Wed, 28 Oct 2026 18:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212061;
	bh=bIwhjuP30lg0ZLS2xFanhdI2fsc0PuqiixETm77ii7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csE4Gvy9vn1xo1xXAlXu3+E+Z2HUMWyDmYEQfZKrR5MTNmnR+gRNUXvYNjyrDIwbM
	 OtLml1atJN5hHp4tuS02gcLnipVdixc0Rqm2eZovjl1stp18uHcCoi7spp6gWJPA6D
	 lUMQw9G2HXFuGm4LDCkbcL/3ffatEviU096/USv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0025/1887] nfsd: fix nfsd_file leak on inter-server COPY setup failure
Date: Wed, 28 Oct 2026 17:35:21 +0100
Message-ID: <20261028170459.797415789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 20c3869a9ab91..7486c470fe6f1 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1777,12 +1777,14 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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



