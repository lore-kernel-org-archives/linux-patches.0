Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61317442388;
	Fri,  7 Aug 2026 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114952; cv=none; b=EvXFpK0lMHEfw0xsEgVcPNx6tF7rImYNIAtWqjM5IBdc2HofD/RIHMuduXEv9DtyaLJmS89aWmo6gtRQGOENxeR7p3pyh9a0A/fbyXHU87s1cQbCNkN+JSA+PjwZEY1P74QI5CUWvy3kMLv52jcOgWA9fbLwGmTgygn+56O1qOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114952; c=relaxed/simple;
	bh=RRhWEf1IF6zYIoeusqSudbwbc8VDyO7g5QtBtKlpI9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhEnrOFrEd/CZ6fYA2XtFxTGrp28/lX+VDnnuRCV+AwKJeFzP600y7E5TRDVg6xtsWS2HgTtqAjuvs0IOwYZ+9SZp3uQD9MZNV51U6KY796sdV8LdzrzyC5uTpSgoZd9ndA6uGuvdUGGdQVI5fi+1Ds3IV3bm+7+ZhhOjwqD4j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1Q860K6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1Q860K6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CCE1F00A3D;
	Fri,  7 Aug 2026 15:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114951;
	bh=3geWi/EnJSoKfOqpXXFRIt+/KAzMYbDipwUFVn+/yC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1Q860K6Bp6VS7hB+rkpcy+Nm6HjRBbSGaOQclVxCa0XZ7d/o85YJRRZ4J0WivYZC
	 GYBCGbq0yN5WSFv/ZCUux0M4wG1OqmZrXkFdSy58sGUZhz8kzKF85g0aWIxS8BH/+p
	 YH9q/fsqow+PJQE7oyLrA/2eboMZS/vBSqw5rH/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/396] Bluetooth: ISO: clear iso_data always when detaching conn from hcon
Date: Fri,  7 Aug 2026 16:34:26 +0200
Message-ID: <20260807143426.581872217@linuxfoundation.org>
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

[ Upstream commit d57e506f6a1e3929611340fae87c1e4823f4d85c ]

When setting conn->hcon = NULL, also conn->hcon->iso_data = NULL is
necessary, otherwise later iso_conn_free() will UAF.

Fix clearing of iso_data in iso_sock_disconn()

Fixes KASAN: slab-use-after-free in iso_conn_hold_unless_zero on
iso_sock_release() followed by hci_abort_conn_sync().

Fixes: fbdc4bc47268 ("Bluetooth: ISO: Use defer setup to separate PA sync and BIG sync")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index f2ff10ae76e22..5868ad1f7128e 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -826,6 +826,7 @@ static void iso_sock_disconn(struct sock *sk)
 	sk->sk_state = BT_DISCONN;
 	iso_conn_lock(iso_pi(sk)->conn);
 	hci_conn_drop(iso_pi(sk)->conn->hcon);
+	iso_pi(sk)->conn->hcon->iso_data = NULL;
 	iso_pi(sk)->conn->hcon = NULL;
 	iso_conn_unlock(iso_pi(sk)->conn);
 }
-- 
2.53.0



