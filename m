Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9032419BCD
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13773C433D2;
	Wed,  7 Jun 2023 20:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170545;
	bh=EA7EnyBO8cmCNPcf02dhIWL9dadcEv0qdxkRF7doZKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkniWLPrD7ctAOd9SbeuXX0Dg4WFokb2mEvceS2/Gse9wQ3Zhy2K5I4/Ux71ZgLwL
	 yeIUF54GDxjdgPIapE58gfpkk1s8hhN1sEA9LZ7xpZPshNwukdzxasSMNLTw4JCEoS
	 mqfv192hBt0C8ujQPjCn1ovaoh4ReS7ojEkpTOnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/225] wifi: mac80211: recalc chanctx mindef before assigning
Date: Wed,  7 Jun 2023 22:15:11 +0200
Message-ID: <20230607200918.238865515@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 04312de4ced4b152749614e8179f3978a20a992f ]

When we allocate a new channel context, or find an existing one
that is compatible, we currently assign it to a link before its
mindef is updated. This leads to strange situations, especially
in link switching where you switch to an 80 MHz link and expect
it to be active immediately, but the mindef is still configured
to 20 MHz while assigning.  Also, it's strange that the chandef
passed to the assign method's argument is wider than the one in
the context.

Fix this by calculating the mindef with the new link considered
before calling the driver.

In particular, this fixes an iwlwifi problem during link switch
where the firmware would assert because the (link) station that
was added for the AP is configured to transmit at a bandwidth
that's wider than the channel context that it's configured on.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230504134511.828474-5-gregory.greenman@intel.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index c5d345e53056a..f07e34bed8f3a 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -871,6 +871,9 @@ static int ieee80211_assign_link_chanctx(struct ieee80211_link_data *link,
 	}
 
 	if (new_ctx) {
+		/* recalc considering the link we'll use it for now */
+		ieee80211_recalc_chanctx_min_def(local, new_ctx, link);
+
 		ret = drv_assign_vif_chanctx(local, sdata, link->conf, new_ctx);
 		if (ret)
 			goto out;
-- 
2.39.2



