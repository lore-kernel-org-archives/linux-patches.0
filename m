Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21604DB540;
	Wed, 30 Sep 2026 16:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786045; cv=none; b=soKKHUNaxpw5LMocUFNufsR56hNkK00vUpldNR8GClDumEqAtBPmoCCXT2d8pQE8HCyehalXjdBGvXVmUxa3NSY32tdhzcn7v6eJAQ+cPg7jgMjzURC0w4wheJNprwcx3SPN4MSAW4lBdyEwM+C37fAoStL/iukFGwQASZYVmNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786045; c=relaxed/simple;
	bh=ORBtZ8nK73w1jFcXAcyeTh+v8qOCcArHAirrfzARFN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArakQvViJsmNbAaH1UpHGzxyqQMPZp3aauB9KSaI9yMfPpqweX9hGElRpsrpbDgkEdoWyCRX5rcOfA7/JRX78lHNtJZJuScWdE+48JQrgoJJKyHyMa03vp/PD72P497qv2KAWLZmtXii9aL+aI3ZNWea9pBKwioeAjYtsId1JAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azSQkDCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azSQkDCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7951F000FF;
	Wed, 30 Sep 2026 16:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786044;
	bh=BdKDiTYEJPnUNi4BRupjigpTdqM6WhvTr5FogdEvIl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azSQkDCILE/ApSO/Fpk1snTbz4rGNQEoXqE7qTGBDDBqxjZrZ2z99WVrPSHZuDE78
	 BqBD8Go7JKzL7LXgnkHlhXgNsK2U589DNe1Bms9mdgRp6iMX76f/9G5K5fa55B6N7Q
	 YlShbK/ZfOUkWBXPf6xX/6cJ9+xVgaLU3vqMlafM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 722/982] net/packet: avoid truncating TPACKET_V3 private size
Date: Wed, 30 Sep 2026 17:24:18 +0200
Message-ID: <20260930152432.259503415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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


