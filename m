Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3142D1E0DFD;
	Wed,  6 Nov 2024 12:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897554; cv=none; b=si+RTyhGcog9KNx8PiMtz4S4jAPd4qCUOVYe/Nsb6KICIV52efqB+sIoGg5uv1Oyy7yNE0dQ3/O1FWgLWwdfMbFH8q58LrTSFEosMy/SXHAbbZ3OtRxy4o5JprX1qWVb6/fHdqlb0L6ZEVEal59ZHpK6JS85IzVovthIfM1Csy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897554; c=relaxed/simple;
	bh=kJHikDqhhaCCj/IgrlKO9JlYNAeA8AUl7u11kPAWOo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUcUe5UjpAE61lm90SnRQ0yJK77Td1epmJVvTlt+FulhgOKHSdCM1NWLFRzTxEJUNONjrZAPuRJFyO1F9avQXfzSXlcUP5k6JtaHoUkfOppBQ5oZT5GS0GVRvowwYmFerodydqLHbYTq1yi+2fZhLLkpsE/X7NK6JADoWPg1lfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeQJU5Kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeQJU5Kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3330C4CECD;
	Wed,  6 Nov 2024 12:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897554;
	bh=kJHikDqhhaCCj/IgrlKO9JlYNAeA8AUl7u11kPAWOo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeQJU5KnpTpjmpUjN//v8FPkRTrSp/BNiRyEF7Xzrsr8gAk9VXCzhtQR2UOqfAGaR
	 zyKYUJOJ3pPDO/p+lgfX/kJXxHGYuwF2bPFXyZ0Q858m5h0iQPUOrX5ik4SxwG2tAG
	 zUZyaEucIEPwd3fOpBtiuwr0K/N6gE9NzDyCq0iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 092/151] wifi: mac80211: do not pass a stopped vif to the driver in .get_txpower
Date: Wed,  6 Nov 2024 13:04:40 +0100
Message-ID: <20241106120311.403468652@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

commit 393b6bc174b0dd21bb2a36c13b36e62fc3474a23 upstream.

Avoid potentially crashing in the driver because of uninitialized private data

Fixes: 5b3dc42b1b0d ("mac80211: add support for driver tx power reporting")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20241002095630.22431-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3115,7 +3115,8 @@ static int ieee80211_get_tx_power(struct
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
-	if (local->ops->get_txpower)
+	if (local->ops->get_txpower &&
+	    (sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 		return drv_get_txpower(local, sdata, dbm);
 
 	if (!local->use_chanctx)


