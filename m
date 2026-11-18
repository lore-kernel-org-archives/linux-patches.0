Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061562;
	b=xCoeRJgFZKIGpvCe6PMpIoSBS5HFvxFAj6ZgOxayCGje/tWmhThCXFfaGQGGaUkaOUQ/
	 z9kSxq7mC+IbrnrJVCcMk03hartsDRWaFBXBxdTHPOoebTwF1she7BpSBp1utsF5K2dNB
	 G1mnOC7eDhGDFIHqEN2fbfcC30sedGIFiOCCLgEmzITRnK5+uuA5ngy9bibf0vxU4Y1te
	 IfJTs4wsM6PXJ+xopNUh2219BfUIX9y0BF4lePEtqNEWyA420xikD6u+86c7HNqv9g9sL
	 mR0BxV39NS/4se/OGGPAxROKShHcaXNnDtH7yWd7VpHyaWzm7+bmwwkTUekJYEp51JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/DxEtwDPVRyg6nVSexxKYCiZOgEGX0fFCnUkOAw2KRY=;
	b=f59odzHBvmN1CCfJ1MfOA6dNXxtt5S1GuwFj/jAKPKj0OVQruMY6Fbr4nvM8r3FxqLDb
	 MfMw/mGkwP3Exeqj0xrG/FKETx/wN0+JNkb1Yhn5z9BpabxqoURW14dgDWK3A/I6JbnKJ
	 W0tXRhS1OZBB0X1SznHCJ839KdzzsQLIq7ULDhWo5Bh+z80yUjUS/OLLd4ksqdzBpAx/3
	 E2RG/V0fMFbT5vFX1nMJt8q06xym6sITzksRuI9Xn5IhlXd4TuWxR3IALDsPYHWiw2shL
	 I1KV+weTJVTL3O2Qg2/QvTkj9XeEkSlGYlF8na/+H6qyFhj5lgEgMCVnChS4Jx+AFKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xrv4l8m5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80D060A2615;
	Thu, 19 Nov 2026 04:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xrv4l8m5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C172E1F000C4;
	Thu, 19 Nov 2026 04:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061562;
	bh=/DxEtwDPVRyg6nVSexxKYCiZOgEGX0fFCnUkOAw2KRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xrv4l8m5sa/ZzZ49JKwDc6pTh/aQlONRcg/nIxRz8DWJMJzljujBYOomsOqpbX7F+
	 OA1QundyYDTyPKn1m2GW9SuSmGOodFO1qvGF48QV7RPszDXKJm5FVAb1HZMB43yvon
	 51BW/BURc/ZDdbAMMzM8OsU6KDlvZwAgTWp/E/ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1555/1848] wifi: mac80211: kill wake_txqs_tasklet on unregistration
Date: Wed, 18 Nov 2026 15:59:53 +0100
Message-ID: <20261118150024.705711460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4f6013102244c..3c268dd598aac 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1393,6 +1393,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	flush_work(&local->sched_scan_stopped_work);
 	flush_work(&local->radar_detected_work);
 
+	tasklet_kill(&local->wake_txqs_tasklet);
+
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
 
-- 
2.53.0



