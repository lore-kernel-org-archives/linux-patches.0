Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC64F318EE1;
	Thu, 28 May 2026 19:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998178; cv=none; b=TjISokeP5mcNhtbA+qcjrbIWRTULBPMkZK8J3+2w0v77DtrUnJJLNC2XAUpSdD4hCfTzbagYkO1+hO3MOHfxQZLZNv6aQdnZByjC1q2DFjpbRKpHT40lwN90J7mMirR3yhuAClTGDMj9QBrWJnqvLvmpxYAdB7/iaUHJNv16LWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998178; c=relaxed/simple;
	bh=qImTs1Xud1Pi8iE+DI2gcFhyvcCyJQDK2HggmvyZSys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpDgXP4Tt4YUuR2hAzCFq8QWrzI+3i01vKFeGk8rqoa6mi0rEbtavikQ0rI+OTB7WUTRfRlAregPQGypP/O9iyx0z6+RO5zi2FsVmKK1OKUVLjl3mov0YxjpPy4jFcOFrQlIL2wzcgk3OAHwP7ROtalxM8xJuHPFY2Q7QdvLo3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRL3z/LV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRL3z/LV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267251F000E9;
	Thu, 28 May 2026 19:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998177;
	bh=CCRExuK9U1tyni1izaiJXPpT6TUFnm1ZCzGhWDjWTIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zRL3z/LV8CkYS3OJURbX3CqsG5a1mYNLPc10OdjSQaVvM632e1u+0LEA3moQqbslc
	 7+/dptP971HbuBzQHxymVHzmJCXMRJgMu8BGsDS1wX6Ta9R8yaXOmBHsaGsRBrUmKm
	 3Pd4dGJ9PZsRl3hkra16jtHP0oiTcgOApyH4SRN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.0 045/461] Bluetooth: L2CAP: ecred_reconfigure: send packed pdu, not stack pointer
Date: Thu, 28 May 2026 21:42:54 +0200
Message-ID: <20260528194648.210623524@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 3374ef8cf99368a40f7efd51a2a375a4c5dc6f0d upstream.

Commit 1c08108f3014 ("Bluetooth: L2CAP: Avoid -Wflex-array-member-not-at-end
warnings") converted the on-stack request PDU in l2cap_ecred_reconfigure()
from an explicit packed struct to DEFINE_RAW_FLEX(), but did not adjust the
size and source-pointer arguments to l2cap_send_cmd():

  -    struct {
  -            struct l2cap_ecred_reconf_req req;
  -            __le16 scid;
  -    } pdu;
  +    DEFINE_RAW_FLEX(struct l2cap_ecred_reconf_req, pdu, scid, 1);
       ...
       l2cap_send_cmd(conn, chan->ident, L2CAP_ECRED_RECONF_REQ,
                      sizeof(pdu), &pdu);

After the conversion, DEFINE_RAW_FLEX() expands to declare an anonymous
union pdu_u plus a local pointer "pdu" pointing at it. Therefore:

  - sizeof(pdu) is now sizeof(struct l2cap_ecred_reconf_req *) = 8 on
    64-bit (4 on 32-bit), not the 6 bytes of (mtu, mps, scid[1]).
  - &pdu is the address of the local pointer's stack storage, not the
    address of the request payload.

l2cap_send_cmd() forwards (data, count) to l2cap_build_cmd(), which calls
skb_put_data(skb, data, count). The L2CAP_ECRED_RECONFIGURE_REQ packet
body therefore contains 8 bytes copied from the kernel stack starting at
&pdu -- the 8 bytes overlap the pdu pointer's value, leaking a kernel
stack address to the paired Bluetooth peer. The intended (mtu, mps, scid)
fields are not transmitted at all, so the peer rejects the request as
malformed and the L2CAP_ECRED_RECONFIGURE feature itself has been broken
for the local-side initiator since the introducing commit landed.

The sibling site l2cap_ecred_conn_req() in the same commit was converted
correctly (sizeof(*pdu) + len, pdu); only this site was missed.

Restore the original semantics: pass the full flex-struct size via
struct_size(pdu, scid, 1) and the pdu pointer (the struct address) as
the source.

Validated on a stock 7.0-based host kernel via the real call path:
setsockopt(SOL_BLUETOOTH, BT_RCVMTU, ...) on a BT_CONNECTED
L2CAP_MODE_EXT_FLOWCTL socket emits an L2CAP_ECRED_RECONFIGURE_REQ
whose body is 8 bytes (the on-stack pdu local's value) rather than
the expected 6. Three captures from fresh socket / fresh hciemu peer
on the same host -- low bytes vary per call, high 0xffff confirms a
kernel virtual address (KASLR-randomised stack slot, not a fixed
string):

  RECONF_REQ body (ident=0x02 len=8): 42 fb 54 af 0e ca ff ff
  RECONF_REQ body (ident=0x02 len=8): 52 3d 2e af 0e ca ff ff
  RECONF_REQ body (ident=0x02 len=8): b2 fc 5b af 0e ca ff ff

After this patch the body is 6 bytes carrying the expected
little-endian (mtu, mps, scid).

Cc: stable@vger.kernel.org
Fixes: 1c08108f3014 ("Bluetooth: L2CAP: Avoid -Wflex-array-member-not-at-end warnings")
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7275,7 +7275,7 @@ static void l2cap_ecred_reconfigure(stru
 	chan->ident = l2cap_get_ident(conn);
 
 	l2cap_send_cmd(conn, chan->ident, L2CAP_ECRED_RECONF_REQ,
-		       sizeof(pdu), &pdu);
+		       struct_size(pdu, scid, 1), pdu);
 }
 
 int l2cap_chan_reconfigure(struct l2cap_chan *chan, __u16 mtu)


