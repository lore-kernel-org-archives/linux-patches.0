Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374F33BFE4C;
	Fri, 15 May 2026 16:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861686; cv=none; b=tVHHuzZXivkgg+buRWBiR8kFniD2DM0B3wuC9KBkt5WtiDOB2Tv6mdJm31+QaU9oOfIQDgeCcnq0d+5yXMGFPqbhwIXALYghl3jw9QHcxAIoR9o1SgCqSvYOdn93FH7cAkK9rJokTdLIyPV6UFQFioAbKEph1xJGfSHuiNdOZUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861686; c=relaxed/simple;
	bh=EHfSpHLEUpn2iigdyb3fncMeMOEO2BSloqLj+3PojzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUHxEg1SV6QEoGM3eJ/Y2yCX7Gfv2gbSx0C8ynQYSLmnkR9dqIFzQhNvkKBh6u2047/LMM2skkz9HYTEpCZjMNwoLzKqpZKw5ZlMkJB07QiNEbYjQhLAyIegd5Yp3c4fu1KOCrq+0gH9e3zje5Xk2TcZghoeWtqZ6wutGG4qJsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Dba8B3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Dba8B3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D85C2BCB0;
	Fri, 15 May 2026 16:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861686;
	bh=EHfSpHLEUpn2iigdyb3fncMeMOEO2BSloqLj+3PojzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Dba8B3RVbx0B6App0bm9WzszqlxbgHJNui9UMoBWoIypijfEIcgy4ASVS6MknSp/
	 hs246XtsyMsbIH3Ad7j4T63RhEIP+15I5aMBllXqs7xgJIReKe1NDQSIPCJP7yVACq
	 msXXQFqxJp7+nfRLHPsmx09NKvOr40HHr7rGwubw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	David Carlier <devnexen@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 422/474] Bluetooth: hci_conn: fix potential UAF in create_big_sync
Date: Fri, 15 May 2026 17:48:51 +0200
Message-ID: <20260515154724.195237237@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 0beddb0c380bed5f5b8e61ddbe14635bb73d0b41 ]

Add hci_conn_valid() check in create_big_sync() to detect stale
connections before proceeding with BIG creation. Handle the
resulting -ECANCELED in create_big_complete() and re-validate the
connection under hci_dev_lock() before dereferencing, matching the
pattern used by create_le_conn_complete() and create_pa_complete().

Keep the hci_conn object alive across the async boundary by taking
a reference via hci_conn_get() when queueing create_big_sync(), and
dropping it in the completion callback. The refcount and the lock
are complementary: the refcount keeps the object allocated, while
hci_dev_lock() serializes hci_conn_hash_del()'s list_del_rcu() on
hdev->conn_hash, as required by hci_conn_del().

hci_conn_put() is called outside hci_dev_unlock() so the final put
(which resolves to kfree() via bt_link_release) does not run under
hdev->lock, though the release path would be safe either way.

Without this, create_big_complete() would unconditionally
dereference the conn pointer on error, causing a use-after-free
via hci_connect_cfm() and hci_conn_del().

Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Cc: stable@vger.kernel.org
Co-developed-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ kept stable's `qos->bcast.out.phy == 0x02` context line instead of upstream's renamed `qos->bcast.out.phys == BIT(1)` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2014,6 +2014,9 @@ static int create_big_sync(struct hci_de
 	u32 flags = 0;
 	int err;
 
+	if (!hci_conn_valid(hdev, conn))
+		return -ECANCELED;
+
 	if (qos->bcast.out.phy == 0x02)
 		flags |= MGMT_ADV_FLAG_SEC_2M;
 
@@ -2125,11 +2128,24 @@ static void create_big_complete(struct h
 
 	bt_dev_dbg(hdev, "conn %p", conn);
 
+	if (err == -ECANCELED)
+		goto done;
+
+	hci_dev_lock(hdev);
+
+	if (!hci_conn_valid(hdev, conn))
+		goto unlock;
+
 	if (err) {
 		bt_dev_err(hdev, "Unable to create BIG: %d", err);
 		hci_connect_cfm(conn, err);
 		hci_conn_del(conn);
 	}
+
+unlock:
+	hci_dev_unlock(hdev);
+done:
+	hci_conn_put(conn);
 }
 
 struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst,
@@ -2230,10 +2246,11 @@ struct hci_conn *hci_connect_bis(struct
 				 BT_BOUND, &data);
 
 	/* Queue start periodic advertising and create BIG */
-	err = hci_cmd_sync_queue(hdev, create_big_sync, conn,
+	err = hci_cmd_sync_queue(hdev, create_big_sync, hci_conn_get(conn),
 				 create_big_complete);
 	if (err < 0) {
 		hci_conn_drop(conn);
+		hci_conn_put(conn);
 		return ERR_PTR(err);
 	}
 


