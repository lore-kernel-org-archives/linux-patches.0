Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D776336D50D;
	Thu, 30 Jul 2026 15:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423611; cv=none; b=WJXNxVACkSrmrNnX/7ROoNBtPwwXvbkhT2AR0aV//AwCZvShsPLT+3VtrPXaUzRn5/mEB6NzoEdYHaSIMZOVQyDe/ggxiDm7nlpWFVos0Dyk3pcUUQhFNCDJJGx0dZZ1k+2tcicciZn3Zfjfj0GchKxpTsi3O5Z3KQPGN2wsdM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423611; c=relaxed/simple;
	bh=PkCBe18F9dsE75yp6C7u525HzPICIxOU3zX2zD23UuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip9augl0gLL8LQQq7m3slwg6xi/417qlpYu3xCYAya95ChS1SMxcr+V2rlFkJCyAIZdge10TfFM8Hk2zKHZecjesdpDLRXlxRNdlMw1Ps6m1KeoVzZ8UOIY6rgHdtcZ4Jzsy5qCG7/gA+U0tBjCj0DIXm4MWz3pERrp63VPnpho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6wrQ5I1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6wrQ5I1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A081F000E9;
	Thu, 30 Jul 2026 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423609;
	bh=MNEXYZywqGSuDXj6SGG5RzZshEQpTFQ+DTH2ESxwExQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6wrQ5I1IvlV5efsiweSIzudHhdP2ZelQKZRyX0SvvYwHmy2bFMRtW04toLA6qpE1
	 xVcpRqdjBLzh5dI19cF3ZSEwejuH2Ew9APJWHgOWnvF/mBUwpQ8PwGS4cnO8Vl5Dhc
	 q23147qKG01koPibbKrTHRujSiPyFwrCaHMFzKcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/675] wifi: nl80211: validate nested MBSSID IE blobs
Date: Thu, 30 Jul 2026 16:06:47 +0200
Message-ID: <20260730141446.765670281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 7f4b01812323443b55e4c65381c9dc851ff009e3 ]

Validate each nested NL80211_ATTR_MBSSID_ELEMS entry as a well-formed
information-element stream before storing it for beacon construction.

RNR parsing already validates each nested blob with validate_ie_attr()
before storing it. Apply the same syntactic IE validation to MBSSID
entries before counting and copying their data and length pointers.

Fixes: dc1e3cb8da8b ("nl80211: MBSSID and EMA support in AP mode")
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612131854.43575-3-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e765c992eb20e4..5583edf4852775 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6034,7 +6034,8 @@ static int nl80211_parse_mbssid_config(struct wiphy *wiphy,
 }
 
 static struct cfg80211_mbssid_elems *
-nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs)
+nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs,
+			   struct netlink_ext_ack *extack)
 {
 	struct nlattr *nl_elems;
 	struct cfg80211_mbssid_elems *elems;
@@ -6045,6 +6046,12 @@ nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs)
 		return ERR_PTR(-EINVAL);
 
 	nla_for_each_nested(nl_elems, attrs, rem_elems) {
+		int ret;
+
+		ret = validate_ie_attr(nl_elems, extack);
+		if (ret)
+			return ERR_PTR(ret);
+
 		if (num_elems >= 255)
 			return ERR_PTR(-EINVAL);
 		num_elems++;
@@ -6216,7 +6223,8 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
 	if (attrs[NL80211_ATTR_MBSSID_ELEMS]) {
 		struct cfg80211_mbssid_elems *mbssid =
 			nl80211_parse_mbssid_elems(&rdev->wiphy,
-						   attrs[NL80211_ATTR_MBSSID_ELEMS]);
+						   attrs[NL80211_ATTR_MBSSID_ELEMS],
+						   extack);
 
 		if (IS_ERR(mbssid))
 			return PTR_ERR(mbssid);
-- 
2.53.0



