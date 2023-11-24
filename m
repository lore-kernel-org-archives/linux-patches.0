Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12375364D6;
	Fri, 24 Nov 2023 18:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owD2kylz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815CDC433C9;
	Fri, 24 Nov 2023 18:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849115;
	bh=WceFKyEOk6p7+Bqi0UOYTF8QlclcRf5i8UcwHY29i18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owD2kylzjq9c+jUacuBdHpqcd26Lo264AgTj0vB0M2O4dtMFYPIcD46t5OKSyHVjK
	 8Pgf4Mnr4r5WFUFi92swPvMV0v9Q5v3TWqC9/RynEEHQwuTEFTy24j1U6/NXa5c0/J
	 cV+8Jy1atBoze7aKmpVVoXCQDos6d2xveqrPszfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/530] wifi: mt76: fix clang-specific fortify warnings
Date: Fri, 24 Nov 2023 17:43:15 +0000
Message-ID: <20231124172028.954326858@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 03f0e11da7fb26db4f27e6b83a223512db9f7ca5 ]

When compiling with clang 16.0.6 and CONFIG_FORTIFY_SOURCE=y, I've
noticed the following (somewhat confusing due to absence of an actual
source code location):

In file included from drivers/net/wireless/mediatek/mt76/mt792x_core.c:4:
In file included from ./include/linux/module.h:13:
In file included from ./include/linux/stat.h:19:
In file included from ./include/linux/time.h:60:
In file included from ./include/linux/time32.h:13:
In file included from ./include/linux/timex.h:67:
In file included from ./arch/x86/include/asm/timex.h:5:
In file included from ./arch/x86/include/asm/processor.h:23:
In file included from ./arch/x86/include/asm/msr.h:11:
In file included from ./arch/x86/include/asm/cpumask.h:5:
In file included from ./include/linux/cpumask.h:12:
In file included from ./include/linux/bitmap.h:11:
In file included from ./include/linux/string.h:254:
./include/linux/fortify-string.h:592:4: warning: call to '__read_overflow2_field'
declared with 'warning' attribute: detected read beyond size of field (2nd
parameter); maybe use struct_group()? [-Wattribute-warning]
                        __read_overflow2_field(q_size_field, size);

In file included from drivers/net/wireless/mediatek/mt76/mt7915/main.c:4:
In file included from ./include/linux/etherdevice.h:20:
In file included from ./include/linux/if_ether.h:19:
In file included from ./include/linux/skbuff.h:15:
In file included from ./include/linux/time.h:60:
In file included from ./include/linux/time32.h:13:
In file included from ./include/linux/timex.h:67:
In file included from ./arch/x86/include/asm/timex.h:5:
In file included from ./arch/x86/include/asm/processor.h:23:
In file included from ./arch/x86/include/asm/msr.h:11:
In file included from ./arch/x86/include/asm/cpumask.h:5:
In file included from ./include/linux/cpumask.h:12:
In file included from ./include/linux/bitmap.h:11:
In file included from ./include/linux/string.h:254:
./include/linux/fortify-string.h:592:4: warning: call to '__read_overflow2_field'
declared with 'warning' attribute: detected read beyond size of field (2nd
parameter); maybe use struct_group()? [-Wattribute-warning]
                        __read_overflow2_field(q_size_field, size);

In file included from drivers/net/wireless/mediatek/mt76/mt7996/main.c:6:
In file included from drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h:9:
In file included from ./include/linux/interrupt.h:8:
In file included from ./include/linux/cpumask.h:12:
In file included from ./include/linux/bitmap.h:11:
In file included from ./include/linux/string.h:254:
./include/linux/fortify-string.h:592:4: warning: call to '__read_overflow2_field'
declared with 'warning' attribute: detected read beyond size of field (2nd
parameter); maybe use struct_group()? [-Wattribute-warning]
                        __read_overflow2_field(q_size_field, size);

The compiler actually complains on 'mt7915_get_et_strings()',
'mt792x_get_et_strings()' and 'mt7996_get_et_strings()' due to the same
reason: fortification logic inteprets call to 'memcpy()' as an attempt
to copy the whole array from its first member and so issues an overread
warning. These warnings may be silenced by passing an address of the whole
array and not the first member to 'memcpy()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt792x_core.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index d06c25dda325e..d85105a43d704 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1388,7 +1388,7 @@ void mt7915_get_et_strings(struct ieee80211_hw *hw,
 	if (sset != ETH_SS_STATS)
 		return;
 
-	memcpy(data, *mt7915_gstrings_stats, sizeof(mt7915_gstrings_stats));
+	memcpy(data, mt7915_gstrings_stats, sizeof(mt7915_gstrings_stats));
 	data += sizeof(mt7915_gstrings_stats);
 	page_pool_ethtool_stats_get_strings(data);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index ec98450a938ff..f111c47fdca56 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -358,7 +358,7 @@ void mt792x_get_et_strings(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (sset != ETH_SS_STATS)
 		return;
 
-	memcpy(data, *mt792x_gstrings_stats, sizeof(mt792x_gstrings_stats));
+	memcpy(data, mt792x_gstrings_stats, sizeof(mt792x_gstrings_stats));
 
 	data += sizeof(mt792x_gstrings_stats);
 	page_pool_ethtool_stats_get_strings(data);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 6e0f0c100db84..620880e560e00 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1198,7 +1198,7 @@ void mt7996_get_et_strings(struct ieee80211_hw *hw,
 			   u32 sset, u8 *data)
 {
 	if (sset == ETH_SS_STATS)
-		memcpy(data, *mt7996_gstrings_stats,
+		memcpy(data, mt7996_gstrings_stats,
 		       sizeof(mt7996_gstrings_stats));
 }
 
-- 
2.42.0



