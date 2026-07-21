Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBE0471424;
	Tue, 21 Jul 2026 20:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664169; cv=none; b=uKss0ZSoTjaqwCeDloJMh3cuvhaFSDDtHT74VFw/n8iAqLSMTFMzbqx2UXLunc9zlt0VPgpgcqrLAHb7NJ08nKDkKpLJDVQ7pO7EEpv1HHWdk3aoHXfVBl0Cua/9AXLao/e6U6M41rlVPOF3/mq1cXW0WblYi+sP6tHRc9Ef+qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664169; c=relaxed/simple;
	bh=SPMvIgZnIEGEhS+sGFpoFt3T1+lxrYIC7rvnFEoiM7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrSJJCSN6ow7N+yhWHYPCR3ZOfZx1k/KT3bqLvvAznpHNf0JAyCgI599+CGgwVdLVn0pDaokjvdymex3Sg0JvMkGI/bORz4VmvtakCvttFMxmc1pC/QrnLNLOakOtFCnLLto6/GU8yrZ1nuJGE5TpUummjf305ldFwLNi0AFw1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sm0oRuls; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sm0oRuls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B031F00A3A;
	Tue, 21 Jul 2026 20:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664167;
	bh=ZDm/Up29BwxpLxdbSpmfcJZJ4GRcyPeKW4Pi40E3jmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sm0oRulsO/PGv9QPDU2SuVgNxHtsZkc5BCzqO4S7cGHf/byHcwiSpeQKAd/wN7m0Y
	 o0m3izy4udeqhoCr+EGHDii4As1FrJYdUL1iYJls8B2D0Z4jartZeecdZMokmfFZwz
	 lP0JIXLWGt7U8gilX9Gu0qv6qWEoLWW539a1CzAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 1097/1276] drbd: reject data replies with an out-of-range payload size
Date: Tue, 21 Jul 2026 17:25:40 +0200
Message-ID: <20260721152510.534010216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit bd910a7660d280595ef94cb6d193951d855d330f upstream.

recv_dless_read() receives a P_DATA_REPLY from a peer into the bio of an
outstanding read request. The peer-supplied payload length reaches it as
the signed int data_size, and two peer-controlled inputs can make it
negative. With a negotiated data-integrity-alg the digest length is
subtracted first, so a reply whose payload is smaller than the digest
underflows data_size. With no integrity algorithm (the default) data_size
is assigned from the unsigned h95/h100 wire length and drbdd() never
bounds it for a payload-carrying command, so a length above INT_MAX casts
it negative; this path needs no non-default feature. The bio receive loop
then computes expect = min_t(int, data_size, bv_len), which is negative,
and drbd_recv_all_warn(mapped, expect) receives with a size_t of SIZE_MAX
into the first mapped page.

The sibling receive path read_in_block() is not affected: it uses an
unsigned size and rejects it against DRBD_MAX_BIO_SIZE before receiving.
Reject a data reply whose size is negative after the optional digest
subtraction, covering both triggers.

Impact: a malicious or man-in-the-middle DRBD peer copies attacker-chosen
bytes past a bio page in the receiver, corrupting kernel memory. A node
that reads from its peer (a diskless node, or read-balancing to the peer)
is exposed in the default configuration; data-integrity-alg is not
required.

Fixes: b411b3637fa7 ("The DRBD driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5-5-xhigh
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Link: https://patch.msgid.link/20260710022837.3738461-1-michael.bommarito@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/drbd/drbd_receiver.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1998,6 +1998,11 @@ static int recv_dless_read(struct drbd_p
 		data_size -= digest_size;
 	}
 
+	if (data_size < 0) {
+		drbd_err(peer_device, "Invalid data reply size\n");
+		return -EIO;
+	}
+
 	/* optimistically update recv_cnt.  if receiving fails below,
 	 * we disconnect anyways, and counters will be reset. */
 	peer_device->device->recv_cnt += data_size>>9;


