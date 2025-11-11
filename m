Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC5A2D29D6;
	Tue, 11 Nov 2025 01:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824049; cv=none; b=r0EuPTve5CkV1LiG81UX45dDphuEU78Rwo5LUsv5i3gfzdbbSkqLsFpIaD/M9KJx4rDCwp/w6el//FCsU3gEbpFxIUhL69Dx3Fm42dg/CqQf1QcxnbyuhmdQr3PDPH1zP7cHCwlX1UgFUQcJfCVvShTafV8d/82tmQxGR0mLSvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824049; c=relaxed/simple;
	bh=7KnNUBuE/dBQBmEKIQoTzQnxuNUvO1/435Bp6P1tsMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHRIe8b4+7APuDRs+MyJH0dX7R+x/AyniWjtaJNcfLa/UBlwOA54FiWBIIYoBhIHvHrSDgGYpOV1Z3L6LDXQhf2EH4z7NtRZ4tgPCRCn54lBtY+gUNT/OaGdbxJFU9w3E97vQ0d1tkTBUEg+gBcJuMnck1vJ3J7yyAn9XnATAxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F78mLGda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F78mLGda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA520C116B1;
	Tue, 11 Nov 2025 01:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824049;
	bh=7KnNUBuE/dBQBmEKIQoTzQnxuNUvO1/435Bp6P1tsMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F78mLGda/21KU7WlZ6RWqqG6qXHgZj0DUtySBJ/jolTemI5+Uym7cNF6ELCF152t4
	 pQVz8+ypbR3YS6zDTdxE3FFkr5qEzekF5Mro+h/vNinzLIG0sj0bUCWX7CmPeyGPOv
	 +bZtMFqs4uUfruIzm5EBzjW0F5kwJJZF6hETaH5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 427/849] wifi: mac80211: count reg connection element in the size
Date: Tue, 11 Nov 2025 09:39:57 +0900
Message-ID: <20251111004546.760003417@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 1373f94148a5adac2f42c8ba9771105624fe4af0 ]

We currently don't count the reg connection length in the per-link
capability length. Fix it.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250826202512.b14fc82f736b.I03442382e8a07f6f9836bcdac2e22ce8afbe6a21@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dd650a127a317..f38881b927d17 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2112,8 +2112,11 @@ ieee80211_link_common_elems_size(struct ieee80211_sub_if_data *sdata,
 		sizeof(struct ieee80211_he_mcs_nss_supp) +
 		IEEE80211_HE_PPE_THRES_MAX_LEN;
 
-	if (sband->band == NL80211_BAND_6GHZ)
+	if (sband->band == NL80211_BAND_6GHZ) {
 		size += 2 + 1 + sizeof(struct ieee80211_he_6ghz_capa);
+		/* reg connection */
+		size += 4;
+	}
 
 	size += 2 + 1 + sizeof(struct ieee80211_eht_cap_elem) +
 		sizeof(struct ieee80211_eht_mcs_nss_supp) +
-- 
2.51.0



