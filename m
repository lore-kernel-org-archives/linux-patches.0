Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C681618FC91;
	Tue, 12 Aug 2025 18:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022308; cv=none; b=YYwYh9moFR/kMKoX7Ufb59n/7vA+Iv+wufiI1y4gjNlf50IMdtJ//n6agAlnBqmB5LsL1/cw3uDWKkTZBIhW4MAEkUSIhY4AwmmZP5xorGkNoS1C2o1Eu6X+YWC7dMLSkWCnlzoQewd7NxB8xEWztc06HqeClsq+2ysp9fAlBpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022308; c=relaxed/simple;
	bh=Z22ZfJE8NWQaENfV1ycklTMWvqmxd+IKqZpfoTOoQL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRO+SHJ0/3P4myUV22rbVUfcBB+W3uUqqwo11tG1Pas3IlO3K0Qt0AlVyaXCDm1KAPAIjRt9vQF2Y9uXMJ4Ofxu0zTLBuKicYLAC0dfmAFC+vntxuGn+72dJKMDc+019v1J857DKUIYBn5wLT3QxMPHVAVeOBanAHn1Bt49AWZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAgnQVQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAgnQVQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35442C4CEF0;
	Tue, 12 Aug 2025 18:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022308;
	bh=Z22ZfJE8NWQaENfV1ycklTMWvqmxd+IKqZpfoTOoQL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAgnQVQaPOc0Y2BvgOrQb5feoJ4pCLVxZjgz7f0an1FmCllB3QSCOw1OQ8MZtD6Di
	 P1yDLwrdZB9eh1dYDpZ0OGt/MERk6SVmlvJ7vVBjteNo8cZ0Y8ZoMgLyrM0HzB6Nx3
	 tHkjnFboAvcIqpsPYgQpx117mZgJlHZg2V3b+IRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f73f203f8c9b19037380@syzkaller.appspotmail.com,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/369] wifi: mac80211: reject TDLS operations when station is not associated
Date: Tue, 12 Aug 2025 19:26:55 +0200
Message-ID: <20250812173019.207111608@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index f07b40916485..1cb42c5b9b04 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1421,7 +1421,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
 		return -EOPNOTSUPP;
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION || !sdata->vif.cfg.assoc)
 		return -EINVAL;
 
 	switch (oper) {
-- 
2.39.5



