Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE363A6F0A;
	Fri,  7 Aug 2026 15:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116938; cv=none; b=FMQFB54uajfwIk++b6NNEwtFUXL68n3Rb9CvKwpF1Ur1HMZlNfteH/Nx6ySXq0CGI8pSDZrr7OQ5Xcad3RE0uVYTD4k85vIVIw2Wht4oY6LMeJUJFHkBC7cLQNJc2GP3MRZfru0GmIEjjwoSLLmkra18GGz94lUBV1i+DQ894PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116938; c=relaxed/simple;
	bh=b0S1noXiL+XRg9Uu8PdSQIlYynt6hlPuZ0KmBw+Rs4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLmvfvnwEGyOGEoGxO9Arz5h8RbaiD1XRELEf0A80QcPd6bP4t/ojguvErW5r7MgSmArAuzt8nC/6fCDYkLx9n5IngbobVknm9Dx96tg6XUwDHIrPGRsT69i9sGFvO3BvphmfgHoEJIZjZBMqzqn7CmcV/CAI74E9uhvzU1jFNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOR82kEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOR82kEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB46E1F000E9;
	Fri,  7 Aug 2026 15:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116937;
	bh=2zEZ5Ktq6X43rxV+6FTJ7YSEcI2Mjd5neaiaRi0Cy/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOR82kEQOBGaz/UDdwFAILDnUTHAL4MWOs6YLg2L01OZrC4YieOLkACHAMEk1D5TK
	 PGSTEkRMafpaCy290F2/dLtNriJ1El7kevkXoBtUeQIpCyIlzMa4TtUhj0wcXz88/9
	 Cm5HTSwOpV9TOF6DdC6k7CzolXA2AZirdl/MEBbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 143/438] Bluetooth: hci_sync: hold conn in hci_connect_acl/le_sync() callbacks
Date: Fri,  7 Aug 2026 16:35:39 +0200
Message-ID: <20260807143431.052844211@linuxfoundation.org>
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

[ Upstream commit 2f5d635ad5906b0235bc0c870e8beba3116e1e98 ]

There is theoretical UAF if the conn is freed while the hci_sync task
is running.

Hold refcount to avoid that.

Fixes: 881559af5f5c ("Bluetooth: hci_sync: Attempt to dequeue connection attempt")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 42bbffba2172e..2cac69922353a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7067,12 +7067,23 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 	return err;
 }
 
+static void hci_acl_create_conn_sync_complete(struct hci_dev *hdev, void *data,
+					      int err)
+{
+	struct hci_conn *conn = data;
+
+	hci_conn_put(conn);
+}
+
 int hci_connect_acl_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
 	int err;
 
-	err = hci_cmd_sync_queue_once(hdev, hci_acl_create_conn_sync, conn,
-				      NULL);
+	err = hci_cmd_sync_queue_once(hdev, hci_acl_create_conn_sync,
+				      hci_conn_get(conn),
+				      hci_acl_create_conn_sync_complete);
+	if (err)
+		hci_conn_put(conn);
 	return (err == -EEXIST) ? 0 : err;
 }
 
@@ -7083,36 +7094,41 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 	bt_dev_dbg(hdev, "err %d", err);
 
 	if (err == -ECANCELED)
-		return;
+		goto done;
 
 	hci_dev_lock(hdev);
 
 	if (!hci_conn_valid(hdev, conn))
-		goto done;
+		goto unlock;
 
 	if (!err) {
 		hci_connect_le_scan_cleanup(conn, 0x00);
-		goto done;
+		goto unlock;
 	}
 
 	/* Check if connection is still pending */
 	if (conn != hci_lookup_le_connect(hdev))
-		goto done;
+		goto unlock;
 
 	/* Flush to make sure we send create conn cancel command if needed */
 	flush_delayed_work(&conn->le_conn_timeout);
 	hci_conn_failed(conn, bt_status(err));
 
-done:
+unlock:
 	hci_dev_unlock(hdev);
+done:
+	hci_conn_put(conn);
 }
 
 int hci_connect_le_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
 	int err;
 
-	err = hci_cmd_sync_queue_once(hdev, hci_le_create_conn_sync, conn,
+	err = hci_cmd_sync_queue_once(hdev, hci_le_create_conn_sync,
+				      hci_conn_get(conn),
 				      create_le_conn_complete);
+	if (err)
+		hci_conn_put(conn);
 	return (err == -EEXIST) ? 0 : err;
 }
 
-- 
2.53.0



