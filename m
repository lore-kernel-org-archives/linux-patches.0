Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1274E2D7D3A;
	Sat, 17 Oct 2026 18:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260173; cv=none; b=KU9TqUFmS6C4er81ZRON7nmJ3C+GQVSHy1uqeHCDGipOM7oD+Vpil1yXWHw/nFqqci3EzhlGP6i/E6RwsBYZo9sXUrc9EJpLfYN/26ZOf3h3l8WbJ3E0ZF0ESmVTD2Yi5S5V4Y1DN7qj84zNvqEmUpkWkj0uCkBdgOJVZgKkRto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260173; c=relaxed/simple;
	bh=/J6v2IGidsUM/txDO5yClROS1qDZm2pwKQrlgMLwpg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5DxTrBkdbNIvMm+zPk2KFMgTgS3J9u5qMvZs8x0B3UJ3dOpibilSqcpQa814vnZ+CR6Ecf9hcoYHa1MbTVGQoyeYsxG5vE3eIVFrC2ct7U4Q+VL/SOVMsPPHvMKFuZLXpMkfcKBELCsvdvYuuXtXO5n2guoG7hKG0f3QdkYlM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTKzBvJQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTKzBvJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ACB1F000C4;
	Sat, 17 Oct 2026 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260172;
	bh=wAzJpjSLXIjTKFmjMvt01IeWdKk/CsxwekTaRzjs4oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTKzBvJQK364OMzw8bl8TndtLPZTc/Pow2imxLvRA5iFr/a7HF5kWbERSXqD0cHMd
	 luVZGe7YBY9AJ+sGYG33zQIeV57HMZsusXvnIXGhJRG+HqMHXCx/49VJDDiRtdAL2V
	 8fUgaTz0/iNBwqf7ccl0yi8CGZGiQYMupakiNcgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1416/1674] Bluetooth: ISO: fix race of kfree vs kref_get_unless_zero
Date: Sat, 17 Oct 2026 18:01:28 +0200
Message-ID: <20261017160507.526239599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit af24e338bf5dafb80f42baa9a0b9e9b57b1c5d9c ]

hci_conn::iso_data is accessed and modified without lock or RCU.
This leads to a race

    [Task hdev->workqueue]                 	[Task 2]
    iso_recv                                    iso_conn_put(conn)
      conn = LOAD hcon->iso_data                  iso_conn_free(conn)
      iso_conn_hold_unless_zero(conn)               hcon->iso_data = NULL
                                                    kfree(conn)
        kref_get_unless_zero(&conn->ref) /* UAF */

and also to races in iso_conn_add() vs. iso_conn_free().

Fix by adding spinlock hci_conn::proto_lock and using it to guard
hci_conn::iso_data.

Fixes: dc26097bdb86 ("Bluetooth: ISO: Use kref to track lifetime of iso_conn")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 2b66c83ff175 ("Bluetooth: L2CAP: use proto_lock for l2cap_data to fix l2cap_disconn_ind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 2 ++
 net/bluetooth/hci_conn.c         | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 35249d2550ee9..62804d98d3ee2 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -745,6 +745,8 @@ struct hci_conn {
 	struct dentry	*debugfs;
 
 	struct hci_dev	*hdev;
+
+	spinlock_t	proto_lock; /* lock guarding protocol data */
 	void		*l2cap_data;
 	void		*sco_data;
 	void		*iso_data;
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 3713974d29397..7e209176d7db2 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1019,6 +1019,8 @@ static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t
 	INIT_DELAYED_WORK(&conn->idle_work, hci_conn_idle);
 	INIT_DELAYED_WORK(&conn->le_conn_timeout, le_conn_timeout);
 
+	spin_lock_init(&conn->proto_lock);
+
 	atomic_set(&conn->refcnt, 0);
 
 	hci_dev_hold(hdev);
-- 
2.53.0



