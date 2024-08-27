Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDE91C689C;
	Tue, 27 Aug 2024 15:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772110; cv=none; b=GbTAwIBXchqcdQfbGr1+lmIHBtERk/d3oCcSVM5VWnZYFHOoT+Qv+55ycCM2tW5Yee4Yr7bfGnw/CNES8MPNytHWk4+ZmI4GztQU+znqr6GQ6APsdPZZYFNg4nJd1PldEDBu8CbDi66xrzvhdtfVKEjdIgKWByceD+l/PtoVt0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772110; c=relaxed/simple;
	bh=I1TGjy/mcQVSUYccvnuTmPCEaJN4O89XFlC0L2Yicvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoIDizd5+wqPXlsXuSzybKD7HYnxsoL3Mi7KlKapYaHRWde+UGE4lCz+Ifo/Q8u3ePvZFIgXz/e2xczvIhWgb/nd49gOlmbiJRenfy7YAvIxeul480UlIiYoVB8ebg3GAUvmQgWLJadlxasQ8gRrFEAKvkWG9Y5LN/DIN0NfPt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xibqdXPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xibqdXPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A19C4FE08;
	Tue, 27 Aug 2024 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772109;
	bh=I1TGjy/mcQVSUYccvnuTmPCEaJN4O89XFlC0L2Yicvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xibqdXPEd5gxZXzgrszf8grwXauSYM7udN+cS6I9Qo2DsjiwYpQOqYN4BFcO32Jk8
	 nTJSv9V6BBuMnfIfCwyvypRucX6zlY9TDymqLC5eFWrUoerAHjsxKgVi6yWoIdXojo
	 DTyOohzlJpSh6i6mwGHmwioZ1wRnZ4AjZKPU0vwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/321] wifi: cw1200: Avoid processing an invalid TIM IE
Date: Tue, 27 Aug 2024 16:37:05 +0200
Message-ID: <20240827143842.697842615@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Jeff Johnson <quic_jjohnson@quicinc.com>

[ Upstream commit b7bcea9c27b3d87b54075735c870500123582145 ]

While converting struct ieee80211_tim_ie::virtual_map to be a flexible
array it was observed that the TIM IE processing in cw1200_rx_cb()
could potentially process a malformed IE in a manner that could result
in a buffer over-read. Add logic to verify that the TIM IE length is
large enough to hold a valid TIM payload before processing it.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230831-ieee80211_tim_ie-v3-1-e10ff584ab5d@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/txrx.c b/drivers/net/wireless/st/cw1200/txrx.c
index 6894b919ff94b..e16e9ae90d204 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -1166,7 +1166,7 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 		size_t ies_len = skb->len - (ies - (u8 *)(skb->data));
 
 		tim_ie = cfg80211_find_ie(WLAN_EID_TIM, ies, ies_len);
-		if (tim_ie) {
+		if (tim_ie && tim_ie[1] >= sizeof(struct ieee80211_tim_ie)) {
 			struct ieee80211_tim_ie *tim =
 				(struct ieee80211_tim_ie *)&tim_ie[2];
 
-- 
2.43.0



