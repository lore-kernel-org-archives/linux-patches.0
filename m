Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9813E1CAA85;
	Tue, 20 May 2025 14:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750582; cv=none; b=eUEWGtLKZQa8MoAIyoR1q2GNDnd9Cu0EgYgJkMUlLBCW1/Upmda3qnA6fRtDynuv1VKxbcdOqUiLWnx/JCOlgCDEv9sfDbKtM6TYYHYuzIWMhRMOwhLC/I4DqndfD9JvarMh2vSpHHQ+Z01zjuJVZEsSxO91y6UpT4w42g6POMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750582; c=relaxed/simple;
	bh=9T18XgCOa56SCPgjYmhXGJRdTE1LObstygaR60NbQaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJT+3lxZQd3JzUvYTvPCSBdHX5HRcMEyB9Yy8C7N72ICq0QKHQ6OCTQsEop2Fv9evhkUuY5fPVPgW+ViqlehY/XkArqwFUAhw4lXKCWn2/abVuQ4s0wB9VMqzVUSYnleiFeQK5eWZcrgTn4/67V4Xdk2hyPONcvfplxs2feJbIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qml4ro5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qml4ro5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A45EC4CEE9;
	Tue, 20 May 2025 14:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750582;
	bh=9T18XgCOa56SCPgjYmhXGJRdTE1LObstygaR60NbQaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qml4ro5EACp0lATsyQV6pDvmArVCURm6O2Xu0LbPJnsFyV06c9vpcC5NB4UrotYBJ
	 8HqMHCClauxicKiKrzQtfnkyokaiu2gyXNTuErW4c7TjqnW89VA/hI0JCipo8SUfe4
	 RAtEq1ERVTvOzedIJT9LDyIyCnZRvej51rk2+500=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4bcdddd48bb6f0be0da1@syzkaller.appspotmail.com,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 056/145] wifi: mac80211: Set n_channels after allocating struct cfg80211_scan_request
Date: Tue, 20 May 2025 15:50:26 +0200
Message-ID: <20250520125812.773361291@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 82bbe02b2500ef0a62053fe2eb84773fe31c5a0a ]

Make sure that n_channels is set after allocating the
struct cfg80211_registered_device::int_scan_req member. Seen with
syzkaller:

UBSAN: array-index-out-of-bounds in net/mac80211/scan.c:1208:5
index 0 is out of range for type 'struct ieee80211_channel *[] __counted_by(n_channels)' (aka 'struct ieee80211_channel *[]')

This was missed in the initial conversions because I failed to locate
the allocation likely due to the "sizeof(void *)" not matching the
"channels" array type.

Reported-by: syzbot+4bcdddd48bb6f0be0da1@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/680fd171.050a0220.2b69d1.045e.GAE@google.com/
Fixes: e3eac9f32ec0 ("wifi: cfg80211: Annotate struct cfg80211_scan_request with __counted_by")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://patch.msgid.link/20250509184641.work.542-kees@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 53e5aee468856..2b6249d75a5d4 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1354,10 +1354,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_MONITOR);
 
 
-	local->int_scan_req = kzalloc(sizeof(*local->int_scan_req) +
-				      sizeof(void *) * channels, GFP_KERNEL);
+	local->int_scan_req = kzalloc(struct_size(local->int_scan_req,
+						  channels, channels),
+				      GFP_KERNEL);
 	if (!local->int_scan_req)
 		return -ENOMEM;
+	local->int_scan_req->n_channels = channels;
 
 	eth_broadcast_addr(local->int_scan_req->bssid);
 
-- 
2.39.5



