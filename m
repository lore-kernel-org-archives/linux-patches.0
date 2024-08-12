Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1810E187339;
	Mon, 12 Aug 2024 16:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478836; cv=none; b=n2ZlBO40lzkGZakB7BcgOq5Cb+J6tLrF+G4vUMLJvawbjVyTn7DS50HvYB4Kbv3qiLPqQYUq7CuOw5vPBuEf/LglSj4ufnaw2OHWFJVYZbJtcPil0SfQQl8d+3Bg89FjWwP+rkG1Cgha8/HbjJRaDk9tRkwizXjFHZrFxuPCqZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478836; c=relaxed/simple;
	bh=Uzb73MNEBRtFXFx5f5dW+YWjZjkbEczrCA1J6R7CKpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bu/KuuwsAUeTUqTK/n1UjNiR4Hn94RKkZARISahhmcua7aYKVXf7v+ZOCLhBFB1Op2LOJr+gLkDyyQ9dR7T51AM3ysUmHIaZnP03awJfEnrbBEq66W9y4kyTp01tT4Ga27Vs9mzac7cgRKpuW+wipGpUo3epNxeP2BPnedOSZPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RnRWHm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RnRWHm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9DBC32782;
	Mon, 12 Aug 2024 16:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478835;
	bh=Uzb73MNEBRtFXFx5f5dW+YWjZjkbEczrCA1J6R7CKpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1RnRWHm3kOGe9HzAz3m4SXax1/m3P6ca8t34lSl7V08gFTui8e7KbIDq0Np94OFsz
	 makS3vAefgZeTLpNyAF9hHs4vBUGASkIO8w+aozFH1rI/2GwIUfwrQXsLIL0vGQdIB
	 4hV6R4oYfSLV5MO9AoXpJdtyVXmDpaveRxp+wPaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bc0f5b92cc7091f45fb6@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/150] wifi: nl80211: disallow setting special AP channel widths
Date: Mon, 12 Aug 2024 18:01:45 +0200
Message-ID: <20240812160126.095188800@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 23daf1b4c91db9b26f8425cc7039cf96d22ccbfe ]

Setting the AP channel width is meant for use with the normal
20/40/... MHz channel width progression, and switching around
in S1G or narrow channels isn't supported. Disallow that.

Reported-by: syzbot+bc0f5b92cc7091f45fb6@syzkaller.appspotmail.com
Link: https://msgid.link/20240515141600.d4a9590bfe32.I19a32d60097e81b527eafe6b0924f6c5fbb2dc45@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a00df7b89ca86..603fcd921bd22 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3346,6 +3346,33 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 			if (chandef.chan != cur_chan)
 				return -EBUSY;
 
+			/* only allow this for regular channel widths */
+			switch (wdev->links[link_id].ap.chandef.width) {
+			case NL80211_CHAN_WIDTH_20_NOHT:
+			case NL80211_CHAN_WIDTH_20:
+			case NL80211_CHAN_WIDTH_40:
+			case NL80211_CHAN_WIDTH_80:
+			case NL80211_CHAN_WIDTH_80P80:
+			case NL80211_CHAN_WIDTH_160:
+			case NL80211_CHAN_WIDTH_320:
+				break;
+			default:
+				return -EINVAL;
+			}
+
+			switch (chandef.width) {
+			case NL80211_CHAN_WIDTH_20_NOHT:
+			case NL80211_CHAN_WIDTH_20:
+			case NL80211_CHAN_WIDTH_40:
+			case NL80211_CHAN_WIDTH_80:
+			case NL80211_CHAN_WIDTH_80P80:
+			case NL80211_CHAN_WIDTH_160:
+			case NL80211_CHAN_WIDTH_320:
+				break;
+			default:
+				return -EINVAL;
+			}
+
 			result = rdev_set_ap_chanwidth(rdev, dev, link_id,
 						       &chandef);
 			if (result)
-- 
2.43.0



