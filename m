Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062603;
	b=zRpSOOBSas7oEUNBCJBJ2NdiUV+XSJGKrkUe65jGd3SIa7OGzkmCSLxa99wWQ/mRc9sS
	 S1F+q4pxQaS1N9iMmD+pHyBBh+Y7DWmPDtbTezhNpzhrJePziEJVe4qsjxfn+54SoJiVl
	 srkcjGiP6dwhb6pGzeGjKlRkB3AYMIs95UojsI/uvUz/4jkXI4HQh5hfc8IAA/m2ElFXZ
	 zpruuFLVR2b5hPyd9MXYW5FjEHrtReYDSlbuIhUqz8S0GtmUJRbk/d0Cq16IM15N81GwM
	 E1f8+hvhXFUylLJpThbn89AjcEEGEoB4O1qVvHANtt0D0JnWWWLFkREkuUlitlOq1xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sjy3RnBR4dfyH1nl8ipsaxZxqopEIUX+LXUDKzfH4YU=;
	b=WD6bn2U3e/5gXSGpMX8A3mJ+n3Qr9Cmhr3/jtzhx2ofyylGVp4GeU2grHqw4/3ph2vCE
	 r6afKUWaNgxjX4A2ul9Ei1x3Ul0Y+bmzeH2Kqq7InFXcD6lsNEz/bNKYG9V5240Qpfjrv
	 i5hcWNz08ueBqbzI16pyo+iq0aOEGcJ18pVS+gbxCkXFYDxl9/kpEIcp/ALj55Zd53mv5
	 CCgOt+h4g/4N8ZCa38FcYyWtj6X2wlWoflvVOsCggj4H0s046fx24uXLJxpqW+zQPA+27
	 1Y9ajIpG7nIu4B6zQi6/1lx5mMuX0+DnvfKtkJqtyS+N3qaR21r9fza993ge3D9nIkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmrgkAxg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6A4606D817;
	Sat,  7 Nov 2026 14:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmrgkAxg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5151F0089F;
	Sat,  7 Nov 2026 14:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062602;
	bh=sjy3RnBR4dfyH1nl8ipsaxZxqopEIUX+LXUDKzfH4YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vmrgkAxgDFK62EdVF4boRUxfKehSTw0Mitsq2bsVvGsSOpwK/rGKhZaEMj1g3+Q+x
	 TFgwhA7237/aaEYt0gjP/GHN1jue7QjCubG5geHHWi7I7+10SQprzgpkqV940UUYmd
	 JAr5linb/kj6gCm6wuRbn7U0WiIOViGbeMNtebRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Jie Law <law.wei.jie@gt.tech.gov.sg>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1476/1536] net: usb: pegasus: check rx pkt_len against the received length
Date: Sat,  7 Nov 2026 08:58:12 -0500
Message-ID: <20261107135039.305994076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Jie Law <law.wei.jie@gt.tech.gov.sg>

[ Upstream commit efee699f6de06611234ef9b0abd52db1340e5452 ]

read_bulk_callback() takes the frame length from the device, from the
receive header on the 0x8513 and from the trailing status bytes on the
other chips, and only checks it against PEGASUS_MTU before passing that
many bytes up the stack. In two cases the stack then uses bytes that the
device did not send:

- A device that sends a short transfer but claims a long frame gets the
  stale or uninitialized remainder of the receive skb delivered as
  packet data.

- A device that claims a frame shorter than an Ethernet header gets
  past the check as well. eth_type_trans() takes pkt_type from h_dest
  and the protocol from h_proto without checking skb->len. If the
  transfer is also short, those come from bytes left in the skb by an
  earlier transfer, or from uninitialized memory.

Drop frames shorter than ETH_HLEN, and frames whose claimed length, plus
the 0x8513 header, does not fit in the bytes actually received, and
count them as length errors. urb->actual_length never exceeds the
PEGASUS_MTU sized transfer buffer, so this also covers the existing
PEGASUS_MTU check. Valid Ethernet frames are at least 60 bytes long
without the FCS, so they are not affected.

Found by code review with LLM assistance. With an emulated USB device,
a 101-byte transfer claiming a 1500-byte frame was passed up as a
1500-byte packet before this change and is dropped after it, and
frames claiming 0, 4 and 13 bytes were passed up and are now dropped
and counted in rx_length_errors. The extra bytes happened to be zero
in the first test, so disclosure of actual kernel data was not
demonstrated.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Jie Law <law.wei.jie@gt.tech.gov.sg>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261021020310.34045-3-law.wei.jie@gt.tech.gov.sg
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/pegasus.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index f5a26a0bc679a..69445a94ee6ff 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -523,11 +523,17 @@ static void read_bulk_callback(struct urb *urb)
 	}
 
 	/*
-	 * If the packet is unreasonably long, quietly drop it rather than
-	 * kernel panicing by calling skb_put.
+	 * Drop frames shorter than an Ethernet header, because
+	 * eth_type_trans() reads the header whatever the length, and frames
+	 * longer than what was actually received. Passing either up would
+	 * expose stale buffer contents, and skb_put() could panic on the
+	 * latter. count is at most PEGASUS_MTU.
 	 */
-	if (pkt_len > PEGASUS_MTU - rx_offset)
+	if (pkt_len < ETH_HLEN || pkt_len + rx_offset > count) {
+		net->stats.rx_errors++;
+		net->stats.rx_length_errors++;
 		goto goon;
+	}
 
 	/*
 	 * at this point we are sure pegasus->rx_skb != NULL
-- 
2.53.0



