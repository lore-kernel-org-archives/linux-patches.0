Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA442AE8D;
	Tue, 11 Nov 2025 00:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822325; cv=none; b=pOjbMRi8Ms8WCdVXLnS9MEtg/igS93pakxsLAPTaa9wIcQdmx5i5n5srs8MN8YpOOMGNORuFQ97BdJ9KASRU5S/jjeD8KoJdCPthMyjirWw5YjXJr4zWCCohr38wgh65U3b3T97pcrPfaXJ75OxppMlE0Tqn1yXIcL/OE/a8cE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822325; c=relaxed/simple;
	bh=+Vq52yz2wzPrQLe653KsTkrHgVoMASea9S0nq6Kmt1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVud2yA3e/sVulUb60eusekGEOPOXGXEYMKtHjppqhFHmvpgp4c1q0grg86oZSphV5qxSLPMpaFm7BbRLiZT5Khbyc6dv5l17W69f69TFnJnSQip0S2JuCKslQmRedzstD2qe1R8UjL6kfspvfjqzJlIVheFs+FxnBi8UI1yIXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4yZuvfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4yZuvfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8E9C19421;
	Tue, 11 Nov 2025 00:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822324;
	bh=+Vq52yz2wzPrQLe653KsTkrHgVoMASea9S0nq6Kmt1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4yZuvfOw8onX5Xr9v/mFWd6pdxpFUCrIGUQ4bYw7DRz0AvEzOHgY6SNJzkVwLB2B
	 se/YgF9eeYZjtI+QgYMqaqsLLnv7UvV1hOShS1C+dh6eHEvg5jNyxeCE/jqcF0WpuU
	 UdGgI/m4diM8tNNh7tlaJ8646z+WMc5nDcne9JMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/565] wifi: mac80211: dont mark keys for inactive links as uploaded
Date: Tue, 11 Nov 2025 09:38:03 +0900
Message-ID: <20251111004527.489209007@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 63df3956903748c5f374a0dfe7a89490714a4625 ]

During resume, the driver can call ieee80211_add_gtk_rekey for keys that
are not programmed into the device, e.g. keys of inactive links.
Don't mark such a key as uploaded to avoid removing it later from the
driver/device.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250709233537.655094412b0b.Iacae31af3ba2a705da0a9baea976c2f799d65dc4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: ed6a47346ec6 ("wifi: mac80211: fix key tailroom accounting leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/key.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 67ecfea229829..7809fac6bae5d 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -510,7 +510,8 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	} else {
 		if (!new->local->wowlan)
 			ret = ieee80211_key_enable_hw_accel(new);
-		else
+		else if (link_id < 0 || !sdata->vif.active_links ||
+			 BIT(link_id) & sdata->vif.active_links)
 			new->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 	}
 
-- 
2.51.0



