Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216314;
	b=KK4PGwO2+v632pRdx/dUt6AeHycvh8nxGLa0W+sm0mlcpxp5A4wy+JdF2uWBaA6mmJpL
	 rkHj+OC74cQCUTTDGhb8Q4LjnU45GgPEHKgpl5LrOG9ZXAA0+IgdgKUaIcksfkQYDrYs9
	 cvz9cKbwxiQPQLhtR4GW2/G2bn95b65OEG48wQrY7hcXbHo4Fm8yXy16NoNjbB063pwkm
	 KASq9AMMwOK2nz8/lkN8ZY5PJh5KbkdBWKsoWpdTB3LXrTBGH+6u+2fyLGF0+kIpSeTV+
	 QrcwIbhdoeQmeqHKzw/Ls6LfF0hy/gCOwlhtYLUIP06asLweIuy186CzJsEQ/roEp/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2PXamIchOwTvjQ+RV+tIrnLly//9uA5PxcPC5Aiw5I0=;
	b=yNGgcKHub92jGOU6XF9grPV1jvo9XyYUGx9kP4lGbzRSS9IVxgCGiUeRnhJX/hEqy72N
	 Xg/LiBWdBbZcXeBx8kNuyoM49NZGcW8k/zYPcD1hAMmK597MAlYrlhNTnV360zK/TzXxT
	 pwgg8mtzNO7/9+QF/h5BahMUsb8UCYSu56JHARltaepKzapEXmcuFn2iwhZgictdHxJlF
	 I64KLx005ffcSxN3/arpT9IwYon8a7GtKouzUanxitj0OYMF+9WLT3U4wTWqrwmZ7sxPc
	 imhSxsc85qUA8ILQZtfwXuFS4QGYg9dmXxAYxhhU+NGUMtqFtJgq67u6trRmdJYdQIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2TpBkCbL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C958C606A32E;
	Wed, 28 Oct 2026 19:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2TpBkCbL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A991F01825;
	Wed, 28 Oct 2026 19:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216313;
	bh=2PXamIchOwTvjQ+RV+tIrnLly//9uA5PxcPC5Aiw5I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2TpBkCbLRfYhyxB3a2uNgl0KnkRMe44Bea7VhjyruTly2ptnlppXZ8bwhoWW4ZQIq
	 cMfLZPcg4LYsX8Nh5vpPr7KKNExNkVDdsc+NuU11FiKgEE89+PTBVKyRTvNva0Nwkr
	 zUdA0XeWsylRGailDjgTvJjigwR97xoFVaxoBuuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Podgorny <radek@podgorny.cz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1516/1887] Bluetooth: do not leak an hci_conn when a second LE connect is rejected
Date: Wed, 28 Oct 2026 18:00:12 +0100
Message-ID: <20261028170533.961913450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radek Podgorny <radek@podgorny.cz>

[ Upstream commit 7e1e4047200fd7519f9bdfe8a001437715e618b4 ]

create_le_conn_complete() decides whether the failed connection is
still pending by comparing it against hci_lookup_le_connect(), which
returns the first LE connection in BT_CONNECT. That is the same
connection only while at most one is pending.

Two can be pending. Connections created on the passive scan path sit
in BT_CONNECT with HCI_CONN_SCANNING set and are invisible to
hci_lookup_le_connect() until hci_le_create_conn_sync() clears the
flag when their command is issued, so the -EBUSY guard in
hci_connect_le() does not prevent a second connection from being
queued while the first is still on the scan path. Whenever two
connections are in BT_CONNECT at once, the lookup may return one
connection while create_le_conn_complete() is reporting the failure
of the other; the early exit then drops the error and hci_conn_failed()
never runs on the connection that failed.

The controller also rejects a second HCI_OP_LE_CREATE_CONN issued
while another connection creation is still outstanding, per Core Spec
Vol 4, Part E. The spec calls for Command Disallowed there; the
bcm43438 observed here answers with an LMP/LL error code instead,
which bt_to_errno() maps to the -EPROTO (-71) in the log below.

The leaked connection stays in BT_CONNECT forever, and because
hci_connect_le() refuses to dial while hci_lookup_le_connect() finds
anything, every subsequent attempt to reach any peer fails with
-EBUSY and no command reaches the controller at all.

Seen on a bcm43438 with two BLE peers polled on the same interval
(state 5 is BT_CONNECT; both handles are UNSET ones, allocated from
the ida above HCI_CONN_HANDLE_MAX):

  Bluetooth: hci1: Opcode 0x2013 failed: -71

  # hcitool con
          < LE 14:9C:EF:03:68:81 handle 3840 state 5 lm CENTRAL
          < LE C4:D3:6A:8C:B5:38 handle 3841 state 5 lm CENTRAL

A btmon capture across the next ten minutes of connect attempts
contains no HCI_OP_LE_CREATE_CONN at all; outgoing LE connections
do not recover until the adapter is reset. With this change the same
scenario fails the rejected connection cleanly and further connects
to both peers go through.

Ask about the connection itself instead of about the device.

Fixes: c9f73a2178c1 ("Bluetooth: hci_conn: Fix hci_connect_le_sync")
Signed-off-by: Radek Podgorny <radek@podgorny.cz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 5bc58e465146c..0c0c052294fc7 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1344,8 +1344,13 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 		goto done;
 	}
 
-	/* Check if connection is still pending */
-	if (conn != hci_lookup_le_connect(hdev))
+	/* Check if this connection is still pending.
+	 *
+	 * hci_lookup_le_connect() returns only the first LE connection
+	 * in BT_CONNECT, which is not necessarily this one when two are
+	 * pending at once, so ask the connection itself.
+	 */
+	if (!hci_conn_valid(hdev, conn) || conn->state != BT_CONNECT)
 		goto done;
 
 	hci_conn_failed(conn, bt_status(err));
-- 
2.53.0



