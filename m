Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ECE33C1AD;
	Fri,  7 Aug 2026 15:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115003; cv=none; b=McYwv/zyRjgVRC2buZ8cZ6GkpmtZo06TwJz6c9KX4S58exOuLSEUcmK9DaK8TT16XCTT9VDwqki9pUh1wqkvCJBoUSePXHXs6Odw3H6Uvbw4hvM7lZ4x3Uut2no6nm2Kyp+b3Vz0o2BkXChtK0nSeGG7zYXWWiEwtBcuEpqnYoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115003; c=relaxed/simple;
	bh=KUleKhgwX4DD55R6T9523bEnvXI/Exv5OtvDJoVVe1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PChFWdbmQgKOkzQja6odW0QnWUgYu1fMqKqLShfuHk54RiPYDnrhgUNl1H1v+WiCpbpLBRYNZfvh2zU/nSIsKVPNkZC0xmMVrU4rHrXh4qUSmrkNU6VJMzXkOblc+Fep/CJCUnDRzCbxHx6FnS8tsJDFgbUmDpjZyRYJ4AUytYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUvPRbij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUvPRbij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8A41F000E9;
	Fri,  7 Aug 2026 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115002;
	bh=c1pO9ACS3QDzvRJ4WqS90juOQUe8ECaeSynsdn05vPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uUvPRbij8ANd6smet88KjbxCbhOn13Gka77ANxjkkUudTo5J5mJd7D7P0G0ouxq4W
	 SrOyZKPTIrVp+qJD//OIdzFMwfJXaKWMkMdxDaN5AMV7A4x6O0Bjezz6xQh1QJzkQ8
	 Ur4ZjlCh+RHOszgNM+uu+gNWJMJFPwrwsPtaFu3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 122/396] Bluetooth: hci_sync: make hci_cmd_sync_run_once return -EEXIST if exists
Date: Fri,  7 Aug 2026 16:34:42 +0200
Message-ID: <20260807143426.937154372@linuxfoundation.org>
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

[ Upstream commit d288f4db0909c22342eb50cd1632b4d850517281 ]

hci_cmd_sync_run_once() needs to indicate whether a queue item was
added, so caller can know if callbacks are called, so it can avoid
leaking resources.

Change the function to return -EEXIST if queue item already exists.

Modify all callsites vs. the changes.  The only callsite is
hci_abort_conn().

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 5761d003daa9 ("Bluetooth: hci_conn: hold conn reference in abort_conn_sync()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 4 +++-
 net/bluetooth/hci_sync.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index ceeb19158a36c..f485cffe35735 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2968,6 +2968,7 @@ static int abort_conn_sync(struct hci_dev *hdev, void *data)
 int hci_abort_conn(struct hci_conn *conn, u8 reason)
 {
 	struct hci_dev *hdev = conn->hdev;
+	int err;
 
 	/* If abort_reason has already been set it means the connection is
 	 * already being aborted so don't attempt to overwrite it.
@@ -2989,7 +2990,8 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 	 * as a result to MGMT_OP_DISCONNECT/MGMT_OP_UNPAIR which does
 	 * already queue its callback on cmd_sync_work.
 	 */
-	return hci_cmd_sync_run_once(hdev, abort_conn_sync, conn, NULL);
+	err = hci_cmd_sync_run_once(hdev, abort_conn_sync, conn, NULL);
+	return (err == -EEXIST) ? 0 : err;
 }
 
 void hci_setup_tx_timestamp(struct sk_buff *skb, size_t key_offset,
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 87a2502fccd6e..ca002269306c4 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -825,7 +825,7 @@ int hci_cmd_sync_run_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 			  void *data, hci_cmd_sync_work_destroy_t destroy)
 {
 	if (hci_cmd_sync_lookup_entry(hdev, func, data, destroy))
-		return 0;
+		return -EEXIST;
 
 	return hci_cmd_sync_run(hdev, func, data, destroy);
 }
-- 
2.53.0



