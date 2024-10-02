Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025901D0491;
	Wed,  2 Oct 2024 13:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877439; cv=none; b=pP42DhxVjrHE6pKFbAQ7BUZJytLkM3J4D74sHavdXwvivqoAiwHusW7WgLTTtWbY/rBs89CbsPS4NL1IXpGo01tKmUYXgI7Hh3zwAl00oKVfSykPPKTZfC4xXAD1i4A9kOxX6ucbNQq/dr8Z/hLZl5DRvbl93Khpii77Sm2ZL1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877439; c=relaxed/simple;
	bh=n7MEG9fout3wMkUsKQLW2DU5Dsr+Nrlu9AcxYkmO5/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaacEFOcqhsEKbDSxSvbX0oLFbyzFfYbws9kRHJI1tG7sTS5Df2KgfGrX948ao4obvaKwT249/Co2v1/j8qP2Nz4fYmPwdhUYstPJp0fQaP83Y41EKcU1Dsn1zN55C7paYQCm7bVAklHPGHqZd5PTnDjW8gvp3ipLpIcyRhSpSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyAkk4Cm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyAkk4Cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA66C4CECF;
	Wed,  2 Oct 2024 13:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877438;
	bh=n7MEG9fout3wMkUsKQLW2DU5Dsr+Nrlu9AcxYkmO5/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyAkk4Cm/Qi8qfxnFAExvpD9E+O4VeMXPcQQl1uykDlrPRF1mYRs7hBqOcQ9dM4Nu
	 0o2G+aV4Ylwi0Sncr0h9ZdnnZuEda8BOTSjT3Q0ELIRrvYgRpaiiltpIHNG1fVj+iI
	 5+RWLK3Ly7qWqp+o+Xud7e2qI8rK28A96xjYpSz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Kees Cook <kees@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 079/634] wifi: cfg80211: fix UBSAN noise in cfg80211_wext_siwscan()
Date: Wed,  2 Oct 2024 14:52:59 +0200
Message-ID: <20241002125814.228636117@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 64c779788a646..44c93b9a9751c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3452,8 +3452,8 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 		n_channels = ieee80211_get_num_supported_channels(wiphy);
 	}
 
-	creq = kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
-		       n_channels * sizeof(void *),
+	creq = kzalloc(struct_size(creq, channels, n_channels) +
+		       sizeof(struct cfg80211_ssid),
 		       GFP_ATOMIC);
 	if (!creq)
 		return -ENOMEM;
@@ -3461,7 +3461,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
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



