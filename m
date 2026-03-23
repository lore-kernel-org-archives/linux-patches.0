Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218542D9ECB;
	Mon, 23 Mar 2026 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277794; cv=none; b=tCOl9RpM57qdV79guJRJKnJePuncCkEDjthEVU4G6vlFy+C7DPVVcetM5tnEROk0qg+1HindB/7032prCTt9CjpRX6+XCaZx0MU5rt4tLWFXasKMmibYNp/No012zNU8WxmmMBnipEa/h7EkXkmXM7syZhV/q5O/+egmj8qwNDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277794; c=relaxed/simple;
	bh=ogREbozIDtaBth1dVvDeZXjygLqgmav8UYWug3c/DrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMrlKAp666VFJfAXfCVRsNixo81tArucEonj9wiwevhvCJ6yRuo+LewXqRhw0k4L471qoXO9AYNmV/QwVOKpdPy0GAuG0ZaDP/PhWsHZ2hSKLzDFig8zjVjvAC5P66OwOjrk0M4RLYMus8g3zvRn6TsGCWESC3lWjq5hPGxCVjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tWgYmfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tWgYmfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD3DC4CEF7;
	Mon, 23 Mar 2026 14:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277794;
	bh=ogREbozIDtaBth1dVvDeZXjygLqgmav8UYWug3c/DrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tWgYmfjmr7/MpLVVcNcJFls5RyDA5goBawFovSb2bKc+zMVQ9Lh0O14LdMMp+lPd
	 BAoz+ULWOKSHof40wSGsC0/TXBFwub9eBSMMLpG6VpVcraBuPvV/6/nHM9JRIcTsST
	 4rZt9X9mUY4OeWUXrATl6rBSKnR4I11bituwc11c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ariel Silver <arielsilver77@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 106/567] wifi: mac80211: bounds-check link_id in ieee80211_ml_reconfiguration
Date: Mon, 23 Mar 2026 14:40:26 +0100
Message-ID: <20260323134536.444789525@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ariel Silver <arielsilver77@gmail.com>

commit 162d331d833dc73a3e905a24c44dd33732af1fc5 upstream.

link_id is taken from the ML Reconfiguration element (control & 0x000f),
so it can be 0..15. link_removal_timeout[] has IEEE80211_MLD_MAX_NUM_LINKS
(15) elements, so index 15 is out-of-bounds. Skip subelements with
link_id >= IEEE80211_MLD_MAX_NUM_LINKS to avoid a stack out-of-bounds
write.

Fixes: 8eb8dd2ffbbb ("wifi: mac80211: Support link removal using Reconfiguration ML element")
Reported-by: Ariel Silver <arielsilver77@gmail.com>
Signed-off-by: Ariel Silver <arielsilver77@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260220101129.1202657-1-Ariel.Silver@cybereason.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5854,6 +5854,9 @@ static void ieee80211_ml_reconfiguration
 		control = le16_to_cpu(prof->control);
 		link_id = control & IEEE80211_MLE_STA_RECONF_CONTROL_LINK_ID;
 
+		if (link_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+			continue;
+
 		removed_links |= BIT(link_id);
 
 		/* the MAC address should not be included, but handle it */


