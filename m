Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D8B41C2E7;
	Wed,  4 Feb 2026 14:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217077; cv=none; b=UoW9/ZFzvQFHAocN/g9K1iA0YxHwLTNgZWQMlTOHcL6159IqQY4pZVsJqL05RJypT45tdxyzwEIknJ/Nl5aDXc5FYzPmTD7kH72NjOvwFlFeIxEnqJj6LZlztSGQiHPm1/qTV6hr6UMlNhCMi1nwLtzImlKJby3s9ZTyurfLwnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217077; c=relaxed/simple;
	bh=BiUpwFIv6xnex3N189Hz7fteiN7tF5jbCc3eJEhWI6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKMLGxwKO8LrBaChiaO/wzUli8U4zNM8nIo3QBBpraSvO6B2jwVSRqi+snnObsKDbu7PUZA2u/kSY+ELpVjpVAbOxRB22scAiCaj1ZMZENXGoOL/o01hbaUwC7CRaNYjUiQOvjF5sbZkF6aXhCgJTzsp8VxVWQqBlxYxp0OdPOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKo1Poka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKo1Poka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258A6C4CEF7;
	Wed,  4 Feb 2026 14:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217076;
	bh=BiUpwFIv6xnex3N189Hz7fteiN7tF5jbCc3eJEhWI6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKo1PokaanTgoC5qAY0tnWIHJLcjO7Eq0eznu33Zk0V1DAzRGt4Z/SaOJ8QCh/f0C
	 /I2lRaGZiW4LIShzlTq0xiPPzUslkD2+Pelmpuk/ZKS83ZBUrqVBF++VA+vv0y0GhB
	 fwR5kmDbfi0D1yeny5kbOhGgiScZhWQCHHb6qfu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 116/206] wifi: rsi: Fix memory corruption due to not set vif driver data size
Date: Wed,  4 Feb 2026 15:39:07 +0100
Message-ID: <20260204143902.380377456@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

commit 4f431d88ea8093afc7ba55edf4652978c5a68f33 upstream.

The struct ieee80211_vif contains trailing space for vif driver data,
when struct ieee80211_vif is allocated, the total memory size that is
allocated is sizeof(struct ieee80211_vif) + size of vif driver data.
The size of vif driver data is set by each WiFi driver as needed.

The RSI911x driver does not set vif driver data size, no trailing space
for vif driver data is therefore allocated past struct ieee80211_vif .
The RSI911x driver does however use the vif driver data to store its
vif driver data structure "struct vif_priv". An access to vif->drv_priv
leads to access out of struct ieee80211_vif bounds and corruption of
some memory.

In case of the failure observed locally, rsi_mac80211_add_interface()
would write struct vif_priv *vif_info = (struct vif_priv *)vif->drv_priv;
vif_info->vap_id = vap_idx. This write corrupts struct fq_tin member
struct list_head new_flows . The flow = list_first_entry(head, struct
fq_flow, flowchain); in fq_tin_reset() then reports non-NULL bogus
address, which when accessed causes a crash.

The trigger is very simple, boot the machine with init=/bin/sh , mount
devtmpfs, sysfs, procfs, and then do "ip link set wlan0 up", "sleep 1",
"ip link set wlan0 down" and the crash occurs.

Fix this by setting the correct size of vif driver data, which is the
size of "struct vif_priv", so that memory is allocated and the driver
can store its driver data in it, instead of corrupting memory around
it.

Cc: stable@vger.kernel.org
Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260109235817.150330-1-marex@nabladev.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -2022,6 +2022,7 @@ int rsi_mac80211_attach(struct rsi_commo
 
 	hw->queues = MAX_HW_QUEUES;
 	hw->extra_tx_headroom = RSI_NEEDED_HEADROOM;
+	hw->vif_data_size = sizeof(struct vif_priv);
 
 	hw->max_rates = 1;
 	hw->max_rate_tries = MAX_RETRIES;


