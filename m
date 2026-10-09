Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCE83431F8;
	Fri,  9 Oct 2026 14:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556611; cv=none; b=Qnh9/X+bJtr9tr0Zs/YjfTGE5HbPJq8IJ1hl7e7JWHOCI0B+ypDLaNh774iXq5+AYm++qmherpw/MYMxrpOUnZJLSe0bNmYYhoqWurnLSFV2ilkINx/41uVKUgXQt+iBOGxSFVJoPdbQxAsuJAUIf0h99cSVndWNN/IC6zgEGuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556611; c=relaxed/simple;
	bh=drWF2nMoRhoxquDLcxu8uIZ40svKFeNKiglf/E+REro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxRoRf+NeG7UQDQaXjFykp8F4oKfRq5vaTRIbzrYMSczM2hwoMEkYq5EbrLCkgoSqw8pc4By2IInqE1BYBIIOcIuZ+DsnkfLM//JiZtdZPAjQ34hQnXH7TjZz19HHzoUXC0qSKI10iuesYsLGRbo+n8gXAeeK0DXVqUf+i62r5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfawU//R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfawU//R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAF21F000FF;
	Fri,  9 Oct 2026 14:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556610;
	bh=If8jcLunJcQIvQfipAU18qxy2eRjKQBPaz9R0fE+dkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfawU//Rre+mKCGNIZ6f1agQHAlUge3Gqb77eY2L1jz2VEERRghsv9FAyjZMAIfgK
	 OtpcnLga0Is3G5nE92c+CaWNX+BGnmpdrw/Nrx1f0bajjXafkOUlep09X6/01ta660
	 GcV4vm+H0iY0TkNT+hXoN/H003oH8C+OQnJhfQs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 263/403] wifi: cfg80211: fix RTS threshold setting for single-radio PHY
Date: Fri,  9 Oct 2026 16:10:24 +0200
Message-ID: <20261009140958.328567705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit 9eda41e32263806a66835e275efdcc0c5f46bbc4 upstream.

Due to an incorrect old_radio_rts_threshold check, we do not set
rdev->wiphy.rts_threshold for a single-radio PHY, and the threshold
value is not propagated to lower layers.

Cc: stable@vger.kernel.org
Fixes: 264637941cf4 ("wifi: cfg80211: Add Support to Set RTS Threshold for each Radio")
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Link: https://patch.msgid.link/20260919092454.50266-1-stf_xl@wp.pl
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4193,12 +4193,13 @@ static int nl80211_set_wiphy(struct sk_b
 			rdev->wiphy.retry_long = retry_long;
 		if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
 			rdev->wiphy.frag_threshold = frag_threshold;
-		if ((changed & WIPHY_PARAM_RTS_THRESHOLD) &&
-		    old_radio_rts_threshold) {
+		if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
 			rdev->wiphy.rts_threshold = rts_threshold;
-			for (i = 0 ; i < rdev->wiphy.n_radio; i++)
-				rdev->wiphy.radio_cfg[i].rts_threshold =
-					rdev->wiphy.rts_threshold;
+			if (old_radio_rts_threshold) {
+				for (i = 0; i < rdev->wiphy.n_radio; i++)
+					rdev->wiphy.radio_cfg[i].rts_threshold =
+						rdev->wiphy.rts_threshold;
+			}
 		}
 		if (changed & WIPHY_PARAM_COVERAGE_CLASS)
 			rdev->wiphy.coverage_class = coverage_class;


