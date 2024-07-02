Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019AA1BBBD7;
	Tue,  2 Jul 2024 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940713; cv=none; b=bnEKKjZ7s7zXaryD6tBx9MASey+QM3LUJ5Vq3IHHxPO9FUrmihtaEpaCWX59eWjwJEawdzroeJ03J08+VtdSCEwvHx4w1JJRBq2es/GHyQgnYih5uHrhjYpuWdFBC3Q4gdrwSx5UAHt3Id+OYPNoXi0dI/Fm5n+VUKmADyY1WqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940713; c=relaxed/simple;
	bh=Sz6gtsUMIRUEe6oOlAWAG9vbqiL8lDo8LRYEiec+EmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfKHYGXNi/1eArymnKOsSR8f9YSEhlI5zxBMQPGKnOhPC9DOtHiHoYonRjRV6HTqrw1Ni+i2b4dBO1JWEaGQcLluBrpt9cy9JTbKVf0yVa6j8dPCKRfPIMSfkkqKlXkdaT39OYPBP0MSEdZ6l4edTWXcaZcVovGYJSNJXE/tsaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klCe9XsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klCe9XsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66575C116B1;
	Tue,  2 Jul 2024 17:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940712;
	bh=Sz6gtsUMIRUEe6oOlAWAG9vbqiL8lDo8LRYEiec+EmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klCe9XsPtw0EtwpYyt7jStKCsM5bcnaq4bNx76G4drBmIh8zLWf8+vG8KFTSwakjr
	 57XO+TXmlACiew76ROgPNR1f3u84ivLsSd0xxZiUamZpjd5w00K+xf4P/SNXNqyesr
	 m2cd9+7eQxyyAdRxKKzF9Z1iBKbgZsoJVKGXJ18c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/163] wifi: mac80211: Use flexible array in struct ieee80211_tim_ie
Date: Tue,  2 Jul 2024 19:02:09 +0200
Message-ID: <20240702170233.633864085@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Jeff Johnson <quic_jjohnson@quicinc.com>

[ Upstream commit 2ae5c9248e06dac2c2360be26b4e25f673238337 ]

Currently struct ieee80211_tim_ie defines:
	u8 virtual_map[1];

Per the guidance in [1] change this to be a flexible array.

Per the discussion in [2] wrap the virtual_map in a union with a u8
item in order to preserve the existing expectation that the
virtual_map must contain at least one octet (at least when used in a
non-S1G PPDU). This means that no driver changes are required.

[1] https://docs.kernel.org/process/deprecated.html#zero-length-and-one-element-arrays
[2] https://lore.kernel.org/linux-wireless/202308301529.AC90A9EF98@keescook/

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230831-ieee80211_tim_ie-v3-2-e10ff584ab5d@quicinc.com
[add wifi prefix]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index aaaa5b90bfe25..5fbc08930941c 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -951,17 +951,24 @@ struct ieee80211_wide_bw_chansw_ie {
  * @dtim_count: DTIM Count
  * @dtim_period: DTIM Period
  * @bitmap_ctrl: Bitmap Control
+ * @required_octet: "Syntatic sugar" to force the struct size to the
+ *                  minimum valid size when carried in a non-S1G PPDU
  * @virtual_map: Partial Virtual Bitmap
  *
  * This structure represents the payload of the "TIM element" as
- * described in IEEE Std 802.11-2020 section 9.4.2.5.
+ * described in IEEE Std 802.11-2020 section 9.4.2.5. Note that this
+ * definition is only applicable when the element is carried in a
+ * non-S1G PPDU. When the TIM is carried in an S1G PPDU, the Bitmap
+ * Control and Partial Virtual Bitmap may not be present.
  */
 struct ieee80211_tim_ie {
 	u8 dtim_count;
 	u8 dtim_period;
 	u8 bitmap_ctrl;
-	/* variable size: 1 - 251 bytes */
-	u8 virtual_map[1];
+	union {
+		u8 required_octet;
+		DECLARE_FLEX_ARRAY(u8, virtual_map);
+	};
 } __packed;
 
 /**
-- 
2.43.0



