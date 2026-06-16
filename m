Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8710B3C6A2B;
	Tue, 16 Jun 2026 16:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626355; cv=none; b=bS7q3ntwhyGyZ2HzQFUd+w8S04q1QeptxC2Uy5OPGpUffU7fhCsMZev9C7uaoGVQft9bgng69jNN2HEX300H4Ktv7jWF5MnppxfTVG4qb8a4fkzMZnBBz5/IZNeNPv+r84vmgpS6r9NyYXdDzRofEIHhBh/ZqYbp7YeU1tzyiwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626355; c=relaxed/simple;
	bh=F/YBdCNWc6640uEoKejLR18slvXafOraWgMYITvY6t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYBFf6G0xijnzfKzexIwLRlUiihViNoEbxQcPO4BNGgnMaTG3D7xtCf5DZSAZVf2zUoDEcDHSxUMU1KjP4FFGMbu8bN0zrMSvkpmeO60wlP+AdtG9BEK3b205EPt0awMbQ+n8UN9tHwKe81wPJZt23p6U42iR8VzFfUrzhOL9uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaQUPdJN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaQUPdJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956441F000E9;
	Tue, 16 Jun 2026 16:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626354;
	bh=LLbQXadQzmTjXu90ytQJynkUEdshscfNWlU0z/JCyjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vaQUPdJNOvqCN3UeeGBt8tHBnB7V4Hhtm9n+zXf0W9oUmrK/JwY1bf9qSqXT6Mf2z
	 tZvFveT+dbUMRAnvvAZJvY83JTk4KF0EqRA+NM8ExGj8ZUjBY9sHtMx1/XQ0g0M5K8
	 v2oaL+ud8uYkT6aHturykdXaPFuExgqAOvhQ3lYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rio Liu <rio@r26.me>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 306/325] wifi: mac80211: skip ieee80211_verify_sta_ht_mcs_support check in non-strict mode
Date: Tue, 16 Jun 2026 20:31:42 +0530
Message-ID: <20260616145114.236874854@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
@@ -364,6 +364,15 @@ ieee80211_verify_sta_ht_mcs_support(stru
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


