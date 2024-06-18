Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4614113C83B;
	Tue, 18 Jun 2024 13:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716317; cv=none; b=AtVfYtFmtia8lZuHPMSHXG7oJjfG00ndoam9vB4e6+3J3UX0FDatJfIF+/OWf4JfHB5mndh3DkirH8T+DeBJr+MWJf4wiJWCG49oobP3IbsmuQcuB0+1t+9owJNb+9wUMj951NPhE02gYiJ096TeaU2pDm9RopG8JhrwLxpT/o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716317; c=relaxed/simple;
	bh=sEqMBwKNujB7jY6wASnIROLfLcEkMJbg8xuTcedrzac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAYMgiqcg/b6rHa2KuQ3usoEmQMAAHcWSudWovRT58kWdtglOE2wmeKj8OClEYBQz5vjA2e8T2m/+KO5jfrh3uneETOyTWj+n43lrzrDIRC3sxk8TFztDkTHwtB6/8wvgjPaP4ockNF8DxZIPqLOtCYH3scsoX2RmG+ZqX86DH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiUxdR0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiUxdR0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE1FC3277B;
	Tue, 18 Jun 2024 13:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716317;
	bh=sEqMBwKNujB7jY6wASnIROLfLcEkMJbg8xuTcedrzac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiUxdR0dBeoiD8YkIMdLjpnBS9bwplNI35OhV5+7qw5V4zwQQVK6csX/8nTqTEENP
	 +mGXrojAqN0VI+Bx5/PZqFqDhOC07WuvypTtVj5MzMn/nFSYnkbodGxqCbXKJZR9Vd
	 cCwQuVqfUlRqcBEAd3loHjrQUIy+xbV5X/+YPhcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 605/770] NFSD: Refactor nfsd4_cleanup_inter_ssc() (2/2)
Date: Tue, 18 Jun 2024 14:37:38 +0200
Message-ID: <20240618123430.641651962@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 478ed7b10d875da2743d1a22822b9f8a82df8f12 ]

Move the nfsd4_cleanup_*() call sites out of nfsd4_do_copy(). A
subsequent patch will modify one of the new call sites to avoid
the need to manufacture the phony struct nfsd_file.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index d39150425da88..5d05bb7a0c0f6 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1714,13 +1714,6 @@ static __be32 nfsd4_do_copy(struct nfsd4_copy *copy, bool sync)
 		nfsd4_init_copy_res(copy, sync);
 		status = nfs_ok;
 	}
-
-	if (nfsd4_ssc_is_inter(copy))
-		nfsd4_cleanup_inter_ssc(copy->ss_mnt, copy->nf_src->nf_file,
-					copy->nf_dst);
-	else
-		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
-
 	return status;
 }
 
@@ -1776,9 +1769,14 @@ static int nfsd4_do_async_copy(void *data)
 			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
+		copy->nfserr = nfsd4_do_copy(copy, 0);
+		nfsd4_cleanup_inter_ssc(copy->ss_mnt, copy->nf_src->nf_file,
+					copy->nf_dst);
+	} else {
+		copy->nfserr = nfsd4_do_copy(copy, 0);
+		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 
-	copy->nfserr = nfsd4_do_copy(copy, 0);
 do_callback:
 	cb_copy = kzalloc(sizeof(struct nfsd4_copy), GFP_KERNEL);
 	if (!cb_copy)
@@ -1854,6 +1852,7 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		status = nfs_ok;
 	} else {
 		status = nfsd4_do_copy(copy, 1);
+		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 out:
 	return status;
-- 
2.43.0



