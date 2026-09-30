Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EB02AEEB;
	Wed, 30 Sep 2026 18:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794786; cv=none; b=QDdbIX2PQaZOeSVZ4d94Oea3/nQW7IYtAjHFRqWx7HnVCGzvZinm62yJX9lONIQUh7X3I8BQPB3sgQLZghz322WEgiY9Gl36rAVPez0C7GzdIFFN2HttO+ZTf06rpLcK+HkbK2wsVrdwDQpigOGgCvjLpJ0FbNLF9ChVSu7H/fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794786; c=relaxed/simple;
	bh=4a/X0Bt6ntIHMjl97ca8HYgtrtq1+E7MqzHnXR04bJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwsGdNzLEx7a8Da2u47U/HCULqk4qB/uhhBn0bOo4HajWHnWtAX93I4qu0ws7/ogXptO9bXCQK64QW+uFqFeiH6dh6uEs1mwi8MH1HDgz1WrEzsRfxNSagHV/LTNYYSCcifis8BQsGTDusBdBm0wwjFFCl0r5eJwgv9vAebtp1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+4Hr9Zx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+4Hr9Zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846041F000FF;
	Wed, 30 Sep 2026 18:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794785;
	bh=oqLII+LcRDveKspSrguW2kiuHTT07nTZm5DuEEBaJQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+4Hr9ZxRhWW77/gmw2jIFexr3wsA+aMJeEf8dkOEpPs7n/85YjlJurArCjLTyx8f
	 37IwScGO/tNM80ygCuFzmv1/sXSwHcjQrzsPjdN88hxoHneskWHysMi1K9PNDvVsDP
	 2rhIJ4NdssUq0dCqxhBk7JcgYFUzt3BnDpyQ8nYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0334/1193] wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()
Date: Wed, 30 Sep 2026 17:16:58 +0200
Message-ID: <20260930152441.573733827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index f3eaa3388694a..cfa903eb0e82f 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -348,6 +348,15 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 		goto out;
 
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
 		if (!ie) {
 			err = -ENOMEM;
-- 
2.53.0



