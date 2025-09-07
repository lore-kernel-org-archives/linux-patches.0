Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD8A1ACEDA;
	Sun,  7 Sep 2025 20:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277018; cv=none; b=PJUg0PAx1Wtn+YTjn5xbeAl9vswZSleLpuGJozHBasDooZmud9s4tubZ0JFHXg9zmxXSN6RvaS7nGwEypvfpv7Gf/F8tOkD/3H1pBgMz8UR6DEl/JW/uL4E6dxWcHotRx7L2RNWhx9AjdSVz0gdMOqymk9PaLudE9DLi3t2xXKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277018; c=relaxed/simple;
	bh=oavXCFxGoOAGnxN3IQaz0qyu3QJi0L8c9RIrxGWtCr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seHehXFxWhxkIHN0PNMHkZGmDI83GCq9DYz4UPPvvujZiO074ThWRq8rMfyvu4CX/dupe+uViTC17Or3R06wbS+fhsXV/nZjhObXRRqkdxo9vNvAf7HTMqtV4HzWpwoSXFATLwit6nTPEhmbBkGPGeWaVwIQKt8ylYUWarlDJVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmil7Z0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmil7Z0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA17C4CEF0;
	Sun,  7 Sep 2025 20:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277018;
	bh=oavXCFxGoOAGnxN3IQaz0qyu3QJi0L8c9RIrxGWtCr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmil7Z0Ey9CGJ65Z0rJcdnPo/jBjZnYjG9yXRHLtMzeCB+jvqWKsmkFD3xvJ3jvmU
	 6OxpipxpcwPTR2fNgtIwg9vc+A4nbUGulSwiRQQo+6SfnqRlHPr8ExLqxFp0tOFfHe
	 2diuS+3CJAoeufDKXX8va/lSgcLgOCxk3w7MjO3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+30754ca335e6fb7e3092@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/175] wifi: cfg80211: fix use-after-free in cmp_bss()
Date: Sun,  7 Sep 2025 21:57:08 +0200
Message-ID: <20250907195615.643123813@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 26e84445f02ce6b2fe5f3e0e28ff7add77f35e08 ]

Following bss_free() quirk introduced in commit 776b3580178f
("cfg80211: track hidden SSID networks properly"), adjust
cfg80211_update_known_bss() to free the last beacon frame
elements only if they're not shared via the corresponding
'hidden_beacon_bss' pointer.

Reported-by: syzbot+30754ca335e6fb7e3092@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=30754ca335e6fb7e3092
Fixes: 3ab8227d3e7d ("cfg80211: refactor cfg80211_bss_update")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20250813135236.799384-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d80ab1725f28d..f00ccc6d803be 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1868,7 +1868,8 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 			 */
 
 			f = rcu_access_pointer(new->pub.beacon_ies);
-			kfree_rcu((struct cfg80211_bss_ies *)f, rcu_head);
+			if (!new->pub.hidden_beacon_bss)
+				kfree_rcu((struct cfg80211_bss_ies *)f, rcu_head);
 			return false;
 		}
 
-- 
2.50.1



