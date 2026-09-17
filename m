Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3CC3DDAF6;
	Thu, 17 Sep 2026 17:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667481; cv=none; b=GiJGc/mSDvI2GzdhjNT035FspyGhz69tuS8GURtL8W6myQIrypyBiyOEPRXvq/VjUZjK6zxFPge6QRBOpgyco44w99KK1aqpgUHDIo0S84T7hC4CPsdvako5YsApihOMQJXIKvnhBGe8wK+C7kBfG8E8Nmwh0fuF6uBXVSN9BAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667481; c=relaxed/simple;
	bh=SAp8fAZGuI5M/0lTXqgOl88a1gXSSBrbFMc0hN3ixCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnFBH1uaGLsxzC4AzPIrFl2A+JitMe81y8p/UMHRcmPhOMtHgjxoM67uzUrD+5Tu5c3ZsY6yRUkatupO3B5YznMeASubFAbMYc9b4E2UmXIiCbuwFSt5Lonwmb7ilSzRGoYt2XAHR4v08RjqAwCOt/wK4BMuMIBp3p9ISVjFyBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZJQdw3z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZJQdw3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3B61F000FF;
	Thu, 17 Sep 2026 17:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667479;
	bh=WgjEfBC1+L7T7OBbpAofwz92Y9deqLbRuGfC2USrW8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZJQdw3zGoaIKXMmhngcfbC5NsQBbmz7nqHdZzvN7MgjLi2BUYuihxf5aVDvhjFEL
	 BO+xvJkwrfV1iLYIwNJA82vUB/vW/G+H934t5dgdgtaD0FOT9E1Cp+zxaOWZC9lVtT
	 RvLdpu+mjE5BOC/p8Fx7ivcv+0wzGC6m5T4yC0/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0107/1102] thunderbolt: Improve multi-display DisplayPort tunnel allocation
Date: Thu, 17 Sep 2026 16:00:50 +0100
Message-ID: <20260917151542.186301568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit afe9021d63b46233f5c87d52b820fa26e7f562cd ]

When 3 monitors are connected through Thunderbolt dock to the system at
once, one of the monitors might fail to establish DisplayPort tunnel.
This happens during DP bandwidth negotiation - each monitor takes
maximum bandwidth that is supported and there might not be enough for
3rd display. In this case Thunderbolt driver drops DP tunnel and
'forgets' about it but with DP bandwidth allocation mode, that comes in
later, some bandwidth might be freed.

Make Thunderbolt driver check again if DP tunnel can be established
after DP bandwidth consumption changed.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 1ea020dafeb81..a48e97e42ce79 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -2747,6 +2747,9 @@ static void tb_handle_dp_bandwidth_request(struct work_struct *work)
 
 		/* Update other clients about the allocation change */
 		tb_recalc_estimated_bandwidth(tb);
+
+		tb_dbg(tb, "checking if more DP tunnels can be established now\n");
+		tb_tunnel_dp(tb);
 	}
 
 put_sw:
-- 
2.53.0



