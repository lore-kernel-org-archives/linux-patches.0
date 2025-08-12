Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9E72CA9;
	Tue, 12 Aug 2025 18:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025114; cv=none; b=reahwel29PNpc3jPssIKq0jr0/znPLvl2V3GD8DHql+jkky5tv5uXm8EDdg8WEUs/L/U4EyWwezdPa1sVyTO64c71YJVNYcWWuvIsCmU9LLIm2p43KNOrU1TB4uGYiRa9DD81q3FqTBnP6DokwwJcoL+yz5ts+O+ZI/ZXUvs/jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025114; c=relaxed/simple;
	bh=gvvkMCoVQDUVlA2Kqf3Nqp60fj9ChRCwVhHi1gvoUrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uULYb4nd7BHh7SfvbF/UsO8o9hnRktaWPuqfX3w+JqSQHvSH6deKgY3grBb65fYaoEVKW8LkW0xmn6qubp/UkMWVRhKGZEHkdhy3/WBuNdpyweykHMjKhorada3eU54VQQl2BJylEyBdQ8PnXk8bb3/qC/r9r1/DiYnkF1IqG8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhnyeuEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhnyeuEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177C9C4CEF0;
	Tue, 12 Aug 2025 18:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025114;
	bh=gvvkMCoVQDUVlA2Kqf3Nqp60fj9ChRCwVhHi1gvoUrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhnyeuEu7b2ZTAeQKJWrAmUyPP9fnKQKvaOZt63pe5Mk0eGi3QrcwUGTjM5bnDPDJ
	 onGGMCsxS3nmJydVJchQECozK179mQsAsxc1nlplkmwDMM5imKGCwX0QWzm8pC4ecK
	 7QvSJJVLmOCWSP/rkXQZr1VDhHuCTLMeqKfXM9fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.16 574/627] nfsd: avoid ref leak in nfsd_open_local_fh()
Date: Tue, 12 Aug 2025 19:34:29 +0200
Message-ID: <20250812173453.712122339@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
 fs/nfsd/localio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfsd/localio.c
+++ b/fs/nfsd/localio.c
@@ -103,10 +103,11 @@ nfsd_open_local_fh(struct net *net, stru
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


