Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04702773EC;
	Mon, 17 Aug 2026 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978942; cv=none; b=u07POJgmyWboqr1NtFKE67yn04jB2IEs2RA2lvFj7PUGl6oalep+VDcTC7S4Ci0m954k+cSfiwY+z7e9INu44PdbctPgh1VOFl/q9vpzuVdd6oq9UuviSLf0ayqzXWr6oSeo+Qz62xrXophr1RI1PyiFJ1pTVxqM9f5ZPbMSe2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978942; c=relaxed/simple;
	bh=XrYfeKnLBUnkn4/5uXU/XFo9ztK8TgBG4IzWC2KokPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NhOC02dPra/8WfWl9hfMgLE5k2Cg1fGxgbEIdV0QUVOWdum1u/V4o3DUUTXgMwluyXrDbJgE13Dnu+saZzYxWjQPlQLk8c/n2pMKZ/pnpUJG016W3XbazVvFmj9VI2VvWqu9fYqwWx1bCOrUCOwx3hNxRVYFrLXeG9/tOi93Xhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQ22H63w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQ22H63w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536E41F000E9;
	Mon, 17 Aug 2026 15:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978940;
	bh=PFteliiihIadT5VDRZwkDugrNPUOiFL36vTzeKdIvzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQ22H63w4jmI4FMbfu8xQ5ZHTABWUT5GWfc/TAqzDuzZvyaVQ9Q5dDab1LILeXNIy
	 UuvVHG0/iN+S6LEuQoaQp5L9zt2ADArouO7dQnz+E6u8tc5sNn3Wrd3AGGbtni0khi
	 bMxviGOMEnq81mJGqND7BB/jCsQWxgee4mzaRiXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?HE=20WEI=20 ?= <skyexpoc@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/609] wifi: cfg80211: bound element ID read when checking non-inheritance
Date: Mon, 17 Aug 2026 15:25:48 +0200
Message-ID: <20260817132545.160602596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ae899e25581d27..1ebe2f3f6f52ac 100644
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



