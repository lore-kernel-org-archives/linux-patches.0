Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4C31F9F73;
	Tue, 26 Aug 2025 12:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213006; cv=none; b=tBO29dO5YEtlYjL7Ozn13e8eZe+8MjZyG4LnQf3q2XWmFp8nGgVcJAo2hZUT8BUathFKUGjE4hFELhOvFxYIso0cGZRWC63nvAuxc9HIA6LJfRJq6XLG3J/wEEatG/BbO5HQ2i8qalxBrP4a1cD/nKvBaGaV6Do4tKwCB5UxOtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213006; c=relaxed/simple;
	bh=YgTtQaU46RCBiXp4K1OowkQn1UBB/7iqaZeyWe3oJVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hvrjer7s6/pZpbP7WqQcCfeaLObavRkJoWLYkX/oPHRtvkhjhCnUNQZVYoZAbxVXMlTFZVeqaOq5lrshLsyiqpFGtRrO0xQhqyq8/uCLQMYNTJ296Dvfip69CKRoCG9++kLYEqas5KgNvgxlgkuDVSQndZrmDnqXGDafmOrPX2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDFoBh8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDFoBh8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35BBC4CEF1;
	Tue, 26 Aug 2025 12:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213006;
	bh=YgTtQaU46RCBiXp4K1OowkQn1UBB/7iqaZeyWe3oJVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDFoBh8pwtijBzVlj1gY0VtdWOyAkv7E9PNOSlCr2LWsuT3xDbMZitBhIN3P+d/+M
	 GTpj9ziWI8zeJhRQGOQ6PPwhaidH+NtUEXjm2+yRs9TsOwRw+lRcfUqahAg1fjIZFs
	 4tj7KUQCPQDhH4N+mt4eOWzXFLl+A1W1mgdzrFu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>,
	Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/587] wifi: mac80211: update radar_required in channel context after channel switch
Date: Tue, 26 Aug 2025 13:05:33 +0200
Message-ID: <20250826110957.622486876@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>

[ Upstream commit 140c6a61d83cbd85adba769b5ef8d61acfa5b392 ]

Currently, when a non-DFS channel is brought up and the bandwidth is
expanded from 80 MHz to 160 MHz, where the primary 80 MHz is non-DFS
and the secondary 80 MHz consists of DFS channels, radar detection
fails if radar occurs in the secondary 80 MHz.

When the channel is switched from 80 MHz to 160 MHz, with the primary
80 MHz being non-DFS and the secondary 80 MHz consisting of DFS
channels, the radar required flag in the channel switch parameters
is set to true. However, when using a reserved channel context,
it is not updated in sdata, which disables radar detection in the
secondary 80 MHz DFS channels.

Update the radar required flag in sdata to fix this issue when using
a reserved channel context.

Signed-off-by: Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>
Signed-off-by: Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250608140324.1687117-1-ramasamy.kaliappan@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 31c4f112345e..4a21e53afa72 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1313,6 +1313,7 @@ ieee80211_link_use_reserved_reassign(struct ieee80211_link_data *link)
 		goto out;
 	}
 
+	link->radar_required = link->reserved_radar_required;
 	list_move(&link->assigned_chanctx_list, &new_ctx->assigned_links);
 	rcu_assign_pointer(link_conf->chanctx_conf, &new_ctx->conf);
 
-- 
2.39.5



