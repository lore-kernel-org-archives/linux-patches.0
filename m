Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B051208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEyGBvA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46ED8C433C8;
	Tue, 31 Oct 2023 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774609;
	bh=pUyMH+nX0EJKYq24EO24I7mdP3yiSgCVpA82bvklxHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEyGBvA13mJmjTLpAwbCbA8bhceiJFpi01F3ooCqyGAiLBIwCVKWEPTmWzwFEUpnz
	 r1ac0pEjKO3BPWXbo8Y3md0wu8ARN/AE9ThSikf0R1ho88BzZl8CQOC69+QNqK7DSS
	 /2fD6bRgrk5xKNyOaHczytA8R35JZRWUacsTIJtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 068/112] wifi: cfg80211: fix assoc response warning on failed links
Date: Tue, 31 Oct 2023 18:01:09 +0100
Message-ID: <20231031165903.464320035@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c434b2be2d80d236bb090fdb493d4bd5ed589238 ]

The warning here shouldn't be done before we even set the
bss field (or should've used the input data). Move the
assignment before the warning to fix it.

We noticed this now because of Wen's bugfix, where the bug
fixed there had previously hidden this other bug.

Fixes: 53ad07e9823b ("wifi: cfg80211: support reporting failed links")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 3e2c398abddcc..55a1d3633853f 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -43,10 +43,11 @@ void cfg80211_rx_assoc_resp(struct net_device *dev,
 
 	for (link_id = 0; link_id < ARRAY_SIZE(data->links); link_id++) {
 		cr.links[link_id].status = data->links[link_id].status;
+		cr.links[link_id].bss = data->links[link_id].bss;
+
 		WARN_ON_ONCE(cr.links[link_id].status != WLAN_STATUS_SUCCESS &&
 			     (!cr.ap_mld_addr || !cr.links[link_id].bss));
 
-		cr.links[link_id].bss = data->links[link_id].bss;
 		if (!cr.links[link_id].bss)
 			continue;
 		cr.links[link_id].bssid = data->links[link_id].bss->bssid;
-- 
2.42.0



