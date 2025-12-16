Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11397398B7D;
	Tue, 16 Dec 2025 12:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888365; cv=none; b=evILo4uayLI3zhWsrBy2WC+IDBeEUdkNWNKQ5rjbUyoZWHhdQQXMPB5kvJUpG0oqFGWfVS5DxTm7CBC7i9aaQf7Z2FIDR4dlEQU9XwR3mliLwSKcbfBTXckSoGMmN4HphYQwDy+WhgeMThaFiPF1+ItA73KhE7+WrfkG93eFzx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888365; c=relaxed/simple;
	bh=3d/KXMrmeYKw1rpoCMjJpy/1YUV/4sedCWmIA2/SYfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIC0F6Ga5Vh/MKTAjCfraH5VI/ekFldwfupyIMemigeh1Qpl3YWhnXRlK3bqo2MqzvPrNdnBun0UwrQOaytHyOpwQOr7qvSfd4oXFFYkecY8dCAfYZLzm3QVEnL2UUl4oe12gr9V1lZ5V/hl1YSzfnP6xoXgOWB1DrDlLEqPHsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPfCHVhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPfCHVhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248EAC4CEF1;
	Tue, 16 Dec 2025 12:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888364;
	bh=3d/KXMrmeYKw1rpoCMjJpy/1YUV/4sedCWmIA2/SYfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPfCHVhHfwJJSZCa08DoyBgG1eIuxk2l6Lkjsv+bTUUmLys5FbdbdVU3qxLdFeT6T
	 liJ0kKIN1mm5i77KR5hnQO3fNldwJ9b9JwUMx/Bpm0y1YyIWqI4DVzBzRXTm0qCOCQ
	 3wmJx3tAYo78ec7lO9/4G9U6c8QMt1o5JmodPd08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 512/614] net: dsa: b53: split reading search entry into their own functions
Date: Tue, 16 Dec 2025 12:14:39 +0100
Message-ID: <20251216111419.919701039@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



