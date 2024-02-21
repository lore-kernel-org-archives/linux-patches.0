Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA4678B7C;
	Wed, 21 Feb 2024 13:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522895; cv=none; b=IW4ZhoSjKg22kgHjbACLH6OWzVdqj2bYCUX2URkkyyvryBARVICpEQnTCTY8ZiuiYiNJlwJmsdsMa2jamqUwEa47n57ov/rgJ6Ec99Em8WLK5/lY5Y5Pc9/TsYIyEWjIGMXsPX+8hejdW1iMdpxBclC+WfSWhjxAi1R3HPlMGGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522895; c=relaxed/simple;
	bh=Op92VbqnCGfwMlHiNWzGhM5/NYNV3vEYN1EfrAsKh7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLUlHglL8KnCcn57ogj4orY/ji2I0BXz8HCHBwE1WQC861eGZnYflAzR7zpj0PvC9XvwU6XXNCmR/AQsJwyDzcpD7sxtQen0cdYIcKHmxMlnTghc4H3ivRerH+gLTcp3DEn4kM0Xh7vb8uuHHAN6WWMkMKOFJFc6i0AY7P9GVHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vN6zWBcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vN6zWBcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46728C433F1;
	Wed, 21 Feb 2024 13:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522894;
	bh=Op92VbqnCGfwMlHiNWzGhM5/NYNV3vEYN1EfrAsKh7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vN6zWBcKNfwWbM1n7yn6LSemwzfvFpwONWNYDM2CrT0/Jg7RuY40FLMsIWe/ZFytF
	 epj7LLkHHw0dXy9N0Q8RB+YtoFdjOXLMyHza++9p0qW+NeP5sL8C5aBv/1wAIwQo5g
	 ZWJErUOFUeMMRAAaYYYQjFo/f48+tWk/blKYLIV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+864a269c27ee06b58374@syzkaller.appspotmail.com
Subject: [PATCH 5.15 268/476] wifi: cfg80211: fix RCU dereference in __cfg80211_bss_update
Date: Wed, 21 Feb 2024 14:05:19 +0100
Message-ID: <20240221130017.754547685@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 68c48970ebf7..2898df10a72a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1809,7 +1809,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 					 &hidden->hidden_list);
 				hidden->refcount++;
 
-				ies = (void *)rcu_dereference(new->pub.beacon_ies);
+				ies = (void *)rcu_access_pointer(new->pub.beacon_ies);
 				rcu_assign_pointer(new->pub.beacon_ies,
 						   hidden->pub.beacon_ies);
 				if (ies)
-- 
2.43.0



