Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5178425743F;
	Thu, 17 Apr 2025 18:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915792; cv=none; b=s1kfThCaqeNg5VfVMPO9HgjjySs5kOOlqToEXstjYu3p4//CgMj2AQi17JRoEJxMDS+MDC6f46ZwUAbwgz/8dSvPiMpP102MT5fuzPV2HGjxTHaN4g3y+phAgNZR3RNbz5heDxpBYnuMnaDumsubHbKTTDyqwWRDIV1XYffuSgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915792; c=relaxed/simple;
	bh=Eg4KU9kNtBCbLlScM2W+OR1+xdD6jAV7qNnCy/lbbYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOrDKvwG2WGLw3tLDacfJHZsa8kXKt821nFqXXzxPOSzRhJdJyaRYtcz7XFtHuMskru4Jwm6MEVPb61lph4Tkju+P8XZeHYmfdZsvyubRE/1SXj5lAwxwoSHN5lTAb24HP/jnKj/bWZj1t2i0fMbY6gWugDZTeDccB0MMbXwR54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzKrh9Co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzKrh9Co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66B9C4CEE4;
	Thu, 17 Apr 2025 18:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915792;
	bh=Eg4KU9kNtBCbLlScM2W+OR1+xdD6jAV7qNnCy/lbbYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzKrh9CokBbiNUfBgG0p8ntkkuxCdvRh1UHgWdUxIGSmGpphZo/3FcJsuV1qyNkA+
	 KOaEZPdVEKSRxIu30gmBNJrH/MzBQsgMDW8jVv00Mcs92jKJRp5so0hp5S8Da4UUU7
	 hF4hZknIJQ+BwQf6HHllgw4c3fqeDME/tZSBOkr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 241/393] wifi: mac80211: fix integer overflow in hwmp_route_info_get()
Date: Thu, 17 Apr 2025 19:50:50 +0200
Message-ID: <20250417175117.292109363@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

commit d00c0c4105e5ab8a6a13ed23d701cceb285761fa upstream.

Since the new_metric and last_hop_metric variables can reach
the MAX_METRIC(0xffffffff) value, an integer overflow may occur
when multiplying them by 10/9. It can lead to incorrect behavior.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: a8d418d9ac25 ("mac80211: mesh: only switch path when new metric is at least 10% better")
Cc: stable@vger.kernel.org
Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Link: https://patch.msgid.link/20250212082124.4078236-1-Ilia.Gavrilov@infotecs.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mesh_hwmp.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -367,6 +367,12 @@ u32 airtime_link_metric_get(struct ieee8
 	return (u32)result;
 }
 
+/* Check that the first metric is at least 10% better than the second one */
+static bool is_metric_better(u32 x, u32 y)
+{
+	return (x < y) && (x < (y - x / 10));
+}
+
 /**
  * hwmp_route_info_get - Update routing info to originator and transmitter
  *
@@ -458,8 +464,8 @@ static u32 hwmp_route_info_get(struct ie
 				    (mpath->sn == orig_sn &&
 				     (rcu_access_pointer(mpath->next_hop) !=
 						      sta ?
-					      mult_frac(new_metric, 10, 9) :
-					      new_metric) >= mpath->metric)) {
+					      !is_metric_better(new_metric, mpath->metric) :
+					      new_metric >= mpath->metric))) {
 					process = false;
 					fresh_info = false;
 				}
@@ -533,8 +539,8 @@ static u32 hwmp_route_info_get(struct ie
 			if ((mpath->flags & MESH_PATH_FIXED) ||
 			    ((mpath->flags & MESH_PATH_ACTIVE) &&
 			     ((rcu_access_pointer(mpath->next_hop) != sta ?
-				       mult_frac(last_hop_metric, 10, 9) :
-				       last_hop_metric) > mpath->metric)))
+				      !is_metric_better(last_hop_metric, mpath->metric) :
+				       last_hop_metric > mpath->metric))))
 				fresh_info = false;
 		} else {
 			mpath = mesh_path_add(sdata, ta);


