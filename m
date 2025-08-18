Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2CD1F4192;
	Mon, 18 Aug 2025 13:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523836; cv=none; b=mDPPn/A6NPrnEM+cEQLvaAMnHWqqz51fL95iqTi4Fc/8WH0/qNibzOIKcIkVV44evFg2CEgWlESkpDZt4fgJ/eZaAKTFEL54KyAZ6CmCyqfVw8lmslKXb3GWLLGhAzhrto6IKixBZ7NhqrHrjhK1iauGCQW+NGw1dsBpfWLVVLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523836; c=relaxed/simple;
	bh=Jk7+M5MRyrHLHigBmDCYdsBsCdJD4Tqk0NLvgaZ9QZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJveunUltpJ30j9QrTneU5RSKthuFDabIDkMvvtMTd/AiD9O+T49Vnxhux8EBUoODUhAuIChFXRR/C/AoXTl0qaoiiAZwMyyUMtD/h7dRubjQCDXZ8BXHdgoTTT86GtnJvJBXuhkmjfwcRjggiEfZIIwdi8dNfaxmgq40UxXmqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IEQ+56bU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IEQ+56bU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BE1C4CEEB;
	Mon, 18 Aug 2025 13:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523836;
	bh=Jk7+M5MRyrHLHigBmDCYdsBsCdJD4Tqk0NLvgaZ9QZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IEQ+56bUgE0VTTQAVK87L6mpWx9rHlvgPv6RghnhgvwQo8Vm8HSnOXxgbKhS7oV75
	 9Qv58GdiTkQuHRU34P8yu7L4G8NRcFaD2rBS4k9n47mFEccuK8+WWjAKQA3D8X3yT6
	 8a4xKd2JPwxM1Mt7Nur2Hoh27hz5LuYtOle94OMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>,
	Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 286/515] wifi: mac80211: update radar_required in channel context after channel switch
Date: Mon, 18 Aug 2025 14:44:32 +0200
Message-ID: <20250818124509.428222866@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3aaf5abf1acc..e0fdeaafc489 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1381,6 +1381,7 @@ ieee80211_link_use_reserved_reassign(struct ieee80211_link_data *link)
 		goto out;
 	}
 
+	link->radar_required = link->reserved_radar_required;
 	list_move(&link->assigned_chanctx_list, &new_ctx->assigned_links);
 	rcu_assign_pointer(link_conf->chanctx_conf, &new_ctx->conf);
 
-- 
2.39.5



