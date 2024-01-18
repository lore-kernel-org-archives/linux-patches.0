Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A396A23760;
	Thu, 18 Jan 2024 10:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575583; cv=none; b=XDfDcimpPkO0cvODiB93H172+UAEnbozFrueu+C1ItH4rU1TpCW7ST2dKZ8byr+XeM9euxCXlIgw5YplCL1XYXu28xkKijVjlLqh9E2ncDDLjZ5euy1VCx8KDwc/YnT6vhV6M3QljPIE6ypepEhvsSn5OFhOPXiam4ZPzbs5mLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575583; c=relaxed/simple;
	bh=ERhoz/TyLo8yn0MnpOhry0zZCBA2s1uedCRYuh4Qc6k=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=SVwGFN7rbSIcSDp1tfegeCRNrIwYiZapWJ2MTe76YtacROtL9n6gyxHskg6JuHXW+cnnRvQavtDXCVgWj0lLkTReXb3EqvS5qC68Y91EeITyR6/eDfXxiLdBXB3jxkZpw+FamXs9Oc4WTBqirVECEJ/mMk3r2IL5FgioTse/OWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDBS6C2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDBS6C2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04FCC433C7;
	Thu, 18 Jan 2024 10:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575583;
	bh=ERhoz/TyLo8yn0MnpOhry0zZCBA2s1uedCRYuh4Qc6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDBS6C2WcSHJhBV31tbxbo6F6x8ATSOwuZCwq0LFre4HbkXrKBVLnwJ8ip3/haAhg
	 VohUBm1NYhhExl8mxRu5uC/U6Xqc+BQ4CdoFwkqwcsejCwlHKv3QWmOk2TSPQHyu8m
	 pmc0Tipjz/fn12pZsd7imd4PVCPp9Y6HcHV2SRSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael-CY Lee <michael-cy.lee@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/100] wifi: avoid offset calculation on NULL pointer
Date: Thu, 18 Jan 2024 11:48:14 +0100
Message-ID: <20240118104311.146831353@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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
index 870ae4cd8202..dce105f67b4d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2658,12 +2658,14 @@ ieee80211_he_oper_size(const u8 *he_oper_ie)
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



