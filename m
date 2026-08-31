Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CE74BB5C6;
	Mon, 31 Aug 2026 14:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184848; cv=none; b=P+x4DN7PAxOzv9j2EBkKugSxlctGoSfO/qPaQqu9RTvaqkAMRY3tM84eQHv1VQnXbg7HtTs4m2BubgpN8bB30bBJ5GpoF9scW06CKROr+FaK3cpAD75YkgRZq8cBF3IcMHK0ygnPVUkAIWTLA7wGtOaIPwby6zhg7tgCXTu3LyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184848; c=relaxed/simple;
	bh=jNkPd6bWxjC928QD6Mz7GAANDT1M8cL4pztJtS4ARHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsZD+kgtfL2jmVEF0yGr6WHkCkF9wZz8977oyVoV8vgzRQe9ahC2hefIBtTeKC16LLc71mlN/B/xOrYyQ0db21S7/bWX8XvLyjujC6XPj9YJqJPJ8Ozuz7Nbc/iHs2j522j4ZHEEBWuYfQLSpGuf9tpXThUjQ2atcbTquEXOgOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acj+OcGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acj+OcGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73441F000E9;
	Mon, 31 Aug 2026 14:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184846;
	bh=R8/dIcJEe416H5+ifsG9AjEVpzRnRQLGJR4/jOdgpjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=acj+OcGxknaEaaQycJzlrH91A1eflD3T65dBIwfEb8q5SLabICHm10oPBsuO8G9q4
	 UJvSzYJ1UaxtbWvHw+weuTO4JIoz2N51RGEt1JDt7+aftZvS7Sovx+eoXaA6w+waEb
	 j/242jN3JdLTlLPkkWNeS4pAXgSpUBQceX7TP/Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 57/92] Bluetooth: hci_conn: Fix not matching by CIS ID
Date: Mon, 31 Aug 2026 15:34:55 +0200
Message-ID: <20260831133402.667611082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c14516faede33c2c31da45cf950d55dbff42962e ]

This fixes only matching CIS by address which prevents creating new hcon
if upper layer is requesting a specific CIS ID.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 0acd4eeb4b22 ("Bluetooth: hci_event: validate LE Set CIG Parameters response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |   12 +++++++++++-
 net/bluetooth/hci_conn.c         |    3 ++-
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1178,7 +1178,9 @@ static inline struct hci_conn *hci_conn_
 
 static inline struct hci_conn *hci_conn_hash_lookup_cis(struct hci_dev *hdev,
 							bdaddr_t *ba,
-							__u8 ba_type)
+							__u8 ba_type,
+							__u8 cig,
+							__u8 id)
 {
 	struct hci_conn_hash *h = &hdev->conn_hash;
 	struct hci_conn  *c;
@@ -1189,6 +1191,14 @@ static inline struct hci_conn *hci_conn_
 		if (c->type != ISO_LINK)
 			continue;
 
+		/* Match CIG ID if set */
+		if (cig != BT_ISO_QOS_CIG_UNSET && cig != c->iso_qos.ucast.cig)
+			continue;
+
+		/* Match CIS ID if set */
+		if (id != BT_ISO_QOS_CIS_UNSET && id != c->iso_qos.ucast.cis)
+			continue;
+
 		if (ba_type == c->dst_type && !bacmp(&c->dst, ba)) {
 			rcu_read_unlock();
 			return c;
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1862,7 +1862,8 @@ struct hci_conn *hci_bind_cis(struct hci
 {
 	struct hci_conn *cis;
 
-	cis = hci_conn_hash_lookup_cis(hdev, dst, dst_type);
+	cis = hci_conn_hash_lookup_cis(hdev, dst, dst_type, qos->ucast.cig,
+				       qos->ucast.cis);
 	if (!cis) {
 		cis = hci_conn_add_unset(hdev, ISO_LINK, dst, HCI_ROLE_MASTER);
 		if (!cis)


