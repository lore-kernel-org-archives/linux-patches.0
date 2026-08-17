Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA233F1AD5;
	Mon, 17 Aug 2026 14:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975557; cv=none; b=F6/sRpBffzKYxjZxWhBOqc5Ty1XM0G4a9Kz4h2KSX6TU1BsjURwCCqLkuE1zLBuB+eqUZ0UcOhky/VUpMvXDhMVDlOCLbR+KYD+8fGgf5RiqrRkHPm3tNaSJ7ekIZrT7gt9QIm/v8GkbkX1htuUgG4oRb56Fv0I5ALztWfCRYkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975557; c=relaxed/simple;
	bh=CC9YD2QnTzMHSGheeO04Nk5W3LCpUMbDqXn7Z17+8nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HZyP5VJ1wDE06noxfJhtapHMAbuACJB4dke2dirBtwElzngBdvdC2VkzVBKPF9pYsNh2iJDxqdMU9hJCobl73DAT2kipOJGHNzWaZMWRQPYbIU9BUc3WQIkHS1eoUlr+/gNnM8KlOZuVo1S3R+Tvl8Dq7hwrar7zUTUcmY8JtIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1wzxNmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1wzxNmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B841F000E9;
	Mon, 17 Aug 2026 14:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975555;
	bh=UTsJeAN3oMEP4Agu87CS/9u8C7MsArDwceYz/sFwo9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o1wzxNmK+aKeucJxYL419qzqtplnqVvaT3yHI4s+D9KIwC5IZwNiI6htafSvaSarS
	 0chUga0lXZTRmnPHMIYEDoW39BTbdLKw/+bCVuNR47B0AHYcguOnKZudkblImAAQph
	 1ZyDZZI+PbxviT5N4V+bgjAe4/ikx+rLi6Oa6Iqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?HE=20WEI=20 ?= <skyexpoc@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/389] wifi: cfg80211: bound element ID read when checking non-inheritance
Date: Mon, 17 Aug 2026 15:27:47 +0200
Message-ID: <20260817132540.039928673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2b64bf73cbcf0a..7d0ddc467232a0 100644
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



