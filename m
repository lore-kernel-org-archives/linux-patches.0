Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBC05187C1;
	Wed, 30 Sep 2026 17:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788048; cv=none; b=BrXfGTJpW+My1ybt6SKUD5dx6V8YtaiweNgpgyY04Anz3Coi1LImiMyATlwscmXCjqEZTWnJ2P1FamMwRLIDOXI8zVpPQ2WOAprpYccaNa8Y+kX1zQPlzcyKLO7z/2XoCnNZHv9v/ZZ1IrCVYeAd8mJna4dTIqBS6x0BRkDSJ6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788048; c=relaxed/simple;
	bh=fBjMrBpi76NqJDfmZONZfaig4My7zZL/o83FiUxe4tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTT9YSh/uI7azKhOpKbuXPExxJyt9Tu/YtX7fMrfae9Agie0yJfFDktYzhrjaL0yjt9likADT3HR1blWg0eGJipIK2f6RfE10O5GTbVcMH/kXvHTK3dHETkePrnQNR7bCTG4B6aGEdiJWzpBMi7WUP52C8EcyB/7WQpy2GPN6EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjsjzzrE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjsjzzrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526C31F000FF;
	Wed, 30 Sep 2026 17:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788046;
	bh=juWh2ySiNkV5U+i/+v3VyP2xcRHC9oEnK8Ubg/ABkFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjsjzzrExUOCQy1zwCyAz8bQ87ljOYFrf8tuEyGrj/UOZRkGbURONVHSaAimAk+gG
	 iA4k5JG36HwC7SJ6EQ4kVj4FV8YjY1eThwaUzZC1XSVV8EnO4K8ScpSw8IGLnUfT+V
	 Vm3WChdP6xAgMBOlznKhyv02YwR2jalWLHMt3JmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 400/457] Bluetooth: hci_conn: fix CIS hold ownership on reuse
Date: Wed, 30 Sep 2026 17:28:25 +0200
Message-ID: <20260930152354.627635295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2079,6 +2079,8 @@ struct hci_conn *hci_bind_cis(struct hci
 		cis->conn_timeout = timeout;
 	}
 
+	hci_conn_hold(cis);
+
 	if (cis->state == BT_CONNECTED)
 		return cis;
 
@@ -2120,7 +2122,6 @@ struct hci_conn *hci_bind_cis(struct hci
 		return ERR_PTR(-EINVAL);
 	}
 
-	hci_conn_hold(cis);
 	cis->state = BT_BOUND;
 
 	return cis;
@@ -2496,6 +2497,12 @@ struct hci_conn *hci_connect_cis(struct
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


