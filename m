Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902A01F7088;
	Tue,  3 Dec 2024 14:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237569; cv=none; b=QZthUQGnuY/rEMA/L/US+enf/pSw5/nv8Z1ranTW3yDpUClpbEyiaRqK/8G4tJAD/XN8dff7s0dViLpDtG4Wcs3CN1hfOa8Fd2dWckNsDxgJ17XPuf3Upc+yUFnVxp947QVwnKiLGXd+yQXTCPvS5l7xM+Ez5th+d74iVGias9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237569; c=relaxed/simple;
	bh=gWX9X8+WUPBQedlXZQTJVtfcekZAzqxlljI8YP/kbj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyIjcbEx6SzJtYY2WO9mCinJuh5gNrEET9kZ5NI2T0+O3yJO7cKu7YHCwDhGJdYKBKTwvqOvK3dw1xdmPoq3haWQABcmJC2m7vHy/dcvGBd959DQIAXuaaB6Ca48hQ46ObVuh/jnL54z52KFhP3jAfYKfRjwwuB74ZTktJbtKC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bI3XtVn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bI3XtVn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F9BC4CEDF;
	Tue,  3 Dec 2024 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237569;
	bh=gWX9X8+WUPBQedlXZQTJVtfcekZAzqxlljI8YP/kbj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bI3XtVn/C3h4TcMKrLUCx4uwmJwI/CteMeosVUNLN3z+uzEZipJ2GFl0Xi/Nj1Cj9
	 SMrOFg/H8vfpEX+L7du4vwW+213Xf/4y6w8pqBCr1zDJ4GqilXPuGBr+pKgDo+i1R6
	 8ZARU91mI5DeyizDvloXdDOmuEOtFDzRQyS8uFOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 001/817] wifi: mac80211: Fix setting txpower with emulate_chanctx
Date: Tue,  3 Dec 2024 15:32:53 +0100
Message-ID: <20241203143955.675517037@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit 8dd0498983eef524a8d104eb8abb32ec4c595bec ]

Propagate hw conf into the driver when txpower changes
and driver is emulating channel contexts.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Link: https://patch.msgid.link/20240924011325.1509103-1-greearb@candelatech.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f2b5c18417ef7..6e35425fbff12 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3046,6 +3046,7 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 	enum nl80211_tx_power_setting txp_type = type;
 	bool update_txp_type = false;
 	bool has_monitor = false;
+	int old_power = local->user_power_level;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
@@ -3128,6 +3129,10 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 		}
 	}
 
+	if (local->emulate_chanctx &&
+	    (old_power != local->user_power_level))
+		ieee80211_hw_conf_chan(local);
+
 	return 0;
 }
 
-- 
2.43.0



