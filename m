Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702065381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED754C433C8;
	Mon, 19 Jun 2023 10:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171309;
	bh=E3NB0T0XcszvM/6kUQe/ASL6b/m0RYz4HGOxlI69whg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZT3zf/LnL9+g3HF19PNYAUKKA7w8jkkEODLdAZrSOrPd7CP1zj4MbdADdCebTQe26
	 PkAsFeeGwvVdsafKy0Lf/PpqbWOQP+7eDbFIMHW27VzxXKyQXglOAiLj1eS0izxpWB
	 sfsmLDjCdrtHVkw8jC4fIq5IazesQXcFXy5a8o6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/49] IB/isert: Fix incorrect release of isert connection
Date: Mon, 19 Jun 2023 12:30:13 +0200
Message-ID: <20230619102131.736389872@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>
References: <20230619102129.856988902@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saravanan Vajravel <saravanan.vajravel@broadcom.com>

[ Upstream commit 699826f4e30ab76a62c238c86fbef7e826639c8d ]

The ib_isert module is releasing the isert connection both in
isert_wait_conn() handler as well as isert_free_conn() handler.
In isert_wait_conn() handler, it is expected to wait for iSCSI
session logout operation to complete. It should free the isert
connection only in isert_free_conn() handler.

When a bunch of iSER target is cleared, this issue can lead to
use-after-free memory issue as isert conn is twice released

Fixes: b02efbfc9a05 ("iser-target: Fix implicit termination of connections")
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/20230606102531.162967-4-saravanan.vajravel@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 60594dad55455..de6fc8887c4a4 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2654,8 +2654,6 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 	isert_put_unsol_pending_cmds(conn);
 	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
-
-	queue_work(isert_release_wq, &isert_conn->release_work);
 }
 
 static void isert_free_conn(struct iscsi_conn *conn)
-- 
2.39.2



