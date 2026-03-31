Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD0C3FADEE;
	Tue, 31 Mar 2026 16:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976021; cv=none; b=aBm+4pWl6Ha2afWxcs/dKiFXzfi2f6qa47tYaHZe5n4dOuDHgqUP2if7CYeSiktHgMlmAwmYmTmFybP/KJ6gSWq5CXwyDhp0qLj6s+Gg39pkEQjBwJpYmz5/XkV47Hna7TiWBr8zGJVAHe1SNCE4HsgnHA4w5Mn2WWxN2adl04M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976021; c=relaxed/simple;
	bh=PPmyuWpnRq1gdJVTg7csNz0GmldBEjsy3zeg5XAxA3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJ873lfaUHVDV2wQMjo8cWKeRYoeG2hCV3y+/oAWQ1hbQQ/q+6xuBKuEYaSx5zrc46QLYk80ylSu9BsQsS4vlRiOKpQSpLtbs2+KaYLZsQ9zTVIXPQeO/foJC6DK8PSRI/5rR0ojQVslKDjZnxWgQ+V85hrrw7eFdKXL5L4s2B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0TU4L73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0TU4L73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D56C19423;
	Tue, 31 Mar 2026 16:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976021;
	bh=PPmyuWpnRq1gdJVTg7csNz0GmldBEjsy3zeg5XAxA3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0TU4L73o1zxVKPhdaQE+j2Rp/fl0noONgXDR1MTclC6754LLzuKgvmo8psdIl/cb
	 BuxPnjbqruUNZwv0Tv0hLdkkgsyObMLUiEPl0U8VCjEjOljsY5Iqrfa5oeInFc9sCR
	 3Ya8QP5xgPn2sJyJR24bCpWl/1TraSoZLlAF0jCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Norouzi <ali.norouzi@keysight.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 144/244] can: gw: fix OOB heap access in cgw_csum_crc8_rel()
Date: Tue, 31 Mar 2026 18:21:34 +0200
Message-ID: <20260331161747.085810163@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Norouzi <ali.norouzi@keysight.com>

commit b9c310d72783cc2f30d103eed83920a5a29c671a upstream.

cgw_csum_crc8_rel() correctly computes bounds-safe indices via calc_idx():

    int from = calc_idx(crc8->from_idx, cf->len);
    int to   = calc_idx(crc8->to_idx,   cf->len);
    int res  = calc_idx(crc8->result_idx, cf->len);

    if (from < 0 || to < 0 || res < 0)
        return;

However, the loop and the result write then use the raw s8 fields directly
instead of the computed variables:

    for (i = crc8->from_idx; ...)        /* BUG: raw negative index */
    cf->data[crc8->result_idx] = ...;    /* BUG: raw negative index */

With from_idx = to_idx = result_idx = -64 on a 64-byte CAN FD frame,
calc_idx(-64, 64) = 0 so the guard passes, but the loop iterates with
i = -64, reading cf->data[-64], and the write goes to cf->data[-64].
This write might end up to 56 (7.0-rc) or 40 (<= 6.19) bytes before the
start of the canfd_frame on the heap.

The companion function cgw_csum_xor_rel() uses `from`/`to`/`res`
correctly throughout; fix cgw_csum_crc8_rel() to match.

Confirmed with KASAN on linux-7.0-rc2:
  BUG: KASAN: slab-out-of-bounds in cgw_csum_crc8_rel+0x515/0x5b0
  Read of size 1 at addr ffff8880076619c8 by task poc_cgw_oob/62

To configure the can-gw crc8 checksums CAP_NET_ADMIN is needed.

Fixes: 456a8a646b25 ("can: gw: add support for CAN FD frames")
Cc: stable@vger.kernel.org
Reported-by: Ali Norouzi <ali.norouzi@keysight.com>
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Ali Norouzi <ali.norouzi@keysight.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260319-fix-can-gw-and-can-isotp-v2-1-c45d52c6d2d8@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/gw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -374,10 +374,10 @@ static void cgw_csum_crc8_rel(struct can
 		return;
 
 	if (from <= to) {
-		for (i = crc8->from_idx; i <= crc8->to_idx; i++)
+		for (i = from; i <= to; i++)
 			crc = crc8->crctab[crc ^ cf->data[i]];
 	} else {
-		for (i = crc8->from_idx; i >= crc8->to_idx; i--)
+		for (i = from; i >= to; i--)
 			crc = crc8->crctab[crc ^ cf->data[i]];
 	}
 
@@ -396,7 +396,7 @@ static void cgw_csum_crc8_rel(struct can
 		break;
 	}
 
-	cf->data[crc8->result_idx] = crc ^ crc8->final_xor_val;
+	cf->data[res] = crc ^ crc8->final_xor_val;
 }
 
 static void cgw_csum_crc8_pos(struct canfd_frame *cf,


