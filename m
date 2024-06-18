Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAA513D8BC;
	Tue, 18 Jun 2024 13:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716293; cv=none; b=DH13JH0ALgq4WmOMvl9TJ4Cd78NIN2rGAp0ZCouOmO4LNWb+DUM5o9ltBWXzXj52J4QvWTblNRIi9GTxhDgUGr6/ai379bItHjivl4bDNLdV4CvwUjyICEKOfNQIpQRv01r1RXousYWvAGvWO2YtoswE6YvMxYWtiLmBAue/Ydw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716293; c=relaxed/simple;
	bh=8ZW4D7lBZHB9yXW96+RThFW0zTSVEU9wai/rBK8uQmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhPJ97cS+eoHu8sEcoAiLNFE9aAtB18NjQNZ41sHrvoszpUwQGgxuemdHfbhK7iW5YHv+iQDjAn6cVe0EQi3dmOc0168hEvgk9IZjHPp7f+y0V4jiKtmWvbh/AV4F4Xf2Z3a1NvPyjDkuLBDt0QGgVIrkrWGmmbeAKrH5KAIne8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvdlODcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvdlODcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BD0C3277B;
	Tue, 18 Jun 2024 13:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716293;
	bh=8ZW4D7lBZHB9yXW96+RThFW0zTSVEU9wai/rBK8uQmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvdlODcvBt0Dt1O4QIv0ufQiETLPigb2D8NIpBs40d3V53ZXF+n3B6Fi45tj+jBet
	 CcvcHqaU6ZIpdDrNL2vZ9FNjgM4xO9McIKtxKTBNlxGlJj13eRV5sHpx0cI6gvqp0s
	 yAqpePAd1RMhVP+WUIXv9jZLNbMOIPLHzZaStqks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 598/770] NFSD: nfserrno(-ENOMEM) is nfserr_jukebox
Date: Tue, 18 Jun 2024 14:37:31 +0200
Message-ID: <20240618123430.375481841@linuxfoundation.org>
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

[ Upstream commit bb4d842722b84a2731257054b6405f2d866fc5f3 ]

Suggested-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index a98513cb35b10..fcf56e396e66b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1810,7 +1810,7 @@ nfsd4_decode_test_stateid(struct nfsd4_compoundargs *argp, struct nfsd4_test_sta
 	for (i = 0; i < test_stateid->ts_num_ids; i++) {
 		stateid = svcxdr_tmpalloc(argp, sizeof(*stateid));
 		if (!stateid)
-			return nfserrno(-ENOMEM);	/* XXX: not jukebox? */
+			return nfserr_jukebox;
 		INIT_LIST_HEAD(&stateid->ts_id_list);
 		list_add_tail(&stateid->ts_id_list, &test_stateid->ts_stateid_list);
 		status = nfsd4_decode_stateid4(argp, &stateid->ts_id_stateid);
@@ -1933,7 +1933,7 @@ nfsd4_decode_copy(struct nfsd4_compoundargs *argp, struct nfsd4_copy *copy)
 
 	ns_dummy = kmalloc(sizeof(struct nl4_server), GFP_KERNEL);
 	if (ns_dummy == NULL)
-		return nfserrno(-ENOMEM);	/* XXX: jukebox? */
+		return nfserr_jukebox;
 	for (i = 0; i < count - 1; i++) {
 		status = nfsd4_decode_nl4_server(argp, ns_dummy);
 		if (status) {
-- 
2.43.0



