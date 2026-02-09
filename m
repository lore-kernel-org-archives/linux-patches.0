Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E4428312F;
	Mon,  9 Feb 2026 14:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648883; cv=none; b=GuWohZHk2vT4HCKiqCvqwh/B43pc1j/om/iVt8/XZsSiNNUmIZMu+sxH/lSLGi7lMe/TkTYPg3+ceUD3a1P3aIMUl6HI2SgYzrB9BwiXfn07XqO9mCuwv2txqRZCFBieuJluZAbdtWm/qdSGkXsm5afwTrVYJUEAWBVYI75Rbis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648883; c=relaxed/simple;
	bh=vnVqSDCGN2ZWWl3N0uKW0TWJ1LhWvR2mI2IFU/hm+6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=do/hkPyec3zNDLLZt9ogWIwBK9LmjnTbBZKefdfCE2oKSwpXx/OiRIUWpkK2ZLHaeVVAV3dsr2SdCBeNbHz3T3YnI24TirTqC5uQpC2MR3m9aAIJ62lqSmt4JMGZITtpip3e5Yowg21yaKAdNGBUaQkoAtSYfSJke4VnckcK3kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5UdBTKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5UdBTKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48E2C116C6;
	Mon,  9 Feb 2026 14:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648883;
	bh=vnVqSDCGN2ZWWl3N0uKW0TWJ1LhWvR2mI2IFU/hm+6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5UdBTKKwXD5xz6F06zzNg4F7mbqsmixyoJTMJbspeGx5sLZNHRTIpS74fdF3hhDW
	 MHKjcR/GbMDKivwJJcNSYIuzpAEVn3MdxmNpjOSOY3HtTzA0ejOLqf4PCUi5eMKenf
	 clUHyki1mQ003L1T37be9V3HZfEXzr4XDMTga2Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 43/75] wifi: mac80211: dont increment crypto_tx_tailroom_needed_cnt twice
Date: Mon,  9 Feb 2026 15:24:40 +0100
Message-ID: <20260209142303.396275185@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 3f3d8ff31496874a69b131866f62474eb24ed20a ]

In reconfig, in case the driver asks to disconnect during the reconfig,
all the keys of the interface are marked as tainted.
Then ieee80211_reenable_keys will loop over all the interface keys, and
for each one it will
a) increment crypto_tx_tailroom_needed_cnt
b) call ieee80211_key_enable_hw_accel, which in turn will detect that
this key is tainted, so it will mark it as "not in hardware", which is
paired with crypto_tx_tailroom_needed_cnt incrementation, so we get two
incrementations for each tainted key.
Then we get a warning in ieee80211_free_keys.

To fix it, don't increment the count in ieee80211_reenable_keys for
tainted keys

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260118092821.4ca111fddcda.Id6e554f4b1c83760aa02d5a9e4e3080edb197aa2@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/key.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index c755e3b332de0..88cf9e63dffe2 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -910,7 +910,8 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
 
 	if (ieee80211_sdata_running(sdata)) {
 		list_for_each_entry(key, &sdata->key_list, list) {
-			increment_tailroom_need_count(sdata);
+			if (!(key->flags & KEY_FLAG_TAINTED))
+				increment_tailroom_need_count(sdata);
 			ieee80211_key_enable_hw_accel(key);
 		}
 	}
-- 
2.51.0



