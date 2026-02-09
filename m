Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCAC37C107;
	Mon,  9 Feb 2026 14:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648455; cv=none; b=aRuELT5ihCyKyeo4NWjguwDCLI5oD9tNdTwA0jQOYYLcCI5ECus3t3huCTbP/9C0wWP46J15leZAclnoHkZvbeJouoFfW8fe5yGt8uQNThcktHol1F5yr8kSudF0mcToTHp8kVcws7xTvSBfgrU+iKJGx9UGEjKRYPKhRwQgE4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648455; c=relaxed/simple;
	bh=xqtYwFq3t0VYfQnsdpeWV/ZjrzYmx1HJ6xK+j32CJ5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOroKSVg9HtnlCbZQnymWUuxxE2YRXBxnFyhBr1qEzEdedVfGPZ7RWFBAyVuavFlxPIjBflslrxt6tH6m+ti3wZL8yvsOnXCAjQ9E68tg5yUpgWWW6WV/1YaV9senIVRvM7Tv86kgp0j4U5eg9/oFWY/i3AVxKXGEtyOn8NV0DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ycamnzco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ycamnzco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA47C16AAE;
	Mon,  9 Feb 2026 14:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648454;
	bh=xqtYwFq3t0VYfQnsdpeWV/ZjrzYmx1HJ6xK+j32CJ5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YcamnzcosNSAppbx9rY43rBcIjrYEUB+5jM3hzbO058l19OsVCq5UYUVZ1IU/Ivgw
	 JPzsnPE/REarRF4DwVzxYZLgQSGm5V5QXDIv69JPyssGVhIUFbBJQO9E2+jx30m8UF
	 +RkNF7czsVtbtDt7tK1EEb/oRq2tlwnPRXH5XZ/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 42/86] wifi: mac80211: collect station statistics earlier when disconnect
Date: Mon,  9 Feb 2026 15:24:05 +0100
Message-ID: <20260209142306.298780892@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit a203dbeeca15a9b924f0d51f510921f4bae96801 ]

In __sta_info_destroy_part2(), station statistics are requested after the
IEEE80211_STA_NONE -> IEEE80211_STA_NOTEXIST transition. This is
problematic because the driver may be unable to handle the request due to
the STA being in the NOTEXIST state (i.e. if the driver destroys the
underlying data when transitioning to NOTEXIST).

Move the statistics collection to before the state transition to avoid
this issue.

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251222-mac80211-move-station-stats-collection-earlier-v1-1-12cd4e42c633@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 64cf5589989bb..9d7d7ee9d7ce2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1477,6 +1477,10 @@ static void __sta_info_destroy_part2(struct sta_info *sta, bool recalc)
 		}
 	}
 
+	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
+	if (sinfo)
+		sta_set_sinfo(sta, sinfo, true);
+
 	if (sta->uploaded) {
 		ret = drv_sta_state(local, sdata, sta, IEEE80211_STA_NONE,
 				    IEEE80211_STA_NOTEXIST);
@@ -1485,9 +1489,6 @@ static void __sta_info_destroy_part2(struct sta_info *sta, bool recalc)
 
 	sta_dbg(sdata, "Removed STA %pM\n", sta->sta.addr);
 
-	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
-	if (sinfo)
-		sta_set_sinfo(sta, sinfo, true);
 	cfg80211_del_sta_sinfo(sdata->dev, sta->sta.addr, sinfo, GFP_KERNEL);
 	kfree(sinfo);
 
-- 
2.51.0



