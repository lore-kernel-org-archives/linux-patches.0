Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A4C14B95F;
	Wed, 19 Jun 2024 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802700; cv=none; b=jkGcLNaerEpCfijMw4ddzQbiVzuUsZnPSd6C381OynBIxUrQtQd/0GB7VVxgyfcr1Rctu3PVXpYvGeVJZLd4zn+sHZs2GCN/kk2ic3wNVkVUzzAppVCM63Eht551hwt89odYidB6lYVUvBhzfo7KVTNwPxq1kJZB5wkbBgoExFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802700; c=relaxed/simple;
	bh=gsGny+SVkNfhS1xYXprJpF1QJ7MnnBDnN81Hmuya28Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D3BGqOe3UfpF1dZSaUWMVM6yXOW10+K3Pu/CenJiWxnffvNjd3myArPYDms+cmyW3yrxCS2MtcWzYOm3JE0j/zm8EncLPsWf8sLvdgvosdMokDGgptqToy+C8i03V9i/bn0WZhY77jizq5c2fABGSN7IM5XgNWa4v4830kaVQDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYfip2d9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYfip2d9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C95C4AF60;
	Wed, 19 Jun 2024 13:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802700;
	bh=gsGny+SVkNfhS1xYXprJpF1QJ7MnnBDnN81Hmuya28Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYfip2d9IlWz6rtrUR+HyKuAm6WYNYIK8/uN91Nv883nqFGrKGQo6SujF4lkkGPd4
	 EDkYzGTifN7lhy4c2dhcFw2KGtuO/GfGOk52B6CteH8/DngYGw3XH2wWtJYTaChY1h
	 vn2eQOx/RA0n0WDWUrgv1vjWiqrfID3VPRBkOPMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lingbo Kong <quic_lingbok@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 018/281] wifi: mac80211: fix Spatial Reuse element size check
Date: Wed, 19 Jun 2024 14:52:57 +0200
Message-ID: <20240619125610.550337557@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lingbo Kong <quic_lingbok@quicinc.com>

[ Upstream commit 0c2fd18f7ec552796179c14f13a0e06942f09d16 ]

Currently, the way to check the size of Spatial Reuse IE data in the
ieee80211_parse_extension_element() is incorrect.

This is because the len variable in the ieee80211_parse_extension_element()
function is equal to the size of Spatial Reuse IE data minus one and the
value of returned by the ieee80211_he_spr_size() function is equal to
the length of Spatial Reuse IE data. So the result of the
len >= ieee80211_he_spr_size(data) statement always false.

To address this issue and make it consistent with the logic used elsewhere
with ieee80211_he_oper_size(), change the
"len >= ieee80211_he_spr_size(data)" to
“len >= ieee80211_he_spr_size(data) - 1”.

Fixes: 9d0480a7c05b ("wifi: mac80211: move element parsing to a new file")
Signed-off-by: Lingbo Kong <quic_lingbok@quicinc.com>
Link: https://msgid.link/20240516021854.5682-2-quic_lingbok@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 55e5497f89781..055a60e90979b 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -111,7 +111,7 @@ ieee80211_parse_extension_element(u32 *crc,
 		if (params->mode < IEEE80211_CONN_MODE_HE)
 			break;
 		if (len >= sizeof(*elems->he_spr) &&
-		    len >= ieee80211_he_spr_size(data))
+		    len >= ieee80211_he_spr_size(data) - 1)
 			elems->he_spr = data;
 		break;
 	case WLAN_EID_EXT_HE_6GHZ_CAPA:
-- 
2.43.0



