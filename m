Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1ED375F65;
	Wed, 23 Sep 2026 14:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175369; cv=none; b=TKC6XLDCX4xGVhZTERAEw4/YkNF35B84/psiclUp3+Q5nVA7EA/VFEz4+r3y8/mySkXgeHDzI7YtRUsSCufKgkmBT7mUB6FO0HVGCAk492K0qlc2LfYtrh/LFAUEZv/DcdHF2ohaae8l4wFfOdKjGTiYFxf7t7kSA3/yt5i6vKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175369; c=relaxed/simple;
	bh=B38rMCAIDfDJIMlS4a6bEmvfgHNXKnWxMUrnBNKaBE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lW98VVzN1IOpsvum/MT0Az+TrDB0BX4WxLemSeqWOnLkMPPct5ydc80Gf9+knY81xAcrPHYk4NB5I/ZNzuwVmTd1+5L+CiuWaTPP7PO39YvgRt7zOKyyY9OFFdKS+w6vGeovNJrtymWE3hHr78QCdGNDe2Rd+0SzLcmsHdodXE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUA8ICX2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUA8ICX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560251F000FF;
	Wed, 23 Sep 2026 14:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175367;
	bh=tZ5OmI+q+/9X4Xsat9XkXU7hxsMVKVNcEaYh9umj0o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qUA8ICX2VHGuIPMTe8bfwuDcIo/zbGWzsnTkAlx5Sn5EZS69xcCYjBDDOAQ1BgzvO
	 rGS5MsZB6Hr7yNOTl6QZt+GDMbCZ3yTISAJXxtyT7QTBObroj/eHgTtYTin+emNSS7
	 6RIgWLJ45qqSxcRxZ6Ba7q3EyfIERA4/RAFMCbys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bc1aabf52d0a31e91f96@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 394/398] wifi: mac80211: fix list iteration in ieee80211_add_virtual_monitor()
Date: Wed, 23 Sep 2026 16:07:48 +0200
Message-ID: <20260923140653.684871452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

commit cbf0dc37bb4e949f1c76566657e71f8e0bdcf338 upstream.

Since 'mon_list' of 'struct ieee80211_local' is RCU-protected and
an instances of 'struct ieee80211_sub_if_data' are linked there
via 'u.mntr.list' member, adjust the corresponding list iteration
in 'ieee80211_add_virtual_monitor()' accordingly.

Reported-by: syzbot+bc1aabf52d0a31e91f96@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bc1aabf52d0a31e91f96
Fixes: a5aa46f1ac4f ("wifi: mac80211: track MU-MIMO configuration on disabled interfaces")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20251204130533.340069-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/iface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1290,7 +1290,7 @@ configure_monitor:
 	if (!creator_sdata) {
 		struct ieee80211_sub_if_data *other;
 
-		list_for_each_entry(other, &local->mon_list, list) {
+		list_for_each_entry_rcu(other, &local->mon_list, u.mntr.list) {
 			if (!other->vif.bss_conf.mu_mimo_owner)
 				continue;
 


