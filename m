Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DB0442FAE;
	Mon, 17 Aug 2026 15:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980344; cv=none; b=N9f56I1kPVL1fr4r0558G+C6BfERkAWIyTEvPwiyzFgSwo1uikk9mumJqbgLjJF3ZhL5m6dhKW5C3+8AqEY3PGiTLrq6dlcbah3TaNq2Okdo8Sl5doMYX5oGSD5PrVaZlUFBFmoBcvxfqtKLEOvKj9wD/a3w2YMJ4Uwp+B4tQv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980344; c=relaxed/simple;
	bh=jKr6IeTdYCNdRASo5pqfI05f423HjILK0FMOcNl3LT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpRCBFUWf3NScCDWU0s0x+OC5qTlI29e79RKVlyKnZed9ggEu6wnNLHzglGtubiNTUagwQAXA1smxtBGdP/PjkWpvxlpb9NyixSaxqFJ7BldbfTrSMHaUQfdtxwuEsXqX+INlU2/mu2ouTF2jJp3AAbFk8lpEJVfzRP0QsKoAEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XzNWx2Ys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XzNWx2Ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6386F1F000E9;
	Mon, 17 Aug 2026 15:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980342;
	bh=Y2CY19mtWrVeQ4aqSwovRd9kYFSM3LAqUMeuvkK8TiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XzNWx2YsBNsPhWUo7JAkViFMVEPQGBiyTs31Dg3U/9WrsPrpt9Ztou7smSWT2IGiI
	 i6fm1zX0kpilC5bguFIVvjC/Wjb/p0aA9JoJdSGsPR3sYnxbrtUlq/PGAJnswlmVMU
	 mHCJg3mDgH8/Irdn6OfA7kA6A/0fVSqMUBIuV+4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 541/609] thunderbolt: icm: Preserve USB4 proxy data-valid bit
Date: Mon, 17 Aug 2026 15:33:57 +0200
Message-ID: <20260817132601.870147081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit e48844ece5e3ed1d1eb865f6da2b16f62cd9f86d upstream.

The ICM USB4 switch operation request encodes two values in
request.data_len_valid: bit 4 marks the data payload valid, while bits
3:0 hold the payload length in dwords.  A zero length with the valid bit
set represents the full 16-dword data array.

icm_usb4_switch_op() sets the valid bit when a transmit payload is
present.  For payloads shorter than the full 16 dwords, it then assigns
the length to the whole field and clears the valid bit that was just set.
The payload is still copied into the request, but the descriptor sent to
firmware marks that data as invalid.

This affects USB4 router operations that send short payloads through the
firmware connection manager.  In particular, USB4 NVM writes can send a
short final block when the image size is not aligned to the 64-byte proxy
payload size.  Firmware may then ignore or reject that final block, while
full 16-dword blocks are unaffected because they are encoded as length 0
with the valid bit set.

OR the short payload length into data_len_valid so the valid bit is
preserved.

Fixes: 9039387e166e ("thunderbolt: Add USB4 router operation proxy for firmware connection manager")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/icm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -2293,7 +2293,7 @@ static int icm_usb4_switch_op(struct tb_
 	if (tx_data_len) {
 		request.data_len_valid |= ICM_USB4_SWITCH_DATA_VALID;
 		if (tx_data_len < ARRAY_SIZE(request.data))
-			request.data_len_valid =
+			request.data_len_valid |=
 				tx_data_len & ICM_USB4_SWITCH_DATA_LEN_MASK;
 		memcpy(request.data, tx_data, tx_data_len * sizeof(u32));
 	}


