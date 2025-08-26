Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FB922CBCB;
	Tue, 26 Aug 2025 12:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212902; cv=none; b=HRCNtDFFxKkM5G6P1K44Q0Ik9lPAq6gTf0d9fPatmMKvXiXa7BvqbjFUQtgPScObJZkobym9eJS0FKsMUOgkRWlibduiwd5GJauZQtrR1B8VZHkYq0dANv4Y/Jl4D4LhPcKcM50jPgxLIA4DnTgadRD4QzAdFj44ofqtKYAspaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212902; c=relaxed/simple;
	bh=2vioXI1afoKi7TNIHZWPn7yQK66xPLuenFdEyyuEFA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CW5IGqzsfWCqzmEbQsN6UPbhvJUbI9NL1b8X8gUHK91aaWZOFQeuKswFsD5gTAqy14KG/E+JBNNEpnW7KazIEQBU7S0MJlsScjHNcEMfCY2OrxFSn8J6k+nUkjrO67An+AApRh7u8ot99XVAWLi0p601F8DNAv4dLhW7NelLKZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enx64k54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enx64k54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C2AC4CEF1;
	Tue, 26 Aug 2025 12:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212901;
	bh=2vioXI1afoKi7TNIHZWPn7yQK66xPLuenFdEyyuEFA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enx64k54aY8k0NOiJb+K0SAqBP51SbevPx/oFd+Gv4zzAQFeWsaIWBCpi01alfQta
	 dL5DrPPKUmV6nSydc4zSgCELix+aqU3HM9qLJ1Ax0SafxBdUlyP5jQ2pIMysoqhQO9
	 xyYa8pTkQ9n2LC//iBCBwC+gLnO0oUXXsl+UDez4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/587] wifi: cfg80211: reject HTC bit for management frames
Date: Tue, 26 Aug 2025 13:04:54 +0200
Message-ID: <20250826110956.641092748@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit be06a8c7313943109fa870715356503c4c709cbc ]

Management frames sent by userspace should never have the
order/HTC bit set, reject that. It could also cause some
confusion with the length of the buffer and the header so
the validation might end up wrong.

Link: https://patch.msgid.link/20250718202307.97a0455f0f35.I1805355c7e331352df16611839bc8198c855a33f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 55a1d3633853..3d631f8073f0 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -739,7 +739,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 
 	mgmt = (const struct ieee80211_mgmt *)params->buf;
 
-	if (!ieee80211_is_mgmt(mgmt->frame_control))
+	if (!ieee80211_is_mgmt(mgmt->frame_control) ||
+	    ieee80211_has_order(mgmt->frame_control))
 		return -EINVAL;
 
 	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
-- 
2.39.5



