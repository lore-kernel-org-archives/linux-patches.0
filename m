Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78B71F09BF;
	Sun,  7 Sep 2025 20:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276629; cv=none; b=PLjqUUr5i4AWtqfayi+f8hVbRLe23hjnxWkz5GTJK7tKfLxpZ5uLdAs0m4Y2bNivNlPVQ0jZkV/5vheBkRxle7xxXHD6+go6/ZEFlS0xYBgk2pLZnUDuXQIq2vbTWY5H+cJ37njwnAaJjeOLsJyReatZ3AK53MTfFlsVKH7rWKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276629; c=relaxed/simple;
	bh=L7joZfE6G/FA9vpuK6tvLKonF409V00UzBeBiMpUeRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNCu3Rq2/kpe2gR7o2t0Lz/p+LgJ6yv8WiCL3aYuq7b0WMcphGyjm9a0Pu0TTsh0KySuRX/3Z1JybHShjCo1TCMu6hfytsISv8Od+jwHNY6U8SjnXLYUWaL/kp9Pk7zQpJlwnwCvMJXdwb/Wj0y48rvr6eHp6EzlKE35jEuTxWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfNqf6+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfNqf6+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE731C4CEF0;
	Sun,  7 Sep 2025 20:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276629;
	bh=L7joZfE6G/FA9vpuK6tvLKonF409V00UzBeBiMpUeRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfNqf6+rtUD2YFKk6MWlikYxxLzD/L48GUv/QoUZUaqivxs/o/Q/n7kbpfJpeQQdQ
	 f0w25PrbzQxGllUql5z4X3Kl3be0EqUQKy23ckT2jRldr1m8yDsiimgOIwWzWlhr28
	 Rd0s02CHpYMeyRDYh2LViY4i9LzHii6LHxhHxkgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 061/121] wifi: mwifiex: Initialize the chan_stats array to zero
Date: Sun,  7 Sep 2025 21:58:17 +0200
Message-ID: <20250907195611.402857970@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

commit 0e20450829ca3c1dbc2db536391537c57a40fe0b upstream.

The adapter->chan_stats[] array is initialized in
mwifiex_init_channel_scan_gap() with vmalloc(), which doesn't zero out
memory.  The array is filled in mwifiex_update_chan_statistics()
and then the user can query the data in mwifiex_cfg80211_dump_survey().

There are two potential issues here.  What if the user calls
mwifiex_cfg80211_dump_survey() before the data has been filled in.
Also the mwifiex_update_chan_statistics() function doesn't necessarily
initialize the whole array.  Since the array was not initialized at
the start that could result in an information leak.

Also this array is pretty small.  It's a maximum of 900 bytes so it's
more appropriate to use kcalloc() instead vmalloc().

Cc: stable@vger.kernel.org
Fixes: bf35443314ac ("mwifiex: channel statistics support for mwifiex")
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20250815023055.477719-1-rongqianfeng@vivo.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |    5 +++--
 drivers/net/wireless/marvell/mwifiex/main.c     |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4316,8 +4316,9 @@ int mwifiex_init_channel_scan_gap(struct
 	 * additional active scan request for hidden SSIDs on passive channels.
 	 */
 	adapter->num_in_chan_stats = 2 * (n_channels_bg + n_channels_a);
-	adapter->chan_stats = vmalloc(array_size(sizeof(*adapter->chan_stats),
-						 adapter->num_in_chan_stats));
+	adapter->chan_stats = kcalloc(adapter->num_in_chan_stats,
+				      sizeof(*adapter->chan_stats),
+				      GFP_KERNEL);
 
 	if (!adapter->chan_stats)
 		return -ENOMEM;
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -664,7 +664,7 @@ static int _mwifiex_fw_dpc(const struct
 	goto done;
 
 err_add_intf:
-	vfree(adapter->chan_stats);
+	kfree(adapter->chan_stats);
 err_init_chan_scan:
 	wiphy_unregister(adapter->wiphy);
 	wiphy_free(adapter->wiphy);
@@ -1481,7 +1481,7 @@ static void mwifiex_uninit_sw(struct mwi
 	wiphy_free(adapter->wiphy);
 	adapter->wiphy = NULL;
 
-	vfree(adapter->chan_stats);
+	kfree(adapter->chan_stats);
 	mwifiex_free_cmd_buffers(adapter);
 }
 


