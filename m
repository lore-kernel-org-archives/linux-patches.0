Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332A03A9D84;
	Sat, 17 Oct 2026 16:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255031; cv=none; b=BOCMY0vbt5Xen8jld7gdEdmc4Lh8y6VtvdIxX+L26kyOuPdOkbTJ4GbkgYFmjmtxsfQohd3RPpfAGd7gokOEa0EEf0xP+8jjMIgNUIgVKmXpA2CpRyC24Os+d6eG+USpm50R0vt1F+c8LdvL77u/fhSEbwV+Uppr4Eb3eSkTwhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255031; c=relaxed/simple;
	bh=6r3sZJcLQgYU9hWBcDimFPDxQB8fwBgb7AfJGUkWl+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGcdGrtLH6Z2TTxw3j8PqrRpGEpAHuuXxfD0HYWnaefHCF4wWd90v14bBuZ1+IxKNYmpgtE6s2Y8h696r4j3rxrOfKbBxIAD50ziPSfqvXkAz6DGmrXGo4HsJg9bL4pnXU9yErfxSAGKGItolTLrEmcDO5Za91BwmjX7Det6R3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NjFN+Lm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NjFN+Lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEED1F000C4;
	Sat, 17 Oct 2026 16:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255030;
	bh=eEfxSxvVnhAARHZmxeYJODswR0POCINQ7D7ewDqerGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1NjFN+Lm34ZHhyJqpXhSz0fFj4YBnONqD9ledaOnGU4ILQDxIltJTjRtk2s9uRIxe
	 qo81zmNei1Uolw1BNWYxy4B2dRjJiiTAg3z9q7/O3wwpVjpzqqr+ryCXbdH6Iqtq31
	 F+HX0yC16//oRSzlOMQG+QO22uz7PTW/KmaXIaZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 641/869] Bluetooth: ISO: fix race of kfree vs kref_get_unless_zero
Date: Sat, 17 Oct 2026 17:58:02 +0200
Message-ID: <20261017160053.451037269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 763f003ac29e3..f846865db0ca4 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -751,6 +751,8 @@ struct hci_conn {
 	struct dentry	*debugfs;
 
 	struct hci_dev	*hdev;
+
+	spinlock_t	proto_lock; /* lock guarding protocol data */
 	void		*l2cap_data;
 	void		*sco_data;
 	void		*iso_data;
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 48d28c79e2992..602b5be7eccc8 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1052,6 +1052,8 @@ static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t
 	INIT_DELAYED_WORK(&conn->idle_work, hci_conn_idle);
 	INIT_DELAYED_WORK(&conn->le_conn_timeout, le_conn_timeout);
 
+	spin_lock_init(&conn->proto_lock);
+
 	atomic_set(&conn->refcnt, 0);
 
 	hci_dev_hold(hdev);
-- 
2.53.0



