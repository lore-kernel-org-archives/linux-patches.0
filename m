Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A3613C9C4;
	Mon, 17 Aug 2026 14:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976581; cv=none; b=hYOAzTuL+y81Xkcc6tSV6418FVG/jPiBCTKKfMzHNm8bqcASkPgpDwqCVTD5UezAQ3UMkawT18YKr3i7rg/wDLGSJ9Jm39e1RHRG+bJryQ42/oE3IqF5Ebinn+fCl0X+CxI+KqX0kNmWe3pRuy82q3VPna120v6QoYsuhTeRKGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976581; c=relaxed/simple;
	bh=rj0jEDfnmUoDknwd6wKAFkq3Vt0qPWtvDbh0O4kG2YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pk8ZY+oelHAgC4XA70igXU6A+rgEQ5GYV8+83Z5Pw8wLZetk9QOpaZO7LM+sdQ0XvzlQBSKEvs424m+oezSNbHcfK+Sv6Y+ecsKWWGdrkGyIa/ueW4Rc7X180g3T0ZSH4AfDEiQB4a3XjFBv+VjHnMizzkvw8OIVYeI3OW4dxk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayKOCviM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayKOCviM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FB81F000E9;
	Mon, 17 Aug 2026 14:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976579;
	bh=qM48Ur/QpUTjCIl4gsQHudQBFyWHUsyJCY/1eAjbTyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ayKOCviMSqCWu3gy43NvOdBj4tVHMeJS3LnbSKkQQyjzOgwQDNgnvls8tU1z3NJPo
	 Ww966xhpkJp0ev8yACYM4zMztLVa2t2xw98CkXi+HXvs6s0IYG70kawzRgQ5JgY8RP
	 0H+XDQ9mgSaNBRA7zaZaiYoXF5FQHTQWstaKyrVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?HE=20WEI=20 ?= <skyexpoc@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/456] wifi: cfg80211: bound element ID read when checking non-inheritance
Date: Mon, 17 Aug 2026 15:27:03 +0200
Message-ID: <20260817132541.315583397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HE WEI (ギカク) <skyexpoc@gmail.com>

[ Upstream commit cb8afea4655ff004fa7feee825d5c79783525383 ]

cfg80211_is_element_inherited() reads the first data octet of the
candidate element (id = elem->data[0]) to look it up in an extension
non-inheritance list. It does so after testing elem->id, but without
verifying that the element actually has a data octet. A zero-length
extension element (WLAN_EID_EXTENSION with length 0) therefore makes it
read one octet past the end of the element.

_ieee802_11_parse_elems_full() runs this check for every element of a
frame once a non-inheritance context exists -- e.g. while parsing a
per-STA profile of a Multi-Link element in a (re)association response,
or a non-transmitted BSS profile -- so a crafted frame from an AP can
trigger a one-octet slab-out-of-bounds read during element parsing:

  BUG: KASAN: slab-out-of-bounds in cfg80211_is_element_inherited
  Read of size 1 ... in net/wireless/scan.c

Return early (treat the element as inherited) when an extension element
carries no data, mirroring the existing handling of empty ID lists.

The bug was found by fuzzing ieee802_11_parse_elems_full() under KASAN.

Fixes: f7dacfb11475 ("cfg80211: support non-inheritance element")
Signed-off-by: HE WEI (ギカク) <skyexpoc@gmail.com>
Link: https://patch.msgid.link/20260707094828.16465-1-skyexpoc@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 1bc2aba69bd732..df9d0431864d39 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -240,7 +240,7 @@ bool cfg80211_is_element_inherited(const struct element *elem,
 		return true;
 
 	if (elem->id == WLAN_EID_EXTENSION) {
-		if (!ext_id_len)
+		if (!ext_id_len || !elem->datalen)
 			return true;
 		loop_len = ext_id_len;
 		list = &non_inherit_elem->data[3 + id_len];
-- 
2.53.0



