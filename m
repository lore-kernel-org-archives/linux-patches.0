Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DD83264FF;
	Tue, 16 Jun 2026 15:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622802; cv=none; b=gHB+u34M/9TCw5quwvXrV7uIEPzqQ47R47iH6rBt1JZrxpv6Pp8JwtXc+jLaJ8qV98ql2mAr1PDGpaNIWjXJ8fu75LUXH2wWyL618vl2upYyNbLtUI96alaABuuLIKgtG0rQzmtrTuoTzWiitw2AK8YS4hpSy6xVBqkKAY1ImrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622802; c=relaxed/simple;
	bh=TI0H2KUrbAuYLQLR0bP619M4uhP7Ns+mOgtMbekfn8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J97eHu2uHsl78nYaRo4wcH1FWXDebeaRC2FHYy6ymX1KluOYZi6FQ8AGF5WdkHtiSWCaNrxp3wy0y0CXQtjYGTN54yvP27dXSiT9mD/PUlAhd5j4nn0JT2BZYL9xYe15uH55R/55KBN864vvkrprSD12F4L2CDgN8i15vRRuS0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Haz/iAQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Haz/iAQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DB61F000E9;
	Tue, 16 Jun 2026 15:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622800;
	bh=3PPS5aTyep09Gv/ky9gwCWxqTw89Ub9pSVr+/z384e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Haz/iAQuZNjqkNjlcko9GHqC7pqKwDBUhKwc7NwYpHnEDiqd5YkkCelqVQVp+rGot
	 TiPHin4DJY3QPRKg50u6QXUzGGqNIS07pyeFvoj6pE9TkbW1m8CgnHfLhwi/lI4TW1
	 eX4iP37RYVffAE4QYeDI5N686rBnMWpSMXGQpXiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8e0622f6d9446420271f@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 031/378] wifi: mac80211: limit injected antenna index in ieee80211_parse_tx_radiotap
Date: Tue, 16 Jun 2026 20:24:22 +0530
Message-ID: <20260616145111.503332253@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 6c0cf89f36ac0c0fd8687a4ccdce2efb23a9c663 ]

When parsing the radiotap header of an injected frame,
ieee80211_parse_tx_radiotap() uses the IEEE80211_RADIOTAP_ANTENNA value
directly as a shift count:

	info->control.antennas |= BIT(*iterator.this_arg);

*iterator.this_arg is an 8-bit value taken straight from the frame
supplied by userspace, so BIT() can be asked to shift by up to 255. That
is undefined behaviour on the unsigned long and is reported by UBSAN:

  UBSAN: shift-out-of-bounds in net/mac80211/tx.c:2174:30
  shift exponent 235 is too large for 64-bit type 'unsigned long'
  Call Trace:
   ieee80211_parse_tx_radiotap+0xadb/0x1950 net/mac80211/tx.c:2174
   ieee80211_monitor_start_xmit+0xb1f/0x1250 net/mac80211/tx.c:2451
   ...
   packet_sendmsg+0x3eb6/0x50f0 net/packet/af_packet.c:3109

info->control.antennas is a 2-bit bitmap (u8 antennas:2), so only antenna
indices 0 and 1 can ever be represented. Ignore any larger value instead
of shifting out of bounds.

Reported-by: syzbot+8e0622f6d9446420271f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8e0622f6d9446420271f
Fixes: ef246a1480cc ("wifi: mac80211: support antenna control in injection")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260531011721.102941-1-kartikey406@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b7aedaab848386..d2ba2d81224f97 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2172,7 +2172,9 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 
 		case IEEE80211_RADIOTAP_ANTENNA:
 			/* this can appear multiple times, keep a bitmap */
-			info->control.antennas |= BIT(*iterator.this_arg);
+			/* control.antennas is only a 2-bit bitmap */
+			if (*iterator.this_arg < 2)
+				info->control.antennas |= BIT(*iterator.this_arg);
 			break;
 
 		case IEEE80211_RADIOTAP_DATA_RETRIES:
-- 
2.53.0



