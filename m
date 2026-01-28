Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67124329C56;
	Wed, 28 Jan 2026 15:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615137; cv=none; b=cylUj0Bhxy2FM7JOjUYp3YuqrufsD/7tQs6hTxvxIxUE3+UeZeCnvnM3/1xrLCL6szqYrUYMWnmBJlQVdr3PZM5564KADJOExMf8Jpcs1QT0J6R3iRw8HaBsF7QcQ+8hBRhFIblUeXgMdUnFRxSSkB8Ri+ErqZ4ZigbF4C17RYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615137; c=relaxed/simple;
	bh=DO98rQtHXodAFwi1N13p53O85uuYnG/h9R5/hpq08t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFZTR7k5RaTx6z6JA7u9lQv6v0hCT32sKWSM86i0a3AXcd9+ZUA/F2HkV91WGyJFQExW2wgcTOrRm22GpeSGMsYVrebEIeFbDyIQYtYp/tSHb7d4iVpO847/y4aFsj0rfZX1IL8XV3DwBgngDOwB2in+lF3zcoOfEPeRddbRP4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlVfIEET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlVfIEET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90305C4CEF7;
	Wed, 28 Jan 2026 15:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615137;
	bh=DO98rQtHXodAFwi1N13p53O85uuYnG/h9R5/hpq08t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlVfIEETH8X11xWviirvs7NtAgeRas12zucoYL0TR1UciJ4OHjvvI0g1TSn7KUGnz
	 GOjsEmiB9/1wYyqRvG+pdiUF59VOJ5Iuwo0ib+Sr+gmEvrrAok1L+jaSR/mSqa1js6
	 UfZIndm3yYRQ1A7QjkdORksiqWxsNackuBL3+DHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/169] net: dsa: fix off-by-one in maximum bridge ID determination
Date: Wed, 28 Jan 2026 16:22:53 +0100
Message-ID: <20260128145337.245566250@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit dfca045cd4d0ea07ff4198ba392be3e718acaddc ]

Prior to the blamed commit, the bridge_num range was from
0 to ds->max_num_bridges - 1. After the commit, it is from
1 to ds->max_num_bridges.

So this check:
	if (bridge_num >= max)
		return 0;
must be updated to:
	if (bridge_num > max)
		return 0;

in order to allow the last bridge_num value (==max) to be used.

This is easiest visible when a driver sets ds->max_num_bridges=1.
The observed behaviour is that even the first created bridge triggers
the netlink extack "Range of offloadable bridges exceeded" warning, and
is handled in software rather than being offloaded.

Fixes: 3f9bb0301d50 ("net: dsa: make dp->bridge_num one-based")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20260120211039.3228999-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 97599e0d5a1d0..76a086e846c45 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -157,7 +157,7 @@ unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
 		bridge_num = find_next_zero_bit(&dsa_fwd_offloading_bridges,
 						DSA_MAX_NUM_OFFLOADING_BRIDGES,
 						1);
-		if (bridge_num >= max)
+		if (bridge_num > max)
 			return 0;
 
 		set_bit(bridge_num, &dsa_fwd_offloading_bridges);
-- 
2.51.0



