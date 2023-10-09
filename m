Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF081A592
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDE7oNJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09556C433C8;
	Mon,  9 Oct 2023 13:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858744;
	bh=T5aJqd73KS955GrmWNXhqQUpAwvpR3gPyAG5/Dw7b4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDE7oNJeTXe1rmfcCo77CbnBy/aEF0+fmPvMUOJ+tWvlqzLB6f/vx7fG8r+5h7ZPi
	 CkZ3RH0Vtz/MOCYLYX7HP3RSjbkvQABFUyt1TivkdcKOXqOMPsbsmbRffjEgr57d4S
	 ZFuMEHx2Cq48wEg73oMUFCTKyU3gPaG3eevoxkIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/226] net: rds: Fix possible NULL-pointer dereference
Date: Mon,  9 Oct 2023 15:00:20 +0200
Message-ID: <20231009130128.330313680@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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
 net/rds/rdma_transport.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 5f741e51b4baa..bb38124a5d3db 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -86,10 +86,12 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 		break;
 
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
-		rdma_set_service_type(cm_id, conn->c_tos);
-		/* XXX do we need to clean up if this fails? */
-		ret = rdma_resolve_route(cm_id,
+		if (conn) {
+			rdma_set_service_type(cm_id, conn->c_tos);
+			/* XXX do we need to clean up if this fails? */
+			ret = rdma_resolve_route(cm_id,
 					 RDS_RDMA_RESOLVE_TIMEOUT_MS);
+		}
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_RESOLVED:
-- 
2.40.1



