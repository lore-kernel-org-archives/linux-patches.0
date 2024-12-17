Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11781F8901;
	Tue, 17 Dec 2024 17:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456552; cv=none; b=nJB/YgVmHXgoZvfBSvJHwgWw3bgEqL7E7e9K7LxTYY36bAZaeCZXu7HCjTHVaTIevfPMAtezNpSTxU5SXRz/SX+PFFyrCxSkLg/6WtY8Fn8s9HAUV0R0g8xDNF66sc8g1ErinSubE6SLu6+9o+oyyINtIbFLYWhby/QZ5CWruNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456552; c=relaxed/simple;
	bh=L2rccWd8bLigoPzwt3t2GhPZdFIIjpfhsYLUpXvMEMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2QM7Gi6tdW4kCx6vZPTJ1cDdA5hSaEXpcvD4OvEdP4nxj/HeWIrsWVTFC2qbIg2ZSaUAySFnVcdYh0TzrjAU1gVf6nMBvK+VG3DyP+ORVcYX/KRoxQR7wGm5TD6jE73Ium992uDli7s+NmwZW3bfjl40FhyHvAdA0s4TmQ5cvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOJZiFHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOJZiFHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154B2C4CED3;
	Tue, 17 Dec 2024 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456551;
	bh=L2rccWd8bLigoPzwt3t2GhPZdFIIjpfhsYLUpXvMEMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOJZiFHFA4OcqQQw/IXpoBL6i9yOYnsGrHyaTrIPit53DqLjFVbOEuYTVXwrAGRb+
	 M1/6TL5pAbuhZ9qLd/LCPHitdDmM/1cWysI9a7np7NIYxNtFwzM5+efQOhnjxiYNjX
	 piMwAxaHT/j+MWvLoMktWeeTlWo0lkkL6+D52Zdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyu Li <lihaoyu499@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/172] wifi: cfg80211: sme: init n_channels before channels[] access
Date: Tue, 17 Dec 2024 18:07:31 +0100
Message-ID: <20241217170550.232771744@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoyu Li <lihaoyu499@gmail.com>

[ Upstream commit f1d3334d604cc32db63f6e2b3283011e02294e54 ]

With the __counted_by annocation in cfg80211_scan_request struct,
the "n_channels" struct member must be set before accessing the
"channels" array. Failing to do so will trigger a runtime warning
when enabling CONFIG_UBSAN_BOUNDS and CONFIG_FORTIFY_SOURCE.

Fixes: e3eac9f32ec0 ("wifi: cfg80211: Annotate struct cfg80211_scan_request with __counted_by")
Signed-off-by: Haoyu Li <lihaoyu499@gmail.com>
Link: https://patch.msgid.link/20241203152049.348806-1-lihaoyu499@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 431da30817a6..268171600087 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -83,6 +83,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	if (!request)
 		return -ENOMEM;
 
+	request->n_channels = n_channels;
 	if (wdev->conn->params.channel) {
 		enum nl80211_band band = wdev->conn->params.channel->band;
 		struct ieee80211_supported_band *sband =
-- 
2.39.5



