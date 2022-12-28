Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99761863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2F4C433EF;
	Wed, 28 Dec 2022 15:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242413;
	bh=O62DbBscuRieN2HTwu4+4z2wGQ/rMFZe4gk8Z8aF/Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVi4Ky+iqIWZ8AC3BbQui2QtTQ4rpEY/Ae1aj3qOMFc0n/1yysbman1h0u4hkD/tK
	 d4azcoPehvTcxrTB49bANVM/jTVoeOsQBJsCeLMrjlXqyOUsfvgGcHQ7CK4OAyzwxC
	 F4zMJdqS3n/YVWL2eIGkHPD78bJCVWFgGxzl1sg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0407/1073] NFSv4.2: Always decode the security label
Date: Wed, 28 Dec 2022 15:33:15 +0100
Message-Id: <20221228144339.074248426@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit c8a62f440229ae7a10874776344dfcc17d860336 ]

If the server returns a reply that includes a security label, then we
must decode it whether or not we can store the results.

Fixes: 1e2f67da8931 ("NFS: Remove the nfs4_label argument from decode_getattr_*() functions")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 8c5298e37f0f..9103e022376a 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4755,12 +4755,10 @@ static int decode_getfattr_attrs(struct xdr_stream *xdr, uint32_t *bitmap,
 	if (status < 0)
 		goto xdr_error;
 
-	if (fattr->label) {
-		status = decode_attr_security_label(xdr, bitmap, fattr->label);
-		if (status < 0)
-			goto xdr_error;
-		fattr->valid |= status;
-	}
+	status = decode_attr_security_label(xdr, bitmap, fattr->label);
+	if (status < 0)
+		goto xdr_error;
+	fattr->valid |= status;
 
 xdr_error:
 	dprintk("%s: xdr returned %d\n", __func__, -status);
-- 
2.35.1



