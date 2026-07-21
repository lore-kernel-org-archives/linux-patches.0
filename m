Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5FC366816;
	Tue, 21 Jul 2026 20:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667308; cv=none; b=trUUSasYasVCtsLyN/ZAlZX9U27BMJcx0o2suZyq13TkqcjAVQ73rViBp2oKzozRx2p0xV/bZfbYwQI6HdoCdSpgvEPiaEKWgmiKUEGNvDWgfznk901Oy9zDEbmqLnGWUBT67sjHOtOmuopKqWTM38nf9BTN0kpTEYmcmesbvHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667308; c=relaxed/simple;
	bh=LAJyZ898dT5Yj9AaSbXSeUcdBOg+Zy5TokjDKsbF8Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHYZAKbxvKRsYjWa8L+9Eq5k/yCI3AwmFayvA4Sw6nVqbx6XsRmZyBl58WvqWL9tu/RrDWzyWX0aAXnFuucEdq4yGLWiN6/4lFWYORedfnX+H4/NPIpfuKOH+Oydqxd4TI3mjWHeK1Bv8bSREhpmtYAGeq+nMW7/FkGwzMxNzfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFIzIVam; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFIzIVam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B5C1F000E9;
	Tue, 21 Jul 2026 20:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667307;
	bh=xFoB6wGjzmUn71RF1P8wrv1aucJQV0bnc2PMgiV9VKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFIzIVamV+exbNW4sBBTE3F3bK1qQ9ZFVBAtiGTRn2GLRB0uBOWDkTLTanvItEjgG
	 nN7f9KvjCnnIBTo1TTNUwob1h21ljc1I05EropwvmM3yxnFrJFI4RkwFCMMYAhzqVg
	 JHW0AT5HdCQ9w2vArkTHaZe6In9KQzLhv2X/oVt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1010/1266] net: thunderbolt: Fix frags[] overflow by bounding frame_count
Date: Tue, 21 Jul 2026 17:24:07 +0200
Message-ID: <20260721152504.427617172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 55d9895f89970501fe126d1026b586b04a224c27 upstream.

tbnet_poll() assembles a multi-frame ThunderboltIP packet into one skb. The
first frame goes into the skb linear area and every further frame is added as
a page fragment.

	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
			page, hdr_size, frame_size,
			TBNET_RX_PAGE_SIZE - hdr_size);

A packet of frame_count frames therefore ends up with frame_count - 1
fragments. tbnet_check_frame() only bounds the peer supplied frame_count to
TBNET_RING_SIZE / 4 (64), which is far above MAX_SKB_FRAGS (17 by default). A
peer that sends a packet of 19 or more small frames pushes nr_frags past
MAX_SKB_FRAGS, so skb_add_rx_frag() writes past skb_shinfo()->frags[] and
corrupts memory after the shared info.

Tighten the start of packet bound to MAX_SKB_FRAGS + 1 so a packet can never
produce more fragments than frags[] can hold. This matches the recent skb
frags overflow fixes in other receive paths, for example f0813bcd2d9d ("net:
wwan: t7xx: fix potential skb->frags overflow in RX path") and 600dc40554dc
("net: usb: cdc-phonet: fix skb frags[] overflow in rx_complete()").

Fixes: e69b6c02b4c3 ("net: Add support for networking over Thunderbolt cable")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/178163152194.2486768.14724194232649760778@maoyixie.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/thunderbolt/main.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -786,8 +786,12 @@ static bool tbnet_check_frame(struct tbn
 		return true;
 	}
 
-	/* Start of packet, validate the frame header */
-	if (frame_count == 0 || frame_count > TBNET_RING_SIZE / 4) {
+	/* Start of packet, validate the frame header. tbnet_poll() puts the
+	 * first frame in the skb linear area and every further frame in a page
+	 * fragment, so a packet may not span more than MAX_SKB_FRAGS + 1 frames
+	 * without overflowing skb_shinfo()->frags[].
+	 */
+	if (frame_count == 0 || frame_count > MAX_SKB_FRAGS + 1) {
 		net->stats.rx_length_errors++;
 		return false;
 	}


