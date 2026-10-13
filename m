Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E4D4EFFCF;
	Tue, 13 Oct 2026 12:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893683; cv=none; b=JAW8q0zj4RFsw5yofsv4jjhzvk0h0tq5lcKXjhSJUbNEU2IJKiSIn+C9WH2U1Km2IDhdsB9QfG1Zky+Mc6DnbMbWQWNzQkuGUVPNJGnNOn6wqAf5VVdEjynJkFRO+sr3SJZ81Z1hl4XdiXJjF+WFX2WbH6rtjp3drXVHXPHrfTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893683; c=relaxed/simple;
	bh=E11Eg6b4akeMi/73rkaxA1F9pb3ZzvA/Y1OXcQnSQ74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIEqPZTSfwYloKcxuo60WNerg8vaCs0Q3iB3zEz8Sw5L31y4SHqbief9hZGR7FTJTFDyqYvm03KsmJSJJaQMJhGjQlCst1H9zs70ilYHCUj24UlSn7Kg7WSJ3Ng2J5b3Ubc/8LcMUW4xENm4jfhGxSpHRZ+vHFrM9Q1FoMXaSto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nxZZnX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nxZZnX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880AE1F00893;
	Tue, 13 Oct 2026 12:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893681;
	bh=nKpGT3kZ34XpLes1Ye1xwJkehfWFpELz1U2RE1mRh9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1nxZZnX7dSFqqVEB+I97o75W8BYAg4vDysTgC447OGwPEuy9jnsgGZKoliKkM5hfW
	 rXQEOYWeRnMSAFwHzuqPjLB42UqZGm63fWZCqjFwtaBCOEp3jZzcS4hoEll136n6EG
	 Ifo8va4MdHg4g+guvdA11xHyChNxIMfuYPFBVRlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 308/621] wifi: mac80211: bound S1G TIM PVB walk to the TIM element
Date: Tue, 13 Oct 2026 13:35:03 +0200
Message-ID: <20261013112928.163841982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit b224d18b1e5d1cddfc67f63f41d80023b2ec8889 ]

ieee80211_s1g_check_tim() parses the S1G Partial Virtual Bitmap (PVB) of a
received TIM element. The TIM is handed in as the element payload:
ieee802_11_parse_elems_full() stores elems->tim = elem->data and
elems->tim_len = elem->datalen (net/mac80211/parse.c), so the valid bytes
are [tim, tim + tim_len).

When walking the encoded blocks the function passes the walker an end
sentinel of (const u8 *)tim + tim_len + 2, i.e. two bytes past the end of
the element. ieee80211_s1g_find_target_block() loops while (ptr + 1 <= end)
and dereferences ptr (and the per-mode ieee80211_s1g_len_*() helpers read
*ptr), so it can read up to two bytes beyond the TIM element -- an
out-of-bounds read of adjacent skb/heap data when the TIM is the last
element in the frame. The +2 appears to account for the element id/len
header, but tim already points past that header at the element payload, so
the addend is wrong.

Pass the correct element end, (const u8 *)tim + tim_len.

Fixes: e0c47c6229c2 ("wifi: mac80211: support parsing S1G TIM PVB")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260606074341.49135-1-hexlabsecurity@proton.me
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211-s1g.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ieee80211-s1g.h b/include/linux/ieee80211-s1g.h
index 5b9ed2dcc00e0..afc01379801fb 100644
--- a/include/linux/ieee80211-s1g.h
+++ b/include/linux/ieee80211-s1g.h
@@ -556,7 +556,7 @@ static inline bool ieee80211_s1g_check_tim(const struct ieee80211_tim_ie *tim,
 	 */
 	err = ieee80211_s1g_find_target_block(&enc_blk, &target_aid,
 					      tim->virtual_map,
-					      (const u8 *)tim + tim_len + 2);
+					      (const u8 *)tim + tim_len);
 	if (err)
 		return false;
 
-- 
2.53.0



