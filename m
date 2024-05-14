Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E209440862;
	Tue, 14 May 2024 10:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682999; cv=none; b=Wx1iqTGqRDg+ha3SsU+pSgRDuavU7BY3D0N/Ibjpqp6/ADq2tMpjo1G0baqipvaizsV0/8A3t9+8Q5Ghw0NiviQXbpnAtB+q5XfC0j4ZBZT8LXxLyUyK5Y+VxouQROMP0svwU1GTFG+SRKppEs2s1FdE0UB15tAkCIDhzwQ78xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682999; c=relaxed/simple;
	bh=voGrpGvSs8D1Ssakqjg/TiorZudk6hVBToWASPvyUn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmIDPAaSWnRn0xtETkiFOEGaFa45LgUOo4uig40reDMDHeEaNQoopjDcsiYrXETtiozqzRU0jQSPVhg0GYsR1rY5xigNyasGlw9ZrYmN0EWpU5gWl8vteDmC5dBENwd2kWWqQlhtWGe9+x8Kd95u/rABJM0n9fvcpAA1uONIcwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dG9IFfEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dG9IFfEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B90AC2BD10;
	Tue, 14 May 2024 10:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682998;
	bh=voGrpGvSs8D1Ssakqjg/TiorZudk6hVBToWASPvyUn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dG9IFfEWNat7/3xmtlxgUr6B9YR8Ld7whjbTzTgiwzuW4RLtCvcFfaca4m321d4jz
	 R9nUuIhYiiuE2dpZWO4z1hPDLGfsbvPDC9nNb7r/cK/wY78qBnwjE7wkOCqY44t6lE
	 aAWn5/XlOfwAFesDIkE6Fdl+pO/902qE+n3OBvEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 107/336] wifi: mac80211: fix prep_connection error path
Date: Tue, 14 May 2024 12:15:11 +0200
Message-ID: <20240514101042.644914481@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2e6bd24339a6ff04413b2e49c0f2672d6f0edfa5 ]

If prep_channel fails in prep_connection, the code releases
the deflink's chanctx, which is wrong since we may be using
a different link. It's already wrong to even do that always
though, since we might still have the station. Remove it
only if prep_channel succeeded and later updates fail.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240318184907.2780c1f08c3d.I033c9b15483933088f32a2c0789612a33dd33d82@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 94028b541beba..ac0073c8f96f4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7294,7 +7294,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 			sdata_info(sdata,
 				   "failed to insert STA entry for the AP (error %d)\n",
 				   err);
-			goto out_err;
+			goto out_release_chan;
 		}
 	} else
 		WARN_ON_ONCE(!ether_addr_equal(link->u.mgd.bssid, cbss->bssid));
@@ -7305,8 +7305,9 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 
 	return 0;
 
+out_release_chan:
+	ieee80211_link_release_channel(link);
 out_err:
-	ieee80211_link_release_channel(&sdata->deflink);
 	ieee80211_vif_set_links(sdata, 0, 0);
 	return err;
 }
-- 
2.43.0



