Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797DD35BDBF;
	Fri,  9 Jan 2026 12:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963223; cv=none; b=iqOvHYuyQypYcr7rMNXGpyL2fMTEs+nPqESRVlCT/oaXrrc4oOY4NsAVgoozH3qfOHRjDNIzqoafNd90hPy6C0lNyg/2gj7DiUv6mlrTAdTN3aCEwdPhCdSi8u3kqSVYaC6iHoN8nOov+2n89Gant65zdkwCd/VWdmZOJvmP26U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963223; c=relaxed/simple;
	bh=Q3wEq8eE7WiC4B8tVNJ2dh2jyRjBFfyzZ1U6tybFTNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ewmw/eysMyOZKsyZrnJ/8rBFS3p/CF2yVKRPiciQ1ZfUf9VWqSXDBwsoexuiCQG+4iXWDbsHLoiSyABMPYOhUVBWBN0qwCXGXREjbXTS37gG5UoIg9HBqGCHoXwDSL+v3QpBHii1hBZNFB7flMuVRhqmPK96EjTDa8BnVc9lwvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewsTn33y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewsTn33y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BCFC19421;
	Fri,  9 Jan 2026 12:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963223;
	bh=Q3wEq8eE7WiC4B8tVNJ2dh2jyRjBFfyzZ1U6tybFTNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewsTn33yfrA6V7SHMCdJpR5XqTppXhPnpVVn6i1DSHXG17m9L3CHdaQvIuLLeJWrU
	 BUNoV7FId89Br1DohTh0p+AbFCnWkdIg9z9R1DtN54EWn7dumK0dm0kOxeJpFdJl8U
	 5N3uhQt3kyqmyu7N/YgbCg5csxRfV9pXvJMkIjB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 633/634] wifi: nl80211: fix puncturing bitmap policy
Date: Fri,  9 Jan 2026 12:45:11 +0100
Message-ID: <20260109112141.453038469@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit b27f07c50a73e34eefb6b1030b235192b7ded850 upstream.

This was meant to be a u32, and while applying the patch
I tried to use policy validation for it. However, not only
did I copy/paste it to u8 instead of u32, but also used
the policy range erroneously. Fix both of these issues.

Fixes: d7c1a9a0ed18 ("wifi: nl80211: validate and configure puncturing bitmap")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -467,6 +467,11 @@ static struct netlink_range_validation q
 	.max = INT_MAX,
 };
 
+static struct netlink_range_validation nl80211_punct_bitmap_range = {
+	.min = 0,
+	.max = 0xffff,
+};
+
 static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[0] = { .strict_start_type = NL80211_ATTR_HE_OBSS_PD },
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
@@ -810,7 +815,8 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_MLD_ADDR] = NLA_POLICY_EXACT_LEN(ETH_ALEN),
 	[NL80211_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_MAX_NUM_AKM_SUITES] = { .type = NLA_REJECT },
-	[NL80211_ATTR_PUNCT_BITMAP] = NLA_POLICY_RANGE(NLA_U8, 0, 0xffff),
+	[NL80211_ATTR_PUNCT_BITMAP] =
+		NLA_POLICY_FULL_RANGE(NLA_U32, &nl80211_punct_bitmap_range),
 
 	[NL80211_ATTR_MAX_HW_TIMESTAMP_PEERS] = { .type = NLA_U16 },
 	[NL80211_ATTR_HW_TIMESTAMP_ENABLED] = { .type = NLA_FLAG },


