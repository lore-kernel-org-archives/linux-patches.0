Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDDB516168;
	Wed, 30 Sep 2026 18:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792110; cv=none; b=LMuR+11YtukswhvrK75zELbEWb9yGrMzJng4CV4gdkP7v5WgfYvbhuvkO2QoKlVjdnhw/AwUN6vxlamjHvlosYi9h2r868cMP8VvtmDaYTh+Rl85YFm0one4yLGZHZtp0H6KoisTNI2YfnZkpIDWVC44YG1zZIB9Bu3q1Af9ce8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792110; c=relaxed/simple;
	bh=fSv0ZCQMItOcP1Klye7OIa0nU1i1TjMdz2Z4C5Em8cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMNq0RViZbkEvch9aBLmY/TeyEkhpYhjmps3GRAtA9zFYe0YLpQK00r3/9D2KSFbraGaDVRopjPX6AkNHfX+cRrAR80n+28WOvqy/WmuGfN1pZY2yMshCn97or7ovEAB9ymw51x/YfgqX/odqGqFBoCcP9YrPzvmwuThElQgtPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmxbC7rp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmxbC7rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112FD1F000FF;
	Wed, 30 Sep 2026 18:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792109;
	bh=i9cssXhBBdPnfwPXJCKdZ3JWC1fLVrpda09Fwo24Fmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TmxbC7rpAm6UtMbcg6V9Y9LSQh8ftsvaK7Gnit5AGlv5p9AxIgPGfL6Id351qsUS3
	 5bZQLksrER9YBbGn3UwQkPutGRDpuXFdFGPSiYu39mhvBpLWYknHHApMi7Vre5YIqy
	 WGk/uhbhafI4TvXXxfqEkhJxR7kGG4yZlCUmI8jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 538/752] net/packet: avoid truncating TPACKET_V3 private size
Date: Wed, 30 Sep 2026 17:26:48 +0200
Message-ID: <20260930152409.889069553@linuxfoundation.org>
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

From: Mark Amirkan <markdamirkan@gmail.com>

commit 37213e61120297920ae4c937fcb326a360da5084 upstream.

tpacket_req3.tp_sizeof_priv is an unsigned int, and packet_set_ring()
validates the full value against the block size.  init_prb_bdqc() then
stores it in the unsigned short blk_sizeof_priv field.

Commit 2b6867c2ce76 ("net/packet: fix overflow in check for priv area
size") fixed the validation arithmetic, but an accepted value above
USHRT_MAX still narrows when it is stored.

For a 131072-byte block, tp_sizeof_priv=65536 is valid.  The narrowing
makes offset_to_first_pkt 48 instead of 65584, so packet records can be
placed in the private area that userspace asked the kernel to preserve.

blk_sizeof_priv is internal state, so widen it to hold the validated
UAPI value.

Fixes: f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer implementation.")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260913-b4-send-packet-private-v1-1-925eab2cd388@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -21,7 +21,7 @@ struct tpacket_kbdq_core {
 	unsigned char	reset_pending_on_curr_blk;
 	unsigned char   delete_blk_timer;
 	unsigned short	kactive_blk_num;
-	unsigned short	blk_sizeof_priv;
+	unsigned int	blk_sizeof_priv;
 
 	/* last_kactive_blk_num:
 	 * trick to see if user-space has caught up


