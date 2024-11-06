Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837DB1E0B62;
	Wed,  6 Nov 2024 12:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897203; cv=none; b=qM7WOeg+nq+DIUTuTbff/rSuTh5Gf68xYd0Kv2QyD6+HbLxB5M8LZsXbmvRXhwNcwGzn1KM2WlEryD0N3mNy6mEgBfQBlJYAA8n+W8tvkhAxoxY/b0w79ND643+hlqnkXHXiffO7WipwasAq01HIlSLaTdOplnDOx2lIgHkuyu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897203; c=relaxed/simple;
	bh=iFGmRQX3shr0BiZVMOHwZlH5HsR4dgClNwSjQvuxo4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbYWh6n9tMz1VDsg2HH2fmcGdhgP7W9KnjgacqekXASG+2fTMj17Tw7XQ3DIxV6oM1B2cqbMB2Gt/xUQzx1ItZDsjrWZ3yCmuUI0x+T9XUaudFienwMfbJep8MKBznpBLJSEt7I7Ww/ttdqdDP7UQu7BlAltjgt5aYXDGV+R7d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bivsKakg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bivsKakg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA670C4CECD;
	Wed,  6 Nov 2024 12:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897203;
	bh=iFGmRQX3shr0BiZVMOHwZlH5HsR4dgClNwSjQvuxo4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bivsKakg356D9pVjm8R85T9+/Z/+nCrDiX4Dz4jXv2X/f1ApGbOF40Cywro8GXCUx
	 UqNPcS/bIYgsulKcUSVBt74J4rIGcaz0CuHuprxjvOxUfKgqIzFLU9tqwNwTAxln7N
	 Ifxf36uFVhl5lqUFHq4PNPa8MqWez2FiUfUldMNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+36218cddfd84b5cc263e@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 074/126] wifi: cfg80211: clear wdev->cqm_config pointer on free
Date: Wed,  6 Nov 2024 13:04:35 +0100
Message-ID: <20241106120308.089856396@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1230,6 +1230,7 @@ static void _cfg80211_unregister_wdev(st
 	/* deleted from the list, so can't be found from nl80211 any more */
 	cqm_config = rcu_access_pointer(wdev->cqm_config);
 	kfree_rcu(cqm_config, rcu_head);
+	RCU_INIT_POINTER(wdev->cqm_config, NULL);
 
 	/*
 	 * Ensure that all events have been processed and


