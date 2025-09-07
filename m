Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B19F14BFA2;
	Sun,  7 Sep 2025 20:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276259; cv=none; b=FyYrQn9JuUrtPa8ABRfG50tSWZ96gW2Y420EOJ4kQa0Iwwfp5HzWMtcNbwXpKlqzXbMZLyNilJfRSy9SfUj9Wg0nwuCX05iC1nCUTzpaGPCmaktNnh+hqXf5TF9JHgzp5HqG7TuoFI+M1vazI1AioQ8oVmdkp8pmf7ckaQO1xEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276259; c=relaxed/simple;
	bh=uKVxe+jY5DOxVajoK4uClqh1YWSZZJtsVWxFG0tjj7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SX0GSbW9i7Tc4pho1ikaC5bVL5zFfqNtlyGlZM+ReJ1Y48eo/wOISiHSHAucdLna6UskX+IoEqaHPuB9UR5xhIQzwY6a6bR9gU1WNSWG7ovgtABpSD2CJU9NkAJ9MGBZS6WsnfWI9B3kQM5wZnVdDLZyFK28cR0MB0R9UPoAhSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovHipu8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovHipu8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119FBC4CEF0;
	Sun,  7 Sep 2025 20:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276259;
	bh=uKVxe+jY5DOxVajoK4uClqh1YWSZZJtsVWxFG0tjj7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovHipu8JVYfV+GH8/kwXOWFAXLsa7QOwDBInwsUlpSEminkk4YevOotLJZdGf6RR0
	 DNDAUBn9IxmxQhd/00+KUQIQWnoF5hQ5FboCjlfqCOdkXaeXtesI+oGINZgVZjfW0F
	 tViH5PuC4qQJgu73nbd72QjkZUhfPli3i2+2Eu4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 047/104] wifi: mwifiex: Initialize the chan_stats array to zero
Date: Sun,  7 Sep 2025 21:58:04 +0200
Message-ID: <20250907195608.914081968@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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
@@ -1486,7 +1486,7 @@ static void mwifiex_uninit_sw(struct mwi
 	wiphy_free(adapter->wiphy);
 	adapter->wiphy = NULL;
 
-	vfree(adapter->chan_stats);
+	kfree(adapter->chan_stats);
 	mwifiex_free_cmd_buffers(adapter);
 }
 


