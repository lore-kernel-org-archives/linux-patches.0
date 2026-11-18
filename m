Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019330;
	b=DC1frDqeXnxm8hnyKCtKNdX+7CqFFOFkiIiSBEn3HiGn14ON0MaRArHpC30pI8Vtnhtr
	 Zj4DyMeS0irpWWpe4EXukCKjN8mX4wXDa65cSWwSNVk7XvSaYUOfEztBUlE3mzArrciC4
	 RzKXLgPuuiiwub1WwgHav+vAdgDzzAkcAt8unw8WgUeC44f9OmARNJ/AJTJR9qeEqaIFC
	 N16flRXqsxIQaPAqMbIK6yFtr4Pq4+ZVDHNwaXD/BZJjilKt/AxJcssX+kE1RrLCoXUHH
	 1RbTIpxPX0V/NhD+GSjq4kk+yi5O60tT/9rQZrAur1unZyBDRH5BM7L5wKCADlIz8QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pM3ZQwE0g38dDI1CxDWxNH3ZzQZ5bmDp2AOl3aA2sZM=;
	b=IcG/Z5afO6iGSV75bX7uqqTP79LCL7D0rhW67h+HaQS5oCu/8V7fJ1CuVTJRSAQ2Q8QX
	 tw44XajEc6EWW2knfYkZvPlSgW+DljBs0uoTfapLzRFj7nWv0hzVRhyQrjc73AmPU1Z5R
	 SJShS7J4xGx3uC/1fywcOz1lexhaeRLLkB0BgDFy22aSd9kJi2UsNtqvWs8fi1F/fIVaC
	 4oCu2AoCl3QwLkfD8Xsuml1Zou/Cbib2deGPR6sajcu1rDLwvEgf6jWp4TJVIarwJafkH
	 cT/mjedz44DcYHINnEdH4X5HnN/ktd1JiGWZTJVRCR5s2DRBsp/LjL0K9HfHMdmpu/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P+qeXDFz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1846460A261E;
	Wed, 18 Nov 2026 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P+qeXDFz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A97F1F000C4;
	Wed, 18 Nov 2026 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019329;
	bh=pM3ZQwE0g38dDI1CxDWxNH3ZzQZ5bmDp2AOl3aA2sZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+qeXDFzInaGsV2hoCAeL+z1QfdqN5noHmIhZb0O6oXT74apoRuZLZNdMufqU8X7y
	 K1/Vngq2BcJ0nhC2G8II1nkLro+TSIaBy92DBW1LnMAXHmuqPzTMwwSBJfz5AQLWHO
	 1sU26Qd7XLpndGmCi0BN4Tzl36wrkakzA0hOPJOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1556/2651] wifi: mac80211: kill wake_txqs_tasklet on unregistration
Date: Wed, 18 Nov 2026 15:46:36 +0100
Message-ID: <20261118150343.970228903@linuxfoundation.org>
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

[ Upstream commit 8ea4f50c3426aaaf3f4c118ee2c2876326ca5db5 ]

We never kill the wake_txqs_tasklet so it could be running
while the hardware is being freed. Kill it, late enough to
never be able to restart afterwards.

Assisted-by: LLM
Fixes: 21a5d4c3a45c ("mac80211: add stop/start logic for software TXQs")
Link: https://patch.msgid.link/20261005224950.3fdb8d0ff377.I851e79ac625c4926e211642ee7a7e458728b0ad3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6408e8464338d..674f35663b3e1 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1732,6 +1732,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	cancel_work_sync(&local->restart_work);
 
+	tasklet_kill(&local->wake_txqs_tasklet);
+
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
 
-- 
2.53.0



