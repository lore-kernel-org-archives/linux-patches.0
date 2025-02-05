Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE51D1519AA;
	Wed,  5 Feb 2025 14:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764826; cv=none; b=kelm4+F3PYdIUmEGg6eqHzt/0qs0JknbmirUXl6hYV/mXRVaRuWkkOj/lryeh1Dr0EsPByxoJ2IIcVlwuGtJzKs4FeaMFzf8NQR0Oec4wOnizq8YWKvcw+mgJ0nT0lSsPGk2s8kNcjmaNuiqn8VGf2DJRXMVVKvag2ejjGEYBVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764826; c=relaxed/simple;
	bh=LakGgLktnx06rB+3L8v8+NsBwPPTX4WpFAEjqSO2b14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLlSsDH19BsEGn7tDqxL+etFUhPKwxw1vHIe63d+QrHnm2XMrMtfwdC3vanvI22Ej9gADxPMDBcbJ2izfxBQqThXGEuTzD/mfRLPqyhnSdOfbeWAMHUSaDsMBGMzLTh1LN769LbWtwTQ+Rk4Pmt5KOCd4zB1pu2NeIR33P4KtYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b36A3CkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b36A3CkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB63C4CED1;
	Wed,  5 Feb 2025 14:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764826;
	bh=LakGgLktnx06rB+3L8v8+NsBwPPTX4WpFAEjqSO2b14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b36A3CkXro9c2XCLIJrtKE9VbLtFo0HJOyweMx6RsOIdQAw8DVGeDaiL9JZ/UUv96
	 bdseltnN5C2pCPjqWquA1x5WfMFAFQ2v/eVeRHikYzGkKDSe5YtG/8uFJiNRTSFdeq
	 HnK7O+xsALt+I9brfMFTV0rUxhDSSMwhfPWobqSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c5d8e65f23569a8ffec@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/590] wifi: mac80211: prohibit deactivating all links
Date: Wed,  5 Feb 2025 14:38:36 +0100
Message-ID: <20250205134501.443538256@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 68596ef78b15e..d0b145888e139 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -728,7 +728,7 @@ static ssize_t ieee80211_if_parse_active_links(struct ieee80211_sub_if_data *sda
 {
 	u16 active_links;
 
-	if (kstrtou16(buf, 0, &active_links))
+	if (kstrtou16(buf, 0, &active_links) || !active_links)
 		return -EINVAL;
 
 	return ieee80211_set_active_links(&sdata->vif, active_links) ?: buflen;
-- 
2.39.5



