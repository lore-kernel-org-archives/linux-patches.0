Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C93D4119F8;
	Thu, 30 Jul 2026 14:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423553; cv=none; b=Jnth9d5eO09fhQ6sFrWB0CBTYh7guITpK6rz4cMr0AnuXqsKYgeO9+f2Q0IIZPEEZtkVa3dYpPyFaa0gsjI5Yu/zLdUgwnOPcLEFQzXNkDnMLQQ5zr+ruhDZ6SP7oIimxQJ3ks/l1pBvcMpClFXtL2h9wAV3OG3Ke7PzqrnK5uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423553; c=relaxed/simple;
	bh=i9WAeMla3dDSEMF3SWMHvqMP6nB2lDO4PXHpvLjims0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k+dEt0jgZUqCKQKH/Y+HRx0S5Z0AUdIeDosjOuoivzUifeNKNPjs66jVzVC2j2AATkvlO1LI8vrFy167A6spyUfU2vMc1aq4+TZELlWUVl7bZYYGDMtK8xca7YOzxx3dotyedsdrLoNsPPOxgf6mgswQz+clNpoY88FAAqTa23o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FulDDH8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FulDDH8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8725F1F000E9;
	Thu, 30 Jul 2026 14:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423552;
	bh=DVTZTCayt6e2FXI93dxoNoFIaSIAb0N5TilA3CIx5Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FulDDH8BAQTm6MByoQDIakRztAXIhwQmuYTIk65IpmELUH1o41oLb9u/NBQaE//qF
	 MxgiWNWjAhJhvCQEsmsCXXe4PFk/1+gVOKCIuXCUXMnZFIvtwMzuPcMX4z5DkY9qHu
	 geaPb8+Os7Yr+Z0pmsyeNNNYTPLqHxHv1U995bZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?HE=20WEI=20 ?= <skyexpoc@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/675] wifi: cfg80211: bound element ID read when checking non-inheritance
Date: Thu, 30 Jul 2026 16:06:55 +0200
Message-ID: <20260730141446.939597507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index af1e2ce1628dae..11f7a27bb7046c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -205,7 +205,7 @@ bool cfg80211_is_element_inherited(const struct element *elem,
 		return true;
 
 	if (elem->id == WLAN_EID_EXTENSION) {
-		if (!ext_id_len)
+		if (!ext_id_len || !elem->datalen)
 			return true;
 		loop_len = ext_id_len;
 		list = &non_inherit_elem->data[3 + id_len];
-- 
2.53.0



