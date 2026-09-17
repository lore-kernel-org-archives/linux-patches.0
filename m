Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8581351B19A;
	Thu, 17 Sep 2026 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664980; cv=none; b=iP/Wrot7JDcxAaMxN0ZHJRmrWdBdnh5Z+5+grDoIM6V8s7WfXIXCwjKy2TGWhF/u0Jtf30PinFEG1IYN/DurgGhca90J1tUxMPu3uw8B2KUha8ocE1SBaBR8b33TzNMwPVlOla+9OAH8MSGLZ/5TlGZZIlC9In1OAqKX9SLYHVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664980; c=relaxed/simple;
	bh=eBoPF6zEZuJLlijaoTH12BetScQZ1Q3ZjnoKrboi2pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qssFAgHlKidB3+PykTL9xJi+Oh8XNm5c8GLMlLCwEoG2nmdLEQ7qsAbwLfFGoNVQiUB1QtgvaoNHhfhHk5BfS9TjdFzcy1UZxgABoSuYTW2yAAJEbNx4vxqvXBRlOYmzkhIrasvXHsQiaUlqHuE0d0yIREbKcAzaXT7Ut0Wb40Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaJ667U1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaJ667U1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DD11F000FF;
	Thu, 17 Sep 2026 17:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664978;
	bh=hfnJVEl0FdTN/iWYrZSc9B1UG+BB4jr93rWt6MaQ5qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaJ667U1b7Og0wVqzsJiPyTOZkYjkfJ1L+d7kFf6vntUmNZYx2nRe2rENnMtH0nT6
	 uuEn17yK9FtzNv5z6FE++2EFMv7Ik0ShtxcWSN5c95H9lTmG3N/n6UHqgPYLvf9VKM
	 Cph3drCXYnS5iNo8Vrj60q4gNal7EexCbKsR8H20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0551/1250] wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()
Date: Thu, 17 Sep 2026 16:05:46 +0100
Message-ID: <20260917151606.869422628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit a2f5286ca4f304d3fd469f01b96b518608912a5c ]

The KASAN allocation trace shows that a malformed IE buffer is
stored via SIOCSIWGENIE (cfg80211_wext_siwgenie()) without any
validation. The crash trace shows that a subsequent SIOCSIWESSID
triggers a connection attempt which calls cfg80211_sme_get_conn_ies()
to process the stored IE buffer, causing:

 - An out-of-bounds read in skip_ie() which reads ies[pos+1]
   (the length byte) past the end of the 1-byte buffer.

 - An integer underflow in the memcpy size argument when offs
   returned by ieee80211_ie_split() exceeds ies_len, causing
   unsigned subtraction to wrap to SIZE_MAX and triggering a
   fortify panic.

Fix this by validating the IE buffer in cfg80211_wext_siwgenie()
before storing it.

Reported-by: syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cc867e537e4bd36f69bb
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260725142028.32560-1-kartikey406@gmail.com
[drop unnecessary ie_len check, update commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/wext-sme.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 573b6b15a446e..b5914f3658db4 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -319,6 +319,15 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 		return 0;
 
 	if (ie_len) {
+		const struct element *elem;
+
+		for_each_element(elem, extra, ie_len) {
+			/* nothing */
+		}
+
+		if (!for_each_element_completed(elem, extra, ie_len))
+			return -EINVAL;
+
 		ie = kmemdup(extra, ie_len, GFP_KERNEL);
 		if (!ie)
 			return -ENOMEM;
-- 
2.53.0



