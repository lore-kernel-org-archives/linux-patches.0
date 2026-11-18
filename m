Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026722;
	b=nnZ5ue0mP47pJWJ3esMEeGBXSgYt+ODii5A9z0T+73YRT0RvpDqMrNOPAszAEiblgABD
	 QietPI0EMcDFygQtOQCWfY3XGNU+KNh/vlViYxgRF5qwQ+OkWkXSnNHdTCgcWARzLN7bM
	 NZ2YDltpqfmQR0MbvDw/O7oDL4GLucxhUUwri3fURDiXbB9HfHVfb5v8wqZqC5DjwhaDB
	 ugp9/PAaqcMc5Gl+YegSTgAPEmzPL9QAfYjwKd3Il1nYTEgBIwXzpS42LKhuNgLs/gKaa
	 6eqbLuB+R3pjffUl/URrHHvEkNZp5C3JBuo31bQdhLfe+5Q5PLhnFt3CSNBxIDMObcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wbk5cA6yIGUVnr/4HQhkaN8jyUMJyQewshUYJzseK3Q=;
	b=T0TUOJicQXoQG7ohwkCKp2OxDKkmSMuWBT2juitmmdX8rK/0mn0RSD3nWFJbNn8ig37E
	 GAxksa+Mub9SevCOo6h6z11e7dMKarHdW1LOCGTxN+5RRQEYBYU2PP/RAMR5pmVVWU6mq
	 tqrPR7BqAxgSjLiEABUvyhu4URVAKNM6bPkHeh32kzxYmoLKtrxRvPb1KOS0K6LcJUwSK
	 +6nuo6t9TNiMZoFqWZl6vwxQ9RhN13pQNK/Cgprkc8X9pddivm+1NxANZSgrZ24h5eh0I
	 8dioFp8MguMjK2cd+EcsnCZN3jXMpW8DwrZHrrOe0/Zo1JUKQXDhiLjlidFHsq4tEnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5qt1Sc8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3330606A31C;
	Wed, 18 Nov 2026 18:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5qt1Sc8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE5F1F000C4;
	Wed, 18 Nov 2026 18:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026722;
	bh=wbk5cA6yIGUVnr/4HQhkaN8jyUMJyQewshUYJzseK3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5qt1Sc86h1tMQzSIR7q1kI6gGbJEhXIBr61Mg/V1ieoaKE/PHMfkb0cEnQJPAdJf
	 hlpc0+R/7aT+ZUhLjmzhlng4Si+oGgkFS+pj1Q3FMo9TRFE8HleBCH+Bg6m3IoRGkM
	 KHVqS5AgAXd2uLfNf8GOvOtvfjNRlCEXXyxdOHsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1536/2151] Bluetooth: MGMT: Fix leaking instance on Add Extended Advertising Parameters
Date: Wed, 18 Nov 2026 15:54:31 +0100
Message-ID: <20261118150217.829246353@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f7f0d0a9eb6e4616c0b3a2a95498b5204c5543c9 ]

If queueing the command fails the instance is never removed, despite it
having already been added or modified by hci_add_adv_instance, so remove
it as it is done by add_ext_adv_params_complete on failure, signaling
it has been removed if it was previously added.

Fixes: cba6b758711c ("Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 2")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index c05acc157055a..d6cc5092534c6 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9227,14 +9227,15 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 				       data, data_len);
 		if (!cmd) {
 			err = -ENOMEM;
-			hci_remove_adv_instance(hdev, cp->instance);
-			goto unlock;
+			goto remove;
 		}
 
 		err = hci_cmd_sync_queue(hdev, add_ext_adv_params_sync, cmd,
 					 add_ext_adv_params_complete);
-		if (err < 0)
+		if (err < 0) {
 			mgmt_pending_free(cmd);
+			goto remove;
+		}
 	} else {
 		rp.instance = cp->instance;
 		rp.tx_power = HCI_ADV_TX_POWER_NO_PREFERENCE;
@@ -9245,6 +9246,18 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 					MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
 	}
 
+	goto unlock;
+
+remove:
+	/* The instance may have been modified already so remove it, like it
+	 * is done in add_ext_adv_params_complete, signaling it has been
+	 * removed if it was previously added.
+	 */
+	if (!adv->pending)
+		mgmt_advertising_removed(sk, hdev, cp->instance);
+
+	hci_remove_adv_instance(hdev, cp->instance);
+
 unlock:
 	hci_dev_unlock(hdev);
 
-- 
2.53.0



