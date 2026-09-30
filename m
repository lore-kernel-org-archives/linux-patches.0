Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AD03750CF;
	Wed, 30 Sep 2026 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787928; cv=none; b=F5saGSRkrF8n5s7vi+LS5QL+m/I3rZHuAYy/rIs0nJDxS62Z/fqHI9ARvewS49B364mlUKK239MS6V1pZek6vqOY+nbaGd2Jm6gWcCQGul1PWeC39EbLxPIeck6VF39FdpVHP0uW37GxkmjseJDoD+ceHFW/O200Jt+BnyPrqgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787928; c=relaxed/simple;
	bh=lFtHJ6ZI/dEE13xynl8hL5YDt0ZBYZEyKiCcHIB6zr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZZDs17ER5mNASsJe5DZNBzyq972kgKeHa00SwuK8OeIZnJNdTky5G+pGDB9aleeyffw9mwnpdi3J6djhwSnl3JGhJGxgmWHse7iwWkRZoI8IcVGe0V2vhjdf8tWJm4A3qUTVB49ZNxcAekokbR4Zk9qA7c7jje+pXlTiB9SDEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbUZ/iwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbUZ/iwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105841F000FF;
	Wed, 30 Sep 2026 17:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787927;
	bh=7t2bEF7hce7VcVMiNSy8Ur66LV3IOmfdB0vbda0WEvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbUZ/iwp4dkRZKtig7Mzc67STTLrV8A1Jqt04hz6d50+683hkXtaih15QGjhlQTgt
	 +mOhCjEIaRt3s1isvGLRgXoQFDhmP2ka8MhTas40hQQKBzomivBSsfLrLOri5HBYly
	 bRVumMqO1zmnJkF+5t1qd/FmR6SJEn4jjWRvjkUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 404/457] Bluetooth: ISO: release unused CIS holds after channel attach
Date: Wed, 30 Sep 2026 17:28:29 +0200
Message-ID: <20260930152354.712885697@linuxfoundation.org>
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

commit 0fcd4dad555c96e0bd3a1b8c569f989be85c7341 upstream.

hci_bind_cis() and hci_connect_cis() return one hci_conn hold for the
ISO layer.  A new channel association consumes that hold, which is
eventually released by iso_conn_free().

There are two cases where iso_chan_add() does not create an association:
it returns success when the socket is already attached to the same
iso_conn, and it returns -EBUSY when another socket is attached.  The
hold returned for the current call is unused in both cases.  This occurs
when deferred setup calls iso_connect_cis() again for its existing
socket, or when another socket attempts to reuse the CIS.

Detect the idempotent case while the connection is locked and release
the unused hold after iso_chan_add().  Also release it on -EBUSY.  Do not
drop it for other errors: a newly allocated iso_conn releases the
transferred hold when its last temporary reference is put.

Fixes: 69997d50ec57 ("Bluetooth: ISO: handle bound CIS cleanup via hci_conn")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -496,6 +496,7 @@ static int iso_connect_cis(struct sock *
 	struct hci_dev  *hdev;
 	bdaddr_t src, dst;
 	u8 src_type;
+	bool already_attached;
 	int err;
 
 	lock_sock(sk);
@@ -568,8 +569,14 @@ static int iso_connect_cis(struct sock *
 		goto unlock;
 	}
 
+	iso_conn_lock(conn);
+	already_attached = iso_pi(sk)->conn == conn && conn->sk == sk;
+	iso_conn_unlock(conn);
+
 	err = iso_chan_add(conn, sk, NULL);
 	iso_conn_put(conn);
+	if (already_attached || err == -EBUSY)
+		hci_conn_drop(hcon);
 	if (err)
 		goto unlock;
 


