Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE861D416E;
	Wed,  6 Nov 2024 12:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895175; cv=none; b=P0NQWyXuYv79AAvCVpnF6ityuCTDXlAygYoFcnQzxaARcdcDum3+KK+wf+9kqBnXv1v2hNlxCGwI8suh4DtpCDpfXVqae2dndFeDdTetBj4Hnb8hakotXgyMWd1Xf461kZnb/eoM+YCY9i5/M2oC+00BLwjZnGx9O1DXdFFg0Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895175; c=relaxed/simple;
	bh=BFuseyQYKbiouNGdDKoTstwyjF+UCXO/sprBHKmvCPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owwVQKaGH3t5ZCSVYJN7uj3lNSvmH0iAAa3gYAdCeoUj5ZqGc6XszXGm04WY8t7YqpRcu/JrEGd2aF2kQYcdC+PiWrkrcKceqCv4HZVdEV+3YCwN1LpVLLMsS/T121JNYLegci/XHYmtYIz4CT8XvWff7SRM/ggduvnVnsHWSIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKm2YDis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKm2YDis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F63DC4CECD;
	Wed,  6 Nov 2024 12:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895175;
	bh=BFuseyQYKbiouNGdDKoTstwyjF+UCXO/sprBHKmvCPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKm2YDiskDd1yQ99JqUkjf+KXcH+YoXpTbhD37wJuLa5y4l7udFL+3opB3saiuo6M
	 ME5YrZ6DaZvKRlRNRnObCehzzzxKKP3OATL13XqhJbJc4QXE7kgKRmezT1f3uOXp+D
	 4UMvozn7K0fHIyg+yiFwN4Vgb+/I/O0x4vqi7qSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 4.19 093/350] nfsd: call cache_put if xdr_reserve_space returns NULL
Date: Wed,  6 Nov 2024 13:00:21 +0100
Message-ID: <20241106120323.199293602@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit d078cbf5c38de83bc31f83c47dcd2184c04a50c7 ]

If not enough buffer space available, but idmap_lookup has triggered
lookup_fn which calls cache_get and returns successfully. Then we
missed to call cache_put here which pairs with cache_get.

Fixes: ddd1ea563672 ("nfsd4: use xdr_reserve_space in attribute encoding")
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Reviwed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4idmap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index a5bb76593ce72..de6bab641b20c 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -565,6 +565,7 @@ static __be32 idmap_id_to_name(struct xdr_stream *xdr,
 		.id = id,
 		.type = type,
 	};
+	__be32 status = nfs_ok;
 	__be32 *p;
 	int ret;
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
@@ -577,12 +578,16 @@ static __be32 idmap_id_to_name(struct xdr_stream *xdr,
 		return nfserrno(ret);
 	ret = strlen(item->name);
 	WARN_ON_ONCE(ret > IDMAP_NAMESZ);
+
 	p = xdr_reserve_space(xdr, ret + 4);
-	if (!p)
-		return nfserr_resource;
-	p = xdr_encode_opaque(p, item->name, ret);
+	if (unlikely(!p)) {
+		status = nfserr_resource;
+		goto out_put;
+	}
+	xdr_encode_opaque(p, item->name, ret);
+out_put:
 	cache_put(&item->h, nn->idtoname_cache);
-	return 0;
+	return status;
 }
 
 static bool
-- 
2.43.0



