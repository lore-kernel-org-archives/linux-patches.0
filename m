Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929D71420B0;
	Tue, 27 Feb 2024 14:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044050; cv=none; b=iPL63+A8tCW0v0hZv129qtAuJfyDIxp4whMV6iG6fxsZo5edHHQe2O21qa14ay77mTiTd+hByo7G226VMmP+IW85CmPoGpHdKRstuC3Gj2E8vfKDF3Gt9QzsK11wGUvAh7Fq+G+x2Jyw2ibcmsF2kpVSiA3d3FzlCWSglLhLXEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044050; c=relaxed/simple;
	bh=pML8lvTB6Jlna/wYbDLyfuNPBP4LwiCqKKbAOkTmZ/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQwEJC1/BFXdUg6mRhnijQ2xBn2X4A/tkC4KKe4TgnkqqETZ5pgsPriYmwS4zr9yYqopR72NVpWmel79B3DjQXDen6TAL3gGNFG9eK395r0g20cLiCLpdtjLpGAfI9nLu0v0BT5NpWAoM/a5tqrBOVsOb4S+g8S0dKKTro1ZMm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWNzpoUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWNzpoUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193D4C433F1;
	Tue, 27 Feb 2024 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044050;
	bh=pML8lvTB6Jlna/wYbDLyfuNPBP4LwiCqKKbAOkTmZ/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWNzpoUP7nr6Vyr05KorjFS3DQPPECGwaUNIXgQVnawhjT32QRQUnGKQf5huhTfW2
	 0gx1aY5xZVHhLOOFfic132B6FXyJwMYDXq9bFyeSerrYFYEYcMQfyaii2d+ezv0lnK
	 IFlTnZMGUPoQJPnS01MH+pN056Hi7KGi84rFs3DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kazior <michal@plume.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/122] wifi: cfg80211: fix missing interfaces when dumping
Date: Tue, 27 Feb 2024 14:26:16 +0100
Message-ID: <20240227131559.205478392@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Kazior <michal@plume.com>

[ Upstream commit a6e4f85d3820d00694ed10f581f4c650445dbcda ]

The nl80211_dump_interface() supports resumption
in case nl80211_send_iface() doesn't have the
resources to complete its work.

The logic would store the progress as iteration
offsets for rdev and wdev loops.

However the logic did not properly handle
resumption for non-last rdev. Assuming a system
with 2 rdevs, with 2 wdevs each, this could
happen:

 dump(cb=[0, 0]):
  if_start=cb[1] (=0)
  send rdev0.wdev0 -> ok
  send rdev0.wdev1 -> yield
  cb[1] = 1

 dump(cb=[0, 1]):
  if_start=cb[1] (=1)
  send rdev0.wdev1 -> ok
  // since if_start=1 the rdev0.wdev0 got skipped
  // through if_idx < if_start
  send rdev1.wdev1 -> ok

The if_start needs to be reset back to 0 upon wdev
loop end.

The problem is actually hard to hit on a desktop,
and even on most routers. The prerequisites for
this manifesting was:
 - more than 1 wiphy
 - a few handful of interfaces
 - dump without rdev or wdev filter

I was seeing this with 4 wiphys 9 interfaces each.
It'd miss 6 interfaces from the last wiphy
reported to userspace.

Signed-off-by: Michal Kazior <michal@plume.com>
Link: https://msgid.link/20240116142340.89678-1-kazikcz@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0ac829c8f1888..279f4977e2eed 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3595,6 +3595,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 			if_idx++;
 		}
 
+		if_start = 0;
 		wp_idx++;
 	}
  out:
-- 
2.43.0



