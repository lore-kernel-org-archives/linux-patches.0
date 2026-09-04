Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E3137C106;
	Fri,  4 Sep 2026 05:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501585; cv=none; b=AW8usuN4nLzctA3P7IboLqEoUbokxjpjXrHzOOaVGbqArE8C6/WcniY6AjB++uBohdYqw1LDZDj/GgRYhiHwnw9rsKyN69ILWH9Pvy3cK5vwQwkHQlt7ah/FhNV3t+B9hPtntGaWaVL4SWmWpWlzNQ/WAbx0WBBzr6J4CXsqT/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501585; c=relaxed/simple;
	bh=80QDRRT4m6ugn02thNJlKoPDuAQsI9kCWEXATAXNMdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHKyEkbsr0gGP8HMa1CHGimgKg6Qh4RWoLYiYLS899tBvBjN4IDiYzz0J2UiVQenCleDhKch9Puv0MbifSY0k9uiep61BqFVYRWtLPLiGg5zW05GhUm9P1Cii32k4yYu6hchxKHDwspBctda6YMzpHcasa1JOmZ3EdkOGXu0wac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbmVCu13; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbmVCu13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0221F00A3D;
	Fri,  4 Sep 2026 05:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501583;
	bh=wQfqcoK+g3qXRzxVwPXM90ZfLQwL/sbWi6kubNapjoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FbmVCu13eiho2+NRG+V5FfYupBFAy/rBTvzCgL/LHiKfQrKYrFHylvvKllUnQr4iR
	 UFFHS88BSW3G+kcxBzWKJG9IJNZLRMbplCB9Jc9zffRtBa+myUseXeCNkCIBFLTr/R
	 GUaT+f3cJeeKAtbOhbHFxWCIwXmxW51FYq5lj9NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 461/552] net: phylink: correctly validate returned PCS in phylink_inband_caps
Date: Fri,  4 Sep 2026 07:00:18 +0200
Message-ID: <20260904045801.153692118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

commit f2849b1fd059ec9b3281b771e6ac5aad9feee851 upstream.

In phylink_inband_caps(), the PCS returned by mac_select_pcs is only
checked if NULL but mac_select_pcs can also return an error pointer.

This can cause a kernel panic as phylink_pcs_inband_caps() only checks
if passed PCS is not NULL and directly dereference ops from the phylink_pcs
struct.

Use the IS_ERR_OR_NULL macro to address both case where the returned
PCS can be NULL or an error pointer and prevent a kernel panic.

Cc: stable@vger.kernel.org
Fixes: df874f9e52c3 ("net: phylink: add pcs_inband_caps() method")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://patch.msgid.link/20260817213009.13924-1-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phylink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -959,7 +959,7 @@ static unsigned int phylink_inband_caps(
 		return 0;
 
 	pcs = pl->mac_ops->mac_select_pcs(pl->config, interface);
-	if (!pcs)
+	if (IS_ERR_OR_NULL(pcs))
 		return 0;
 
 	return phylink_pcs_inband_caps(pcs, interface);


