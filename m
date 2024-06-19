Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1E1146A85;
	Wed, 19 Jun 2024 13:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803296; cv=none; b=bDHC0owwJT2NI6pquQGqOOCJARHptlaP2K+9/JFXfKBn+M2ROlKSEnuPPgxgCGEVoUc2EnrRgi5P1R9Zj7UUHjZoMnMZeg2Bu/rStVCpGEHT2KZSGYAJt73SidTHNgcdJ9QiH67I8UTqzMYNCP6sRj6F2f0Qw0s8gIamwbAZQZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803296; c=relaxed/simple;
	bh=ycHsJ6IMwxwQRHNyXoha8vyvjaAaHLHyBM+3FQxVWzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrirmnLTnGmN0bpZKS4IQLnROaXsaszQQylntFwWXoBWX+zy9dQBYT0G2eIX+HfYqBSBe9bL4zxe2aWU2mG2HUZATfEfHcwg53tcr+IiRckKxySlv61sMhBg/8OdB93M56FhibP1T+/i8XojEJZk3KHWewaAwJOD9i5jHXMY4Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6ADY+D+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6ADY+D+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DC2C2BBFC;
	Wed, 19 Jun 2024 13:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803296;
	bh=ycHsJ6IMwxwQRHNyXoha8vyvjaAaHLHyBM+3FQxVWzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6ADY+D+9A3YIwSh7QJqeMehZgvAdqRDx3m2/badmHnEWUSyGH/gINbAraMy75R08
	 5nHNu/FlR/6h1Y1pd5rChVDuvYe3cKaeZzoKaGYSO741Bts7A91DSOnqgcz1P7ck+0
	 ram+qQrilWL6aU0jKOyheQeHWiHwkON/jDQJlGe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.9 220/281] wifi: cfg80211: validate HE operation element parsing
Date: Wed, 19 Jun 2024 14:56:19 +0200
Message-ID: <20240619125618.425739004@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 4dc3a3893dae5a7f73e5809273aca0f1f3548d55 upstream.

Validate that the HE operation element has the correct
length before parsing it.

Cc: stable@vger.kernel.org
Fixes: 645f3d85129d ("wifi: cfg80211: handle UHB AP and STA power type")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240523120533.677025eb4a92.I44c091029ef113c294e8fe8b9bf871bf5dbeeb27@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 127853877a0a..8daed8232b05 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2128,7 +2128,8 @@ static bool cfg80211_6ghz_power_type_valid(const u8 *ie, size_t ielen,
 	struct ieee80211_he_operation *he_oper;
 
 	tmp = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_OPERATION, ie, ielen);
-	if (tmp && tmp->datalen >= sizeof(*he_oper) + 1) {
+	if (tmp && tmp->datalen >= sizeof(*he_oper) + 1 &&
+	    tmp->datalen >= ieee80211_he_oper_size(tmp->data + 1)) {
 		const struct ieee80211_he_6ghz_oper *he_6ghz_oper;
 
 		he_oper = (void *)&tmp->data[1];
-- 
2.45.2



