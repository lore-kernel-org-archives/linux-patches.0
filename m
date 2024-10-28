Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C2515B10D;
	Mon, 28 Oct 2024 06:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097815; cv=none; b=Ymxf1t0LKoUhSaqBfi+Qxbn9AlkNqbA6ASGzKICE5DmddJ+OsT6xIFDg4WsCpK5mY6bL8AkfekoXTbI9LbWO77VGA6UZSCcr36sSiGItK9hrRQCkQg1iIKc3Se84kIfAvTijkZ9YMibGQ/UiU9tQn4Yqr3f0MntFRE4k/2itk4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097815; c=relaxed/simple;
	bh=2ZPZwM0AfavPZ0KmV4B5yIGJI1uA9DLGBbket/wUzwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRRxGXxKCWeBMQTFrs+yRzqQsYg+S1Q1jhClB44A3Ln0RxIjs++3lFdJZXPRsYC7frPDiI4Q1IdsyCW2JHUFcNutfpy5I3HxGOe3e/O1eym40ofC/S0kCbOuABV/BzBTyI0cIsQQah+Gkmzo6BMn9g88YS10HDNKjsF/TcARupE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxF0a5bW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxF0a5bW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EF1C4CEC3;
	Mon, 28 Oct 2024 06:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097815;
	bh=2ZPZwM0AfavPZ0KmV4B5yIGJI1uA9DLGBbket/wUzwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxF0a5bWyXnADUL/35eGmjtq7/LsHf/uTodjkznAN0k1hWj2db/ofKPwaJhBb7kma
	 q0nSiyMhapBrYgEbcfKwW2huzxhIDFDBD3XsjPu3ImwWyMCfuZP11Qx/4DPU2ASenV
	 UomYivAbm/XkqJYAepTJGcA9KoRXVjrKc95o/uN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/208] Bluetooth: ISO: Fix UAF on iso_sock_timeout
Date: Mon, 28 Oct 2024 07:25:39 +0100
Message-ID: <20241028062310.543954228@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9b365fb44fac6..c2c80d6000836 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -90,6 +90,16 @@ static struct sock *iso_get_sock_listen(bdaddr_t *src, bdaddr_t *dst,
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
@@ -97,9 +107,7 @@ static void iso_sock_timeout(struct work_struct *work)
 	struct sock *sk;
 
 	iso_conn_lock(conn);
-	sk = conn->sk;
-	if (sk)
-		sock_hold(sk);
+	sk = iso_sock_hold(conn);
 	iso_conn_unlock(conn);
 
 	if (!sk)
@@ -217,9 +225,7 @@ static void iso_conn_del(struct hci_conn *hcon, int err)
 
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



