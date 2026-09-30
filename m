Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BD551C056;
	Wed, 30 Sep 2026 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793754; cv=none; b=rN2ljcDa000DZ+hYjtujq6uRlFu6ZwWRvxZFhnSj/8LeGMX1fc7WxCGF2igx2sci08P+/VIUyzQm7IVXqD65AUjhrZit/Ylbbwgqiv/ULs3sJsFAoXTlylo70hocOtKZbhZ9zqki0++QxxGyadIR+/7OFBojkLYGIO0/1PLyEFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793754; c=relaxed/simple;
	bh=bdCVlGmmV+I8NDe650UbLpMC1ivd9E+XPFowe5/Kxso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDAGElTii6hvKgr3nrDMnrLaqgkLO+pqYJD5RfQzdd9LdGJebDe1S4JGqAhs6ymSFzE8TX1wg9A+faR9Kb+rVepcSB1fb3dczVJKiLboeEX2rMlgJJpB4QwIbIE4rF4205XeBJw4mA8VCEbbql1IRJc9Kux3I/S8U2pIOThlZ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmUhI+me; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmUhI+me"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A57C1F000FF;
	Wed, 30 Sep 2026 18:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793753;
	bh=crBOkr4fXgyKNNjcxRnQNUFA5p8d2OG4uFyBbzEmofs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmUhI+meVXYedYcGh+hH/lz2vyXZ2F7NCCQXufo9vChddPGr2E++9q97bD5r5tykk
	 AdAh7YFyvejNBBe8ZOmr7kHQEvfRtmoChCZ3ree5f9hAmgrDaJ2iPx3vscepMrgHKI
	 YuCA0qeI1HpCR6CEviNQTEO5FAwARFpufRofQulA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 321/395] Bluetooth: hci_conn: fix CIS hold ownership on reuse
Date: Wed, 30 Sep 2026 17:29:43 +0200
Message-ID: <20260930152347.624114447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit e06d549fcd4a0ba381ed67ddf1ab3c7a6ca4314c upstream.

Commit 69997d50ec57 ("Bluetooth: ISO: handle bound CIS cleanup via
hci_conn") made hci_bind_cis() and hci_connect_cis() return a
connection with one hold for the ISO layer.  hci_bind_cis() currently
takes that hold only after configuring a CIS, so its BT_CONNECTED and
matching BT_BOUND paths return a bare lookup result.  Its configuration
failure path can likewise call hci_conn_drop() before taking a hold.

Take the hold before any state-dependent return or configuration error
so every successful return follows the documented ownership contract
and every error drop is balanced.

hci_connect_cis() also assumes hci_conn_link() always takes a new CIS
hold before dropping the one returned by hci_bind_cis().  However, the
helper returns an existing link without taking another hold.  In that
case, preserve the CIS hold for the caller and drop the redundant LE
hold because the existing link already owns its parent hold.  Returning
early also avoids changing an existing CIS back to BT_CONNECT.

Fixes: 69997d50ec57 ("Bluetooth: ISO: handle bound CIS cleanup via hci_conn")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1975,6 +1975,8 @@ struct hci_conn *hci_bind_cis(struct hci
 		cis->conn_timeout = timeout;
 	}
 
+	hci_conn_hold(cis);
+
 	if (cis->state == BT_CONNECTED)
 		return cis;
 
@@ -2016,7 +2018,6 @@ struct hci_conn *hci_bind_cis(struct hci
 		return ERR_PTR(-EINVAL);
 	}
 
-	hci_conn_hold(cis);
 	cis->state = BT_BOUND;
 
 	return cis;
@@ -2380,6 +2381,12 @@ struct hci_conn *hci_connect_cis(struct
 		hci_conn_drop(le);
 		return cis;
 	}
+
+	/* The existing link already owns the hold on its parent. */
+	if (cis->link) {
+		hci_conn_drop(le);
+		return cis;
+	}
 
 	link = hci_conn_link(le, cis);
 	hci_conn_drop(cis);


