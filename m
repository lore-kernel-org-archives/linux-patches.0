Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215971;
	b=y44y/Pfh6TZL1pG7n25Q3U/nKZ0UIpa5eQfZ04ugyMW1rrQHZKNlzaCRNoLFh64b8zOU
	 gwftC+m4wzUyjjRoqAd2e32bgvqx8w2abyWCRRUtyrbzRa6aXjzAMfmUPSjmBOf71a64d
	 9XI+mAltubW/5udpabEzUUewVU5LQ6tbUG9khW9nzIOlZzsqfqwuAztxKUd6SGfNpvtz4
	 TypJgJ2yEg6ucK2dPeeSrrlewKKIAu3gFAqABJ5yg7A2+LdxzMRV+/sKbsx4sJntwohYc
	 wzOfIPLtyjRnADuDNoPGw/ySF/aTnzP0wXPf5Ryn/0knuy2UCnbTmY5yCDTzXUEOsiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=44osliRxjcjre6rVoJ5tyGvqf7+mkwTTVkHUOz6XeOA=;
	b=2Wc320gyJMTm7MRV2QkkP6jIKHwSDw6FPTo9K3Tb2D0UdbVwPRioKRmHUCG5MAOyJcO+
	 lj+6pK92lyStAj0rl+H2Vqa+gjfxIKOV7DifYjeYpGRX0hr6Thu42jSVZ8Blp+MqBaae3
	 Qxbag41iLByxTYI9B4N6WCy2xnDQs524GDkzV/Uibhtm9/cHqLtu8iYfZKbD/ejwmNcK2
	 9mHQvtG4/ien47RrF3zwiH9odHh9Qu1v3k0zNKNR3sGm3PQUehql9dIXDpWTjbuC2k3/V
	 frTGhqM4y5yEB0P1PXq4qa4pIdsj96iA+MsEDNdYZCH1KbFkxNsysRv45N+H48rMgaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O4geUetJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DD7606A31F;
	Wed, 28 Oct 2026 19:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O4geUetJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846AC1F01825;
	Wed, 28 Oct 2026 19:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215971;
	bh=44osliRxjcjre6rVoJ5tyGvqf7+mkwTTVkHUOz6XeOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O4geUetJquOod+M5hjs3GAVJLyQkoUsRwAi8Sc2IZehKaN7Fo6RupJU73V5u1oZIK
	 oHJ5g0EqqydQcQaV3d2Owa+MLlo/TLCnKi6xHiwxBJUdqdj3kvNpTQwEFIqk99LhyY
	 50GeUZpQKYKRiWRr4xEsu/9G16J3CXwbdIqgZhaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1395/1887] svcrdma: Use svc_xprt_put to free listener on create failure
Date: Wed, 28 Oct 2026 17:58:11 +0100
Message-ID: <20261028170531.195379352@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit e346ef7bcb137f50c49f969330ab7dcf64ea1654 ]

svc_rdma_create() calls kfree(cma_xprt) when
svc_rdma_create_listen_id() fails. svc_xprt_init() has already
acquired a net namespace reference via get_net_track(); kfree
bypasses svc_xprt_free() which releases it.

Replace the kfree() with svc_xprt_put() so the kref_init birth
reference drops to zero and svc_xprt_free() dispatches
svc_rdma_free() to clean up properly. sc_cm_id is still NULL
at that point; the preceding patch added the necessary NULL
guard in svc_rdma_free().

svc_xprt_free() also drops the module reference via
module_put(), but the caller _svc_xprt_create() does the same
on xpo_create failure, double-putting the single
try_module_get() it acquired. Take a compensating
__module_get() before the svc_xprt_put() to keep the count
balanced, matching the convention in svc_rdma_accept()'s error
path.

Fixes: 4fb8518bdac8 ("sunrpc: Tag svc_xprt with net")
Cc: stable@vger.kernel.org
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260527-rdma-follow-on-v1-3-1b09bd87b6cd@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index ae15c2ed2f12c..f573b555853c7 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -350,7 +350,13 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
 
 	listen_id = svc_rdma_create_listen_id(net, sa, cma_xprt);
 	if (IS_ERR(listen_id)) {
-		kfree(cma_xprt);
+		/* _svc_xprt_create() acquired one module reference and
+		 * puts it on xpo_create failure.  svc_xprt_free() puts
+		 * a second one when the kref drops to zero.  Take a
+		 * compensating reference so both puts are balanced.
+		 */
+		__module_get(cma_xprt->sc_xprt.xpt_class->xcl_owner);
+		svc_xprt_put(&cma_xprt->sc_xprt);
 		return ERR_CAST(listen_id);
 	}
 	cma_xprt->sc_cm_id = listen_id;
-- 
2.53.0



