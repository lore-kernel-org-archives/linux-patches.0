Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487301B0F32;
	Wed, 19 Mar 2025 14:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394837; cv=none; b=ScRRVqDietzE4tKO8xoiA/So4LvLlSKnNGrWZ2hkX2aqSoNmm9ta012KRLYjCa39rb8Jw/Q+6hnsraXV9i6gTIrtciEGlWmZJrZVU9++AU2hxVjVmMK1Zx4J2dqLwIdOY7FxXxu5lWGz07PryoVyxwi6VU/oi/ymWSn0Kv1N4Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394837; c=relaxed/simple;
	bh=ZFsE6W7iwbJybHhCZiHzcXeKHXv5UNGbyTtquKD2Js8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIRuFLlqAuWvvprDYL/b4J5O8XIXNpgBknS2+XNyfJ5Kj6m3udI7azYbgOTs1dHFGrtK92+G9kIdfJgNcZzYEduLGkdM9lX90cp/gOjOrfzvxmQnjNVffW9fR1IUAUSXXp4/YsVpmiHD2zIQnxfB2sv2F9tZ5a9yb3WL/pOHP5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnGghMIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnGghMIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BBCC4CEE4;
	Wed, 19 Mar 2025 14:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394837;
	bh=ZFsE6W7iwbJybHhCZiHzcXeKHXv5UNGbyTtquKD2Js8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnGghMIVxCZI4wf5gSdtxQAM1+6AygO+1Dka/APbg55//HA92HfkQf49RG1i0W9V+
	 pWBvT11GCDjqsem229wCZtoeH+nTmjvACcQibtOhKDwmoviLtyDhsWYADTqwnVlPwp
	 irIzjuyOotAKi+YXjNSxjK1q+Zv25Poyur1xFtN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 018/241] Bluetooth: SCO: fix sco_conn refcounting on sco_conn_ready
Date: Wed, 19 Mar 2025 07:28:08 -0700
Message-ID: <20250319143028.159792999@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 8d74c9106be8da051b22f0cd81e665f17d51ba5d ]

sco_conn refcount shall not be incremented a second time if the sk
already owns the refcount, so hold only when adding new chan.

Add sco_conn_hold() for clarity, as refcnt is never zero here due to the
sco_conn_add().

Fixes SCO socket shutdown not actually closing the SCO connection.

Fixes: ed9588554943 ("Bluetooth: SCO: remove the redundant sco_conn_put")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index aa7bfe26cb40f..ed6846864ea93 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -107,6 +107,14 @@ static void sco_conn_put(struct sco_conn *conn)
 	kref_put(&conn->ref, sco_conn_free);
 }
 
+static struct sco_conn *sco_conn_hold(struct sco_conn *conn)
+{
+	BT_DBG("conn %p refcnt %u", conn, kref_read(&conn->ref));
+
+	kref_get(&conn->ref);
+	return conn;
+}
+
 static struct sco_conn *sco_conn_hold_unless_zero(struct sco_conn *conn)
 {
 	if (!conn)
@@ -1353,6 +1361,7 @@ static void sco_conn_ready(struct sco_conn *conn)
 		bacpy(&sco_pi(sk)->src, &conn->hcon->src);
 		bacpy(&sco_pi(sk)->dst, &conn->hcon->dst);
 
+		sco_conn_hold(conn);
 		hci_conn_hold(conn->hcon);
 		__sco_chan_add(conn, sk, parent);
 
@@ -1411,8 +1420,10 @@ static void sco_connect_cfm(struct hci_conn *hcon, __u8 status)
 		struct sco_conn *conn;
 
 		conn = sco_conn_add(hcon);
-		if (conn)
+		if (conn) {
 			sco_conn_ready(conn);
+			sco_conn_put(conn);
+		}
 	} else
 		sco_conn_del(hcon, bt_to_errno(status));
 }
-- 
2.39.5



