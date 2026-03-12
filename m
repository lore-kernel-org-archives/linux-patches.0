Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2214C26F288;
	Thu, 12 Mar 2026 20:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347187; cv=none; b=ZbItZM9LxAz4+b3Rikm8ARskEtHSyJ8wQ1tQsmiZM8Tuajy2RTxXPAdZnBrLMR4sVIQbJp14xZsY5620lkeeS4EAMFy++YijqSBt/+xy84IjuCcwk9Xi1m0yLH7fWiEBdOc/ezMdC7n5NaHzDMqUzpj2Mq2K6sTHJfKuL7NLnPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347187; c=relaxed/simple;
	bh=YXbX1cHusej7MmbQebSZk7ajb171y324e4q+EKYAKLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jt3ZAzhG4NZLKzJsPA4orTYWHKtyaxe73fPsYP1voFcUKGcOwggLRMhaAdtegYk7A7HEvjrc7X4pLvoId7GrIQPnaigJ6U1mY6LMrSM6ymnItOMEE/M9BwgibSSkngzV9xTgFdxGEEk9OWjw4WT4d+bJeUzqIqNz15AqxkkruBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mbLfIaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mbLfIaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB5EC4CEF7;
	Thu, 12 Mar 2026 20:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347186;
	bh=YXbX1cHusej7MmbQebSZk7ajb171y324e4q+EKYAKLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mbLfIaVzDRINQPB/+SLRkEx0kHEHyTBNb0zWdGWAI5ShuYRK9dbg5u8xceTq3HNm
	 2VDXMHJaF+852+XCkTmYNaIyMe0Jgokt7hF+lbhYg9YFigbn+JA/GxkTuX9LAskcRl
	 ZVJx1Unf5GLkiKSgfD0H1vwJDzWVUs+++CTe4Wiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/265] wifi: rsi: Dont default to -EOPNOTSUPP in rsi_mac80211_config
Date: Thu, 12 Mar 2026 21:09:42 +0100
Message-ID: <20260312201025.360343153@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit d973b1039ccde6b241b438d53297edce4de45b5c ]

This triggers a WARN_ON in ieee80211_hw_conf_init and isn't the expected
behavior from the driver - other drivers default to 0 too.

Fixes: 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx drivers")
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Link: https://patch.msgid.link/20260221-rsi-config-ret-v1-1-9a8f805e2f31@puri.sm
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index c92bb8815320e..85fd5090e0b8a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -666,7 +666,7 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
 	struct ieee80211_conf *conf = &hw->conf;
-	int status = -EOPNOTSUPP;
+	int status = 0;
 
 	mutex_lock(&common->mutex);
 
-- 
2.51.0



