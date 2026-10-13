Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625724F7971;
	Tue, 13 Oct 2026 12:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893080; cv=none; b=i1EiOXbs8Aa22lXDsh2ccGDjHN8dMkJqMylgqqddvZS9KoeItmH7yAO2ARs2Q5In0Yk6c1rS8tw/mEVG4qZwXWsa8iIETrUhpR0G+E9lPKTNkEUKfNHBzlnNVmVP7f01w43U+RQbAYW5u+4Y3h/NYj6RdbPWvnh73yZ1+F/suTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893080; c=relaxed/simple;
	bh=Ch7DchOzGiaun6c/x6ULzZnhV8QJp2ipzRu8KU2acmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIucfjS0e4gucKBYGbcb++jHGmGJALkZvysx+oX/eD84aOFKRtnz1HLfdJtb7PNH2Jghvs4Dam+1IUJv+v/sIotd7hPK8+RjXsGRApgQDEff+6SZyIK7GQUIKssyIgdmo4hbUiCgWif90ZKBxAyrSMSXaM6sdWfjdd1tMLppma0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o22C9YBs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o22C9YBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD5A1F000FF;
	Tue, 13 Oct 2026 12:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893079;
	bh=M2IzY63zAXDIo6GFYaLjft7427g07keIK2SHDBZ9DzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o22C9YBs3iuyxee0gl6Ts7bENqVAhNsIy6rEssWKYeW2cw5lXZ+cc+7WulVKtjkiu
	 NlVs7QfVmIfMhIOjna+E+33r+ES6QUIqKhZpr4+/j4jfEHCZmImQ+1N//FkJpVD8Ct
	 siBR12S3SvsAbh2YrILF8UOFV0IOTIgUP0t4ehE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 104/621] Bluetooth: ISO: Reject concurrent BIS listener setup
Date: Tue, 13 Oct 2026 13:31:39 +0200
Message-ID: <20261013112923.317302740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 555ff78fa719f50ff4cdbdb40aa1acc6e8e327d3 upstream.

iso_sock_listen() drops the socket lock before calling iso_listen_bis()
to preserve the hdev->lock ordering. Two concurrent listen() calls on
the same broadcast socket can therefore both observe BT_BOUND. Caller
A can attach connA and release the locks, then caller B can acquire
them and attach connB before A publishes BT_LISTEN.

__iso_chan_add() checks whether connB already has a socket, but not
whether the socket already has a connection. The second attachment
overwrites iso_pi(sk)->conn, leaking the connA reference and leaving
connA->sk intact. Socket teardown follows connB, so later events on
connA can cause a stale socket access.

Recheck BT_BOUND and require iso_pi(sk)->conn to be NULL after taking
both the HCI device and socket locks in iso_listen_bis(). The connection
check also covers the interval between attachment and publication of
BT_LISTEN. Reject a competing setup with -EBADFD through the existing
unlock path before allocating another connection.

A recorded KASAN report from an instrumented kernel shows:

  BUG: KASAN: slab-use-after-free in iso_sock_hold+0x119/0x1f0
  Call Trace:
   iso_sock_hold+0x119/0x1f0
   iso_conn_del+0xe4/0x270
   hci_disconn_complete_evt+0x351/0x8c0
   hci_event_packet+0x71b/0xb20
   hci_rx_work+0x293/0x730

  Allocated by task 93:
   sk_prot_alloc+0x113/0x220
   sk_alloc+0x2b/0x6d0
   bt_sock_alloc+0x29/0x370
   iso_sock_alloc.constprop.0+0x19/0x300
   iso_sock_create+0x94/0x100

  Freed by task 93:
   kfree+0x121/0x3c0
   __sk_destruct+0x42b/0x540
   iso_sock_release+0x29d/0x340
   __sock_release+0xa1/0x260
   sock_close+0x10/0x20

Fixes: 168e28305b87 ("Bluetooth: iso: Fix circular lock in iso_listen_bis")
Cc: stable@vger.kernel.org
Assisted-by: GPT-6 Astra
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1221,6 +1221,11 @@ static int iso_listen_bis(struct sock *s
 	hci_dev_lock(hdev);
 	lock_sock(sk);
 
+	if (sk->sk_state != BT_BOUND || iso_pi(sk)->conn) {
+		err = -EBADFD;
+		goto unlock;
+	}
+
 	/* Fail if user set invalid QoS */
 	if (iso_pi(sk)->qos_user_set && !check_bcast_qos(&iso_pi(sk)->qos)) {
 		iso_pi(sk)->qos = default_qos;


