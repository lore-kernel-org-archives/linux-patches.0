Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DEA1F7554;
	Tue,  3 Dec 2024 15:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239733; cv=none; b=l24ZR7cVGn+nbc3YX8VTT+hGO12+mc0Bz8ePoh0vqMrnXo9lsuQ2ujepbn7p1jAyhYonrGo6/rMjhpwhdyoXIL7Nie5ww9fmXlrYJxwSDURIdpknWmYRuRvdzgV1meSBaKUplTcg+qVgXpUiwyTLs1T9qWw2E5d9tEGxZEhfAgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239733; c=relaxed/simple;
	bh=GuIJeetjBQLrqzX0wkiP/jZVI70c8wQe2kt4RNSQio8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BI9cUyHSA+roPrNjqtd20fxYXAHyhFZy8dzfpenWJeJ9me8lruI+/toJDsukbONY8dfWbbojuzmzDEeWc3C4Zn5JR+7YpPjp5C3GYsOniOl1bPpzmqTGfWa1xKV8dJo4RdncS776WJP0rzyhDmPCXQN/LczJq2Com9yCg94xwMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjVNq5XO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjVNq5XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E25C4CECF;
	Tue,  3 Dec 2024 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239733;
	bh=GuIJeetjBQLrqzX0wkiP/jZVI70c8wQe2kt4RNSQio8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjVNq5XOs2hwC+6d16+2UkDwQX2WjxaWT7t3lX3XW1Ysc7aWf7bWmqY0xgnZ2nO2W
	 8zwPp5+LdGV2xD4RMK8USINjHowf6b71COHjee1omHYXiz9R1nEtG9fxZ57gwSq/zp
	 qVxfw0HT4R8o1qfWw/mkV0mi3jE3WtMhyO6WklQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Vetrov <vvvvvv@google.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.11 684/817] wifi: nl80211: fix bounds checker error in nl80211_parse_sched_scan
Date: Tue,  3 Dec 2024 15:44:16 +0100
Message-ID: <20241203144022.671232670@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksei Vetrov <vvvvvv@google.com>

commit 9c46a3a5b394d6d123866aa44436fc2cd342eb0d upstream.

The channels array in the cfg80211_scan_request has a __counted_by
attribute attached to it, which points to the n_channels variable. This
attribute is used in bounds checking, and if it is not set before the
array is filled, then the bounds sanitizer will issue a warning or a
kernel panic if CONFIG_UBSAN_TRAP is set.

This patch sets the size of allocated memory as the initial value for
n_channels. It is updated with the actual number of added elements after
the array is filled.

Fixes: aa4ec06c455d ("wifi: cfg80211: use __counted_by where appropriate")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksei Vetrov <vvvvvv@google.com>
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://patch.msgid.link/20241029-nl80211_parse_sched_scan-bounds-checker-fix-v2-1-c804b787341f@google.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9776,6 +9776,7 @@ nl80211_parse_sched_scan(struct wiphy *w
 	request = kzalloc(size, GFP_KERNEL);
 	if (!request)
 		return ERR_PTR(-ENOMEM);
+	request->n_channels = n_channels;
 
 	if (n_ssids)
 		request->ssids = (void *)request +


