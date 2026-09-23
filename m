Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF3D306D2A;
	Wed, 23 Sep 2026 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172811; cv=none; b=hcB2LYjm0TMca8mQFieUcdIni4Dfy5Flqm2X75jGreeAFU0bPlbVtAA2qE5MgYQHmQ1bXEabXvDWKzZgJhoUj+462DW0aoofYx8kyx23swSwyQrt5pIle0Pbr/TpGmTPPVGTOXDFyYB3pcnyz2ta5mZnFt7wnwup0zIR2VnJIxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172811; c=relaxed/simple;
	bh=4k6wichMMKGON9Od6UyanH6Swq/r383fpCYd1giNaM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6LOm6YVxz5OgExFVm2AEfLLPdW5axnY5nfoFDs1sFhGIHaNRdS1daulq+xrnw3v2DvV4aigFmy9Bv9xc3CBf0NvbIDAtROtUrqQ8JbV3z7LYapGLbhEH0wx0t8SSvr7UMGoX8kIzIJUL4sn/x16gIlJC5L0U1aDR+vr+VkiNxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N480vg2O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N480vg2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5601F000FF;
	Wed, 23 Sep 2026 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172810;
	bh=2WwPjBtcd6JtXdp8qxQ+SqEnqYmB2cxyN4rGC/nyIs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N480vg2ODr2OYtOQ4pkCw6tTwgEiwA49W0GOKsLbhzAdr7yA6UkjoE8ZTVvRwLRmo
	 zV1Uk9K16vQiVA24fe5UujAVpbJX8y9Op+kHhweetvFRQcIlIO0SMczPtq/iQXVty0
	 h3jRwjG4gjTFlTREgvroYaVaxIPg2uQZTuA9j5Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 068/438] wifi: cfg80211: fix NAN regulatory enforcement
Date: Wed, 23 Sep 2026 16:01:29 +0200
Message-ID: <20260923140646.551744092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 17a5f8571d1d40c88b78cfc154a7da0d60f13f37 ]

reg_wdev_chan_valid() returns early for any wdev that has no netdev,
which is fine for P2P originally (and later PD still), but NAN has
no netdev and yet enforcement code was added and is needed, but is
dead code right now.

Use wdev_running() instead so that netdev-less wdevs aren't skipped.
P2P/PD don't do anything in the later switch, but NAN code can now
be reached.

Assisted-by: LLM
Fixes: 0e8ec738a71e ("wifi: cfg80211: add support for NAN data interface")
Link: https://patch.msgid.link/20260904165614.6abc075b5401.Ib90696e3fa49b1698c27d64db5360d51f6f187a9@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1e8214d6b6d88..3454afa038bf7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2345,7 +2345,7 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 	iftype = wdev->iftype;
 
 	/* make sure the interface is active */
-	if (!wdev->netdev || !netif_running(wdev->netdev))
+	if (!wdev_running(wdev))
 		return true;
 
 	/* NAN doesn't have links, handle it separately */
-- 
2.53.0



