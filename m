Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60D01519AA;
	Wed,  5 Feb 2025 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764836; cv=none; b=HyhKhSX7DZaJ04mEgJ7G4e9Z1Pu6E1PSX3btUYe//r1NoXdf0qHsAAprOcpnfnwi3uqvZnFS1bKexSPPOocz9nFOKjMOi5HG81lTzvovNjIvNie72ch6/kukH9nNur0CEb3W8+x5U1jAMLcXlmNTBwG6RU4B5iyk06hmIp/Kqgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764836; c=relaxed/simple;
	bh=9Fzb4mkkqA8sxwFn3is0IMf8Bv3Ik+u8tyjBWsDOVGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duJ5rGkG1XfPIBIB/1HqHIohlo1YfEqgSTa1K25CkLq9Q4PI29Aryqe4RxxFsmSKF+vTkLQ9pk8sgIUvvvADy4WU6smVr91dbPXjI3Khe38gMctzrIvTzyOG3jpFwwk/wbCJ02LdSnppbgZfr43qgC8X1f50U5ZOJTPE57Tpcy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNoiZXuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNoiZXuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2489FC4CED1;
	Wed,  5 Feb 2025 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764836;
	bh=9Fzb4mkkqA8sxwFn3is0IMf8Bv3Ik+u8tyjBWsDOVGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNoiZXuwoB1cn6vmXnBnCk6quU0nXXsgBJ6BPmQ4JtpcO3aNeuQbERS/6Cw6qqx0P
	 n2EPmvjsOSB1i9CRs/f+LNNgBFWJJzb1/wnBQbFvPOVvHHj1KDDFtBAmDxzhwh533I
	 MMdDZJCJsdVO3iRiPx2adPmepRS7XWUPwaWDJcoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Rowley <lkml@johnrowley.me>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/590] wifi: cfg80211: Move cfg80211_scan_req_add_chan() n_channels increment earlier
Date: Wed,  5 Feb 2025 14:38:37 +0100
Message-ID: <20250205134501.482083077@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 3a0168626c138734490bc52c4105ce8e79d2f923 ]

Since adding __counted_by(n_channels) to struct cfg80211_scan_request,
anything adding to the channels array must increment n_channels first.
Move n_channels increment earlier.

Reported-by: John Rowley <lkml@johnrowley.me>
Closes: https://lore.kernel.org/stable/1815535c709ba9d9.156c6a5c9cdf6e59.b249b6b6a5ee4634@localhost.localdomain/
Fixes: aa4ec06c455d ("wifi: cfg80211: use __counted_by where appropriate")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://patch.msgid.link/20241230183610.work.680-kees@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d0aed41ded2f1..21bc057fd8c29 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -763,12 +763,11 @@ static  void cfg80211_scan_req_add_chan(struct cfg80211_scan_request *request,
 		}
 	}
 
+	request->n_channels++;
 	request->channels[n_channels] = chan;
 	if (add_to_6ghz)
 		request->scan_6ghz_params[request->n_6ghz_params].channel_idx =
 			n_channels;
-
-	request->n_channels++;
 }
 
 static bool cfg80211_find_ssid_match(struct cfg80211_colocated_ap *ap,
-- 
2.39.5



