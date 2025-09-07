Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316D41A2389;
	Sun,  7 Sep 2025 20:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276194; cv=none; b=n1YGw3/wp38LJ84r/Y84HQGIwY9bZxPVCzclCxYhneNkicJOZ6h1pVdmeaTx1JqooXEhh5dR1sstGM2qiccIuICrAjlgKTi6zsdTMF8TqVmBrtOInBrj9n3Lc68v20f2Mi9UQKeTo+Crka6yIgJJj8S7Vulp69W2TZjA+FGddIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276194; c=relaxed/simple;
	bh=zgkd4Uz7BBtzFpZX97rPhFaMnagTHzfYv9CPoeuzuck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3ld+nfrsVik8JNhxpmU4RfPfUjqE3rCT2wadX822uvfjS6gKzBOXJy6NthmEmS4o5G2BoZCWvrC8KxYHu37f7cnAWT13QDKzFTKk9Vj/SyjVKOQ/wkXpm9X+tmx6RD7nwj/C65hOyTUptzjSJjQh1t3xGYUu3hzZav3ruIDeKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNetGAPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNetGAPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FFEC4CEF0;
	Sun,  7 Sep 2025 20:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276194;
	bh=zgkd4Uz7BBtzFpZX97rPhFaMnagTHzfYv9CPoeuzuck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNetGAPzToWb0qtrNaCMRrO1mw6bPt3ssjhY3FLQJVR9WCPr8Jjv6jwYJLFC178AE
	 TR5YHDOaZIrL1xi971a2rtThvTg2EqP+N3JdP+zvWtgI7FmanNXvmxbzd9flKjzE+8
	 5ZSN+WbqtT9Xi80WlvMnCeH9NudatdSXq90hsNoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/104] wifi: libertas: cap SSID len in lbs_associate()
Date: Sun,  7 Sep 2025 21:57:45 +0200
Message-ID: <20250907195608.427603506@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit c786794bd27b0d7a5fd9063695df83206009be59 ]

If the ssid_eid[1] length is more that 32 it leads to memory corruption.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/2a40f5ec7617144aef412034c12919a4927d90ad.1756456951.git.dan.carpenter@linaro.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 3e065cbb0af91..5f0fef67fa841 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1101,10 +1101,13 @@ static int lbs_associate(struct lbs_private *priv,
 	/* add SSID TLV */
 	rcu_read_lock();
 	ssid_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SSID);
-	if (ssid_eid)
-		pos += lbs_add_ssid_tlv(pos, ssid_eid + 2, ssid_eid[1]);
-	else
+	if (ssid_eid) {
+		u32 ssid_len = min(ssid_eid[1], IEEE80211_MAX_SSID_LEN);
+
+		pos += lbs_add_ssid_tlv(pos, ssid_eid + 2, ssid_len);
+	} else {
 		lbs_deb_assoc("no SSID\n");
+	}
 	rcu_read_unlock();
 
 	/* add DS param TLV */
-- 
2.50.1



