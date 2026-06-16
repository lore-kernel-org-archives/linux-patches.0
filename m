Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96DB466B4C;
	Tue, 16 Jun 2026 17:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631798; cv=none; b=iIEwGhlsAIosD4Uynyuw8xqKjIdtWw/tWNdOBdT0NP2Nb7YbpjpX5mhF7271s3Jlf6skjjH9XB1ShNHe1J9zhYca3hOosy6YeuexzLpN4KbvJ7+PJVH+Sm/qcd0deG2nvDaNDBR+5Jq8uTidrJZvGWsgTiyD79iMPF1bqglDNmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631798; c=relaxed/simple;
	bh=18DwnwYNghSfJ1gb31D3j+MiJt7SLZJmrFNrk0hJV5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeH7mP+3VJ1d/Km+wdmQP62ISoMvnl+PCfRuhWXV5yJGfx8GZpHf7DFxid0palBkD8DNMpC1OvH2mhMfNogRDzLe0NoEQ9FRbdNaCzHXBMPGPWWloq/fGUQU1Y6xFJN2Q8y2bWhs5vtktzpNTyifOw/ibTiIc96HCeQJ22ZQo6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuuBxmqr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuuBxmqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BA71F000E9;
	Tue, 16 Jun 2026 17:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631795;
	bh=HDOCfrkwb9k4TaSPUkcyY8JfpaZpfAvsfZjVEEYTS24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuuBxmqrSwh5xLkriYBpG+bgu0DUaj3f6L9ovQkf5yVV8F3A/ZB96c11bxz2JT3XI
	 et5RemUxIFicZDztV3bsyonRz4uUMnt7PMmKiEcTam+ujLKfh52dp/IzbaXsjb4mZc
	 Bo6DvX8jReTv6ilST+FK9XAmM+6x0xerQiHo/F1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 289/522] wifi: nl80211: reject oversized EMA RNR lists
Date: Tue, 16 Jun 2026 20:27:16 +0530
Message-ID: <20260616145139.456390250@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyuqiabc@gmail.com>

commit 4cd92957e8f8cc4ebfe8a5d4203c14c592fde6b1 upstream.

nl80211_parse_rnr_elems() stores the parsed element count in a
u8-backed cfg80211_rnr_elems::cnt field and uses that count to size
the flexible array allocation.

Reject nested NL80211_ATTR_EMA_RNR_ELEMS input once the count reaches
255, before incrementing it again. This keeps the parser aligned with
the data structure it fills and matches the existing bound check used
by nl80211_parse_mbssid_elems().

Fixes: dbbb27e183b1 ("cfg80211: support RNR for EMA AP")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/20260529152542.1412734-1-n05ec@lzu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5478,6 +5478,9 @@ nl80211_parse_rnr_elems(struct wiphy *wi
 		if (ret)
 			return ERR_PTR(ret);
 
+		if (num_elems >= 255)
+			return ERR_PTR(-EINVAL);
+
 		num_elems++;
 	}
 


