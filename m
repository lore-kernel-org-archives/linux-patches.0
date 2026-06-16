Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B9F44DB64;
	Tue, 16 Jun 2026 16:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626755; cv=none; b=o4tipfvawow6mZqFdmSYXyJF+jfr95vQrsdxTVbL4EcDSOoMJbOENsTNR/I3GC2aiukEhNEzXHQfZIhVKt/UdcwdBxpbqym2tyKjsFUlynNCROx+EYMVYbfHnJi7frGEX8O1qNZMbhwUVhgrc+/D+iJDYzx04ehnWyFefYaXxMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626755; c=relaxed/simple;
	bh=r2HJufjgW14U0QkTayXCbtGpGLXH6J9AHR1frxEmpko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4c9vaEvGL2wV3IgELj+BRtURwhvwbxrAj3GfQwF8855LbVof03KPCyvXiQXlHAiUfpit//Sg1eMh4dZfNyXiELAe2HhkuL5nw1tqxI5hjOk1D3W8YVJpF6UDHTVSzIVRsMCZbCxYzoG6lnnOogqsippBUeCSTnXUiikeB1IKuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIQhS9Jo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIQhS9Jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037DD1F000E9;
	Tue, 16 Jun 2026 16:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626753;
	bh=WS6FkEuls3+Noy+1nqAm+DElKCckpo5KnS3GF6TDnu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIQhS9JosOvsWgyruF9RjNPTxlPuqc0p16TQOCZWUBAHMMQ+Hx3iFZZ0Cd8Z6ABV3
	 EBCXvd6MUH7QhzNgdwEsEZIGd/mII7VGknBNlMgUJdPmJ6/xzlEh1nzxGMvSkdGanF
	 BNsUuJkFmCDAhVnZLZXgt4TtDQlcr66ajb80fH/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8e0622f6d9446420271f@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/261] wifi: mac80211: limit injected antenna index in ieee80211_parse_tx_radiotap
Date: Tue, 16 Jun 2026 20:27:48 +0530
Message-ID: <20260616145046.449527373@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
index 0458cbba232e21..b82c7884a92db3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2169,7 +2169,9 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 
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



