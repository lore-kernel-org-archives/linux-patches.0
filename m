Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019321;
	b=2TSpJF9fb2LgMa3xqevRlhCNXvEWkg9c1d9Nm53WiHjRSH9+l3Wmg4J5ALG3nAsOyYdf
	 40VPoc1NmFKZH/etAt1PKcSeCrrcqHGEBZQFYkRrvgcmbS/EbczeOV5JO4XiHIOsDb2B4
	 bKLPuK5CiaLpyJJEIG0mDm1yewEqxdz0/Mltk9HuQZ6ez7bKsButGx6mH1QreU6yAkCSs
	 BHdR3SKxwyolHQyWPhn0rY9rgoNd+bkR+Tda808SPcNa6KfzYLASw+0Jk+qeXVuxAP3lu
	 sGaePs5n1FL+EE276Yur4jtB4/zwd+d1EKl+sHx4QLOEGw55zUbTPtfzQJJGfkD3X/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pYdalanGZkFTaAXuXHkknpfEEyX8k5ujBAT/I9I57MI=;
	b=D1YNoH84YDZZM0IxbQJWH80RrH+RyQMv1itfVbGryO9sa1d7EVFKsvBslfR9m7auvMDb
	 AfvRiqwtNxoDQG42f2TVBjHi6SI/vOrCvfabsil/S/Hk33MnDuFiF/FJEG1HWrTTq7t9W
	 bOcVkMlMjOHWAXLhQ2hRhm1Lw010qbbTtx2DgjKSBuJmhUr3YP6W5W7NQPDGHI7q9ivfv
	 LKUTkGW2i08QqjAP/UO7lLL5pOs8Z0IQoQFAyR/QQDiruSivj/AGD7C3GH5CAEM9h7emp
	 5P5Bx0et5fqoCz+mWvF7A77Le+JXUDF5yfn+bkfEaqMaY01ZON8nSGjMcm7r3n73F3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4m2Lqs5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FCD60A260E;
	Wed, 18 Nov 2026 16:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4m2Lqs5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27D21F000C5;
	Wed, 18 Nov 2026 16:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019321;
	bh=pYdalanGZkFTaAXuXHkknpfEEyX8k5ujBAT/I9I57MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4m2Lqs5k6PTZtNX91R1kO8OfS1MXouHWeyY/SilxmUKEsj8if+lOmkbZUi1scI/P
	 Af4eceBOb3XWCOZRxhf/XRGFaXprlP1c9IREE2+NDMKaecoe8I50dx6/L3FIRmdzWI
	 hopwXDWJFe1Soohf+0QoWalPRWmhb6JYaW1af1Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1554/2651] wifi: mac80211: clear fragment cache entry is_protected
Date: Wed, 18 Nov 2026 15:46:34 +0100
Message-ID: <20261118150343.902007485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f3d29dc9224b0881d10d34664456adf113bc4777 ]

In practice, we probably shouldn't end up with a fragmented
frame that's protected, filled into the cache, finished or
dropped and then the next frame is unprotected, since only
unicast data frames can be fragmented.

However, tools complain and it's more correct to be able to
do this (e.g. an unencrypted fragmented EAPOL _could_, at
least in theory, happen), so clear the flag when the entry
is reused.

Assisted-by: LLM
Fixes: 7e44a0b597f0 ("mac80211: prevent attacks on TKIP/WEP as well")
Link: https://patch.msgid.link/20261005224950.c3e4106f34d5.I866c0862db031c3a810d2333acdd22e2733d2b8c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7ead509304ebe..aa8e3e375e075 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2309,6 +2309,7 @@ ieee80211_reassemble_add(struct ieee80211_fragment_cache *cache,
 	entry->rx_queue = rx_queue;
 	entry->last_frag = frag;
 	entry->check_sequential_pn = false;
+	entry->is_protected = false;
 	entry->extra_len = 0;
 
 	return entry;
-- 
2.53.0



