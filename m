Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26522125BF;
	Sat,  3 Feb 2024 04:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933449; cv=none; b=aHo08OEvQVkeALNKQz/+03Rc4l1nFI8NGtd6GoFvnpfSXtYNKonzrimc3VX+6bxtqcWWWyuw+Z/u92xzG2N1pyp9P5XiYwMksIEfc5vlA5VA0EL7aqacr6eOtj8iqsgfkuf8BieJcv8jL+AzHolZc+ilGLmxxsMJJEwU0NcMojU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933449; c=relaxed/simple;
	bh=Y0t1V8lEuIsfagdOUQFQLrKaqurw5L1XjKpYgcqsPlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQ+o6gXc2o0N55Hek3xDNHuEcSa+qaLiEoEZryJJef2N9p+GZrdVW1XHv0VgnUzk9q1Uj+CotRSkflug0ZIXiBgRANMrmlC4CHeq2X4OwuWtApAhCH6Jk6Rgkl37VY2BE102mpHHIQ5O7c/xt4NnB+rnfmvUxMeBeB4fpHFnx3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/ozOQ/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/ozOQ/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A3BC433B1;
	Sat,  3 Feb 2024 04:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933449;
	bh=Y0t1V8lEuIsfagdOUQFQLrKaqurw5L1XjKpYgcqsPlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/ozOQ/6m92N2q9nAmgNwEj/g8VuF/P9xrsh5ok0OQlhpb5Hh8EoK77ZcrKCe7GkV
	 fbUajPLl7zw0JbJ/NqQIC9p8z68vh5Nkl+IclhcjjCKr/TOkVaKdwIQqPXNRuQr9wx
	 7yDn4axwWyIt6WzmV6sDZGE/gQwoXWfG3Sqg1680=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+864a269c27ee06b58374@syzkaller.appspotmail.com
Subject: [PATCH 6.1 183/219] wifi: cfg80211: fix RCU dereference in __cfg80211_bss_update
Date: Fri,  2 Feb 2024 20:05:56 -0800
Message-ID: <20240203035342.417766713@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 1184950e341c11b6f82bc5b59564411d9537ab27 ]

Replace rcu_dereference() with rcu_access_pointer() since we hold
the lock here (and aren't in an RCU critical section).

Fixes: 32af9a9e1069 ("wifi: cfg80211: free beacon_ies when overridden from hidden BSS")
Reported-and-tested-by: syzbot+864a269c27ee06b58374@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://msgid.link/tencent_BF8F0DF0258C8DBF124CDDE4DD8D992DCF07@qq.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 86906557a04e..3ad4c1032c03 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1811,7 +1811,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 					 &hidden->hidden_list);
 				hidden->refcount++;
 
-				ies = (void *)rcu_dereference(new->pub.beacon_ies);
+				ies = (void *)rcu_access_pointer(new->pub.beacon_ies);
 				rcu_assign_pointer(new->pub.beacon_ies,
 						   hidden->pub.beacon_ies);
 				if (ies)
-- 
2.43.0



