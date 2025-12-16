Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B6A398B62;
	Tue, 16 Dec 2025 12:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888358; cv=none; b=c4b/MpNjqQ+Sb01kEQFA58BFBg9Jv5gUBGboAByPhvleyr4YYK9/16DfJaUHdHiqoMfeyduIZuiFqE3IwnByhmsF+xnYdunvtbr/aPloWJVDBEtkbIbjMfp+itTv5MsgIk5tT4/bV/1oFdN3FxLlKICV4z1zxmUH2A/ub9RrP3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888358; c=relaxed/simple;
	bh=Rsju1NiN7gPYOHhfQcprKzUxzZ3oJSKMf3kHN7iawps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3gZ6a60z2MGSYxfL1dMGUwwwTz12G0Iip8rVLoBSwDxndz9VxrsnR7jTBw5Y4Yotr2T4g9v5p8rdrMsBllmMD26qubI8YtyrQkLKZHj6Q0S1SFT+8c+8BpnKuZDJzQ/irmwcrhrNzQNUAd6mDxKD+AytXh8XO9Dx1im2qA4DIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGzDiZrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGzDiZrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A911C4CEF1;
	Tue, 16 Dec 2025 12:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888357;
	bh=Rsju1NiN7gPYOHhfQcprKzUxzZ3oJSKMf3kHN7iawps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGzDiZrRHSDour53G17yIQyli64MEebvLAp8gYPkz8xfuHL3AiPGfS+YigVBUvylz
	 YCBXDMd6DoiZcCdRHHC8BeUyMaCVNMm22qvy5N76peUv8sshunGowoenlG+n+o8AUD
	 ESVoTuMcW6nrq2s1s9EvfzEKP1vRBMI3a0F/y7+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 510/614] net: dsa: b53: move writing ARL entries into their own functions
Date: Tue, 16 Dec 2025 12:14:37 +0100
Message-ID: <20251216111419.846589237@linuxfoundation.org>
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

[ Upstream commit bf6e9d2ae1dbafee53ec4ccd126595172e1e5278 ]

Move writing ARL entries into individual functions for each format.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251107080749.26936-4-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8e46aacea426 ("net: dsa: b53: use same ARL search result offset for BCM5325/65")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 38 ++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 41dcd2d03230d..4c418e0531f73 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1840,6 +1840,16 @@ static void b53_arl_read_entry_25(struct b53_device *dev,
 	b53_arl_to_entry_25(ent, mac_vid);
 }
 
+static void b53_arl_write_entry_25(struct b53_device *dev,
+				   const struct b53_arl_entry *ent, u8 idx)
+{
+	u64 mac_vid;
+
+	b53_arl_from_entry_25(&mac_vid, ent);
+	b53_write64(dev, B53_ARLIO_PAGE, B53_ARLTBL_MAC_VID_ENTRY(idx),
+		    mac_vid);
+}
+
 static void b53_arl_read_entry_95(struct b53_device *dev,
 				  struct b53_arl_entry *ent, u8 idx)
 {
@@ -1852,6 +1862,19 @@ static void b53_arl_read_entry_95(struct b53_device *dev,
 	b53_arl_to_entry(ent, mac_vid, fwd_entry);
 }
 
+static void b53_arl_write_entry_95(struct b53_device *dev,
+				   const struct b53_arl_entry *ent, u8 idx)
+{
+	u32 fwd_entry;
+	u64 mac_vid;
+
+	b53_arl_from_entry(&mac_vid, &fwd_entry, ent);
+	b53_write64(dev, B53_ARLIO_PAGE, B53_ARLTBL_MAC_VID_ENTRY(idx),
+		    mac_vid);
+	b53_write32(dev, B53_ARLIO_PAGE, B53_ARLTBL_DATA_ENTRY(idx),
+		    fwd_entry);
+}
+
 static int b53_arl_read(struct b53_device *dev, const u8 *mac,
 			u16 vid, struct b53_arl_entry *ent, u8 *idx)
 {
@@ -1892,9 +1915,8 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 		      const unsigned char *addr, u16 vid, bool is_valid)
 {
 	struct b53_arl_entry ent;
-	u32 fwd_entry;
-	u64 mac, mac_vid = 0;
 	u8 idx = 0;
+	u64 mac;
 	int ret;
 
 	/* Convert the array into a 64-bit MAC */
@@ -1931,7 +1953,6 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 		/* We could not find a matching MAC, so reset to a new entry */
 		dev_dbg(dev->dev, "{%pM,%.4d} not found, using idx: %d\n",
 			addr, vid, idx);
-		fwd_entry = 0;
 		break;
 	default:
 		dev_dbg(dev->dev, "{%pM,%.4d} found, using idx: %d\n",
@@ -1959,16 +1980,9 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 	ent.is_age = false;
 	memcpy(ent.mac, addr, ETH_ALEN);
 	if (is5325(dev) || is5365(dev))
-		b53_arl_from_entry_25(&mac_vid, &ent);
+		b53_arl_write_entry_25(dev, &ent, idx);
 	else
-		b53_arl_from_entry(&mac_vid, &fwd_entry, &ent);
-
-	b53_write64(dev, B53_ARLIO_PAGE,
-		    B53_ARLTBL_MAC_VID_ENTRY(idx), mac_vid);
-
-	if (!is5325(dev) && !is5365(dev))
-		b53_write32(dev, B53_ARLIO_PAGE,
-			    B53_ARLTBL_DATA_ENTRY(idx), fwd_entry);
+		b53_arl_write_entry_95(dev, &ent, idx);
 
 	return b53_arl_rw_op(dev, 0);
 }
-- 
2.51.0



