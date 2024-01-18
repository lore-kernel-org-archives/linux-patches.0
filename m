Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB661B96D;
	Thu, 18 Jan 2024 10:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575162; cv=none; b=kZuLwPc10tbOMSadvj3K34oKJed3LTzA7OJkI+pfq/uJY7JzSlXK1qNOFj9DubBBxK/KwVcGILR1RyNTj5W1DElJXa3Uw20LseJyS/T/p05NdU3A1Jt1dzrEBQK0AIfS4bM0vIoZ7d8p2dxTx2vTsy0bUnNzudXdHFujhDFIJco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575162; c=relaxed/simple;
	bh=oCcyvaEWITSV7K1F4NnUo9gZ0MiMBeMPANtS5FDdWUQ=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=N6YhLM8crwwedqwOrBNgZo68k16MZLK0wcNKiNaf/y99Zzk8tFejzljPpBzNlosMbSLKWNbKuOmHphXZbY3J6HM//u9VNhxgvhA5rzC0sThh6LMlbwaRoYLuBFUz3GWV0neU7m3175SznS2nTvAEZMvnjAXjnYzvKCq5WCHHvYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QouVyuCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QouVyuCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCD0C433F1;
	Thu, 18 Jan 2024 10:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575162;
	bh=oCcyvaEWITSV7K1F4NnUo9gZ0MiMBeMPANtS5FDdWUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QouVyuCJ2ZcB+0NC/yVcoe3Y6ahopGgNnfacmsaBMLxGwjaJmH1ySyWAMSF/JBsQP
	 N+vSUXp0M6Kt0z+oR8lPv5a/Rrto2l+gtatw0Ztj3N+g1IQ8TXneu1byzRHI/GykwJ
	 SdtOWtogP2akGjWNhp4+iGfZhbBMEzOmRcHYbad0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael-CY Lee <michael-cy.lee@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/150] wifi: avoid offset calculation on NULL pointer
Date: Thu, 18 Jan 2024 11:47:11 +0100
Message-ID: <20240118104320.470693373@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael-CY Lee <michael-cy.lee@mediatek.com>

[ Upstream commit ef5828805842204dd0259ecfc132b5916c8a77ae ]

ieee80211_he_6ghz_oper() can be passed a NULL pointer
and checks for that, but already did the calculation
to inside of it before. Move it after the check.

Signed-off-by: Michael-CY Lee <michael-cy.lee@mediatek.com>
Link: https://lore.kernel.org/r/20231122030237.31276-1-michael-cy.lee@mediatek.com
[rewrite commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 2b0a73cb7cbb..2fa186258e35 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2790,12 +2790,14 @@ ieee80211_he_oper_size(const u8 *he_oper_ie)
 static inline const struct ieee80211_he_6ghz_oper *
 ieee80211_he_6ghz_oper(const struct ieee80211_he_operation *he_oper)
 {
-	const u8 *ret = (const void *)&he_oper->optional;
+	const u8 *ret;
 	u32 he_oper_params;
 
 	if (!he_oper)
 		return NULL;
 
+	ret = (const void *)&he_oper->optional;
+
 	he_oper_params = le32_to_cpu(he_oper->he_oper_params);
 
 	if (!(he_oper_params & IEEE80211_HE_OPERATION_6GHZ_OP_INFO))
-- 
2.43.0



