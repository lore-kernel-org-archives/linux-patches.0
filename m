Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4242A4C33C4;
	Wed, 30 Sep 2026 16:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785771; cv=none; b=UCrf8ZvRhHSBm85bQuFQy9QFjC6R4D3D26z83xFn2GjNP3tRnyz/Wq4bPgOBWHHiawMvRewemG6G8DJIbt9lCSRR4lbIr/MYzD1JSMvUIqVZIuc8T254q2WbcmfVN5im67s80AsF2BWwk6dqqNGwCRmDUZDejjMuju4bmaIlL9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785771; c=relaxed/simple;
	bh=AO7wzKCuYP4saW0j/xWchd8kgq7HRXLf1FkAAQF0Nuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNg5xrGjQP/HOTqzwqa0OmRQtRsuG5B5nKoGtmHrr5HaO1PCeAQqY1Vw/RK1DR7fdS4Cwt0xehmGvF+aQxafLqAy1+KgpCLra+FmhfDURVEBphzSnEwIV7UbLB6YzQMx/+Z31Qr1vY2SgzjItFvrrHF9IIL1/Tb902URVHFoIU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ld8wRRro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ld8wRRro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEBC1F000FF;
	Wed, 30 Sep 2026 16:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785770;
	bh=AVJDJVdF8yvSVandhQ6tP2PqTc71dUDpzwu2xtCWVLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ld8wRRroMH1DgSKZInwUHvPGrv6Ee6/05YyZmKfr5a86I00qGHZMvwNz96XB9Dqn8
	 UO3p2TBfwotNnYXRz2ch3lOeuFWX2Eqt1FdXlyfQoM3pLZXICVH0Qrr2qsSdw3qCvC
	 YlUxZQ8+BV0gj/n/6++mapN0w30lTKuMc/MvcD6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1a797e1c81be78a2ace7@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 625/982] wifi: cfg80211: only group hidden BSSes with beacon entries
Date: Wed, 30 Sep 2026 17:22:41 +0200
Message-ID: <20260930152430.198253016@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 068843ed0902c552a13860c5ec6b2ca65b57a065 ]

When a probe response for an unknown BSS comes in, __cfg80211_bss_update()
looks for an existing entry with the same BSSID and a hidden (zero-length
or NUL-filled) SSID, and if it finds one it groups them, using the beacon
IEs from the existing entry.

But that could find another entry without a beacon, if it was also from a
probe response (with SSID), so there's a group without beacon elements.

If a beacon with a hidden SSID for that BSSID arrives later,
cfg80211_combine_bsses() goes looking for the probe response entries that
belong to it - i.e. entries with the same BSSID and channel that have no
beacon IEs - and finds those two. They are already grouped with each
other, so it hits its

  WARN_ON_ONCE(bss->pub.hidden_beacon_bss)
  WARN_ON_ONCE(!list_empty(&bss->hidden_list))

which are there because an entry without beacon elements is not supposed
to be part of a group yet.

Only combine entries when a beacon was already received, ones that are
kept separate will be combined when a beacon arrives.

Assisted-by: LLM
Fixes: 4593c4cbe1c9 ("cfg80211: fix BSS list hidden SSID lookup")
Reported-by: syzbot+1a797e1c81be78a2ace7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1a797e1c81be78a2ace7
Link: https://patch.msgid.link/20260904165614.bcfa64715745.Iad740347c86de56d4ff4f96a95f3c3afc47c42de@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 1ebe2f3f6f52a..829b78eba6b10 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1879,6 +1879,13 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 			if (!hidden)
 				hidden = rb_find_bss(rdev, tmp,
 						     BSS_CMP_HIDE_NUL);
+			/*
+			 * Only group with an entry with beacon data, otherwise
+			 * beacon data can never be filled/updated.
+			 */
+			if (hidden &&
+			    !rcu_access_pointer(hidden->pub.beacon_ies))
+				hidden = NULL;
 			if (hidden) {
 				new->pub.hidden_beacon_bss = &hidden->pub;
 				list_add(&new->hidden_list,
-- 
2.53.0



