Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47D01A596
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UC2+HoDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B58C433CB;
	Mon,  9 Oct 2023 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857572;
	bh=C9ELLYE1GK5pwg33kE3hXiDtzDDC/m5yf1yI6d5EYB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UC2+HoDYGnM+gAsBn85PcFilhWp4BWqAkTSoy0zG23P/CZECw4WLdLABVXh1u2qFz
	 pdF7A82V1IVhq3YvTjIQV4XC+MA/Ym0lQwGMKOWEXLT12nFUUJWQS7JSXJJBOYwxf3
	 6WFruYSHTHRKnW7OAnjzW69WcjtpYAYe3q6OY5LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/162] Bluetooth: ISO: Fix handling of listen for unicast
Date: Mon,  9 Oct 2023 15:01:10 +0200
Message-ID: <20231009130125.379270128@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

[ Upstream commit e0275ea52169412b8faccb4e2f4fed8a057844c6 ]

iso_listen_cis shall only return -EADDRINUSE if the listening socket has
the destination set to BDADDR_ANY otherwise if the destination is set to
a specific address it is for broadcast which shall be ignored.

Fixes: f764a6c2c1e4 ("Bluetooth: ISO: Add broadcast support")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 5cd2e775915be..91e990accbf20 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -458,7 +458,7 @@ static void iso_recv_frame(struct iso_conn *conn, struct sk_buff *skb)
 }
 
 /* -------- Socket interface ---------- */
-static struct sock *__iso_get_sock_listen_by_addr(bdaddr_t *ba)
+static struct sock *__iso_get_sock_listen_by_addr(bdaddr_t *src, bdaddr_t *dst)
 {
 	struct sock *sk;
 
@@ -466,7 +466,10 @@ static struct sock *__iso_get_sock_listen_by_addr(bdaddr_t *ba)
 		if (sk->sk_state != BT_LISTEN)
 			continue;
 
-		if (!bacmp(&iso_pi(sk)->src, ba))
+		if (bacmp(&iso_pi(sk)->dst, dst))
+			continue;
+
+		if (!bacmp(&iso_pi(sk)->src, src))
 			return sk;
 	}
 
@@ -910,7 +913,7 @@ static int iso_listen_cis(struct sock *sk)
 
 	write_lock(&iso_sk_list.lock);
 
-	if (__iso_get_sock_listen_by_addr(&iso_pi(sk)->src))
+	if (__iso_get_sock_listen_by_addr(&iso_pi(sk)->src, &iso_pi(sk)->dst))
 		err = -EADDRINUSE;
 
 	write_unlock(&iso_sk_list.lock);
-- 
2.40.1



