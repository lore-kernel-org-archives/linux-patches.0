Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD4B2BE643;
	Tue, 26 Aug 2025 13:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214453; cv=none; b=e7pygR8r7ZRedldNaPDQQfLajfhMoAYRbPwBIUu//wJXiR1IPSZbC7xRZ10itWfPu7tfOfeZwfVivqO+ESeBebw2hfeqMmhUBqXcbQ5oZJPKdlosJai+I5aZXZ20D7dFACycgBF+rLPfLLBBuUUE41qrXIYRGjg6K8wsnnIfe+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214453; c=relaxed/simple;
	bh=lWLj21lEnzFfo7t6GBlour637Hm7HCSmjpPvhj9TX5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKqtYJMjXquSg6nKW/6iOPh21h7sP4PFGmFI+D72RhPIKBu4WmWLJfG7FGugX0AjLtbmepK6rSryBh8qx0OBmMPo3WPs1LI6RiiO8XP0Tu+JPOq6oTMv/2/wn3uaYVdd1HfgX3fub4PzYYu2qykU+UzLS93gG7tOEyxUpbs/DMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JB/IpiAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JB/IpiAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599FEC4CEF1;
	Tue, 26 Aug 2025 13:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214453;
	bh=lWLj21lEnzFfo7t6GBlour637Hm7HCSmjpPvhj9TX5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JB/IpiACpyF3z9N4IJhrWRnkjedcMlDqSqxITB7/7bz9MiqYeYGWSvRuD9wtxH+Lq
	 24jL+eCr7oxu8ExKKFq7XykgK/OJIHeAoSAFkv6f/BpRp+On5ombEPim9oTHhcT5a1
	 LGvnKmGH0bET0DCP4H5iaANVMVWG3cVfJJUp3Igw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/482] wifi: cfg80211: reject HTC bit for management frames
Date: Tue, 26 Aug 2025 13:06:09 +0200
Message-ID: <20250826110933.690669628@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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
index e7fa0608341d..e0246ed9f66f 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -700,7 +700,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 
 	mgmt = (const struct ieee80211_mgmt *)params->buf;
 
-	if (!ieee80211_is_mgmt(mgmt->frame_control))
+	if (!ieee80211_is_mgmt(mgmt->frame_control) ||
+	    ieee80211_has_order(mgmt->frame_control))
 		return -EINVAL;
 
 	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
-- 
2.39.5



