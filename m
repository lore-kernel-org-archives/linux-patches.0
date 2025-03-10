Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F3F18FDAB;
	Mon, 10 Mar 2025 17:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628780; cv=none; b=Rt/7EompDgsvS3AGgco/f2dW18z3uIkFDHQ4Ue79M3Rr41XzYe/KNeTVGCmPgaOhyKfdCbWHW2ZvFKov7zxEsaKcgybDm/LKCs8j7NJgWHgKOmkpMl/rzOokDHg5GspO2ggMq1JgFPiVS5BzOF00eUoREFsMu2OiGXVevhj/T60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628780; c=relaxed/simple;
	bh=0/3c2QQ6XoXc1efnAHNQsVqOxzyh/c0H1axP3SxtCyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/43Y3rQrIhyKdwVFp6vY8vFe/dIMEPxf7OxGUWatO+3O4Khoxr5GDekcv5rKm9fJ9aXdk/ENK4/3kNquFyjozfoTvCzvIJ8+wOAUYjOEx6gJx86hANRAZ1BGUXJZifPT72EoJqPbtw7DnxOY0rRm465vPR5RxzDdop2ubJMQZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5HoP+bd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5HoP+bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAFAC4CEE5;
	Mon, 10 Mar 2025 17:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628780;
	bh=0/3c2QQ6XoXc1efnAHNQsVqOxzyh/c0H1axP3SxtCyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5HoP+bdOf4izF89MzUAC+GuaDjruOVno6u/OBnkDqYG3zzo7aYwuCoyTnDFrtr5v
	 vWn3IEJ23aNtEADz8GRW5YwVmKdmXYJAa4XpWCIZkEbAtRpyRPyXXMffGPPwZlqMX8
	 xIBEfc1GWdWOl0vGM2qNs0011wCDNe+L7RJIs+fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/620] wifi: cfg80211: adjust allocation of colocated AP data
Date: Mon, 10 Mar 2025 17:58:32 +0100
Message-ID: <20250310170548.186579583@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 1a0d24775cdee2b8dc14bfa4f4418c930ab1ac57 ]

In 'cfg80211_scan_6ghz()', an instances of 'struct cfg80211_colocated_ap'
are allocated as if they would have 'ssid' as trailing VLA member. Since
this is not so, extra IEEE80211_MAX_SSID_LEN bytes are not needed.
Briefly tested with KUnit.

Fixes: c8cb5b854b40 ("nl80211/cfg80211: support 6 GHz scanning")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20250113155417.552587-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ad857cd1e6f0e..d977d7a7675e1 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -821,9 +821,7 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev)
 			if (ret)
 				continue;
 
-			entry = kzalloc(sizeof(*entry) + IEEE80211_MAX_SSID_LEN,
-					GFP_ATOMIC);
-
+			entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 			if (!entry)
 				continue;
 
-- 
2.39.5



