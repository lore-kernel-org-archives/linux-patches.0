Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C68833E355;
	Fri,  7 Aug 2026 15:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116941; cv=none; b=TZ/5gZsHrpoZIfkp5YQ7W63eULiUu6FBtrmbAJOlLOq6lnRJQGY1wiiUMWZlHOPi3GV0Vc85sN1BUoIomd+YCKzfJpp9W8YQZLj9oLFLY9U1BeYN1yuAVPoSBgupiJFu8cZ56m0EvUJXFVj4IqsWoxBnBFRjIeyX2Ma9RRDlT9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116941; c=relaxed/simple;
	bh=3AYeO+wXBbimTA3bDAaC5QloYytvsiMBxhd4z9FJmF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pz1UfvMzrJiI5y4rNsCdFnGRwm7HFx+OFQrHaAUhy4uljRQamNeuG+/0XcQ/fXPVnQhPEnU9ZIpyzkyamxPfcKi+DvajR9h7z6We5j9rXNMxnaaxyqMCeownOwVOO+v1qhN9M9elfKMUsPOG3DLygLvPB8WnU5NnvpwxD4WXNWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adVMuN0f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adVMuN0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07071F00A3A;
	Fri,  7 Aug 2026 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116940;
	bh=P9rW5eUAXH0RfKuPP6Q7PfIfg4UWbjHDySE/wN4kMXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adVMuN0fViTvNncTQZ35UUBe+X4bEYuWBSdOVGyLDi69Z5j9n8TNt62BvNDnrjWMd
	 3c5yLAylbn+0CkVpl/BrUO4R9hMiBoFh5diLXyR7CMB42YAXKKUaImTvmPveII9DOr
	 nC9cvbjmRZav8tDlVBG4JZoN0gO/QWkMtPNm5zsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 117/438] wifi: mac80211: validate individual TWT params before driver setup
Date: Fri,  7 Aug 2026 16:35:13 +0200
Message-ID: <20260807143430.488418107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 0502d5077e419427d80f4d46ba95d0067f5fb916 ]

ieee80211_process_rx_twt_action() only partially validates a received
S1G TWT setup frame before queueing it.

An individual agreement can therefore reach ieee80211_s1g_rx_twt_setup()
with twt->length too short for the full struct ieee80211_twt_params.

The individual path passes twt to drv_add_twt_setup(). Both the tracepoint
and the driver callback consume the complete parameters block, not merely
req_type. Do not pass a short individual agreement to the driver.
Broadcast agreements remain unchanged because they are rejected locally
after accessing only req_type.

Fixes: f5a4c24e689f ("mac80211: introduce individual TWT support in AP mode")
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260723010928.76551-1-enderaoelyther@gmail.com
[edit commit message to not overclaim lack of validation nor
 understate driver impact]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/s1g.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/s1g.c b/net/mac80211/s1g.c
index 5af4a0c6c6424..abc338e22e59c 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -101,6 +101,10 @@ ieee80211_s1g_rx_twt_setup(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_twt_setup *twt = (void *)mgmt->u.action.s1g.variable;
 	struct ieee80211_twt_params *twt_agrt = (void *)twt->params;
 
+	if (!(twt->control & IEEE80211_TWT_CONTROL_NEG_TYPE_BROADCAST) &&
+	    twt->length < sizeof(twt->control) + sizeof(*twt_agrt))
+		return;
+
 	twt_agrt->req_type &= cpu_to_le16(~IEEE80211_TWT_REQTYPE_REQUEST);
 
 	/* broadcast TWT not supported yet */
-- 
2.53.0



