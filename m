Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC29786331;
	Tue, 12 Aug 2025 17:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020579; cv=none; b=ububMT05norivwAS/jJJo6pZFYKD3re2wXO6kexSiSZnJ+RNxCoNlu3HYXQ45pMCVcW3pjQsWdqW3ycgSBJI9Jy1EDSrX9y+cCU0ZzJCYY29bH9h3opL6lTzGD93EZhk8ELTLkhwIYNmdzDyRsNwlnAjodH37fIdjDI3Bh2NIVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020579; c=relaxed/simple;
	bh=zo0EW7BBWP7q5z/IW3LZGD9MLsIeM8TuMTe7HmYJNdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujeYLfNMRi1HSuK2JFruYshhrkfEIQtyGGiurA86rUrkaAtIl3ZLnS3Pr8VcEEr9enFXLyUcgkdmlbjeVVl2ZSEzJTu2ZJnyyFWtskAI4xQDUnMOG8vcueej8KPvXvt5z0nz3Wj1oVtbT1A/yo3BalLRvvWnMBiJRMWrRrUHTB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfCGpEzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfCGpEzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CBBC4CEF0;
	Tue, 12 Aug 2025 17:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020579;
	bh=zo0EW7BBWP7q5z/IW3LZGD9MLsIeM8TuMTe7HmYJNdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfCGpEzN3c+ScKHBM3mDlT+gB3UnSuzzTpHZOZvmsA0wEB31Dlgin0J+y4NyNc0cL
	 zKFd4cuqoxrRCSzYVG/tUQLSf1uzYvxiIjc+nHLzN4B7ZonHnGsNv9Pkjzm5aANwFY
	 DqQ+x9jDpJnk8wcaE6MHxTkOIEZCGITZVkuLM8hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f73f203f8c9b19037380@syzkaller.appspotmail.com,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/253] wifi: mac80211: reject TDLS operations when station is not associated
Date: Tue, 12 Aug 2025 19:28:29 +0200
Message-ID: <20250812172953.852937911@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moon Hee Lee <moonhee.lee.ca@gmail.com>

[ Upstream commit 16ecdab5446f15a61ec88eb0d23d25d009821db0 ]

syzbot triggered a WARN in ieee80211_tdls_oper() by sending
NL80211_TDLS_ENABLE_LINK immediately after NL80211_CMD_CONNECT,
before association completed and without prior TDLS setup.

This left internal state like sdata->u.mgd.tdls_peer uninitialized,
leading to a WARN_ON() in code paths that assumed it was valid.

Reject the operation early if not in station mode or not associated.

Reported-by: syzbot+f73f203f8c9b19037380@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f73f203f8c9b19037380
Fixes: 81dd2b882241 ("mac80211: move TDLS data to mgd private part")
Tested-by: syzbot+f73f203f8c9b19037380@syzkaller.appspotmail.com
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Link: https://patch.msgid.link/20250715230904.661092-2-moonhee.lee.ca@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index f4b4d25eef95..04531d18fa93 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1351,7 +1351,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
 		return -ENOTSUPP;
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION || !sdata->vif.cfg.assoc)
 		return -EINVAL;
 
 	switch (oper) {
-- 
2.39.5



