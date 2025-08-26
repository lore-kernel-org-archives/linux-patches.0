Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BBF1B87E8;
	Tue, 26 Aug 2025 13:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214485; cv=none; b=bqiEp16RIMi+Lz3N66E9kpB5r7shBCUwI9FhWRQrdJgc12TUfv04C64JckYYVaRUsWiRF2Cql38VB3JZRPi4iM2OkTVLsbAqz1gwKTCTpbsMvJ8FG52mFkMLQCW+Ui2fbKsToFUk8mRX3s+bO8fGN2z8r+Ieo9pqkFL/sRAhRJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214485; c=relaxed/simple;
	bh=j3WlBwmDQRAsUaSvZaH0lEINPVOI6/eckEmY42w19Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7il0FPQ5oyVPkYcA7d2PqfxR248wM2VJJYNJmj6HhKBa7Bn7OAAzD84musd19nYnpIhHU1KzVjR8YjWjlpuvsfEI/HvwUM6y7EkFBMlxd3rs/cKkTJuqzWJfy2vuW9uZL8y76Iv2zQFOgwYAiff259rsfVQ7NLbWliydKBV+8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+jP2UJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+jP2UJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3314C113D0;
	Tue, 26 Aug 2025 13:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214485;
	bh=j3WlBwmDQRAsUaSvZaH0lEINPVOI6/eckEmY42w19Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+jP2UJLXrY5rvhPbrIesLwtTMxTXvV4dKYzWMvSNpN4r4BgUdXI1SFQorjGql/Zc
	 vs2RRNt+cbnxtWxOMX8sHVvhusCT+P58UqAaF99Oq3HBwW0rXRHNVLU4nwFNoklJnO
	 6L7UGwLElaCJINMcPam4Kpz840AlY9bTtTmD1VL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>,
	Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/482] wifi: mac80211: update radar_required in channel context after channel switch
Date: Tue, 26 Aug 2025 13:06:41 +0200
Message-ID: <20250826110934.475741435@linuxfoundation.org>
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

From: Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>

[ Upstream commit 140c6a61d83cbd85adba769b5ef8d61acfa5b392 ]

Currently, when a non-DFS channel is brought up and the bandwidth is
expanded from 80 MHz to 160 MHz, where the primary 80 MHz is non-DFS
and the secondary 80 MHz consists of DFS channels, radar detection
fails if radar occurs in the secondary 80 MHz.

When the channel is switched from 80 MHz to 160 MHz, with the primary
80 MHz being non-DFS and the secondary 80 MHz consisting of DFS
channels, the radar required flag in the channel switch parameters
is set to true. However, when using a reserved channel context,
it is not updated in sdata, which disables radar detection in the
secondary 80 MHz DFS channels.

Update the radar required flag in sdata to fix this issue when using
a reserved channel context.

Signed-off-by: Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>
Signed-off-by: Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250608140324.1687117-1-ramasamy.kaliappan@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f07e34bed8f3..648af67b8ec8 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1308,6 +1308,7 @@ ieee80211_link_use_reserved_reassign(struct ieee80211_link_data *link)
 		goto out;
 	}
 
+	link->radar_required = link->reserved_radar_required;
 	list_move(&link->assigned_chanctx_list, &new_ctx->assigned_links);
 	rcu_assign_pointer(link_conf->chanctx_conf, &new_ctx->conf);
 
-- 
2.39.5



