Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECC625EFBF;
	Tue, 11 Mar 2025 15:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706535; cv=none; b=QixY7N50p1Q8aT4Y++s4LMSXx6cvAwk4DSbIAAFPxr1Hz5WW62zhTkWwdfVauZSNVQc46vUfP0v+K0beK63/J9NStn2gaxt9EiCVHTLzxK/+nDTtRhJEVk1fkA7XhME4j1S+1ZvxkSpqFIChVmFZAKSjecxZwCfYvCVfG87etSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706535; c=relaxed/simple;
	bh=3cC/KAc9HaBD60vQY4RdscHwphbXcoYkTpXLRSXosow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxP98EZeqryYQilwMJMUk/aubPQ7I+r1eJ0gIDwolwktaWlJOAU8TzPUVY2zBQsS2LhodYKz5Gg2tCUZF00KT7OBXyXar+t4qpxaF7kKpqpbCZUYIelOwFhQw5hx8C7Ve/9w0F1Mb/dy97VyWab32RdjzS6+WwOJrl1qJaOpM4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNzBymov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNzBymov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0055C4CEE9;
	Tue, 11 Mar 2025 15:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706534;
	bh=3cC/KAc9HaBD60vQY4RdscHwphbXcoYkTpXLRSXosow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNzBymovWZ/3KdTNaXyZP+R7vRj9+q/s3Eu6pIQmgX4+o3OUoJc2wCmP+Lk27EW8b
	 fBCbcB+SHlC1NbrRQxncBfkD0bw87T0iN4H4ht74dWV7/NAX7SX7Spfba4c8Sz7Nyx
	 AAWZo70HHk3oND1g2AFHSRlavt8d0qaMIu00+3XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/462] wifi: cfg80211: adjust allocation of colocated AP data
Date: Tue, 11 Mar 2025 15:55:07 +0100
Message-ID: <20250311145759.975512441@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 348b2fce25fc3..670fcdbef95be 100644
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



