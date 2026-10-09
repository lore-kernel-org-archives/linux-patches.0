Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D363B582F;
	Fri,  9 Oct 2026 14:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556668; cv=none; b=FH/xJ3bjwNdUiBS/lAIGrpiscvb05Gi3JspwlckbuVeGfgdV2qALxfJkye1v3AwkQ3dXFZF/ZoGont3u6FXync9YlZsU8k5O3kOc3bRRZCTjCLcTRez9j/+sUXtREgbJeyGymEajF12e97canWFLvc1p1yC3cZqih46Xv5I/TGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556668; c=relaxed/simple;
	bh=JCgv3pbe12IrohJqQ9+A34pg7j+6k/qkGXmeMgY6BJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ek4lp78tQgpzfNPofx7F/rjL530meenk1NX4KkmG86F3av2U917xLQhhWU7fqWHCCeUA3TXRY6RiRhoFTOzi4BB6/W/VAFHQjHQ6Hx4HNyKugKY1JhikfbLDt+SAAKiTpOf4ywlNF1JEyI54/e0HRGPO+NjnV/rOwflU0FSRMkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gc9+IxZp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gc9+IxZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B951F000FF;
	Fri,  9 Oct 2026 14:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556667;
	bh=e+7kP7MHFkjB/pOv2DzM37HHGXtbzAwra6PSquBDfmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gc9+IxZpEl9R85l3rtN+cIfd5jHwtaXU/eDSA7BgAhtFM3Ra3cQBc4mK+UTmBDHZC
	 mvF0fOpLx2LTKv1IBHr+fKqQJcggsDwYkQEeAS/oh7wkP5dfENYkMXHJSMb0BRLTOf
	 FiLPuJb2+yAA+SS3qRA0NHsyT8E9BPEnO7by3hJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Ruide Cao <caoruide123@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 272/403] wifi: mac80211: reject invalid 320 MHz CSA bandwidth
Date: Fri,  9 Oct 2026 16:10:33 +0200
Message-ID: <20261009140958.547372743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Ruide Cao <caoruide123@gmail.com>

commit 56e236759f0a8dc910c2ae7cd3c161f298ee5794 upstream.

The HT/VHT channel definition validator can receive a 320 MHz
bandwidth indication from a received CSA frame on a non-6 GHz link.
It warns for this unsupported width but continues with an uninitialized
vht_operation.chan_width, which is then read by
ieee80211_chandef_vht_oper(). With panic_on_warn enabled, this lets a
received frame panic the kernel.

Reject the channel definition before entering the VHT operation
conversion. This preserves the existing CSA fallback while avoiding
both the warning and the uninitialized read.

Fixes: 21c3f8f95554 ("wifi: mac80211: refactor STA CSA parsing flows")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Link: https://patch.msgid.link/bd68e360e06135c750397cb6be003a01a834a179.1787222001.git.vega.cover-letter@nebusec.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/spectmgmt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -111,8 +111,8 @@ validate_chandef_by_ht_vht_oper(struct i
 
 	switch (chan_width) {
 	case NL80211_CHAN_WIDTH_320:
-		WARN_ON(1);
-		break;
+		chandef->chan = NULL;
+		return;
 	case NL80211_CHAN_WIDTH_160:
 		vht_oper.chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
 		vht_oper.center_freq_seg1_idx = vht_oper.center_freq_seg0_idx;


