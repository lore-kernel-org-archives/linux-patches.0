Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D5F516140;
	Wed, 30 Sep 2026 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784813; cv=none; b=oQBNcyrEp/FGWLATfOClLRkhmJpfoO4r5R7IXIax1P2mbeOI/oEJTrwQApjGRlBwfWQuOlOc/mU9zZ3kiycsM4QCGvhWfsukAqXu8K514wkXwJcmP0cyfWg6VClxbJTsx/SSViqrBLSWp1eDB3iKBChBdsPR0HnUZA/Cg2vx5dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784813; c=relaxed/simple;
	bh=lJ6CTpvd6rbHlZ+q8IjXDjeXeAlHbfmS4g1N7EF+Kqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruk45P/R8vOvY8HXWL6iGCgUZ8SRnQgom7kzqIgbj7XRqYwDs9u3bNlA3Qe/kv14/AbvzmW7PbtWpaxFG+lvb8agJdTzk1zOyk2H9CPxektJWRgJzEdF2aI7DElcR4HnwSRNZWLh4gZJFgK7xj1QYu8OhXIPX34+9zpXhSrULXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqmlCwF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqmlCwF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0653B1F000FF;
	Wed, 30 Sep 2026 16:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784810;
	bh=ltu1ESo+ytQplV/7F2oPLuRhrBmHiOrVutx2i9wWKwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqmlCwF8wKRBtreJF8IUjMcMDTCzIoAAoII666Jk+pOfhaZKEdfVoGF5BjSwOFOje
	 dCaY7X5gLZaSNX6NEQdEXEzhkVF/UUwuo62j6oWL8yLjDxWei6thJNS6lB4UWn1BwJ
	 geLL97XDRJpDjbEpWhnM45GuxXUB10Nbl7bUb/UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 286/982] wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()
Date: Wed, 30 Sep 2026 17:17:02 +0200
Message-ID: <20260930152422.944712703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 68f45afc352de..be121fa36c514 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -346,6 +346,15 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
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



