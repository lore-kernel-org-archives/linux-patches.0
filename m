Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F577346FD2;
	Thu, 30 Jul 2026 14:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421336; cv=none; b=IB8hTnfqkCWZZzioyrXwSnNOuFpWQnRKuAGs2HfoAXmq+j5c2wk/Jv9Yi/6/j2lGGh0bZnmrD9T1FD38SqFCCWywe6zbworyT6cfsJibtaO5AGRmqJ/ETT+lA3f3Gm9lIOio8jw8QdmBnTLd3/tE7HaLKhsP9LGPrKI+L4xaBE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421336; c=relaxed/simple;
	bh=cx05kV48LGw/o/N0yaLBPLumpwXMXa5pfvknn+IRX0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjGSSgqe7BhJTQkGDXGjlsW5/ss6qjTT1qZzZUdAr71LINRfr/E9y+Ic4JgHh4fEV3cfnWDX30Hjw6aAh5/QC7djIUaejVkL9mQqGve5RBE271jbsAfJSVfsXGoH91dNQFK62rze4gZXKAbvrK6AFhQzBZ9MAb49OsfKSPC2OMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAMHCK5o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAMHCK5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450D11F00A3A;
	Thu, 30 Jul 2026 14:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421334;
	bh=bGD/0x1MXGiRX7ajzkezQY1UyGn6ctrEZTb+DqN9gz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YAMHCK5o3gzdRWHM+namzSZgS0DetY2qRRiUcFmLTAHQTUnmf0/CrWZ23q/0t895Q
	 94gCZhfo0blvS3oChxuNei5KWarw+mmsN9tgnXeE2ZDbHJRox1ZME5bxiiXQi24m0O
	 QhGAQ2wXBN/2QUT//IxbkBlAY0efbe981bB19FWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 068/744] wifi: mac80211: avoid non-S1G AID fallback for S1G assoc
Date: Thu, 30 Jul 2026 16:05:41 +0200
Message-ID: <20260730141445.722939691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 035ed430ce6a2c35b01e211844a9f0a7643e57a4 ]

When assoc_data->s1g is set and no AID Response element is present,
falling back to mgmt->u.assoc_resp.aid reads the non-S1G
association-response layout.

Keep the fallback for non-S1G only. If a successful S1G association
response omits the AID Response element, abandon the association
instead of proceeding with AID 0. Initialize aid to 0 for other S1G
responses so the later mask and logging flow keeps a defined value
without reading the non-S1G layout.

Fixes: 2a8a6b7c4cb0 ("wifi: mac80211: handle station association response with S1G")
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612152440.25955-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b98ddfa3003e16..ddd3479f0b4034 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6659,7 +6659,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
-	u16 capab_info, status_code, aid;
+	u16 capab_info, status_code, aid = 0;
 	struct ieee80211_elems_parse_params parse_params = {
 		.bss = NULL,
 		.link_id = -1,
@@ -6737,8 +6737,10 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 
 	if (elems->aid_resp)
 		aid = le16_to_cpu(elems->aid_resp->aid);
-	else
+	else if (!assoc_data->s1g)
 		aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
+	else if (status_code == WLAN_STATUS_SUCCESS)
+		goto abandon_assoc;
 
 	/*
 	 * The 5 MSB of the AID field are reserved for a non-S1G STA. For
-- 
2.53.0



