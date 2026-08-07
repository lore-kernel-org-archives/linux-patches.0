Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7714D4756C9;
	Fri,  7 Aug 2026 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115058; cv=none; b=fMC69hmLKayihLNs/Tqy3KwHOGnsTx5LU4ptdzCsDodqL1LLYLxHSJLlE/qmlyanPLD7uwsQQm5vhtQsb2ya7kSYEPHSBvedd6tMBV8/QG9vF+L4+eAL6390wManj7I0ccqQPx3C5yYfrbpiBbEVZIW+2+bvsNhOKQtq0hZUk8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115058; c=relaxed/simple;
	bh=BNkg+TM9XmS+OSkSXTxYhX8Vu/vdv9W7X10tZxqdgWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QguiJ9r3fhrvTLq3+3kJLfMrtqNalGhsCjaJxhZHW7OoaF6uISwTUpnvfcPxiFOD0eEqAjN/5hr9/A317p3X4EgSE+9HgKGIhqIUKJ3a8MqoLTzG92XNuzP20Vx11QrKACKZmcAL5BagN39YFJcTqvTDnvRAU9/bNNooHzzhjgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBVaHMtY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBVaHMtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8441F00A3E;
	Fri,  7 Aug 2026 15:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115053;
	bh=OXbBLbn1O7PbXGLUmeXOtmSU6MjdGRvq/NUmtJi389A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BBVaHMtYpLPRu5LhoJWcEqV66pp4Gx0BxKfOGf99tulvKFaMJP0GtZ5cKNRlTCzPR
	 mnma6uIa8Rss38XE27u1kHD4jpiJ1sbCFj1C0KHx9JXq+HN3iuazjtCse4sWmxeiX2
	 +EM17284ovxg5JpkWO+SU46DOAvBNN0xb8PABaeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/396] wifi: mac80211: validate individual TWT params before driver setup
Date: Fri,  7 Aug 2026 16:34:17 +0200
Message-ID: <20260807143426.376473294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1f68df6e80670..7702cff84d546 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -101,6 +101,10 @@ ieee80211_s1g_rx_twt_setup(struct ieee80211_sub_if_data *sdata,
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



