Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED8636607D;
	Thu, 30 Jul 2026 15:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426406; cv=none; b=tdkTUuLjGFFRYdm1r4KS208cGcnMmmyybk3nb8b5NpLNZHuqUKxZx7Vj7CRwJ4eWXOqmrXtfaKFwxSOy4GmxQWUo65nzafCC9vbP588N6wLx3zGhZuZ3yeSvTuupPJS8RIuLQcEMOBT1566T1/MdL8OemkNCSMMd30/+E1ueqNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426406; c=relaxed/simple;
	bh=NzIgRYXoyahKbT3lMVXHk2p2hv/NyXlS//8N6eAcM7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0xS8EAiNKH/7/Sz9PFUd5sRf4H/fRqgTj8lcByEkUFsWias3qLC/gSHnBajMWEJNnub60Nk97hIVpgQHT/5poAfi5OPO2YHRIHGT1j9peodvAEoMgjPVTP0GyKpEP5NmK2ugTzCPRdp+o+NSffAwTwv6fQHbPtkGodlx0r+Wr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaTJIMEv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaTJIMEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAD01F000E9;
	Thu, 30 Jul 2026 15:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426405;
	bh=9HWiYkOFe/tjzTSUTuOycv3wma8AWJPCAP879c8yWiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TaTJIMEvly/v3u9YW45yb0yvuuLRK9IrFvFSgJI6nGznr2oWojXE2IGcLe66UYUH0
	 8IRPeM0LiE2udC1/3HgM3jg+3lG2ZvP93VXZZ+76pq8dMU775rzetzSPdjPBbdKijH
	 RZ+7JH6yNQItz0mYL6ENPCmlv3RsgN6i88BXFuU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 407/602] phonet: pep: fix use-after-free in pep_get_sb()
Date: Thu, 30 Jul 2026 16:13:19 +0200
Message-ID: <20260730141444.517573413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 0f71f852a96af9685858ce59fda34ecbf85c283d upstream.

pep_get_sb() doesn't consider that pskb_may_pull() might have relocated
the skb data, and continue to access the older pointer, causing UAF.

Reproduced under KASAN:

  BUG: KASAN: slab-use-after-free in pep_get_sb+0x234/0x3b0
  Read of size 1 at addr ff11000105510f50 by task repro/157
   pep_get_sb+0x234/0x3b0
   pipe_handler_do_rcv+0x5f7/0xa10
   pep_do_rcv+0x203/0x410
   __sk_receive_skb+0x471/0x4a0
   phonet_rcv+0x5b3/0x6c0
   __netif_receive_skb+0xcc/0x1d0

Refetch the header with skb_header_pointer() after pskb_may_pull(), so
the possibly stale pointer is no longer dereferenced. There are better
ways to solve this, but, this is the less instrusive one.

Fixes: 9641458d3ec4 ("Phonet: Pipe End Point for Phonet Pipes protocol")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260721-phonet_get_sb_uaf-v1-1-95fd7881cc4e@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pep.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -55,6 +55,8 @@ static unsigned char *pep_get_sb(struct
 	ph = skb_header_pointer(skb, 0, 2, &h);
 	if (ph == NULL || ph->sb_len < 2 || !pskb_may_pull(skb, ph->sb_len))
 		return NULL;
+	/* pskb_may_pull() may have reallocated the head; refetch ph. */
+	ph = skb_header_pointer(skb, 0, 2, &h);
 	ph->sb_len -= 2;
 	*ptype = ph->sb_type;
 	*plen = ph->sb_len;


