Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66A113C3F6;
	Wed,  5 Feb 2025 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765333; cv=none; b=TNnp6AypregwGDo5HC2TwGd3HBwW9lVAO6aSnBBR7QKp1O/vZEBwEFxJgobfAr4MTzSaS8k58s1jGl1zCMKvMw5RXYi9Ry1JvPsCEizaPP6nH4tDwsNP/y1+0oe5C6ip2WKmBJH42p1e+xMVDdeTTfygy4oEblMAbI423Zm7498=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765333; c=relaxed/simple;
	bh=oR7QzoYlosWqrxV7rAkZ6JKYt26IVQhQAViNwy3Y+XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjvRm4sDbvC5hh7NFAAdeX0Hm0vLZGHJY/sVd5P7XMhSFb5/Fpy3BhfwbBWAz6LNTKztpi9Lw6Hpil9RYzyLfLrJgukSXWdYl+uFUQNrliZeBWdYYQGGJnlj3LbMvHU3BUMmUPI1+W3V+cRNafUrTfTI6oUScapfF/t95Aj1W3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZLrHYeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZLrHYeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9386C4CED1;
	Wed,  5 Feb 2025 14:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765333;
	bh=oR7QzoYlosWqrxV7rAkZ6JKYt26IVQhQAViNwy3Y+XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZLrHYeEqYEIrO8/h4c7u8o/VZV5b5+KFazpbBplC1txPeclgn/yEXHwwRgKmpNsc
	 gpbXr3CyRcC7PT2tNvRYaLH+JyD9sEuemVX75+kHFfMfeEf35QvWuS4w86ob4O8NWe
	 G2hVKcuZcyb7L7NqPVWuSnB1F/ekalfkn8g0vVLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c5d8e65f23569a8ffec@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 167/623] wifi: mac80211: prohibit deactivating all links
Date: Wed,  5 Feb 2025 14:38:29 +0100
Message-ID: <20250205134502.623377428@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7553477cbfd784b128297f9ed43751688415bbaa ]

In the internal API this calls this is a WARN_ON, but that
should remain since internally we want to know about bugs
that may cause this. Prevent deactivating all links in the
debugfs write directly.

Reported-by: syzbot+0c5d8e65f23569a8ffec@syzkaller.appspotmail.com
Fixes: 3d9011029227 ("wifi: mac80211: implement link switching")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20241230091408.505bd125c35a.Ic3c1f9572b980a952a444cad62b09b9c6721732b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index a9bc2fd59f55a..e7687a7b16835 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -727,7 +727,7 @@ static ssize_t ieee80211_if_parse_active_links(struct ieee80211_sub_if_data *sda
 {
 	u16 active_links;
 
-	if (kstrtou16(buf, 0, &active_links))
+	if (kstrtou16(buf, 0, &active_links) || !active_links)
 		return -EINVAL;
 
 	return ieee80211_set_active_links(&sdata->vif, active_links) ?: buflen;
-- 
2.39.5



