Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AEBF510;
	Wed,  5 Feb 2025 14:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764262; cv=none; b=dUpLyFgV+8PdY0WI2C7xfHT2s3HMesarrkjMgpbSTdDleU6ld8F7g1LCDrMCQEXpnOevoAalnn1NT+O3jfp2WFOyuY3CtixY31qZHBq4AwwqgUHMJEWcziWvdBu5ffynXF2ycsFj/Ehe66ZaaDyMdbxwsYRBMwRH7oAWvmkh8XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764262; c=relaxed/simple;
	bh=GWh3eWiKRkxW6EPiKWq1pkpvnf0Pu9i5C/03uhAXgI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HM5HgCYckOPl3+jga3Srmo0Y660aueMTosnAFADxEWZK1mBG+JGX8ZVQp3RrkgV31993cE4S9k7qGmTy/7utyLpJg173b+8N89cUAGgxJxvnnip9N4sr9r8USbzaGVevZzs9H4somkj147OQ/r8VffnMmQOSO+dSvq2OwWUTcZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIvEZuNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIvEZuNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD71DC4CED1;
	Wed,  5 Feb 2025 14:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764262;
	bh=GWh3eWiKRkxW6EPiKWq1pkpvnf0Pu9i5C/03uhAXgI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIvEZuNJ1c2tZMfRulljKcA0qfFAbEMYeR+FOe31gH6yzEUXyJSYnnIA4KkJKGwik
	 cKHjHcFRbjjNqf7CcWfRkcgyTMa7ODDhsBQtpBvdPSbX7OSEnv5aixpdIXGuh0xyi3
	 Nl7POzAPd41RL0hvEjCRTTJE8RmdJ+XoMHRGTNLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/393] wifi: cfg80211: adjust allocation of colocated AP data
Date: Wed,  5 Feb 2025 14:40:54 +0100
Message-ID: <20250205134425.464079599@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c76ac1959fe8d..ce622a287abc6 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -856,9 +856,7 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev)
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



