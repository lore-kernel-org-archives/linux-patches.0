Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564614DEC26;
	Wed, 30 Sep 2026 18:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792433; cv=none; b=Hxqx9isPv97GGTHVVgPeZOg2KuXWqLvgy19t69/S1CsEL+yhwdAJyoiaw0tR1YURswqAcp5cV35NVISXDb/cRo+VnDw7Qx/Sg8nhuagdwmPbcH1HjHJX79mNN9mS4VlyPptE89mfe9XzDfr5Su3gjp6CheI9I7kVWvo+zKUxWZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792433; c=relaxed/simple;
	bh=RoDxB28kzE7Rw40ZYN/hcOzv1twKNhWlfeGzcd2vNfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYSoQKp2cEtcqace7s1VyaV9rURJi6m6XC377K+/Umo0N8esA5TuobZxLjnxeytBdk1MgaXKCwBR1VnnK+ka187mfepvMqmXcnC38eHqKTbB1o9fOnWosFepS7wizPMGL19nXZSYM7x9P+x/7VA0RuSrFFtFVaiLetlSmNIzrc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSkshWLP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSkshWLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D411F000FF;
	Wed, 30 Sep 2026 18:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792432;
	bh=idKNuwxP63kcv0fpg7WKmNmtQ5d+63rD+XfkJd8AnD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSkshWLPgPIB08u4E2spg69JVNqXMjOhm/fj4fGH0gA1ts8cppNJm/gMFGi6OwJ5p
	 eCSzwRrQ9sEooPxOZQxD9de2HDlDTU1kobgoIN+97vtAY/b6gt0HZ54a5ibKAjUo8S
	 KmZQauAyYuTLKgV3JQi/8VP1DmgbAtQI7tsmau8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 651/752] nfc: llcp: Fix list corruption / refcount desync in nfc_llcp_recv_dm()
Date: Wed, 30 Sep 2026 17:28:41 +0200
Message-ID: <20260930152412.347174891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit bf1460acdf8cf5a07c819f59785d40f20d113099 ]

nfc_llcp_recv_dm() handles DM(NOBOUND)/DM(REJ) for a socket that is still
linked on local->connecting_sockets: it looks the socket up with
nfc_llcp_connecting_sock_get(), sets sk->sk_state = LLCP_CLOSED and
returns, without taking the socket lock and without unlinking the socket
from the connecting_sockets list.

llcp_sock_release() selects the list to unlink from by sk_state: a socket
in LLCP_CONNECTING is unlinked from connecting_sockets, otherwise from the
sockets list.  Because recv_dm left the socket physically on
connecting_sockets but in the LLCP_CLOSED state, release() takes the else
branch and calls nfc_llcp_sock_unlink(&local->sockets, sk).  That runs
sk_del_node_init() while holding sockets.lock, i.e. it removes the socket
from the connecting_sockets hlist under the wrong lock.  A concurrent
connect() linking another socket onto connecting_sockets under
connecting_sockets.lock then mutates the same hlist unserialized, which
corrupts the list and desyncs the sk_add_node()/sk_del_node_init()
sock_hold()/__sock_put() pairing.  An unprivileged local process holding
LLCP sockets, with the DM supplied by the remote peer over an established
LLCP link, can drive this to leak kernel sockets without bound (the
mis-decrement goes through the non-freeing __sock_put() path, so the
object is never released), leading to memory exhaustion / DoS.

This is the same class of bug that was fixed in the sibling handler
nfc_llcp_recv_cc() by commit b493ea2765cc ("nfc: llcp: Fix use-after-free
race in nfc_llcp_recv_cc()"); recv_dm did not receive the equivalent fix.

Fix it the same way: take lock_sock(), re-check that the socket is still
hashed (release() may have won the race), and for the NOBOUND/REJ case
unlink it from connecting_sockets before moving it to LLCP_CLOSED.  The
unlink drops the connecting_sockets membership reference via
sk_del_node_init(), leaving the socket unhashed, so the later
nfc_llcp_sock_unlink() in llcp_sock_release() becomes a no-op and no
double put occurs.

Fixes: a69f32af86e3 ("NFC: Socket linked list")
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Link: https://patch.msgid.link/20260716232657.203145-1-qwe.aldo@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_core.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index a0b4559d8edc7..4d810b758361b 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -1258,6 +1258,7 @@ static void nfc_llcp_recv_dm(struct nfc_llcp_local *local,
 	struct nfc_llcp_sock *llcp_sock;
 	struct sock *sk;
 	u8 dsap, ssap, reason;
+	bool connecting = false;
 
 	dsap = nfc_llcp_dsap(skb);
 	ssap = nfc_llcp_ssap(skb);
@@ -1269,6 +1270,7 @@ static void nfc_llcp_recv_dm(struct nfc_llcp_local *local,
 	case LLCP_DM_NOBOUND:
 	case LLCP_DM_REJ:
 		llcp_sock = nfc_llcp_connecting_sock_get(local, dsap);
+		connecting = true;
 		break;
 
 	default:
@@ -1283,10 +1285,33 @@ static void nfc_llcp_recv_dm(struct nfc_llcp_local *local,
 
 	sk = &llcp_sock->sk;
 
+	lock_sock(sk);
+
+	/* Check if socket was destroyed whilst waiting for the lock */
+	if (!sk_hashed(sk)) {
+		release_sock(sk);
+		nfc_llcp_sock_put(llcp_sock);
+		return;
+	}
+
+	/*
+	 * For DM(NOBOUND)/DM(REJ) the socket is still linked on the
+	 * connecting_sockets list.  Unlink it here, under the socket lock,
+	 * before moving it to LLCP_CLOSED: llcp_sock_release() selects the
+	 * list to unlink from by sk_state, so leaving a connecting socket
+	 * in the CLOSED state would make it unlink from the wrong list and
+	 * corrupt the connecting_sockets list / desync the socket refcount.
+	 * This mirrors nfc_llcp_recv_cc().
+	 */
+	if (connecting)
+		nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
+
 	sk->sk_err = ENXIO;
 	sk->sk_state = LLCP_CLOSED;
 	sk->sk_state_change(sk);
 
+	release_sock(sk);
+
 	nfc_llcp_sock_put(llcp_sock);
 }
 
-- 
2.53.0



