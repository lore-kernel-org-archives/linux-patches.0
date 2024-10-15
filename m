Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8B51EF0AB;
	Tue, 15 Oct 2024 11:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992549; cv=none; b=gmcipBijS47mY4TuCpr0w5/MEqLWWv7SWYjSYw7TzKmspfFjx9Jc1iN3Nk5xmFK1OqzPL97KPrfW1VH+DwMiXYspltBOM1hDN7+kwE2wAZ0LdqpOFKfJ7fMgbdtbqs764+V3N4Ns1a2dyejrQRB+FPc97oH80gH7WBVe7YKgRmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992549; c=relaxed/simple;
	bh=Dp8wdZaYb9qG4skUE0397wMMy9jOTvFLiQQqiYH7UZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVKr1mFm2nm337BLjHNDYyawQxD/6SZ2k2chV1T/tMzVSFtBzpIHmj2/NqUDZD4cRMEUJY+7EUfoRfraDlDM9YdkSeGpaknW36kE0QfGxwIHGV0mAFAyiL9qBdPy7Gp62chcRn2RvyxkWP3s/niy9SXMDgRwLH77EaqizfauOtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snqCbo9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snqCbo9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644CDC4CEC6;
	Tue, 15 Oct 2024 11:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992548;
	bh=Dp8wdZaYb9qG4skUE0397wMMy9jOTvFLiQQqiYH7UZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snqCbo9jSk2MGbid+obk3kThpGyrNFj9s1N5QWLb/YuC7e5R5t3UaGpAdkVLQ2MN5
	 5GDduar8PKkAZGnWk0RCsyFj7xvbuMRjmEUhniN8r91VnHqL0ePQ5mD0jpPAVhuGKQ
	 W/4W+R+J9GBgkZqWIYwiHwf7yrDAFRtrHX5ICt1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Kees Cook <kees@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/691] wifi: cfg80211: fix UBSAN noise in cfg80211_wext_siwscan()
Date: Tue, 15 Oct 2024 13:21:05 +0200
Message-ID: <20241015112445.002925791@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b8e28025710dd..dc41b31073e75 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2813,8 +2813,8 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 		n_channels = ieee80211_get_num_supported_channels(wiphy);
 	}
 
-	creq = kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
-		       n_channels * sizeof(void *),
+	creq = kzalloc(struct_size(creq, channels, n_channels) +
+		       sizeof(struct cfg80211_ssid),
 		       GFP_ATOMIC);
 	if (!creq) {
 		err = -ENOMEM;
@@ -2824,7 +2824,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
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



