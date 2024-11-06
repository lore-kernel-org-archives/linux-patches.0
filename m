Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CDF1F471A;
	Wed,  6 Nov 2024 12:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897560; cv=none; b=NcEZP5JWPspyUCKh7ygZ04cR67xsCwKsyX1Jk/h0sk2j/SGfmcRoZSWXDmrpfsvSN5v742qQCxtBAIiUY9JmHD/TLPgc78S4iUYlStiXDp2dGpoBrOV3sKVTl3TTj0q/DcAl2RW/7zwOuL1x5YOhBxe0dU0pTqT1a8SzM3BJv88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897560; c=relaxed/simple;
	bh=jM3hfE614SpSjiNFtOxb7h6wHRjUdzw/FL4MJsj4qhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjzppTMEuneBIw5guMPLDP7lcr96DUgqZ5PM5S9Dt9hWwqp8m4c+2jBG+OHs1ZcPuTXD3sfQUsjon0BItMQbX2Ecj5OdL27umkUrhW8VGhMi3mjpjVkWecXzHfKaT+vrA0+QCzDad6NoP9xKa+OhU8SvL41eLBeDnK8jHXl22jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6mfT3n0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6mfT3n0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79811C4CECD;
	Wed,  6 Nov 2024 12:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897559;
	bh=jM3hfE614SpSjiNFtOxb7h6wHRjUdzw/FL4MJsj4qhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6mfT3n0A2p5LcJBUkmZdU4qSuJRZSzUaHMbgd/8P6IqVaB/OyKotUXGaDlDWd1lQ
	 xhTMMmNs8nJeu+LXn7cuJvUh/Bu8ZM9CXLBqvADyg/EXe+GKosc6IC3mTNrU5XyACQ
	 Hn4MC+BKqTEsefsN5HBD8xMR5UA2y+qxL7UOcov4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+36218cddfd84b5cc263e@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 094/151] wifi: cfg80211: clear wdev->cqm_config pointer on free
Date: Wed,  6 Nov 2024 13:04:42 +0100
Message-ID: <20241106120311.459512862@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit d5fee261dfd9e17b08b1df8471ac5d5736070917 upstream.

When we free wdev->cqm_config when unregistering, we also
need to clear out the pointer since the same wdev/netdev
may get re-registered in another network namespace, then
destroyed later, running this code again, which results in
a double-free.

Reported-by: syzbot+36218cddfd84b5cc263e@syzkaller.appspotmail.com
Fixes: 37c20b2effe9 ("wifi: cfg80211: fix cqm_config access race")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20241022161742.7c34b2037726.I121b9cdb7eb180802eafc90b493522950d57ee18@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1233,6 +1233,7 @@ static void _cfg80211_unregister_wdev(st
 	/* deleted from the list, so can't be found from nl80211 any more */
 	cqm_config = rcu_access_pointer(wdev->cqm_config);
 	kfree_rcu(cqm_config, rcu_head);
+	RCU_INIT_POINTER(wdev->cqm_config, NULL);
 
 	/*
 	 * Ensure that all events have been processed and


