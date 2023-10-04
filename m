Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655371D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADC2C433C7;
	Wed,  4 Oct 2023 18:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442670;
	bh=FABeDLnSMJrQzz4od+8oRc+HbfJ1Ix4bih0ryybpJxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmmsAJ1gcBY50Lks+Kykkwt8Df4GRfPO4Pb/lPkyCUsjsMnnn1JdykhejiZ4N3DnI
	 FSRBoS9LKCANP9AZBH7ZwBJ+oNrkU6gc8N03oy7ygC+b2y1zLdWuL5T1xqjiKSxSEa
	 Vl184YFWZe9N2pYqcQQ9KHsYQXcjsxXerTI3Q1xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/183] net: rds: Fix possible NULL-pointer dereference
Date: Wed,  4 Oct 2023 19:54:51 +0200
Message-ID: <20231004175206.402452169@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a9e4ff948a7d6..f71f073fd27ac 100644
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



