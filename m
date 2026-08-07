Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65077377A93;
	Fri,  7 Aug 2026 15:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115007; cv=none; b=RRHv1csWah6YO2lEyfnYDf7pVJ95vz7xHFKdMnEPjl6oLrSadHOa9tXz3IwMPiZSYlC4jOSHk+Zs6AkwAmjEaLiRDRz10LvJ9cMqW0jNEcT55rMjEd25LiILZiLyEITYVRuDW2SN4TiVCjChS4yNq+3IUBbJ6RBbfqfxcFi8zuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115007; c=relaxed/simple;
	bh=tQBviu+Hx61TyH7fcjAeiNAnpAAEkGThAo4yuSZHlZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFSW+I8hsqUaUi7TPAd/T+0qa0MJf9CXniCO6a2MCOMXiceuOpPXdOye2j4iZpYhWqhNvPWv/7eHKn1xTgBSnVVRpfzMF09S4MLXZ3zqxPtmyD0l7pC3WzthguXc0HDSlLBjIyTqJYAKCjI+D/B11Wm7z2oHXHAotAUF2jY5BEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrOJApJ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrOJApJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A8D1F000E9;
	Fri,  7 Aug 2026 15:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115005;
	bh=qhWlkJWP8CXpZ2IzN6gcP5fq3wguSNTNgwCG8I3mCUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qrOJApJ2yNCmg1uzCkR1Q+oZ3lNPV7C+8rEWdTvOaAmZ0dWT57E7De+2WM/+2EWAh
	 YnV5secDElTc+VjMyTvDfZSBvTAx7PrPZht/QXMN0dkEgzsp7EXz3UHyY2J/fsVZJT
	 ZYSwTsDrsCSsqXIR1bNVHAsZ7taSHVLITbykyG/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 123/396] Bluetooth: hci_conn: hold conn reference in abort_conn_sync()
Date: Fri,  7 Aug 2026 16:34:43 +0200
Message-ID: <20260807143426.960262022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 5761d003daa987ac81463f570713ce9c9dd204e5 ]

There is theoretical UAF if the conn is freed while the hci_sync task is
running.

Hold refcount to avoid that.

Fixes: 227a0cdf4a02 ("Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index f485cffe35735..e630d6369a0c3 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2965,6 +2965,13 @@ static int abort_conn_sync(struct hci_dev *hdev, void *data)
 	return hci_abort_conn_sync(hdev, conn, conn->abort_reason);
 }
 
+static void abort_conn_destroy(struct hci_dev *hdev, void *data, int err)
+{
+	struct hci_conn *conn = data;
+
+	hci_conn_put(conn);
+}
+
 int hci_abort_conn(struct hci_conn *conn, u8 reason)
 {
 	struct hci_dev *hdev = conn->hdev;
@@ -2990,7 +2997,10 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 	 * as a result to MGMT_OP_DISCONNECT/MGMT_OP_UNPAIR which does
 	 * already queue its callback on cmd_sync_work.
 	 */
-	err = hci_cmd_sync_run_once(hdev, abort_conn_sync, conn, NULL);
+	err = hci_cmd_sync_run_once(hdev, abort_conn_sync, hci_conn_get(conn),
+				    abort_conn_destroy);
+	if (err)
+		hci_conn_put(conn);
 	return (err == -EEXIST) ? 0 : err;
 }
 
-- 
2.53.0



