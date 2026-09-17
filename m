Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5434ABBB4;
	Thu, 17 Sep 2026 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660943; cv=none; b=cmFU9ogBoeJ7+1x29zi5NvbWOUnlQ34ompRRHpexfeyQ3ZtDBbdLBJM3k8/PLAZRGfQ/FTUeIadsJTvewHaWTiaMMVHY5bIRIveK2YJLl5/+gXQygtum34StTLZIrb5GhdKj8+gO5ov8htv2bp8s3mvVyWAXjexUvb2q1mhW1NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660943; c=relaxed/simple;
	bh=31My7GVWDoOfXjKwfbP6b7zQjCp84KetCrBFsrjigQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtjpcjoNtQk/jIKQTys5+Ktm0BEH8JW+hUaBEG5/i1Qk9cWpktiM20C3TZ50+hTrao7/qTxXjui+pASBP641F/Uh9f/DwoXwa45bjNlRa7mAr1dlso0c/buXQIZWt567b0z0eEjsm4kdkhh4U7IO4iQdMVpl3bO3WgwY+jsAe4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjW01Fdr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjW01Fdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422581F000FF;
	Thu, 17 Sep 2026 16:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660941;
	bh=Peb66PRahK4+RDRo+6+W/dDA6WubaNhSJa2bltfw9FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjW01FdryxSTKLaJPCqy1nB2qjsEC5j7yzk9tegu0JDvVXYW6LjLOuh4qEqhcD2NI
	 IZkJpXuVEI+QPNbTAd3+iSJuMPCDUl9rGel4Z8CHDffFA1QZOjT6JIUfjwHd57abCn
	 49lxXKOWCVlgtetNUZstGyrQYbxiaXOvkr7/+t4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0029/1250] wifi: nl80211: reject beacons with bad HE operation
Date: Thu, 17 Sep 2026 15:57:04 +0100
Message-ID: <20260917151552.717602548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8b9a100e1a76c52988b31099b349fd95a58c8768 ]

The HE operation element not only needs to be longer than
the fixed part, but also have an appropriate size for the
variable part inside of it. Check this.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260415144514.6217f5974fb5.Iff7ff6bcb159584e756d0f825c65860cdd53c6ea@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 232218818ed7f..badb951763840 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6505,8 +6505,12 @@ static int nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
 	if (cap && cap->datalen >= sizeof(*params->he_cap) + 1)
 		params->he_cap = (void *)(cap->data + 1);
 	cap = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_OPERATION, ies, ies_len);
-	if (cap && cap->datalen >= sizeof(*params->he_oper) + 1)
+	if (cap && cap->datalen >= sizeof(*params->he_oper) + 1) {
 		params->he_oper = (void *)(cap->data + 1);
+		/* takes extension ID into account */
+		if (cap->datalen < ieee80211_he_oper_size((void *)params->he_oper))
+			return -EINVAL;
+	}
 	cap = cfg80211_find_ext_elem(WLAN_EID_EXT_EHT_CAPABILITY, ies, ies_len);
 	if (cap) {
 		if (!cap->datalen)
-- 
2.53.0



