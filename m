Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54103158208;
	Tue,  9 Jul 2024 11:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524155; cv=none; b=Hs9DSjNM/AEar2AYHoalHGtKdDvXM40ZJtagC/Ap9YmnVdeUWxO2w2qCWQxmyAPZYP49e3ZB+3MMD5qOgBKred1cndDQUTg2R3fOD7PAAwLmBEhFKcEcFM/5XPkKe5WdxMopBwcZ/vLbNPUIDpQc9n6yNsikotpEiODxh766o4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524155; c=relaxed/simple;
	bh=TBnevPvt/pGRMxaTXgi+BOwYzytxAvgjZsY3UMWX5rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCs2RadrHN02M8mA9cF23/edWBAVa7+c2rP9M2nf7kpjpJ+z/hEArLXENTWplolwBR4cKSjFJJdTesSD496h8/WOGP/7exzDz4937a4ZT/57RDogjyTuQCnR6Kg5K8HzI1qlBNSR4M75GgYPf3UZQRWP+88BDVUrjUZhzwRKl8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDpp6uVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDpp6uVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887D5C3277B;
	Tue,  9 Jul 2024 11:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524154;
	bh=TBnevPvt/pGRMxaTXgi+BOwYzytxAvgjZsY3UMWX5rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDpp6uVKDzx/Ta0FOJGPHchTAPvqUU7+xhjf6mhyVbtcSB9gwm51ktY3QLu4gneRI
	 wZ+2XzRk1DA/K+ZPjdFnMs7HGu2bhJaKLuRrNR8DTDFEYFy/HJJz2A9tpAMH2jRLXj
	 GOeJP6AN1YufbVbZPnyPaZ8iU0LeLqxHMaQvSgcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 088/197] wifi: mac80211: fix BSS_CHANGED_UNSOL_BCAST_PROBE_RESP
Date: Tue,  9 Jul 2024 13:09:02 +0200
Message-ID: <20240709110712.370387629@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 816c6bec09ed5b90a58a1e12d5a606c5b6e23f47 ]

Fix the definition of BSS_CHANGED_UNSOL_BCAST_PROBE_RESP so that
not all higher bits get set, 1<<31 is a signed variable, so when
we do

  u64 changed = BSS_CHANGED_UNSOL_BCAST_PROBE_RESP;

we get sign expansion, so the value is 0xffff'ffff'8000'0000 and
that's clearly not desired. Use BIT_ULL() to make it unsigned as
well as the right type for the change flags.

Fixes: 178e9d6adc43 ("wifi: mac80211: fix unsolicited broadcast probe config")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240627104257.06174d291db2.Iba0d642916eb78a61f8ab2cc5ca9280783d9c1db@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2d7f87bc5324b..baaff7bc09119 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -395,7 +395,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_HE_OBSS_PD		= 1<<28,
 	BSS_CHANGED_HE_BSS_COLOR	= 1<<29,
 	BSS_CHANGED_FILS_DISCOVERY      = 1<<30,
-	BSS_CHANGED_UNSOL_BCAST_PROBE_RESP = 1<<31,
+	BSS_CHANGED_UNSOL_BCAST_PROBE_RESP = BIT_ULL(31),
 	BSS_CHANGED_MLD_VALID_LINKS	= BIT_ULL(33),
 	BSS_CHANGED_MLD_TTLM		= BIT_ULL(34),
 
-- 
2.43.0



