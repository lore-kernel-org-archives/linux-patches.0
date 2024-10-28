Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9942AF07;
	Mon, 28 Oct 2024 06:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098419; cv=none; b=UWvDnr36sCk3zT4fkEvLVHttKYfp4T5RqnfA2UWapWrmjf3pnQLqc+ihkR18WlZoWCucK7RsN6x8Ob35E8raT+JMqXH+9GgoCuVru9+xs1ZpHLhiTcxxWllr9/X9zI+e6TuIY/SvxzGUggGITjR6I+e16iAP/qtIHCzOLp1+kko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098419; c=relaxed/simple;
	bh=kPkM6C4gAKOYBW1QQ8bhkp9K7LXp4PxsNiZMrCrDijk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5jxWAwfxhIH5KAgMPrqrnO0d8nhyYk5WfsnslwZBtMOiDb6LMNelJr0HecQmj5bbEzjDaHKWbRSAFDqK53cfxYmkqvCx/p6UrNbXLiX3WIOjZpL0lcaAbOweUrgFcej5C6Q+PuAtxdjXnRi3fTib/6NJyjRB89+VOq6svFBQ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yU8hlDAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yU8hlDAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D924C4CEC3;
	Mon, 28 Oct 2024 06:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098419;
	bh=kPkM6C4gAKOYBW1QQ8bhkp9K7LXp4PxsNiZMrCrDijk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yU8hlDAVYIterxU3eWKy2Z7oxxLuW6jYiCoHlmyLlVUpDtZzcBZtOvnChvv3W75lC
	 NxwecOiwqxHBG1EkHDkx2k5iDsECS9PP5n898JPRgEqwbokBH0CZXhIWYsMCAnhaLr
	 WhUcL0JF/OcPYaM+VMBhNPQ1GTghLZpUft+lwdNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 173/261] Bluetooth: ISO: Fix UAF on iso_sock_timeout
Date: Mon, 28 Oct 2024 07:25:15 +0100
Message-ID: <20241028062316.331838252@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index c9eefb43bf47e..7a83e400ac77a 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -93,6 +93,16 @@ static struct sock *iso_get_sock(bdaddr_t *src, bdaddr_t *dst,
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
@@ -100,9 +110,7 @@ static void iso_sock_timeout(struct work_struct *work)
 	struct sock *sk;
 
 	iso_conn_lock(conn);
-	sk = conn->sk;
-	if (sk)
-		sock_hold(sk);
+	sk = iso_sock_hold(conn);
 	iso_conn_unlock(conn);
 
 	if (!sk)
@@ -209,9 +217,7 @@ static void iso_conn_del(struct hci_conn *hcon, int err)
 
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



