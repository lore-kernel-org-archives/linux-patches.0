Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9509A196447;
	Thu,  6 Jun 2024 14:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683157; cv=none; b=jJeio9hSE5vtRO+vzoJglU/KViBhVNVa3KZSvD5nmARGTSX+WVdjoi2rlrUkjIgYVE5lxwRZrboOtDneGc2L20x18h0qSny3mc3LNJCmMdH0F783neFPKVioa55104vwujxGRicNzmMqBRuuD+DvETbXw8HpZeuueXPcm24X0EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683157; c=relaxed/simple;
	bh=xb6Zsuy4lxG4DTGDbOksy+qy8fEBtVcVTt2lWP+54Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbDkZNlVCS9OMdFt9aWQqXwITM7ogyE4Bxoo5GpWI/9YTbTaXazkldOp1gfUaQveBxK29LiAoIcZwxti2P0FJkY7UGZ13xk/Im0rq9k7vDbmPCKglNu8Qbzx7AC4tj6COuliXmDkj7sTYb0mj3GOwsQL+SPyFJ3w6VeRPmlJVpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AU8KHwD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AU8KHwD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA4EC2BD10;
	Thu,  6 Jun 2024 14:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683157;
	bh=xb6Zsuy4lxG4DTGDbOksy+qy8fEBtVcVTt2lWP+54Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AU8KHwD2u1d8wzAda5Fc0A98faF407BrCC0t+1Fv6x36Q3KvDRWCCwpxA6WXYXNy1
	 Vy5KtuiGeEhhgU2wt/BIFLLSpSbNHwo04U0+P6vtkc8lkoHKVmjfLPnpToEoMAn+yC
	 AovrG8Mdr8b9uifqg0VGc1u+0TUACgUMkBPjFKHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Kinder <richard.kinder@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/473] wifi: mac80211: ensure beacon is non-S1G prior to extracting the beacon timestamp field
Date: Thu,  6 Jun 2024 15:59:17 +0200
Message-ID: <20240606131700.803215052@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Kinder <richard.kinder@gmail.com>

[ Upstream commit d12b9779cc9ba29d65fbfc728eb8a037871dd331 ]

Logic inside ieee80211_rx_mgmt_beacon accesses the
mgmt->u.beacon.timestamp field without first checking whether the beacon
received is non-S1G format.

Fix the problem by checking the beacon is non-S1G format to avoid access
of the mgmt->u.beacon.timestamp field.

Signed-off-by: Richard Kinder <richard.kinder@gmail.com>
Link: https://msgid.link/20240328005725.85355-1-richard.kinder@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f25dc6931a5b1..9a5530ca2f6b2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5528,7 +5528,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 			link->u.mgd.dtim_period = elems->dtim_period;
 		link->u.mgd.have_beacon = true;
 		ifmgd->assoc_data->need_beacon = false;
-		if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY)) {
+		if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY) &&
+		    !ieee80211_is_s1g_beacon(hdr->frame_control)) {
 			link->conf->sync_tsf =
 				le64_to_cpu(mgmt->u.beacon.timestamp);
 			link->conf->sync_device_ts =
-- 
2.43.0



