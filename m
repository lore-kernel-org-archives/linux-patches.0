Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E021DE3B8;
	Wed,  6 Nov 2024 12:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894886; cv=none; b=fz0AgrKJD+Gwo1HbKnCatzVYe3EUkaxvJaxbbYBQIBGO1kaDpAd/usadc0VQTM6Bh+ICw6Be8DH58PrwAQlXWy6YKo3gESQeEIJu58EE6xYshkA+xSVdrwK46BSvvkeWtEKpMguhP/V77qH+KqrHWRZiR6uu8J4VHKIICZY7ZDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894886; c=relaxed/simple;
	bh=bCtFF9KB0IJOS/sIJdEJIQYUcT416mFGU7TIODj/DwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4gNIgIEXmO5SzjQ31dD2SLwELVHUiGREWQysqROzza4G27VIrSuskFBXW2w/JJgHZlBrlq2mr+OxT9bmN3nfx+/VisZ4zNakl42d+vR/G03JEiz8fmOuqFE4BhR3m8GK5QGMXVWbsBhPAr7kLHy8hpHmPL+E0sSmUpTFzByLkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrcUC/ET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrcUC/ET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8DAC4CECD;
	Wed,  6 Nov 2024 12:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894885;
	bh=bCtFF9KB0IJOS/sIJdEJIQYUcT416mFGU7TIODj/DwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrcUC/ETaobQoaXLKn0yS36H5p11ibePJyMnFtywpIQS/s3Vj7b7Dk59V+nIVPQ70
	 /NHbxWkBmv8P8W56Kp6OYYaX99sIDO/l8e/P4+f3QEWiu011EPw2ds6qRIXV2A7RTs
	 ZdrX4hHVrAde+cdVojFxdyYIaX3PBPQusFaJP0a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Kees Cook <kees@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/350] wifi: cfg80211: fix UBSAN noise in cfg80211_wext_siwscan()
Date: Wed,  6 Nov 2024 12:59:20 +0100
Message-ID: <20241106120321.674708970@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit a26a5107bc52922cf5f67361e307ad66547b51c7 ]

Looking at https://syzkaller.appspot.com/bug?extid=1a3986bbd3169c307819
and running reproducer with CONFIG_UBSAN_BOUNDS, I've noticed the
following:

[ T4985] UBSAN: array-index-out-of-bounds in net/wireless/scan.c:3479:25
[ T4985] index 164 is out of range for type 'struct ieee80211_channel *[]'
<...skipped...>
[ T4985] Call Trace:
[ T4985]  <TASK>
[ T4985]  dump_stack_lvl+0x1c2/0x2a0
[ T4985]  ? __pfx_dump_stack_lvl+0x10/0x10
[ T4985]  ? __pfx__printk+0x10/0x10
[ T4985]  __ubsan_handle_out_of_bounds+0x127/0x150
[ T4985]  cfg80211_wext_siwscan+0x11a4/0x1260
<...the rest is not too useful...>

Even if we do 'creq->n_channels = n_channels' before 'creq->ssids =
(void *)&creq->channels[n_channels]', UBSAN treats the latter as
off-by-one error. Fix this by using pointer arithmetic rather than
an expression with explicit array indexing and use convenient
'struct_size()' to simplify the math here and in 'kzalloc()' above.

Fixes: 5ba63533bbf6 ("cfg80211: fix alignment problem in scan request")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Kees Cook <kees@kernel.org>
Link: https://patch.msgid.link/20240905150400.126386-1-dmantipov@yandex.ru
[fix coding style for multi-line calculation]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 0dc27703443c8..4c6c333011e02 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1414,8 +1414,8 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 		n_channels = ieee80211_get_num_supported_channels(wiphy);
 	}
 
-	creq = kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
-		       n_channels * sizeof(void *),
+	creq = kzalloc(struct_size(creq, channels, n_channels) +
+		       sizeof(struct cfg80211_ssid),
 		       GFP_ATOMIC);
 	if (!creq) {
 		err = -ENOMEM;
@@ -1425,7 +1425,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	creq->wiphy = wiphy;
 	creq->wdev = dev->ieee80211_ptr;
 	/* SSIDs come after channels */
-	creq->ssids = (void *)&creq->channels[n_channels];
+	creq->ssids = (void *)creq + struct_size(creq, channels, n_channels);
 	creq->n_channels = n_channels;
 	creq->n_ssids = 1;
 	creq->scan_start = jiffies;
-- 
2.43.0



