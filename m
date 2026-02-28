Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E70340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301118; cv=none; b=T9hKXrO22XXM0eDI68QN0NilOoA2NSsR0lsVY68md0feH2ORwzyzeMa5VqZqjU2NopFgb6qtwnCeEpOGSAyDlNl4oSoBN/H2eJd3wZ6/pCeU6HMgSuMyA0O9Cn6fo40Den00vSwTnAyKokL5Pk51NGinm71KheOth3qcQxhIyro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301118; c=relaxed/simple;
	bh=4wLXK5S4UDku9OQOAkxbi5IM0s3pceDMWRtXIPyy4nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k04giQlO9czfP7QSB64FWEqi01BYIG/bcurvuG4RWcjr21qTDmnaIJwNX1yEQqrAw9G5uXH4zXpy7Gq2b5aok0hA/7yf7FLaRXfqa6F3MqCp0MxJrveLLBpio3N6dbIB+DcPVD54fBfmSOi+vU6q9bzgygBtkiU+7C7R5bWCFsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBtg8sRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBtg8sRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF8AC19425;
	Sat, 28 Feb 2026 17:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301118;
	bh=4wLXK5S4UDku9OQOAkxbi5IM0s3pceDMWRtXIPyy4nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBtg8sRC1xQBNADQ1X+v3qR43TgfZKXyMCL9/5EFGrpSjuV5grxukJkJGkc6r/onb
	 xdBfFAYqOZ2l0mt4XJU5XH8jXM1xykNtRk7g4nDLD6FSmgicEmrhubYWNPSRhBAwCV
	 M2/sm0C4lMmYZ7twbKP8WEJfh091skEmTM8+C6XlWujI7nIDFlbkVI6z6EEpJP7I4v
	 5GKGJWO2PbIxKVkEr20tS6ArKFwxlDqcPq974cA4YjkTG5ZS+T6mFpz0pV2tid55DF
	 nsniJJv2Ir3I0q8Rao/GreSBN+xk+RrBvfEDDDqgUsj2cHEovRuxMhqFFC5KQ+hohO
	 oP0SbJeuH6jMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Stefan=20S=C3=B8rensen?= <ssorensen@roku.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 275/752] Bluetooth: hci_conn: Set link_policy on incoming ACL connections
Date: Sat, 28 Feb 2026 12:39:46 -0500
Message-ID: <20260228174750.1542406-275-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Stefan Sørensen <ssorensen@roku.com>

[ Upstream commit 4bb091013ab0f2edfed3f58bebe658a798cbcc4d ]

The connection link policy is only set when establishing an outgoing
ACL connection causing connection idle modes not to be available on
incoming connections. Move the setting of the link policy to the
creation of the connection so all ACL connection will use the link
policy set on the HCI device.

Signed-off-by: Stefan Sørensen <ssorensen@roku.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 1 +
 net/bluetooth/hci_sync.c | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 6fc0692abf057..6dbef0cd53037 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -990,6 +990,7 @@ static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t
 	switch (type) {
 	case ACL_LINK:
 		conn->pkt_type = hdev->pkt_type & ACL_PTYPE_MASK;
+		conn->link_policy = hdev->link_policy;
 		conn->mtu = hdev->acl_mtu;
 		break;
 	case LE_LINK:
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index f5896c023a9fa..cc1d340a32c62 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6879,8 +6879,6 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 
 	conn->attempt++;
 
-	conn->link_policy = hdev->link_policy;
-
 	memset(&cp, 0, sizeof(cp));
 	bacpy(&cp.bdaddr, &conn->dst);
 	cp.pscan_rep_mode = 0x02;
-- 
2.51.0

