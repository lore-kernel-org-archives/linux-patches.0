Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DB93D9545;
	Mon, 17 Aug 2026 15:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980207; cv=none; b=QIoNkDQOB0zIZYyVWZqT4X3xL02aIsTi9qk3y/V3j32vmp8HZCYBMdsenKYGh3REMT9sIF/Bq6vTR7uA+W2dHgoVOXM4R9g6p2OA/xO5Q0cjByS1VXUPhpOlDvM+pK6BFIzvNc7hzcVzm34r35CkDM/Rxk8Vde+R4DAvRh0xCvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980207; c=relaxed/simple;
	bh=DvN4qd5/B1SdYuxKThX2i5NlOq63Th7GosyLx4kNyA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx7P6L2SvpZAQch0jH1ZxHRyXzascsUPjifR7Pj+ujMCWCWL/cvk9J6Jn4WUWYIFtV+wOGZWwnHLP0vk9SYZfktPxMM4/7SbmgWYhLnhv94s2ZwljXcQUQNaWN45SNG7f6rxPE4s3oSezjnktPGb3c28DjlUWHSkBLNDVqPaZ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6MIw1gJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6MIw1gJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143501F000E9;
	Mon, 17 Aug 2026 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980205;
	bh=Oh9AsxFGG/OOD7u+AOKK+OhQ5z72wYZSYMHHnaE/oz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6MIw1gJ/HW+vH7PqVrvq5A7+Kw82EAHnknKbv/YJMLFcrgULFIojQZ0o0lQ1qgsf
	 Ti93rApAvwDuog9543sH4lqTRKLD9ZGvxofmvHWmy3w4toh9yBQ3KVYFQ+QKma+0y5
	 bEWqlaals7/pYpks3wRNkMxTpv0NBBsOBFuZjsJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	David Carlier <devnexen@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Todd Kjos <tkjos@google.com>
Subject: [PATCH 6.1 485/609] Bluetooth: hci_conn: fix potential UAF in create_big_sync
Date: Mon, 17 Aug 2026 15:33:01 +0200
Message-ID: <20260817132600.158022042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ Backported to 6.1.y: included inline helper hci_conn_valid() in
  include/net/bluetooth/hci_core.h from upstream commit 881559af5f5c ]
Signed-off-by: Todd Kjos <tkjos@google.com>
---
 include/net/bluetooth/hci_core.h | 18 ++++++++++++++++++
 net/bluetooth/hci_conn.c         | 19 ++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index e67b1e5e0d2c8..76764d399b23e 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1069,6 +1069,24 @@ static inline unsigned int hci_conn_count(struct hci_dev *hdev)
 	return c->acl_num + c->amp_num + c->sco_num + c->le_num + c->iso_num;
 }
 
+static inline bool hci_conn_valid(struct hci_dev *hdev, struct hci_conn *conn)
+{
+	struct hci_conn_hash *h = &hdev->conn_hash;
+	struct hci_conn  *c;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(c, &h->list, list) {
+		if (c == conn) {
+			rcu_read_unlock();
+			return true;
+		}
+	}
+	rcu_read_unlock();
+
+	return false;
+}
+
 static inline __u8 hci_conn_lookup_type(struct hci_dev *hdev, __u16 handle)
 {
 	struct hci_conn_hash *h = &hdev->conn_hash;
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 54cfcab763638..aa5404412cbd3 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2088,6 +2088,9 @@ static int create_big_sync(struct hci_dev *hdev, void *data)
 	u32 flags = 0;
 	int err;
 
+	if (!hci_conn_valid(hdev, conn))
+		return -ECANCELED;
+
 	if (qos->out.phy == 0x02)
 		flags |= MGMT_ADV_FLAG_SEC_2M;
 
@@ -2194,11 +2197,24 @@ static void create_big_complete(struct hci_dev *hdev, void *data, int err)
 
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
 
 struct hci_conn *hci_connect_bis(struct hci_dev *hdev, bdaddr_t *dst,
@@ -2223,10 +2239,11 @@ struct hci_conn *hci_connect_bis(struct hci_dev *hdev, bdaddr_t *dst,
 	}
 
 	/* Queue start periodic advertising and create BIG */
-	err = hci_cmd_sync_queue(hdev, create_big_sync, conn,
+	err = hci_cmd_sync_queue(hdev, create_big_sync, hci_conn_get(conn),
 				 create_big_complete);
 	if (err < 0) {
 		hci_conn_drop(conn);
+		hci_conn_put(conn);
 		return ERR_PTR(err);
 	}
 
-- 
2.53.0



