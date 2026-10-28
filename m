Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207690;
	b=sYPX8V+FBtWJtxV7TbMHBlolvbeJ1OuNSlG6qfrSzpmPdSy3WVc9eGK7X5YYn5RecgLM
	 uMBAq0UQ2XQyApyR+SbUFQH1sYAQsiAS6/YxLCQYr+BygUYXVN0I4+S9PWvkWpTYo5xWJ
	 FPEynucy5mXGOQ2k3jJTr4yQjV/EFT+W2Rr8M05ge65VS8Y+85GIw9LdRFoAD1hi0pzD/
	 ISATfT5Vp5cnxMB1IjoYh+4hT8Gr4IF3crYyJ4z0P+AmOhyXl2C61+C/Y2wsiG1Z82bWQ
	 OsJqsSEIx94GcKLT6HUgol7J8KG2PzxQfMTCJrbjrV8WIQ23YAl0rLphJRBE4sS4u7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j11fYw3nF3MFpjVnJ9OyJbxs2dDqgU+t8W6uuoCHN2U=;
	b=Xg2HTYA8uHsFUCFt64J8oIJA9wqnNyvmAsOpxcQdSeQW1gnmQyqKqujmHUgHg/g81C8x
	 Q+n2S9Bpogdy1WynPjlJ1AyjYsAlU+2Zmw9yyUylWUhNCfERivWPDfbMUHaK4cibhcMPu
	 7orLkScIhLUNkMLSC5pgy3+gHbvQgDP2u8VZctCyHzNBDO4Ak+ULduuI8VeteGldTHKOJ
	 SAYMWkYkkydbJ3IzLm4Hgu9KWk1AUfcM4xKv6Ajuxfdq9gT3XnkXR/A2WPRD/cCWHXJaX
	 yGHk9DecDnAaHa06l/BR4tfR/eHXDFL4eZm+bHfPkyN5+/bi6HU8OxoOgZtlNqlyCOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5k2qdi6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBF4606A329;
	Wed, 28 Oct 2026 17:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5k2qdi6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18F31F01825;
	Wed, 28 Oct 2026 17:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207690;
	bh=j11fYw3nF3MFpjVnJ9OyJbxs2dDqgU+t8W6uuoCHN2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5k2qdi6ZDO6100S9thZt69K34CnskeAzMcjeb2iVGGjCJRT8c6iGWNKCjJRMNGCR
	 JpmOhNJx6gJZSe1P7yXP3oJ9dmlkyb2Az1KflG2X/AsF21AtfZb+oWWiWWapsrg4M6
	 tE40StIfVD+QHRdZPjyAEFhr2N7nrdF/IZwjZWpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Xuanqiang Luo <xuanqiang.luo@linux.dev>,
	Kaiwen Shi <skwkevin@mail.ustc.edu.cn>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 105/247] mac802154: fix data race and NULL deref on local->assoc_dev
Date: Wed, 28 Oct 2026 17:58:28 +0100
Message-ID: <20261028165949.884286262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Kaiwen Shi <skwkevin@mail.ustc.edu.cn>

commit c037915f80c4db47f7d061d68e703ffd551b1a34 upstream.

local->assoc_dev is shared between the association path and the
association-response worker without common synchronization.

mac802154_perform_association() stores the coordinator pointer and waits
for a response. Its timeout and error paths clear the pointer and return
to mac802154_associate(), which may then free the coordinator object.
Meanwhile, mac802154_rx_mac_cmd_worker() may observe the associating bit
and enter mac802154_process_association_resp(), which dereferences
assoc_dev.

The worker's bit test and the handler's pointer dereference are not
atomic with respect to cleanup. Cleanup can clear assoc_dev between them,
causing a NULL dereference, or free the coordinator while the response
handler still uses the pointer.

The recorded result is exposed to the same window. assoc_status and
assoc_addr are written by the handler but read by the association path
while the associating bit is still set, so a second response for the same
request - a malicious one, for instance - can replace them between those
reads and leave the caller with an incoherent status and address pair.

The response handler only needs the coordinator extended address.
Replace assoc_dev with a cached address, removing the pointer lifetime
dependency. Protect the cached address and the associating bit with a
dedicated spinlock. A READ_ONCE()/WRITE_ONCE() pair would not guarantee
an atomic __le64 access on all 32-bit architectures.

wpan_dev->association_lock cannot be reused here: nl802154_associate()
holds it across rdev_associate(), hence for the whole of
mac802154_perform_association() including the wait for the response.
A response handler taking that lock would only get it once the
association has already given up.

Reset the completion, publish the cached address, and set the associating
bit while holding the lock. The response handler takes the lock, rechecks
the bit and the cached address, records the response, clears the bit, and
only then completes the waiter. Thus cleanup cannot pass the handler
between its state check and completion, and the cached 64-bit value
cannot tear.

The handler clears the bit before completing, not the woken waiter:
otherwise complete() is issued under the lock and a second (e.g.
malicious) response can reacquire it before the waiter and replace the
result. So a wait that returns success implies the bit is already clear,
and the success and negative-response paths return directly. The
transmit-error and timeout paths still clear it under assoc_lock, which
serializes any racing response against the cleanup while the call returns
the error it already selected. Both paths snapshot assoc_status and
assoc_addr under the same lock.

Both users run in process context, so a plain spinlock is sufficient.
The lock is not held while waiting for the completion.

Suggested-by: Miquel Raynal <miquel.raynal@bootlin.com>
Suggested-by: Xuanqiang Luo <xuanqiang.luo@linux.dev>
Fixes: fefd19807fe9 ("mac802154: Handle associating")
Cc: stable@vger.kernel.org
Signed-off-by: Kaiwen Shi <skwkevin@mail.ustc.edu.cn>
Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260829230551.1787432-1-skwkevin@mail.ustc.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac802154/ieee802154_i.h |    7 +++++
 net/mac802154/main.c         |    1 
 net/mac802154/scan.c         |   51 ++++++++++++++++++++++++++++++++-----------
 3 files changed, 45 insertions(+), 14 deletions(-)

--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -80,7 +80,12 @@ struct ieee802154_local {
 	spinlock_t rx_lock;
 
 	/* Association */
-	struct ieee802154_pan_device *assoc_dev;
+	/* assoc_lock protects assoc_dev_extended_addr, assoc_addr,
+	 * assoc_status, the assoc_done reinit/complete pairing and the
+	 * IEEE802154_IS_ASSOCIATING bit in @ongoing.
+	 */
+	spinlock_t assoc_lock;
+	__le64 assoc_dev_extended_addr;
 	struct completion assoc_done;
 	__le16 assoc_addr;
 	u8 assoc_status;
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -105,6 +105,7 @@ ieee802154_alloc_hw(size_t priv_data_len
 	INIT_WORK(&local->rx_mac_cmd_work, mac802154_rx_mac_cmd_worker);
 
 	init_completion(&local->assoc_done);
+	spin_lock_init(&local->assoc_lock);
 
 	/* init supported flags with 802.15.4 default ranges */
 	phy->supported.max_minbe = 8;
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -532,7 +532,9 @@ int mac802154_perform_association(struct
 	struct ieee802154_association_req_frame frame = {};
 	struct ieee802154_local *local = sdata->local;
 	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
+	__le16 resp_short_addr;
 	struct sk_buff *skb;
+	u8 resp_status;
 	int ret;
 
 	frame.mhr.fc.type = IEEE802154_FC_TYPE_MAC_CMD;
@@ -574,9 +576,11 @@ int mac802154_perform_association(struct
 		return ret;
 	}
 
-	local->assoc_dev = coord;
+	spin_lock(&local->assoc_lock);
 	reinit_completion(&local->assoc_done);
+	local->assoc_dev_extended_addr = coord->extended_addr;
 	set_bit(IEEE802154_IS_ASSOCIATING, &local->ongoing);
+	spin_unlock(&local->assoc_lock);
 
 	ret = ieee802154_mlme_tx_one_locked(local, sdata, skb);
 	if (ret) {
@@ -595,25 +599,37 @@ int mac802154_perform_association(struct
 		goto clear_assoc;
 	}
 
-	if (local->assoc_status != IEEE802154_ASSOCIATION_SUCCESSFUL) {
-		if (local->assoc_status == IEEE802154_PAN_AT_CAPACITY)
+	/* The association is complete: mac802154_process_association_resp()
+	 * cleared the associating bit before waking us, so a second (e.g.
+	 * malicious) ASSOC RESP can no longer pass the recheck and overwrite
+	 * the result.  Snapshot assoc_status/assoc_addr under the lock.
+	 */
+	spin_lock(&local->assoc_lock);
+	resp_status = local->assoc_status;
+	resp_short_addr = local->assoc_addr;
+	spin_unlock(&local->assoc_lock);
+
+	if (resp_status != IEEE802154_ASSOCIATION_SUCCESSFUL) {
+		if (resp_status == IEEE802154_PAN_AT_CAPACITY)
 			ret = -ERANGE;
 		else
 			ret = -EPERM;
 
 		dev_warn(&sdata->dev->dev,
 			 "Negative ASSOC RESP received from %8phC: %s\n", &ceaddr,
-			 local->assoc_status == IEEE802154_PAN_AT_CAPACITY ?
+			 resp_status == IEEE802154_PAN_AT_CAPACITY ?
 			 "PAN at capacity" : "access denied");
-		goto clear_assoc;
+		return ret;
 	}
 
-	ret = 0;
-	*short_addr = local->assoc_addr;
+	*short_addr = resp_short_addr;
+
+	return 0;
 
 clear_assoc:
+	spin_lock(&local->assoc_lock);
 	clear_bit(IEEE802154_IS_ASSOCIATING, &local->ongoing);
-	local->assoc_dev = NULL;
+	spin_unlock(&local->assoc_lock);
 
 	return ret;
 }
@@ -635,19 +651,28 @@ int mac802154_process_association_resp(s
 		     dest->mode != IEEE802154_EXTENDED_ADDRESSING))
 		return -EINVAL;
 
-	if (unlikely(dest->extended_addr != wpan_dev->extended_addr ||
-		     src->extended_addr != local->assoc_dev->extended_addr))
+	spin_lock(&local->assoc_lock);
+	if (unlikely(!test_bit(IEEE802154_IS_ASSOCIATING, &local->ongoing) ||
+		     dest->extended_addr != wpan_dev->extended_addr ||
+		     src->extended_addr != local->assoc_dev_extended_addr)) {
+		spin_unlock(&local->assoc_lock);
 		return -ENODEV;
+	}
 
 	memcpy(&resp_pl, skb->data, sizeof(resp_pl));
 	local->assoc_addr = resp_pl.short_addr;
 	local->assoc_status = resp_pl.status;
+	/* Clear the associating bit before waking the waiter: once the result
+	 * is saved, any subsequent (e.g. malicious) ASSOC RESP must fail the
+	 * test_bit() recheck above and can no longer overwrite the result.
+	 */
+	clear_bit(IEEE802154_IS_ASSOCIATING, &local->ongoing);
+	complete(&local->assoc_done);
+	spin_unlock(&local->assoc_lock);
 
 	dev_dbg(&skb->dev->dev,
 		"ASSOC RESP 0x%x received from %8phC, getting short address %04x\n",
-		local->assoc_status, &deaddr, local->assoc_addr);
-
-	complete(&local->assoc_done);
+		resp_pl.status, &deaddr, resp_pl.short_addr);
 
 	return 0;
 }


