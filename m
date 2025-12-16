Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B417334A3BF;
	Tue, 16 Dec 2025 11:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886368; cv=none; b=gzlCtg/5uPZ2LvUX/ek3haz/B91F8LxM9NqUVGCEpfZfavuQSMvQL9ZAKfpbN+R7GD32ZhyHMGAz/WbJcoGYWHx2DZc1LhNzuOqqUPfwiGl5b2rMtJbWM9n52hGyvHOmuXZuUYpfO3AK9G9Bd8NGm4pm0VLPGsPv1iznFSIJauI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886368; c=relaxed/simple;
	bh=J0Vpr1lSzESiReWImJIzHuBQ2qbp46pVm/AWx0msAGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8yTL85tB1APmW02MdZxNtXTUO7S01z414wjINLUKIvwf/z7Hk3H0UfBDLFUbc5MoDaLHYdq98IT2EKU9L1UfPlC5HrM399TKf7dBEYVXVylLN4Sv68T6deaSwOidbRZjNeE0McC2hQt76Z5NOUDfMYQjRn+dnaegJndI5gqA2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqvYrxFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqvYrxFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09698C4CEF1;
	Tue, 16 Dec 2025 11:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886368;
	bh=J0Vpr1lSzESiReWImJIzHuBQ2qbp46pVm/AWx0msAGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqvYrxFucQSFdvDYBtrKbI2uIvGC+ajgG+M0wggClnj7Ixy5xOslB4U44N9qrxUo0
	 oabpHE6ig/yXq4eRYouJbUCgvmy1EMw6yl2oRrqLdpsX35naAjUfpEDp2Lg+vnFcO8
	 v+6rPn2ihiUK1Vujr73wT8d0XygKZHFHLZpMGXqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 415/507] net: dsa: b53: split reading search entry into their own functions
Date: Tue, 16 Dec 2025 12:14:16 +0100
Message-ID: <20251216111400.496414626@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit e0c476f325a8c9b961a3d446c24d3c8ecae7d186 ]

Split reading search entries into a function for each format.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251107080749.26936-6-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8e46aacea426 ("net: dsa: b53: use same ARL search result offset for BCM5325/65")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 56 ++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 38e6fa05042ca..190eb11644917 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2060,28 +2060,48 @@ static int b53_arl_search_wait(struct b53_device *dev)
 	return -ETIMEDOUT;
 }
 
-static void b53_arl_search_rd(struct b53_device *dev, u8 idx,
-			      struct b53_arl_entry *ent)
+static void b53_arl_search_read_25(struct b53_device *dev, u8 idx,
+				   struct b53_arl_entry *ent)
 {
 	u64 mac_vid;
 
-	if (is5325(dev)) {
-		b53_read64(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSTL_0_MACVID_25,
-			   &mac_vid);
-		b53_arl_to_entry_25(ent, mac_vid);
-	} else if (is5365(dev)) {
-		b53_read64(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSTL_0_MACVID_65,
-			   &mac_vid);
-		b53_arl_to_entry_25(ent, mac_vid);
-	} else {
-		u32 fwd_entry;
+	b53_read64(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSTL_0_MACVID_25,
+		   &mac_vid);
+	b53_arl_to_entry_25(ent, mac_vid);
+}
 
-		b53_read64(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSTL_MACVID(idx),
-			   &mac_vid);
-		b53_read32(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSTL(idx),
-			   &fwd_entry);
-		b53_arl_to_entry(ent, mac_vid, fwd_entry);
-	}
+static void b53_arl_search_read_65(struct b53_device *dev, u8 idx,
+				   struct b53_arl_entry *ent)
+{
+	u64 mac_vid;
+
+	b53_read64(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSTL_0_MACVID_65,
+		   &mac_vid);
+	b53_arl_to_entry_25(ent, mac_vid);
+}
+
+static void b53_arl_search_read_95(struct b53_device *dev, u8 idx,
+				   struct b53_arl_entry *ent)
+{
+	u32 fwd_entry;
+	u64 mac_vid;
+
+	b53_read64(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSTL_MACVID(idx),
+		   &mac_vid);
+	b53_read32(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSTL(idx),
+		   &fwd_entry);
+	b53_arl_to_entry(ent, mac_vid, fwd_entry);
+}
+
+static void b53_arl_search_rd(struct b53_device *dev, u8 idx,
+			      struct b53_arl_entry *ent)
+{
+	if (is5325(dev))
+		b53_arl_search_read_25(dev, idx, ent);
+	else if (is5365(dev))
+		b53_arl_search_read_65(dev, idx, ent);
+	else
+		b53_arl_search_read_95(dev, idx, ent);
 }
 
 static int b53_fdb_copy(int port, const struct b53_arl_entry *ent,
-- 
2.51.0



