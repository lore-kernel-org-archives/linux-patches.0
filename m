Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B3B1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C572C433C9;
	Mon, 11 Sep 2023 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440627;
	bh=ThiveC0KvlKmmG5kV4euqLhr0V5Ca7dahHZpsxVQmBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2Cehj2MswLvA7x4n+JOGCM2kdAg1HiRQ6potLmHe86QvHE5qlYH1sd91Nqdzi2RV
	 Nvxvbk7JIRdx0DiuGIj2l7mS0WoFJ+PtXvuqaYt1pv22s3Sg51ajD+cjzv1fSuUztl
	 2uuxQJbQURtHrEr0cS0IjUuO/fmil6m++faDEWyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 128/739] Bluetooth: hci_event: drop only unbound CIS if Set CIG Parameters fails
Date: Mon, 11 Sep 2023 15:38:47 +0200
Message-ID: <20230911134654.663186136@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 66dee21524d9ac6461ec3052652b7bc0603ee0c5 ]

When user tries to connect a new CIS when its CIG is not configurable,
that connection shall fail, but pre-existing connections shall not be
affected.  However, currently hci_cc_le_set_cig_params deletes all CIS
of the CIG on error so it doesn't work, even though controller shall not
change CIG/CIS configuration if the command fails.

Fix by failing on command error only the connections that are not yet
bound, so that we keep the previous CIS configuration like the
controller does.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index bdacfcd7082de..c02a7ac6de39c 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3803,6 +3803,22 @@ static u8 hci_cc_le_read_buffer_size_v2(struct hci_dev *hdev, void *data,
 	return rp->status;
 }
 
+static void hci_unbound_cis_failed(struct hci_dev *hdev, u8 cig, u8 status)
+{
+	struct hci_conn *conn, *tmp;
+
+	lockdep_assert_held(&hdev->lock);
+
+	list_for_each_entry_safe(conn, tmp, &hdev->conn_hash.list, list) {
+		if (conn->type != ISO_LINK || !bacmp(&conn->dst, BDADDR_ANY) ||
+		    conn->state == BT_OPEN || conn->iso_qos.ucast.cig != cig)
+			continue;
+
+		if (HCI_CONN_HANDLE_UNSET(conn->handle))
+			hci_conn_failed(conn, status);
+	}
+}
+
 static u8 hci_cc_le_set_cig_params(struct hci_dev *hdev, void *data,
 				   struct sk_buff *skb)
 {
@@ -3824,12 +3840,15 @@ static u8 hci_cc_le_set_cig_params(struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
+	/* BLUETOOTH CORE SPECIFICATION Version 5.4 | Vol 4, Part E page 2554
+	 *
+	 * If the Status return parameter is non-zero, then the state of the CIG
+	 * and its CIS configurations shall not be changed by the command. If
+	 * the CIG did not already exist, it shall not be created.
+	 */
 	if (status) {
-		while ((conn = hci_conn_hash_lookup_cig(hdev, rp->cig_id))) {
-			conn->state = BT_CLOSED;
-			hci_connect_cfm(conn, status);
-			hci_conn_del(conn);
-		}
+		/* Keep current configuration, fail only the unbound CIS */
+		hci_unbound_cis_failed(hdev, rp->cig_id, status);
 		goto unlock;
 	}
 
-- 
2.40.1



