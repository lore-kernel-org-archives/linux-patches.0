Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58C73A6F0A;
	Fri,  7 Aug 2026 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116935; cv=none; b=ORpwR1Iasnhiz8A600YEi6sIPSycgiXFPso6jBtp8vwh8UaMbhfvDb0j++Dk3S6KO/g3O8FCG0PRTavnyBPYBU1h0MJ++o6j9jy+UaoE/Vn7jxwquFPPSbOQjzQ5MFum2ToSp4wf1tjFXWQh76KFOMOE4+Pq4awZKPVXZAKzBfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116935; c=relaxed/simple;
	bh=YEXg4sUvYPyZlZdsciJrDqTlD/BJe8Pi5yfxaXHYwPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McKhNg02LL+PCwy9h35k8lQnPlDZiQHLtco07OeLjoCZNGF1FG3OyS3aZ9fAzq8/EboGlqPdYPuTumR74sxore+Woswid5BWETT0Cv4RhmOgNYB92piPt6cMDa9QzOD/QvSJyN9bjTJEnsAqe6wSZRTA5E+MsmmgOFBnXaRON/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHErQ21z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHErQ21z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6401F000E9;
	Fri,  7 Aug 2026 15:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116934;
	bh=EpO0VarNIPqGLNbqEm/VnVY2O8nKE/bAL9PJxTfPNoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHErQ21zbYxLNApHmwEJR2kHnZH/9NKsDlv9aGoWJRClyCw9+/5o+9Ybwh51gteRM
	 3u9c5zT7wrdcpTyRYPSJEI68WMKZ1dB0j9zrBMVeWj2vPvmsyGfSSPDcuhti3rbQOQ
	 wTzCrQVTxq0DdQUm54r4I06WXlsRPuAdNcqVE8K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 142/438] Bluetooth: hci_conn: hold conn reference in abort_conn_sync()
Date: Fri,  7 Aug 2026 16:35:38 +0200
Message-ID: <20260807143431.032764913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 924c7795e368a..fb96d019cf856 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -3168,6 +3168,13 @@ static int abort_conn_sync(struct hci_dev *hdev, void *data)
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
@@ -3193,7 +3200,10 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
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



