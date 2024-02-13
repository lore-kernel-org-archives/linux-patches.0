Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FDD5FBB5;
	Tue, 13 Feb 2024 17:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707844985; cv=none; b=NzpDj9eoYJuXg2rvbyWoVr/7ewJtfGY272/V5oKokZQOF+3UmNM5nfGR70lYIHQxSarm/rDv6iVTvHvqAt0ti4hUbNOHNo3zHxunB0P8kLd8Z8EWxAUD2RjtRd6Yvhm6z+HRk3urS0s2PtCh1YHK05u8LY5n9pxYd0Vqr9si0s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707844985; c=relaxed/simple;
	bh=HJPWn1n7lYRANjowJthzTRVFRCsAVpqjvz14YNC6VQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sngnDRI6rdqbo7k7y8g4GMU6wXryMzyhWsBJ4f92/7dOMnlDy/EHwjf8VFmo2vYk+HmtfjQeUCnCXpc+nfvLx2gJbIhVkRkYDzua4wlARbty6H/+7axw9mYKbhiWLTt0Av9UWwK4vJiQmiu5gmbyDWuNvdGSHkydWVgEL+4l46k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKhiS6zd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKhiS6zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A56AC433F1;
	Tue, 13 Feb 2024 17:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707844984;
	bh=HJPWn1n7lYRANjowJthzTRVFRCsAVpqjvz14YNC6VQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKhiS6zdXVhd4Ln8Tol/hCPzrSY0YItwW6aqjKURQ8KcU27S7CzwDNfVt41fGCcsG
	 FdOJJbCHKahKhcXSrSXl2zjG1/5RvyF+ZXorOaM9W9dCIWyAwCqEDFQznm0eBElquG
	 2j5rfnfwZ8UcUPGduWE32o/jz92UAk2OYBz7Nx+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/64] wifi: mac80211: fix waiting for beacons logic
Date: Tue, 13 Feb 2024 18:21:00 +0100
Message-ID: <20240213171845.175313180@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

[ Upstream commit a0b4f2291319c5d47ecb196b90400814fdcfd126 ]

This should be waiting if we don't have a beacon yet,
but somehow I managed to invert the logic. Fix that.

Fixes: 74e1309acedc ("wifi: mac80211: mlme: look up beacon elems only if needed")
Link: https://msgid.link/20240131164856.922701229546.I239b379e7cee04608e73c016b737a5245e5b23dd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c07645c999f9..c6f0da028a2a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7221,8 +7221,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 		rcu_read_lock();
 		beacon_ies = rcu_dereference(req->bss->beacon_ies);
-
-		if (beacon_ies) {
+		if (!beacon_ies) {
 			/*
 			 * Wait up to one beacon interval ...
 			 * should this be more if we miss one?
-- 
2.43.0



