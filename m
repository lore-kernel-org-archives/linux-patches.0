Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026149;
	b=ab+HX9mDr3lP+sd/F8lcOZ9oem76B3R8T+YL5ONXXfAnBH9hEbpzIT+P58X53EgwZliW
	 dFLkSl93znEqRGPqJyNKxk+YJ2/gfbxN0Rj4LboJ6BzMKKCeX5yYTUv3CKBF0C9QIOKcF
	 N4mntd0G08eKNSVPwkWAPZnzZRq9SUa6R1KppVvChipkCBUBUinn46grjiixuZZiRoG6r
	 0wWymXOrPI9xxxe419iZPOTR1+7JrHlamEx3bAjhwDp/nWDR4Bv7mCZau9YGcmWh4ecWc
	 +6eT+bdt8dk9JQB26w0dG0RwzoaGY6SSj2cs0TMzHTlbUjRwtEx0tyGdxjr8CREA7cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1faxNjCNJZWS2L8QpIoeNN4IwIrxt3jpR+K446FEN5c=;
	b=r+ImTxNWz98b9jEVejvIllGKkX8Ll2+hKgGVtfy+HkVmqpiSzF3uz3ynPn4sDxQ0oyDW
	 t5kyvKRaoDfNWbCm8FIOcmYovv+erQxzbB25AaQs6P+C739MKdwXw7lKrOy08MANvqLgD
	 tFNNTLHeehJFCzSHKZMnfmbRdcwVPhAXlYmqBQGJ1mD2cXKijoo4DWrvgFvtmR+34SEJ8
	 N00VGi9JStot+ODnVc7eR2QB8PCkvHjViQk1E7nldCHbq3+uAK3ws5kscHaFzVwMCs3V2
	 38IDHtIAIevpE0J8aTsru/WQJWktggX8RUbz8g3xqtftpKJO71FZaDaTrAXsnTJ/ttQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p5fzQcsl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB84A606A31C;
	Wed, 18 Nov 2026 18:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p5fzQcsl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066B61F000C5;
	Wed, 18 Nov 2026 18:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026149;
	bh=1faxNjCNJZWS2L8QpIoeNN4IwIrxt3jpR+K446FEN5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p5fzQcslqaYGlU+p7LOurWybqiL11XQRmDexD5MwXWOU/6j5TMzUNZkvwy3+qPveD
	 SeZx8sZIHH8WRV1sJgzrfBSEIoVZQalyqxQ9LQ4Hs/TZ9/iOu5d4YrTG5huWOQOB6U
	 Q5A0X7twgZum3d0FltfucLhGdNRYakGi61PfZCZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1291/2151] wifi: mac80211: kill wake_txqs_tasklet on unregistration
Date: Wed, 18 Nov 2026 15:50:26 +0100
Message-ID: <20261118150209.152957839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b62ef65db40de..589698cdc14b7 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1698,6 +1698,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	cancel_work_sync(&local->restart_work);
 
+	tasklet_kill(&local->wake_txqs_tasklet);
+
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
 
-- 
2.53.0



