Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38114DA9B0;
	Thu, 17 Sep 2026 18:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668515; cv=none; b=K3M6NTIGzbzbS+9nyfo25MtjUQJInKAkeugPc8fd+i9POHxAlemMFXlK4P3usbigpH2x1kIKFMwzRt1StMiIRhAmQGz6qD0yjzdQVgDhOLbBiweZRR4rrKEN/KsAcjhkm1Ch062GFRDqUl0tBzB5zBgNx4w1HnKDHyKy/NQRo8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668515; c=relaxed/simple;
	bh=JYL83tXU0hcPbGEQhCNVljLjbBlSn1BHFT5lpNTbnWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQQ/8xt0/tPXYBkdM8z5/qNek/A0mPGiQKW6IbFkd/3ay2fHaW0k8aGSA5ZKU7BR+935aWWryEiem0GwAYYNUyzn71UJDHI2KvDwz3J8AVQNRCsNizURHQwVEzZMyZqX3QaeJThrPPCcf6/Pn7OhvZ2zV/xqcQEsicRb1ajRysk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwqKDpLR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwqKDpLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109ED1F000FF;
	Thu, 17 Sep 2026 18:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668513;
	bh=sE4HFJjDMoPcUyRc4TxY5KUIuChBvtA94KOQcoVWbg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UwqKDpLRESf2av0GJT2+IJaAAUzywAzgm8PfhdZOfr0QJKipfCqiBTaj254VJf/Zn
	 5PcL3JE/fB1jweiHJun3my+BYBIUdruGw5Uidln08z0ceQS5ARiYmTDW6zCj9zxw8v
	 NSH1WISzanu/9JInTxQU3vaqPXKRpOza+/CwJCkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0448/1102] wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()
Date: Thu, 17 Sep 2026 16:06:31 +0100
Message-ID: <20260917151550.929813279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



