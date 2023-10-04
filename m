Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DDE1D6B0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ar2DIyTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55534C433C9;
	Wed,  4 Oct 2023 18:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444066;
	bh=Nq0wxDHc1DIS+/fazlv3MFBnuCInrBNO2TDflez4HAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ar2DIyTRqR7lDY/i2VEPw7U1rnaMBOVTz2uMjuSNT3g+KQYf4bkOcaMLmtHtZiDcI
	 KoqKRfoh1M3UgGzsSgCIlnLFyY/bOcQGP1hnQ2Ojrupo63Pa5h+GA43vIKVCWLkJmr
	 Sgrf58GzOFTM3g+mHupxbt0tBzjeZnk/HfnkC5yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 090/321] net: rds: Fix possible NULL-pointer dereference
Date: Wed,  4 Oct 2023 19:53:55 +0200
Message-ID: <20231004175233.378720010@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Chernyshev <artem.chernyshev@red-soft.ru>

[ Upstream commit f1d95df0f31048f1c59092648997686e3f7d9478 ]

In rds_rdma_cm_event_handler_cmn() check, if conn pointer exists
before dereferencing it as rdma_set_service_type() argument

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: fd261ce6a30e ("rds: rdma: update rdma transport for tos")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/rdma_transport.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index d36f3f6b43510..b15cf316b23a2 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -86,11 +86,13 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 		break;
 
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
-		rdma_set_service_type(cm_id, conn->c_tos);
-		rdma_set_min_rnr_timer(cm_id, IB_RNR_TIMER_000_32);
-		/* XXX do we need to clean up if this fails? */
-		ret = rdma_resolve_route(cm_id,
-					 RDS_RDMA_RESOLVE_TIMEOUT_MS);
+		if (conn) {
+			rdma_set_service_type(cm_id, conn->c_tos);
+			rdma_set_min_rnr_timer(cm_id, IB_RNR_TIMER_000_32);
+			/* XXX do we need to clean up if this fails? */
+			ret = rdma_resolve_route(cm_id,
+						 RDS_RDMA_RESOLVE_TIMEOUT_MS);
+		}
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_RESOLVED:
-- 
2.40.1



