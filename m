Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125DA332EA2;
	Fri,  7 Aug 2026 14:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113990; cv=none; b=u2/NSErR4L3yVs9oJZEp6GWIHJA5Iv0oU3keVssKHc/29j4boILt8HXag9TFbKiXJXbW2m9E+wTX0FdJrNWLXLE6/Ag/nj+VL9hscoUJJlcXzy1e1wmQ43dNlESpeEEI7EQXPx6EcW65yhul0Yl7tXmyYQAx1vKDhxu3MJNdCIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113990; c=relaxed/simple;
	bh=rCiSLpqhBzh2Or7nlGqWWqoYLgRnwv7l1+7rWmc2ZYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyN2I+hb1/4kdKU5kmnO3qKq9oCHTSmLi3Ilvpq7fNFbQXvjXrBvMvUZNWQ+0YUuXopYyCVeeAgtfzl3g9Y/0NLbvGhKPxnHpeSoZ4mU/93h1AXov93LKSCnG670MQd7V3OYvIt+EODUXRRU01M7L5dAxcpeLzeZJ8EpT9rKuVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8z9Fftg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8z9Fftg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229A41F000E9;
	Fri,  7 Aug 2026 14:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113988;
	bh=n8oBTStOMVFE3qu90Y5QwUTlhOEJjqdLGWu2bJq3/DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z8z9FftgyparICajxc5ARRZk/+ZdAdVnMB7g4VGOLODZBCV1H+GuL0Uk84m3Ts8LA
	 ZQ3SKuIZqqDmkAM2QjNmNMCQN/fIDIkGMIVagmmxz9RwfhFFrSJQJCAq4SnjPCiFad
	 1RRC+Z1rWAWEYeg0yno/SXgGpyAgeayRpgDBXX/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/337] Bluetooth: hci_conn: hold conn reference in abort_conn_sync()
Date: Fri,  7 Aug 2026 16:35:07 +0200
Message-ID: <20260807143420.794213817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 93c14e2d66c8a..c5b006d9d974a 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2925,6 +2925,13 @@ static int abort_conn_sync(struct hci_dev *hdev, void *data)
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
@@ -2950,6 +2957,9 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
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



