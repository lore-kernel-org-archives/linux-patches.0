Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECC24534A9;
	Tue, 16 Jun 2026 15:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624607; cv=none; b=bkWCXflYogJl4Gmxny2aZ09nHGKrLoRgzTT17KIXYRoW4cBwhr1OJ7HvxxyeZdWkaVeG2joFQMyaxU0RLmKYLB4rxqKIjysj6S6Bt+YSPyzeUsvr2G7Oh9dguOOtHLdByUz2gSWXlW8d+8I4ntKcbbVUPH7Z2Dm7v+E/hZJszYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624607; c=relaxed/simple;
	bh=20ucPT++1iz7zJUhsN2En6yz2abNkH4NUVc0so7ncfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sK+caSv7lbhps+Y3VA3D0+p9+Y7fe9LTtobA67wWHQslbMAWA5XCfNSvJHrJd3XUfUZBO9GY5ir3RF744XMvXi6Uj5SfvnNpguoIB6wnwX3hfUGTx1J9jpZJp3de4G1w83S+0jJNoXc39JNnkN7h5Jy5TOPlU++ylpNU37JUCcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ri+E28DH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ri+E28DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EC01F000E9;
	Tue, 16 Jun 2026 15:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624605;
	bh=HzxqTJAtjeXt5XvEHUGgtgpUF86MORjoSBvzVJrXJO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ri+E28DHbHIodlU8mQyEteKWjaNUOC45nlAW0PTmg8OLWTyB8/BCvaGUEa5pNUUMu
	 DQpoWji2d3KeodlVO3I4Gi/201zfIwrGJuQZ4U8q5SdZeGaRDLrTHU+0t2AJiO+PNq
	 WD4rL03AS9i/4qrwzH+9273SDMX9vHiO6T3OdcAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rio Liu <rio@r26.me>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.0 365/378] wifi: mac80211: skip ieee80211_verify_sta_ht_mcs_support check in non-strict mode
Date: Tue, 16 Jun 2026 20:29:56 +0530
Message-ID: <20260616145129.348733831@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rio Liu <rio@r26.me>

commit 711a9c018ad252b2807f85d44e1267b595644f9b upstream.

Some Xfinity XB8 firmware advertises >1 spatial stream MCS indexes in
their basic HT-MCS set. On cards with lower spatial streams, the check
would fail, and we'd be stuck with no HT when in fact work fine with its
own supported rate. This change makes it so the check is only performed
in strict mode.

Fixes: 574faa0e936d ("wifi: mac80211: add HT and VHT basic set verification")
Signed-off-by: Rio Liu <rio@r26.me>
Link: https://patch.msgid.link/99Mv9QEceyPrQhSP52MtAVmz0_kWJmzqotJjD9YW6LGLqk-AZloAueUyHCURilFkuqOh6Ecv8i2KKdSE1ujP3AnbU5QEouVisT1w_V3xdfc=@r26.me
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -420,6 +420,15 @@ ieee80211_verify_sta_ht_mcs_support(stru
 	ieee80211_apply_htcap_overrides(sdata, &sta_ht_cap);
 
 	/*
+	 * Some Xfinity XB8 firmware advertises >1 spatial stream MCS indexes in
+	 * their basic HT-MCS set. On cards with lower spatial streams, the check
+	 * would fail, and we'd be stuck with no HT when it in fact work fine with
+	 * its own supported rate. So check it only in strict mode.
+	 */
+	if (!ieee80211_hw_check(&sdata->local->hw, STRICT))
+		return true;
+
+	/*
 	 * P802.11REVme/D7.0 - 6.5.4.2.4
 	 * ...
 	 * If the MLME of an HT STA receives an MLME-JOIN.request primitive


