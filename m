Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031340;
	b=UWp5ni2yaQ4FeZChVFZH36IrKiRjmc/j0SDQRMMXthUXH/Bm2VN4udXyG5nmx2r1fiTi
	 zkRdN/mnyfMjw/2MkAmPvAE5O49KZ9feKaMePVrzYgwn9FsgzriCMIvnJkMuGWx077UBl
	 lobgpLF1Y0rqu5edFRT8GniPkS4masy2eIPGZBDKgNORx5+pF2oGfsY4I16MsnfDxuSkl
	 aVPRVgOKUbChvXVFV2bpBZedQsIeLrRv4XCisG6BRgAz7GjLflACRaqRtWgJ3RehR/S9g
	 TnZow8a/W7m3sLM6Iix/pKK0uj2nsuIHdyZUOj3BygLV8RDQIm3KvFA5YroBSZxMChg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1TCY/D00cGOZCrDV8yfSxbn/Vt1AUY2kqOGHDSnIwJU=;
	b=eZzaO7GMLYKwttwJLkmkIxeFt621fi/lReei8QVfqj5ZnKo9bwzApqjtNssp3mlZbkFz
	 +ELyAo8CTz2J8+YehdXv/9WedYZuf4rj08t6d1S7DEU2iy0Vp67xpKYn7l/uTYGTu09tm
	 u0DpvNk3tsfCNA0cCCIbpJiaV3jReFTakN30TZEPrcMyeCi5wKFlTppV01H+KYQmrqBgq
	 2yu4/4IlWe8QTT3kv9OqFZNCaFXuLon1g2U4YGwIPM70aGCBTyDtx/EQhvNd4gbjnf2+g
	 /niFPghmn1ienHDNCVMumZ9WMjDSzbSEQl50MXMGgMkdrhUh1Q+WGSZat9CFbhNZG9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcF73Gyw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF621606A320;
	Wed, 18 Nov 2026 19:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcF73Gyw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C541F000C4;
	Wed, 18 Nov 2026 19:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031340;
	bh=1TCY/D00cGOZCrDV8yfSxbn/Vt1AUY2kqOGHDSnIwJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcF73GywDvO7tVtKd4/2mUc8OyHpoDpiGwbhm1OJKi32J8GiK3NakvQPxOQP06nDm
	 zVvU4RsQxEVtw8ADgvE3OIRRm6/F9WT7kjgOADKV6X2kpjjz54QLctBC6crb7AJQ5+
	 ydQSNcEY++viC7A2KcrRpv9VOlfy6V70wtmOy1q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1025/1756] wifi: mac80211: kill wake_txqs_tasklet on unregistration
Date: Wed, 18 Nov 2026 15:52:32 +0100
Message-ID: <20261118150050.897067689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a65d49e4402ad..34a2241335693 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1694,6 +1694,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	cancel_work_sync(&local->restart_work);
 
+	tasklet_kill(&local->wake_txqs_tasklet);
+
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
 
-- 
2.53.0



