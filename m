Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055990;
	b=CoMKNcPoOpadW4b1Bt3QVFzSbABYg43q67PWFDXnuYjzlc5Cpa9wTv5ZzkouF/MQoH8k
	 Ae7jvzW0Xww92O5x7dx85/o1zVqHbEXWBnDsUCo1T/uHhqR9HDRFJGwy01RvJ7SmqEn7u
	 3YTQJArBaLNizWxQ31OPAuLXXTvOHH5/jlbFz6CKB/hvAPeEv8JEXp+z3BtKhNshbWDLH
	 Xn4l+jyMaqQA69yknHewkvFih8Nr2cjix22374Y5xbFKdO6gsKYFyYiZL3RF+Bw1dTitC
	 nOQ+QdAWuzdIZNmfLAwxOWblPk5DacT+vmRN5KWZl5yGSasTl0ELxR2RbxufKv8p2CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xuryWluEyqEyZQNV9ztqgsu7fjxX+aASM8sfRO/+R5w=;
	b=2TyJoE/PC40DXnxs/DOd4JVUhenfAOtIVbOR4ATc9VUGs8VdbvKBy2XNPsiqAxKf3VTo
	 B6yVGMoyeL0EKEkhk9n6JoPqiBgDbLXyGHHCzi3pWSQ58zOi3JAXnD5nd+i9gfF26P3XT
	 cUw8Z4DXyvBxIE0TsLZ48JmX/3hlgz/ApYCfYJxxmHrDs6Tyt0M6RodqPJSrOCITViyDU
	 DhBsSo85KmtD1LaHrZM6OrMgrJQ4RPIVWRapDjMukdMPI6QNF6LdA7uCvh0EwS7e7IWTa
	 4xgCKpsXMo+kjWvH0SX0Zj5nMZaqhNC98SAToYF81SlOCBP3qPVlnQ15a4BeGbCFXnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YPM/FjGS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B37606A325;
	Thu, 19 Nov 2026 02:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YPM/FjGS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10D81F000C4;
	Thu, 19 Nov 2026 02:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055990;
	bh=xuryWluEyqEyZQNV9ztqgsu7fjxX+aASM8sfRO/+R5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPM/FjGSh52hOlzl81NoDBL2qJWzOnJo2zbc3DhQjWgOmC8K8Czfti0bV998PwkWF
	 LQ0Lk1yg8ZatBOA2he2VWo18kT57024YqM+KoAmRlH/KDAzPy0kPYDqBl/+VZaSlJ4
	 6kXQn3OBeGgtFfSvRL0MYcADZu/lLwm+jpQ+OtFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1829/2214] wifi: mac80211: kill wake_txqs_tasklet on unregistration
Date: Wed, 18 Nov 2026 15:58:25 +0100
Message-ID: <20261118150124.608237357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5f2f589d07708..ad1cbafe4ae69 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1407,6 +1407,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	flush_work(&local->sched_scan_stopped_work);
 	flush_work(&local->radar_detected_work);
 
+	tasklet_kill(&local->wake_txqs_tasklet);
+
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
 
-- 
2.53.0



