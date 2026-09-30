Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F28B3264C2;
	Wed, 30 Sep 2026 18:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791262; cv=none; b=lrfu06qpMTsCUrruoT6Tk6zg8nsOHYu+5pqoi/SpYftFGE4niwqo7242oZNc5ypPXw5I0Hr0pvBX2MHpYVH1A60t/pCT0WDr17Qk7mgUOkGx9dUb9RL7chplenM/2maAxMyYNnYCFSrZkxX+GoR+C3faFUefsELQDYphTMZs748=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791262; c=relaxed/simple;
	bh=EhinVo+6a11/i0VYtaSoNZM2Ogm2IpwC4e3eA1urQoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSWNgJt80kFKVaVO/eHQkOQ55tE8XrwwT52FNWW0FI3RaQdZlI/xSqLDKp3Jvs/IxaLRPdwcsPPB0RCVN1JXnSztPFRRsHqaYgZOlChKA1wG04Kf87LG45PGJkrmffEaZBhkolve8NuapNfh7PtRRnA86QeeUnstsLSl3C5oLcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiYaIqQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiYaIqQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C461F00898;
	Wed, 30 Sep 2026 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791261;
	bh=vls9V+eHlpq9/rPPTeb4BDgzI1nb3M3NbRkdX37qeWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tiYaIqQkkEQ3tFaD5XlDrOosQ7P95i1lPclogpm4nosbUPX+0Q29gngdwgxeyY6e9
	 cXvyqoXuKl+S6c5yV9+2iO8vg4X+b6CiwuNPZ2DF7X03GLuasXFd7ZieJuC7jt2cih
	 8SF7GZLdCNsNLNdyeYCgSiB3oYAofY8JUHa2FR0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 223/752] wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()
Date: Wed, 30 Sep 2026 17:21:33 +0200
Message-ID: <20260930152403.080560860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 193a18a531423..1919290d1208d 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -333,6 +333,15 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
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



