Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956AF2505D7;
	Tue, 20 May 2025 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750168; cv=none; b=J0V4KwanUyEo3zz8+udHQN6Qqau1adWF8b4Ftzhy/n7fudMk+Cs04a7p7IxAIO3eRefc86oZbNXaLr67SHCjIK0zS1GrIA0ckgISmgnRV81X50f2w8oXYhSuFH5usDJCoe8gUUoMsNb0Ln1BzIKMlAH+xhF0CFeb0IxnxKawtX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750168; c=relaxed/simple;
	bh=9HrgRlUpAUStfa+TVyPXW5oUdBnGurdbH8ltom8FrMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S15hXdd9424fmLAYQvpuIrhKBTvpcqBF0jhkp7gGP2ROXa77DeAfe1/xMf1zoOXkwZECpXEFLBcbGLy4f/wrghfd1hNc3zYO2GuMrMBN7D9/G6NMKzihfnDy/tQ6Rwa9wssDiagLljpwOfHTMWW3VjiAro7rCNrP6RYVjhkPF7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ufkf1QQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ufkf1QQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F158C4CEEA;
	Tue, 20 May 2025 14:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750168;
	bh=9HrgRlUpAUStfa+TVyPXW5oUdBnGurdbH8ltom8FrMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ufkf1QQ2UImh/P7qE0vf6HVcIttvIdB7zQONfCNwOACIFi3QJPqtJMa3s4WKY3TrH
	 PFyVPrJeYizpj4PMxjIMU/L0NY8azPCQgqkbNzURKT7zcT93kus0lJ1TwNZQfvCq3d
	 LyAsYShAGP9Uws5MdS0uSvgrwOBL36ByKOCwqKRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4bcdddd48bb6f0be0da1@syzkaller.appspotmail.com,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/143] wifi: mac80211: Set n_channels after allocating struct cfg80211_scan_request
Date: Tue, 20 May 2025 15:50:19 +0200
Message-ID: <20250520125812.581204208@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ee1211a213d70..caedc939eea19 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1344,10 +1344,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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



