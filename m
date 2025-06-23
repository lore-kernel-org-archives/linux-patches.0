Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20426224B07;
	Mon, 23 Jun 2025 21:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715739; cv=none; b=rBgcnuEOWAscCDsCqn2bQFol7HAeX6U9mE5A9CsnSLtlos9yTkYl++g3SgQ2dCCLd2nK+cgPbjyCFI2E29e9LLiEcg6k0MvuLmUTCMCu9ndlFGK1CTFpSv5XACtI+kOxbY6N/ROkmqWCyKEIYbwBxiugrsHKJKfgZDo3p84NcnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715739; c=relaxed/simple;
	bh=r3B6RP6LKdIG+kraE9Pjp9WGP5GBbawCCU+I1sGqr74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skyJItFrebLZmh9Eem7IiooyoCKu8BudeEouEz/dA/VU6mm9Vs++uV8qxDIDewPZJsi0Quow9zm87jBBo1ajBWn1womTz43cfbc0BzNZtG5eeXTjqzxUmWylGVSj6SxlWPsvHdTQrOF5ecQ3M1OAaYgIeGRLi8mmaL3uSGguoH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHxTP/5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHxTP/5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30B5C4CEEA;
	Mon, 23 Jun 2025 21:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715739;
	bh=r3B6RP6LKdIG+kraE9Pjp9WGP5GBbawCCU+I1sGqr74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHxTP/5cPvvvFhvC1nsEbjEdZjyn25lCuiC46LGm3uZ2BFsfAJO1df2tv509MkeJ5
	 GiKaA3EE6MckWqQb7PRd3wCccrcdEU5NmPlQcGtSxqgEyM6NxWLeFfPO21Cngdv4DX
	 0FcBJx4GAInWylbvBCt/nlk5JGCNpylLWULJVn6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/414] wifi: mac80211: validate SCAN_FLAG_AP in scan request during MLO
Date: Mon, 23 Jun 2025 15:05:41 +0200
Message-ID: <20250623130647.106455017@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>

[ Upstream commit 78a7a126dc5b8e3c5a3d4da9f513e0236d2dc1a3 ]

When an AP interface is already beaconing, a subsequent scan is not allowed
unless the user space explicitly sets the flag NL80211_SCAN_FLAG_AP in the
scan request. If this flag is not set, the scan request will be returned
with the error code -EOPNOTSUPP. However, this restriction currently
applies only to non-ML interfaces. For ML interfaces, scans are allowed
without this flag being explicitly set by the user space which is wrong.
This is because the beaconing check currently uses only the deflink, which
does not get set during MLO.

Hence to fix this, during MLO, use the existing helper
ieee80211_num_beaconing_links() to know if any of the link is beaconing.

Signed-off-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250516-bug_fix_mlo_scan-v2-1-12e59d9110ac@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f11fd360b422d..cf2b8a05c3389 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2876,7 +2876,7 @@ static int ieee80211_scan(struct wiphy *wiphy,
 		 * the frames sent while scanning on other channel will be
 		 * lost)
 		 */
-		if (sdata->deflink.u.ap.beacon &&
+		if (ieee80211_num_beaconing_links(sdata) &&
 		    (!(wiphy->features & NL80211_FEATURE_AP_SCAN) ||
 		     !(req->flags & NL80211_SCAN_FLAG_AP)))
 			return -EOPNOTSUPP;
-- 
2.39.5



