Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221F711715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FC2C433CA;
	Mon, 11 Sep 2023 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445010;
	bh=yBx3Tk0P7SqcCLXbhOp6LoKl1vGQNNR77cDtkOApZaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFxV5mDrR1HHj0AyhKLixdKndXR4c3UhKnVI+iYsyWZZGdDIfevVVLTEKWSYDBD5Q
	 Sec1NJr12sZy8vQgkC6qnGHE7DEAZ997NnEY0K9aRXA08PQJ+PZF7h6X9IhfKjFujW
	 VJG355rZq8J8VSJsNtSyab2jBmxYqz92broVZqMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <keescook@chromium.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/600] mac80211: make ieee80211_tx_info padding explicit
Date: Mon, 11 Sep 2023 15:43:47 +0200
Message-ID: <20230911134639.344103473@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a7a2ef0c4b3efbd7d6f3fabd87dbbc0b3f2de5af ]

While looking at a bug, I got rather confused by the layout of the
'status' field in ieee80211_tx_info. Apparently, the intention is that
status_driver_data[] is used for driver specific data, and fills up the
size of the union to 40 bytes, just like the other ones.

This is indeed what actually happens, but only because of the
combination of two mistakes:

 - "void *status_driver_data[18 / sizeof(void *)];" is intended
   to be 18 bytes long but is actually two bytes shorter because of
   rounding-down in the division, to a multiple of the pointer
   size (4 bytes or 8 bytes).

 - The other fields combined are intended to be 22 bytes long, but
   are actually 24 bytes because of padding in front of the
   unaligned tx_time member, and in front of the pointer array.

The two mistakes cancel out. so the size ends up fine, but it seems
more helpful to make this explicit, by having a multiple of 8 bytes
in the size calculation and explicitly describing the padding.

Fixes: ea5907db2a9cc ("mac80211: fix struct ieee80211_tx_info size")
Fixes: 02219b3abca59 ("mac80211: add WMM admission control support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230623152443.2296825-2-arnd@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8a338c33118f9..43173204d6d5e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1141,9 +1141,11 @@ struct ieee80211_tx_info {
 			u8 ampdu_ack_len;
 			u8 ampdu_len;
 			u8 antenna;
+			u8 pad;
 			u16 tx_time;
 			u8 flags;
-			void *status_driver_data[18 / sizeof(void *)];
+			u8 pad2;
+			void *status_driver_data[16 / sizeof(void *)];
 		} status;
 		struct {
 			struct ieee80211_tx_rate driver_rates[
-- 
2.40.1



