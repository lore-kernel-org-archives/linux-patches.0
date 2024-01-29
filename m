Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0E3157048;
	Mon, 29 Jan 2024 17:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548141; cv=none; b=sBPhvFbK3sflGy6DOeP1N6UmZXjvKAgzy8v/eVJFX2Amw1URhupjn+4tLiLmcjs0szaelIs23gpx31K0zE+IQvZkMOVnNAKZGyLjuE1PiHrYpbnuKz7lbqvE72Yt7j3oR9qV7kPr5NxVL6lpybFN+HPLliRFxzRSwExkEcS8Vbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548141; c=relaxed/simple;
	bh=K8CB5S4M1xeSkRwo0++LAH3pxfFAtXhxrsDH0f+tD9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deDX6mSsxCTzZdPlSV7lV7C4pZ/vXJXCAsakH7Uk40dtu4IcmT6Wh4umdH4sZQz67UnECJ95WWlmfs33oaqDv0FWsZNkv3ltZR61YUM5SL6yFXdqWS+gNnsDI/d3Itqn0TMUgKIeBe91GmdXRQPa0H6ja5qT2Ke8AFjLMUCfXAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnFCMOUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnFCMOUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B76C433A6;
	Mon, 29 Jan 2024 17:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548141;
	bh=K8CB5S4M1xeSkRwo0++LAH3pxfFAtXhxrsDH0f+tD9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnFCMOUvTR6PPGixAWZ3ameVuDjDO9pdL8NevSHlb7If8zLUzJep8PDpCNefFSocb
	 ZMoPMfzW9ttB8ppq78MBMP4oRdjIYPu/Qv3LBZr9yWRVaIu/75aby/cr9ec8VpUzNn
	 sS2N657O8jcaZ04kC0WCSz7x7vVIHLMZF36MJ2s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 145/346] SUNRPC: use request size to initialize bio_vec in svc_udp_sendto()
Date: Mon, 29 Jan 2024 09:02:56 -0800
Message-ID: <20240129170020.673077074@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 1d9cabe2817edd215779dc9c2fe5e7ab9aac0704 ]

Use the proper size when setting up the bio_vec, as otherwise only
zero-length UDP packets will be sent.

Fixes: baabf59c2414 ("SUNRPC: Convert svc_udp_sendto() to use the per-socket bio_vec array")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svcsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 998687421fa6..e0ce4276274b 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -717,12 +717,12 @@ static int svc_udp_sendto(struct svc_rqst *rqstp)
 				ARRAY_SIZE(rqstp->rq_bvec), xdr);
 
 	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, rqstp->rq_bvec,
-		      count, 0);
+		      count, rqstp->rq_res.len);
 	err = sock_sendmsg(svsk->sk_sock, &msg);
 	if (err == -ECONNREFUSED) {
 		/* ICMP error on earlier request. */
 		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, rqstp->rq_bvec,
-			      count, 0);
+			      count, rqstp->rq_res.len);
 		err = sock_sendmsg(svsk->sk_sock, &msg);
 	}
 
-- 
2.43.0



