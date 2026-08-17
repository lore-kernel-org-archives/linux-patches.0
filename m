Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E5B43CEED;
	Mon, 17 Aug 2026 14:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977291; cv=none; b=gzAvxmt58urMmPeDXcdP+OAtZTgzHGsjBW8IC9mNL/vf9WtznES8/fWAXBNeNkIyETR/4O3oD7oIPEe+ur2vSUhiw9plfjdDKY8KE424JOO5XuHd4oQmbMZorUzJ5xWnR3LQWkkXFOYcGFZ1XrjRHh0KmIfMwkHcpPCubzuRlHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977291; c=relaxed/simple;
	bh=Ba+m+qUv1zMffmZB3+1M+/zL9//mNX9wzq7UCTrgjyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyAHZW/7tEeyoPiHff9t7JLmU3099NO4V/ZB69JaqD7t7Z7e/YsYz9rqCyyMOqGeExZmbHZ5P+G/VPuuG0fGnSXCztOKHNRG2KToMPLkcMYe1rTQCPMi98Ij0UZAS1N5AvGDS+mzG3qcB8L+l73V4YesVBNixQIU4cPy/P35z9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjzYRTgw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjzYRTgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569B81F000E9;
	Mon, 17 Aug 2026 14:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977289;
	bh=RDyd/zdZeWQfTCqrhmaSzvlToLXIbOuXFYDzbW+tZLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjzYRTgweSCjuiKaJK9lQDiNKD/d8/XfdjEvpUItL9LjLrFon7toOznVs4P7y3OLu
	 YXzOhg9/c3qow9mXpvyE70/Kfd84CihgK9rRn9nV6AaC4N26NYXeQJ25ygTEOF8AFq
	 QfcDIdn/yA4PaEQEXQX/cPa/Oz8ToFR4utR6hRI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 279/456] wifi: mac80211: validate individual TWT params before driver setup
Date: Mon, 17 Aug 2026 15:31:09 +0200
Message-ID: <20260817132550.865558374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 10b34bc4b67d4..e41fd43f6a6ec 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -100,6 +100,10 @@ ieee80211_s1g_rx_twt_setup(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_twt_setup *twt = (void *)mgmt->u.action.u.s1g.variable;
 	struct ieee80211_twt_params *twt_agrt = (void *)twt->params;
 
+	if (!(twt->control & IEEE80211_TWT_CONTROL_NEG_TYPE_BROADCAST) &&
+	    twt->length < sizeof(twt->control) + sizeof(*twt_agrt))
+		return;
+
 	twt_agrt->req_type &= cpu_to_le16(~IEEE80211_TWT_REQTYPE_REQUEST);
 
 	/* broadcast TWT not supported yet */
-- 
2.53.0



