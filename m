Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD54D14B959;
	Wed,  5 Feb 2025 14:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765346; cv=none; b=bIUaa7lxoR1apmseK/FNqQM4YTTiztDxuQQad6+B5x8X0asGNMFkTp97zbevA0NOFsMU5gXTdUX1F924CzBqCZfsGEE6pDYJeB23VtGrpTfC+UhHCeoMvhxJKYQXsRm0xVjMcQ0zEI14hIM91xJufy08fQdNcVnskS3SSV1oWeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765346; c=relaxed/simple;
	bh=+nW9E0YRM+TRkiQk0+dUR3h5p13ZzJoOsx4pIAnkttY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flWsPxv0O3nit6bfXeTTwPpzI+ZU5u9ltuDkPKgKK+tWml340PQ/oYRozlC+0fiEyIYnscuqTPKwZw5d7O9uaWm9ZF4DM4P3eLAo/yoZoiDWaX+mSFdMA0aDc11JmuYktLXpE+ncs3VgbUElW6Npb+bXfVThwQVwaaLSxvWq3TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMT0whQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMT0whQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B155C4CED1;
	Wed,  5 Feb 2025 14:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765346;
	bh=+nW9E0YRM+TRkiQk0+dUR3h5p13ZzJoOsx4pIAnkttY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMT0whQG1vIt5GW7KJt4eynsPrkpISTALBMR8xAYzfvKXla5Tl30taWfA+jK+zw2q
	 W6cIxZn2MPGA1C2oLwCSXBxGKOj8w1RxoFLknwNOBjAq/i5iWMCxu6AKS4yesG7Zj+
	 tpbv5PbUVBMJmTXtXQ9tyQBdgOjht/P3eR5EaBGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Rowley <lkml@johnrowley.me>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 168/623] wifi: cfg80211: Move cfg80211_scan_req_add_chan() n_channels increment earlier
Date: Wed,  5 Feb 2025 14:38:30 +0100
Message-ID: <20250205134502.662247037@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 1c6fd45aa8093..ccdbeb6046399 100644
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



