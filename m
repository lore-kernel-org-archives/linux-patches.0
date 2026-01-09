Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C19335097;
	Fri,  9 Jan 2026 12:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963226; cv=none; b=C/3vyw1gf4HC3vF1udKgPQckC8qvyhpPuK9l2oj+ek/qtqsUuH7oHeUIvfKTbHLxbbNzD1n1n7PvPPLFvpdcXrhLTn7qp+KEvMZdx/bsBj+vjUE757OyfnmwZ4CG6qNOLaXxuC9iYwnF4BPX79A7eTBDeta2DJAp6mqususE7+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963226; c=relaxed/simple;
	bh=UgOh7JflFCJYsKSyp6Z3ciH3Jzg9AbhyoHJuHcBGaAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmgzFDx3l/2jebk9OUHWKwyeQYk1iV8UgD9sPwcFZgCpAmcPXMlLcG2L6XlClMAoVoKHIqs4lEBLtlZiPPRWmySQoNyhmDH1dHhofGhB6OUMgJa5hdSirdkzw09Lt4tOLYKijRR1cQ6GJ8ZhLsYBX+kVHTUMYu9YW3L/YTjtgEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZQefTyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZQefTyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EBBC19421;
	Fri,  9 Jan 2026 12:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963226;
	bh=UgOh7JflFCJYsKSyp6Z3ciH3Jzg9AbhyoHJuHcBGaAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZQefTyU2A5IlR07EfGRnjRQdeG1FsPXygvM06cgbRVtN9I9VlNnVwrXoKEySdgWn
	 yY+FMQ8WIrN5I/fPpQ2aS+uiieRtaNBRyRpBdsySl8TGzIzVm6HnHAXoxByFviXIq+
	 4uek1tnKtQ5A3a7Oqa4WoVm+XU+W+EFKRQlCOGrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <quic_adisi@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 634/634] wifi: mac80211: fix switch count in EMA beacons
Date: Fri,  9 Jan 2026 12:45:12 +0100
Message-ID: <20260109112141.490486847@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <quic_adisi@quicinc.com>

commit 1afa18e9e72396d1e1aedd6dbb34681f2413316b upstream.

Currently, whenever an EMA beacon is formed, due to is_template
argument being false from the caller, the switch count is always
decremented once which is wrong.

Also if switch count is equal to profile periodicity, this makes
the switch count to reach till zero which triggers a WARN_ON_ONCE.

[  261.593915] CPU: 1 PID: 800 Comm: kworker/u8:3 Not tainted 5.4.213 #0
[  261.616143] Hardware name: Qualcomm Technologies, Inc. IPQ9574
[  261.622666] Workqueue: phy0 ath12k_get_link_bss_conf [ath12k]
[  261.629771] pstate: 60400005 (nZCv daif +PAN -UAO)
[  261.635595] pc : ieee80211_next_txq+0x1ac/0x1b8 [mac80211]
[  261.640282] lr : ieee80211_beacon_update_cntdwn+0x64/0xb4 [mac80211]
[...]
[  261.729683] Call trace:
[  261.734986]  ieee80211_next_txq+0x1ac/0x1b8 [mac80211]
[  261.737156]  ieee80211_beacon_cntdwn_is_complete+0xa28/0x1194 [mac80211]
[  261.742365]  ieee80211_beacon_cntdwn_is_complete+0xef4/0x1194 [mac80211]
[  261.749224]  ieee80211_beacon_get_template_ema_list+0x38/0x5c [mac80211]
[  261.755908]  ath12k_get_link_bss_conf+0xf8/0x33b4 [ath12k]
[  261.762590]  ath12k_get_link_bss_conf+0x390/0x33b4 [ath12k]
[  261.767881]  process_one_work+0x194/0x270
[  261.773346]  worker_thread+0x200/0x314
[  261.777514]  kthread+0x140/0x150
[  261.781158]  ret_from_fork+0x10/0x18

Fix this issue by making the is_template argument as true when fetching
the EMA beacons.

Fixes: bd54f3c29077 ("wifi: mac80211: generate EMA beacons in AP mode")
Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Link: https://lore.kernel.org/r/20230531062012.4537-1-quic_adisi@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5456,7 +5456,7 @@ ieee80211_beacon_get_template_ema_list(s
 {
 	struct ieee80211_ema_beacons *ema_beacons = NULL;
 
-	WARN_ON(__ieee80211_beacon_get(hw, vif, NULL, false, link_id, 0,
+	WARN_ON(__ieee80211_beacon_get(hw, vif, NULL, true, link_id, 0,
 				       &ema_beacons));
 
 	return ema_beacons;


