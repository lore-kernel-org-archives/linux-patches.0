Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA41A15B10D;
	Mon, 28 Oct 2024 06:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097460; cv=none; b=eTlafWSrQCrcboMuHo+FCbI4VjZGrjvfIjvk9w3t7Ox9+5FRF3gt4FpO+PnvSdT9FSGr1L3HcrNko11Nq6uJRpfP3Cf23ex3W+qPdYvzop16TWIlP8sg9n/jrs9z6qMPZ28epDmW0Z/b+PCRatAns/9I+5et+89Epq5h+aZUCgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097460; c=relaxed/simple;
	bh=H3PhouvQxeYXOYq7VFZIVpjKXc5xTFl69SNxptMi1pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2P3dpN4TP2n9yWzMwgev1DOV5BKyz12qK2FczJnMjRGQiyWGEWn21QiLqBaTuA0ABNP71AB5JXLsR9fpgCcNrDqJTC3AKlwNnr0uzbQKc5oFPrVxrIwtDdvFtbWQIMMeBfoCuB+I/RCmSKisbhi+v4lczklC1hRrhGO7oYcwHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fop5UrR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fop5UrR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69399C4CEC7;
	Mon, 28 Oct 2024 06:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097460;
	bh=H3PhouvQxeYXOYq7VFZIVpjKXc5xTFl69SNxptMi1pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fop5UrR4B0bB01NMueekC7ljcbPbXmzKk+zrxSi6Q1FAkhtvc9cBTmjSazkOasZfX
	 oDSuO1kIo5hyKgY3+yxQ7fqwtAjILkWrsR+A9B9F7fezPBbMdJWN/ue0+blQmLXdnW
	 Q8IwuL4azZHW1FfzxEsoaudLxbvEfGP16QSGAd64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/137] Bluetooth: ISO: Fix UAF on iso_sock_timeout
Date: Mon, 28 Oct 2024 07:25:43 +0100
Message-ID: <20241028062301.681590040@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 246b435ad668596aa0e2bbb9d491b6413861211a ]

conn->sk maybe have been unlinked/freed while waiting for iso_conn_lock
so this checks if the conn->sk is still valid by checking if it part of
iso_sk_list.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index b61abddc7bd4e..27efca5dc7bbf 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -68,6 +68,16 @@ struct iso_pinfo {
 #define ISO_CONN_TIMEOUT	(HZ * 40)
 #define ISO_DISCONN_TIMEOUT	(HZ * 2)
 
+static struct sock *iso_sock_hold(struct iso_conn *conn)
+{
+	if (!conn || !bt_sock_linked(&iso_sk_list, conn->sk))
+		return NULL;
+
+	sock_hold(conn->sk);
+
+	return conn->sk;
+}
+
 static void iso_sock_timeout(struct work_struct *work)
 {
 	struct iso_conn *conn = container_of(work, struct iso_conn,
@@ -75,9 +85,7 @@ static void iso_sock_timeout(struct work_struct *work)
 	struct sock *sk;
 
 	iso_conn_lock(conn);
-	sk = conn->sk;
-	if (sk)
-		sock_hold(sk);
+	sk = iso_sock_hold(conn);
 	iso_conn_unlock(conn);
 
 	if (!sk)
@@ -184,9 +192,7 @@ static void iso_conn_del(struct hci_conn *hcon, int err)
 
 	/* Kill socket */
 	iso_conn_lock(conn);
-	sk = conn->sk;
-	if (sk)
-		sock_hold(sk);
+	sk = iso_sock_hold(conn);
 	iso_conn_unlock(conn);
 
 	if (sk) {
-- 
2.43.0



