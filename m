Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1828E3093DD;
	Mon, 13 Oct 2025 15:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367835; cv=none; b=PmXSwD/oeQg1zvWQU8FXp/mdehOeD2B+4hsZDZY7dQbK6ScfTGhsb9Cr5GhudtAUpvp2TCt1Iuf9cSKAs0K5WLd3zkL8MOdz8KfjtJHOzg27UkCaZudBGNO6/1xcj6vb8kFrTwV1ypQzYHDDNn8r6GFKo4HBfSwJ3dwNX5XO21I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367835; c=relaxed/simple;
	bh=eQrqAOyVT1g3louU1IYmXpgSDQh9zrvR5GQA1mORR1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM+V5IQYZjo6yxH1RYEJbl3TrEIxL0NfRxipkGtVNryR3pOzPByTy4+YVhgQEmXgdZ42fmk7BPOgdjyNtA1p0+yN8ytuVwNVR7JAaqLL1IIHqt/XGdpJT2iRMoijHoghR6VS12+B/7bXVY0ccBi+rtXCYi/FzgPiuZxHNHtzhFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Xgh4ujR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Xgh4ujR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DEFC4CEE7;
	Mon, 13 Oct 2025 15:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367835;
	bh=eQrqAOyVT1g3louU1IYmXpgSDQh9zrvR5GQA1mORR1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Xgh4ujRgM7er7smrMzSir7Rm7vlahKdwedhQB0k1TMEuteGXfsjHGLJM7IdTUUhi
	 Xv6o0CF5Wvtm7JMedKu4NCuNykSFcVFJrOTQ9SiLjyisG3QJPBUH8J9tQ24AitomZ2
	 /KqPl9xjF+AZPMQww2dIeG1+YignMja/WtxJF4BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/196] Bluetooth: ISO: Fix possible UAF on iso_conn_free
Date: Mon, 13 Oct 2025 16:45:42 +0200
Message-ID: <20251013144320.773459099@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 9950f095d6c875dbe0c9ebfcf972ec88fdf26fc8 ]

This attempt to fix similar issue to sco_conn_free where if the
conn->sk is not set to NULL may lead to UAF on iso_conn_free.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index b94d202bf3745..be71082d9eafa 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -718,6 +718,13 @@ static void iso_sock_kill(struct sock *sk)
 
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
 
+	/* Sock is dead, so set conn->sk to NULL to avoid possible UAF */
+	if (iso_pi(sk)->conn) {
+		iso_conn_lock(iso_pi(sk)->conn);
+		iso_pi(sk)->conn->sk = NULL;
+		iso_conn_unlock(iso_pi(sk)->conn);
+	}
+
 	/* Kill poor orphan */
 	bt_sock_unlink(&iso_sk_list, sk);
 	sock_set_flag(sk, SOCK_DEAD);
-- 
2.51.0



