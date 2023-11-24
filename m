Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3184C33CCA;
	Fri, 24 Nov 2023 19:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/Syq8z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0913C433C7;
	Fri, 24 Nov 2023 19:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853823;
	bh=sdpaCRLHOOunxzoYusvI2wYZ0Rsz8LXi4P/pqH2Pmxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/Syq8z2cZ750uLLpj0QJu/K51QU+COCETVyhcjYrn7S1XG/0zngLMtn3X/oRdT24
	 QLptt4X/XcZ4136wY2k1IACR5u4bRxfg7ZqIZ+tlQfyhktxW4ULjspgmCNJ0EwVl0n
	 FQnNHcClLOFIWGwC9PXE5hduiQXtd1HUeoKhuXJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/159] wifi: ath10k: fix clang-specific fortify warning
Date: Fri, 24 Nov 2023 17:53:46 +0000
Message-ID: <20231124171942.296660655@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit cb4c132ebfeac5962f7258ffc831caa0c4dada1a ]

When compiling with clang 16.0.6 and CONFIG_FORTIFY_SOURCE=y, I've
noticed the following (somewhat confusing due to absence of an actual
source code location):

In file included from drivers/net/wireless/ath/ath10k/debug.c:8:
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

The compiler actually complains on 'ath10k_debug_get_et_strings()' where
fortification logic inteprets call to 'memcpy()' as an attempt to copy
the whole 'ath10k_gstrings_stats' array from it's first member and so
issues an overread warning. This warning may be silenced by passing
an address of the whole array and not the first member to 'memcpy()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230829093652.234537-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 04c50a26a4f47..34db968c4bd0b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1138,7 +1138,7 @@ void ath10k_debug_get_et_strings(struct ieee80211_hw *hw,
 				 u32 sset, u8 *data)
 {
 	if (sset == ETH_SS_STATS)
-		memcpy(data, *ath10k_gstrings_stats,
+		memcpy(data, ath10k_gstrings_stats,
 		       sizeof(ath10k_gstrings_stats));
 }
 
-- 
2.42.0



