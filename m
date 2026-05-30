Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93F03BFE3B;
	Sat, 30 May 2026 18:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165003; cv=none; b=IUyopnUEkrjaUgmChDNkr2xU6VoDGJTkuv40cCuSdRMUa7Wg+6eSAMs/IHi3Gh+d2PpPW6qQh/+mBCXEn7s8+bSNiZCBcJIy5wC/ydUeyAOkNhx+WYu4DQAw6EpiL6LhPDYY32hf1Y7t1Bv2sfYNYn65P5SfugniPZZWFezMl7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165003; c=relaxed/simple;
	bh=7IHyO2ObSpOAJ3aG1uqbDbC1tQCsm1lRCr0w6j5V2Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Paalv86uI9yQK0C9nc4IJgMv1dkCiK7LICeMoZCNmeV9BBu+nx2XnILc8PalTaaA/m1fWAo+AcLy8m1gWEd9xfmrxVyKOcvVMjDoQHDWQyTGSBjt9aSs99sOnfffN93kBs2ZLSaMGTFbRsOIDQXgl4EeFG6XhFPjP8AUJiCUmeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJoSYij/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJoSYij/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CF71F00893;
	Sat, 30 May 2026 18:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165001;
	bh=+nDuGRSXQJZH67sCHSUA25ZCcuIoRfH1Jk3s2jdYacA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJoSYij/0k5QFjzUvlhJKmMIJhAnmpqtOzbDF05lEgiBCmfKze/AI/7ciab3qIkFV
	 /yd2pJe2NIxqt4qtVqiaUhfAzzrx0gQWrThlQtD5XEh+4jIfNe1wS9I/Kngj19DJvI
	 tTQ1CueZTpGy02/Tu8v3TFFivh3W5EmppcDC8+hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minh Nguyen <minhnguyen.080505@gmail.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 691/776] vsock/vmci: fix UAF when peer resets connection during handshake
Date: Sat, 30 May 2026 18:06:45 +0200
Message-ID: <20260530160257.705883331@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Minh Nguyen <minhnguyen.080505@gmail.com>

commit 99e22ddf4edb63dc8382bc028af928056d3450cf upstream.

vmci_transport_recv_connecting_server() returned err = 0 for a peer
RST in its default switch arm:

	err = pkt->type == VMCI_TRANSPORT_PACKET_TYPE_RST ? 0 : -EINVAL;

That made vmci_transport_recv_listen() skip vsock_remove_pending(),
leaving the pending socket on the listener's pending_links with
sk_state = TCP_CLOSE while destroy: still dropped the explicit
reference taken before schedule_delayed_work().

One second later vsock_pending_work() observed is_pending=true and
performed full cleanup: vsock_remove_pending() then the two trailing
sock_put(sk) calls -- the first reached refcount 0 and __sk_freed
the socket, and the second wrote into the freed object:

  BUG: KASAN: slab-use-after-free in refcount_warn_saturate
  Write of size 4 at addr ffff88800b1cac80 by task kworker
  Workqueue: events vsock_pending_work

Treat peer RST like any other unexpected packet type (err = -EINVAL).
All destroy: arms now return err < 0, so vmci_transport_recv_listen()
removes pending from pending_links synchronously and
vsock_pending_work() takes the is_pending=false / !rejected branch,
dropping only its own work reference.  This also closes the
multi-packet race Sashiko reported on v2: pending is removed from
the list before any subsequent packet can find it.

The pre-existing sk_acceptq_removed() gap on the err < 0 path of
vmci_transport_recv_listen() that Sashiko also noted is not
introduced or changed by this patch.

Tested on lts-6.12.79 with KASAN: 52/100 unpatched -> 0/100 patched.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Cc: stable@vger.kernel.org
Signed-off-by: Minh Nguyen <minhnguyen.080505@gmail.com>
Acked-by: Bryan Tan <bryan-bt.tan@broadcom.com>
Link: https://patch.msgid.link/20260519102310.237181-1-minhnguyen.080505@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/vmci_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1156,7 +1156,7 @@ vmci_transport_recv_connecting_server(st
 		/* Close and cleanup the connection. */
 		vmci_transport_send_reset(pending, pkt);
 		skerr = EPROTO;
-		err = pkt->type == VMCI_TRANSPORT_PACKET_TYPE_RST ? 0 : -EINVAL;
+		err = -EINVAL;
 		goto destroy;
 	}
 


