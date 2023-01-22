Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3D37E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1B3C433D2;
	Sun, 22 Jan 2023 15:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400288;
	bh=EZ3BUobsby/MOPiHnmeAU9CQ6rU4BMV9oA+8+70P4tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqJkRsLnz31FN3LCBbaWaqPQGY7CK5naMtxj6EKlWtEEZVVutodepE769k/Og6ETc
	 /u0i7WKFscL8YCOLDXUl+l8x0ni8S3kYTtlKTw+uDPPfr4CyB49c+MgGYmc2Pyrqi7
	 WQsWA3k3Fviu8vCRWmsntqy6C8TIz7qrIVcJnZ4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/98] RDMA/srp: Move large values to a new enum for gcc13
Date: Sun, 22 Jan 2023 16:03:22 +0100
Message-Id: <20230122150229.674135320@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 56c5dab20a6391604df9521f812c01d1e3fe1bd0 ]

Since gcc13, each member of an enum has the same type as the enum [1]. And
that is inherited from its members. Provided these two:
  SRP_TAG_NO_REQ        = ~0U,
  SRP_TAG_TSK_MGMT	= 1U << 31
all other members are unsigned ints.

Esp. with SRP_MAX_SGE and SRP_TSK_MGMT_SQ_SIZE and their use in min(),
this results in the following warnings:
  include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast
  drivers/infiniband/ulp/srp/ib_srp.c:563:42: note: in expansion of macro 'min'

  include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast
  drivers/infiniband/ulp/srp/ib_srp.c:2369:27: note: in expansion of macro 'min'

So move the large values away to a separate enum, so that they don't
affect other members.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

Link: https://lore.kernel.org/r/20221212120411.13750-1-jirislaby@kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 6818cac0a3b7..85bac20d9007 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -62,9 +62,6 @@ enum {
 	SRP_DEFAULT_CMD_SQ_SIZE = SRP_DEFAULT_QUEUE_SIZE - SRP_RSP_SQ_SIZE -
 				  SRP_TSK_MGMT_SQ_SIZE,
 
-	SRP_TAG_NO_REQ		= ~0U,
-	SRP_TAG_TSK_MGMT	= 1U << 31,
-
 	SRP_MAX_PAGES_PER_MR	= 512,
 
 	SRP_MAX_ADD_CDB_LEN	= 16,
@@ -79,6 +76,11 @@ enum {
 				  sizeof(struct srp_imm_buf),
 };
 
+enum {
+	SRP_TAG_NO_REQ		= ~0U,
+	SRP_TAG_TSK_MGMT	= BIT(31),
+};
+
 enum srp_target_state {
 	SRP_TARGET_SCANNING,
 	SRP_TARGET_LIVE,
-- 
2.35.1



