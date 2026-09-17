Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9670C39CD06;
	Thu, 17 Sep 2026 17:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667217; cv=none; b=NFwkMgMcCdqCgXKoSjs0Dxpc8If0Mn6pJ1TdqX8UgVyLMIaErku/0KD+ThhmrVJS69gt94zRvfPZ6iSEokt0VXVdwXXAN05cQ8Ls6wm9JhfiTWSoGJjpWHnL7qsR6R1r+5MTYys0tmPc845AGA2eGXR9L8nx8KT9jHJ/N5drcmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667217; c=relaxed/simple;
	bh=K8kBXAEJjclc06niDcW2MUB9HQ2JGX92+E72EKxHaW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtumYgWJuRHkT0WVdxSXpnxfacoXmHXS0gn7p8XZro/AExqFNNiLnt+oR+E4VTvt4hevZqccHmnuAMvEq7EMGCuaKgYD/dJ79iWankHgYbH1VKszOC8IO+cn6HEQr3b2nu0E8Khd5KVmzluKjQbF38pgSbq35wqYjo/PTfwVcyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ostXSvwn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ostXSvwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE421F000FF;
	Thu, 17 Sep 2026 17:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667216;
	bh=oUW8Iw1LyNx4XVAuxhHbCH00DnLhRLBNuMBWZ/x83X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ostXSvwnQx9xVL0jmVUt2bgZaCsrBKaBLyI4RHGm1qXuol6XqnoslLNbOUOTf4kbM
	 YXm0v665AuJjITuyvrFR7Bp2vMaFzgKoqYz2idkSiprkWTR1zMXfEf3VpHjiZ2s+vL
	 6v2PUGvBtpgKEM0E0OoMcBhoGDNk86sPw9ofHVzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0020/1102] wifi: nl80211: reject beacons with bad HE operation
Date: Thu, 17 Sep 2026 15:59:23 +0100
Message-ID: <20260917151539.938474385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 47e3bcba268af..d9fa7e8447877 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5896,8 +5896,12 @@ static int nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
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



