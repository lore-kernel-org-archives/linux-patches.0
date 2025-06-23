Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DC93FB1B;
	Mon, 23 Jun 2025 21:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713102; cv=none; b=JadYWqf55IMFK4QYaFHsWSeO68/3O/F3WCzxLe/h81kzVd+P7HOKV9OkKdP7lnVvU6WPNwpXJnZ4ZLWjDf/Fh+y7nQ8R9rpxT8+dYgDsZMuJQ/gOSJKLumY3w7HEnB8UicndlZS5yoz5unZNNpyO312VnPWmGWNnMVNKIrfDVug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713102; c=relaxed/simple;
	bh=3uAXvAgQKAqGN3s6BzAQZLr3PS8Kl1o+0RdognG9RcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQFffcof/DBZwECoITH0KiJYz8HBPdsiuWCVvwTl8mTDjbPgFLAhbpfOdi9teFQTNCXaBKmWiNU+1GrGWrof+99Vs3HXsdqKThS9C/OPy+m4DGL12pa2mahANp6tZFkrIf/F1od63r5Uf/g/5pvYzBGHiBnNyhDzbmFA6crMib0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azp1Iogt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azp1Iogt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE12FC4CEEA;
	Mon, 23 Jun 2025 21:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713101;
	bh=3uAXvAgQKAqGN3s6BzAQZLr3PS8Kl1o+0RdognG9RcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azp1Iogtyn36vm5MKsUNQrRYE2BO1u8CsIWXtQaevssbc94feR6kEFTLrrwg58ac9
	 D32eJoN05lTg7bL348t7boMMfVodl0eZNZzEnaIuhrlzm4I4rUUUhgWPFtEklaiQBz
	 JAsBYtoSdETwdfI17YRSd76zxcRFnf5SpNqnFgiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 328/592] wifi: mac80211: validate SCAN_FLAG_AP in scan request during MLO
Date: Mon, 23 Jun 2025 15:04:46 +0200
Message-ID: <20250623130708.257826972@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>

[ Upstream commit 78a7a126dc5b8e3c5a3d4da9f513e0236d2dc1a3 ]

When an AP interface is already beaconing, a subsequent scan is not allowed
unless the user space explicitly sets the flag NL80211_SCAN_FLAG_AP in the
scan request. If this flag is not set, the scan request will be returned
with the error code -EOPNOTSUPP. However, this restriction currently
applies only to non-ML interfaces. For ML interfaces, scans are allowed
without this flag being explicitly set by the user space which is wrong.
This is because the beaconing check currently uses only the deflink, which
does not get set during MLO.

Hence to fix this, during MLO, use the existing helper
ieee80211_num_beaconing_links() to know if any of the link is beaconing.

Signed-off-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250516-bug_fix_mlo_scan-v2-1-12e59d9110ac@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9f683f838431d..acfde525fad2f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2904,7 +2904,7 @@ static int ieee80211_scan(struct wiphy *wiphy,
 		 * the frames sent while scanning on other channel will be
 		 * lost)
 		 */
-		if (sdata->deflink.u.ap.beacon &&
+		if (ieee80211_num_beaconing_links(sdata) &&
 		    (!(wiphy->features & NL80211_FEATURE_AP_SCAN) ||
 		     !(req->flags & NL80211_SCAN_FLAG_AP)))
 			return -EOPNOTSUPP;
-- 
2.39.5



