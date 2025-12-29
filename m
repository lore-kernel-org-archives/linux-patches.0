Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D552E7F03;
	Mon, 29 Dec 2025 16:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024934; cv=none; b=Rw5MckK0JnAnU+x3GNEb4iw8IVb+k6DYpurhU1pVYEl2PZRx1HA6s1c5DAtuc/k3GMYVHcjHJjGejfZizy8FuBt9AnMnCoYAyY0qLqk5IC3Aqcly1TbF6wAkdOKNjiO8BGNxOhaU3V1IqXt/ogAjRIakpCD54n7iXp5q8Ywek+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024934; c=relaxed/simple;
	bh=kRbPnB+tSuZjl5lcwwV7ldMFwzH7WNn9IadGkY5qXcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYcd04TfFTKLqQ3lBlEY4iPRdduaufMQiDzxPeY2AEtFLiF3I6IOMcZQNbmDAGaVHFKK8bST76xMIhJFxA4NG3hUt38QqGmKjA7KeZQ/emlGlLzgtpVthGYDTpdXD6L7pkGio2mT8bMD7+zD7l4bQyuI6wbosH5+2u3bPcsia+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvZPnMG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvZPnMG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAE5C16AAE;
	Mon, 29 Dec 2025 16:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024933;
	bh=kRbPnB+tSuZjl5lcwwV7ldMFwzH7WNn9IadGkY5qXcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvZPnMG7L/BXn5OFaWybA1irRjb6VmWsmA1baO3ZPydBx/cyfPfS7EK2ewfR9+K7u
	 /kQ1gRlpYyo2nPQ6Pe9gpKyeLgfdWPDBZTIJP5kSDesZM72Pi7ZpdnkReI2mo6S54R
	 sHDODyMu4zk3grPbnC9l8QcFEAa1dP6SOXS2XSV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/430] wifi: cfg80211: use cfg80211_leave() in iftype change
Date: Mon, 29 Dec 2025 17:07:18 +0100
Message-ID: <20251229160725.695866168@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7a27b73943a70ee226fa125327101fb18e94701d ]

When changing the interface type, all activity on the interface has
to be stopped first. This was done independent of existing code in
cfg80211_leave(), so didn't handle e.g. background radar detection.
Use cfg80211_leave() to handle it the same way.

Note that cfg80211_leave() behaves slightly differently for IBSS in
wireless extensions, it won't send an event in that case. We could
handle that, but since nl80211 was used to change the type, IBSS is
rare, and wext is already a corner case, it doesn't seem worth it.

Link: https://patch.msgid.link/20251121174021.922ef48ce007.I970c8514252ef8a864a7fbdab9591b71031dee03@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 56724b33af045..4eb028ad16836 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1203,28 +1203,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		dev->ieee80211_ptr->use_4addr = false;
 		rdev_set_qos_map(rdev, dev, NULL);
 
-		switch (otype) {
-		case NL80211_IFTYPE_AP:
-		case NL80211_IFTYPE_P2P_GO:
-			cfg80211_stop_ap(rdev, dev, -1, true);
-			break;
-		case NL80211_IFTYPE_ADHOC:
-			cfg80211_leave_ibss(rdev, dev, false);
-			break;
-		case NL80211_IFTYPE_STATION:
-		case NL80211_IFTYPE_P2P_CLIENT:
-			cfg80211_disconnect(rdev, dev,
-					    WLAN_REASON_DEAUTH_LEAVING, true);
-			break;
-		case NL80211_IFTYPE_MESH_POINT:
-			/* mesh should be handled? */
-			break;
-		case NL80211_IFTYPE_OCB:
-			cfg80211_leave_ocb(rdev, dev);
-			break;
-		default:
-			break;
-		}
+		cfg80211_leave(rdev, dev->ieee80211_ptr);
 
 		cfg80211_process_rdev_events(rdev);
 		cfg80211_mlme_purge_registrations(dev->ieee80211_ptr);
-- 
2.51.0



