Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A9D29BD9D;
	Tue, 12 Aug 2025 19:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026770; cv=none; b=QfUq216Kr1pDztGvAIU8dnYPrYYWjFSPqh03xb7NJDdHNd1jhiig8NhQ2y5dahHgk0f0WOKEJVYTjn15CEgW2+ik0Oe2zCgLW4oT8PBFioinP13Fu5tYf8nehu6S+vGfTGEXN8LZsGlvl+AG3XxzH/uxzch+9N0He3UWV4u8KiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026770; c=relaxed/simple;
	bh=XnTeAQGNQROfSeGxS8cmgqQ32g/FVXzNDe9M9lgnvx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2xJ4t0xrfjp6pvp7L0dsVA4s643oAUqyE/cpL0fglfbBZQvVUCPKh9oG2FmX9tjpU4RryjfxacfmLjsrD98HbdukOottgNOnkrsX/8wd6cdmhFiMIa3Coc6sURSeDfCftczIK6SEmbRK7uSbTRsaFXbkmz3sNxoG1XqlYZsaQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4b7gFK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4b7gFK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CA7C4CEF1;
	Tue, 12 Aug 2025 19:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026770;
	bh=XnTeAQGNQROfSeGxS8cmgqQ32g/FVXzNDe9M9lgnvx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4b7gFK5inTuK3u894q/xUlS+Ieo/3T7iOnhbbSj/Ore+X/GcdUC6wKev7KxYymQK
	 XbBqyefsgkff+p8rlYV+an4nykyZyM0RbAVJH6dxddk+nMol3on6imCyzHKW9sNXNq
	 j8ARcQm0ztQfUiM820zpU4xXNbER1rYfAH2Tuk84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.15 434/480] nfsd: avoid ref leak in nfsd_open_local_fh()
Date: Tue, 12 Aug 2025 19:50:42 +0200
Message-ID: <20250812174415.302517865@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

commit e5a73150776f18547ee685c9f6bfafe549714899 upstream.

If two calls to nfsd_open_local_fh() race and both successfully call
nfsd_file_acquire_local(), they will both get an extra reference to the
net to accompany the file reference stored in *pnf.

One of them will fail to store (using xchg()) the file reference in
*pnf and will drop that reference but WON'T drop the accompanying
reference to the net.  This leak means that when the nfs server is shut
down it will hang in nfsd_shutdown_net() waiting for
&nn->nfsd_net_free_done.

This patch adds the missing nfsd_net_put().

Reported-by: Mike Snitzer <snitzer@kernel.org>
Fixes: e6f7e1487ab5 ("nfs_localio: simplify interface to nfsd for getting nfsd_file")
Cc: stable@vger.kernel.org
Signed-off-by: NeilBrown <neil@brown.name>
Tested-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/localio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/localio.c b/fs/nfsd/localio.c
index 4f6468eb2adf..cb237f1b902a 100644
--- a/fs/nfsd/localio.c
+++ b/fs/nfsd/localio.c
@@ -103,10 +103,11 @@ nfsd_open_local_fh(struct net *net, struct auth_domain *dom,
 			if (nfsd_file_get(new) == NULL)
 				goto again;
 			/*
-			 * Drop the ref we were going to install and the
-			 * one we were going to return.
+			 * Drop the ref we were going to install (both file and
+			 * net) and the one we were going to return (only file).
 			 */
 			nfsd_file_put(localio);
+			nfsd_net_put(net);
 			nfsd_file_put(localio);
 			localio = new;
 		}
-- 
2.50.1



