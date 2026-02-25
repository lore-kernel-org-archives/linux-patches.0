Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3971B276049;
	Wed, 25 Feb 2026 01:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984017; cv=none; b=JYO+Kw0fj9TtCjgMlDq1r4065p8Dyd4zv8F4HQPmppCaNgI/NYQYM8kyBmoxwCOYo40oYLE/sMIX7hpHLEFQo1Z7q4heonPRU4VSrU70E0MTQzI8LCFE7Ki4kyRObxuldw5n6IzaXUZ5h8zHGrxFy8386i5SbWWwdoFPZan5iFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984017; c=relaxed/simple;
	bh=hCYCVyC40oDh1WWcR1yRRN1TCjO8VGv/HdGF1rgd3Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FuQ39bDgLPFpP1tnrHr8qxhg8PJVItxeEwpQpthFWcKHhhUBNERJW3jugCXKp0kPlTWwtC/Bb5rByeIeDU8WuI+VAp21TAGdWtw+IT158z+siw/YM4CrupoZBN84mf5Jty67Gsir1Ue+ni518ePLWV26vhDjvNrAYqQCqbUS148=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgAAapMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgAAapMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7619C116D0;
	Wed, 25 Feb 2026 01:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984017;
	bh=hCYCVyC40oDh1WWcR1yRRN1TCjO8VGv/HdGF1rgd3Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgAAapMgHFRTk4ohbgo5W7CTZ17diow7ztwvU7rA0pnGUAaA3mm8oT0RsvbLSj8xd
	 heYiCivH5Yebbq2anaNd26Y+0wb+q93ZVsGssY4yslHn/nA1pQWfA4cL1G8YGUmggV
	 nO7y8qDmylvDZe5n1y1855wg/eX5WEQQhXsxMV0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Chenming <chenming.huang@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 238/641] wifi: cfg80211: Fix use_for flag update on BSS refresh
Date: Tue, 24 Feb 2026 17:19:24 -0800
Message-ID: <20260225012354.646915577@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Huang Chenming <chenming.huang@oss.qualcomm.com>

[ Upstream commit 4073ea516106e5f98ed0476f89cdede8baa98d37 ]

Userspace may fail to connect to certain BSS that were initially
marked as unusable due to regulatory restrictions (use_for = 0,
e.g., 6 GHz power type mismatch). Even after these restrictions
are removed and the BSS becomes usable, connection attempts still
fail.

The issue occurs in cfg80211_update_known_bss() where the use_for
flag is updated using bitwise AND (&=) instead of direct assignment.
Once a BSS is marked with use_for = 0, the AND operation masks out
any subsequent non-zero values, permanently keeping the flag at 0.
This causes __cfg80211_get_bss(), invoked by nl80211_assoc_bss(), to
fail the check "(bss->pub.use_for & use_for) != use_for", thereby
blocking association.

Replace the bitwise AND operation with direct assignment so the use_for
flag accurately reflects the current BSS state.

Fixes: d02a12b8e4bb ("wifi: cfg80211: add BSS usage reporting")
Signed-off-by: Huang Chenming <chenming.huang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251209025733.2098456-1-chenming.huang@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 90a9187a6b135..9a0c02c23dc56 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1959,7 +1959,7 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 	ether_addr_copy(known->parent_bssid, new->parent_bssid);
 	known->pub.max_bssid_indicator = new->pub.max_bssid_indicator;
 	known->pub.bssid_index = new->pub.bssid_index;
-	known->pub.use_for &= new->pub.use_for;
+	known->pub.use_for = new->pub.use_for;
 	known->pub.cannot_use_reasons = new->pub.cannot_use_reasons;
 	known->bss_source = new->bss_source;
 
-- 
2.51.0



