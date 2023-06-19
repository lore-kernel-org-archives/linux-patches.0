Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A208ABE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C71C433C0;
	Mon, 19 Jun 2023 10:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171693;
	bh=Tcbzsrwxn8D0kz3ZOEH/d0tsXkrF+vz8eBY3cOkrdvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bf8MUCQtFg0tMoKTfeeluKM6mKYgjJLs53rZ4c3N/N+IAYJRqxgmlyT9ZbNsmnVb7
	 nD0dan7OT0tqEt4UJ5ysKuWqLLhZwrWiMUMSLFCU2vfcrvDnjk2dZ4+LjxTts3wTVq
	 PujJaRaIuO7xNABnWGz2wN3Kb27jqmP5/G9I0UFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/166] IB/isert: Fix incorrect release of isert connection
Date: Mon, 19 Jun 2023 12:30:00 +0200
Message-ID: <20230619102200.802674206@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
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
index a02a3caeaa4e7..a7fef3ea77fe3 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2571,8 +2571,6 @@ static void isert_wait_conn(struct iscsit_conn *conn)
 	isert_put_unsol_pending_cmds(conn);
 	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
-
-	queue_work(isert_release_wq, &isert_conn->release_work);
 }
 
 static void isert_free_conn(struct iscsit_conn *conn)
-- 
2.39.2



