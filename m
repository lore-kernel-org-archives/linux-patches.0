Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E899A29D291;
	Tue, 26 Aug 2025 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215250; cv=none; b=ZNpiXSiillA2PcGfL5TdLeFThzmiNGQ0vJCdfQfxof5LVmh8im2y6/tnfdCCMK5PcLRcV0ejOXfWJhiX6OZWA4RnrluzEOfdZVhl/l+D5IkTCG6bn0Y9fxY2uBNvWH0cCvRiBZI0WS9mlQwhODUauMa+0T3ulIl/T7EnRRSsVIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215250; c=relaxed/simple;
	bh=HY/MEyc+3amWoQA+w6i6n9FvUY0AMBsMZO8qOECz5ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cdm6TaaGk4kGJOZiIXg5KiEN9SpRCNa/WdS9speexPWneyr6fO709qGgedpBafmT1bTU39PMHUyIPtLEOX3UGjg4mK7N96PHF7Dt1+o9TnoRPraPQthsZyJcjWDTGZP8ZBC8b7Mv8o9jikjgzJ8g3ilVfQtfVODjcKsA9cqGjNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=de4L9MVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="de4L9MVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72007C113CF;
	Tue, 26 Aug 2025 13:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215249;
	bh=HY/MEyc+3amWoQA+w6i6n9FvUY0AMBsMZO8qOECz5ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=de4L9MVxVQhuq/Un7YyxI/p7+9ktpkxxMDucYs8ow6xEDZRQDbn12HcTVO0KAAjy+
	 wTtRiNYMZ3BSMru3+rcnpPgq8O2SaWanQ43rPil5KoCIbJS2plA+5mgecqAOMpxZQ2
	 XLVXDkH+fFQoCDqq8eKE7Dh2N9tyGWxUJRfvPWkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?Hanne-Lotta=20M=C3=A4enp=C3=A4=C3=A4?= <hannelotta@gmail.com>
Subject: [PATCH 6.1 443/482] wifi: mac80211: avoid lockdep checking when removing deflink
Date: Tue, 26 Aug 2025 13:11:36 +0200
Message-ID: <20250826110941.775302740@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

commit b8b80770b26c4591f20f1cde3328e5f1489c4488 upstream.

struct sta_info may be removed without holding sta_mtx if it has not
yet been inserted. To support this, only assert that the lock is held
for links other than the deflink.

This fixes lockdep issues that may be triggered in error cases.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230619161906.cdd81377dea0.If5a6734b4b85608a2275a09b4f99b5564d82997f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Hanne-Lotta Mäenpää <hannelotta@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/sta_info.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -357,8 +357,9 @@ static void sta_remove_link(struct sta_i
 	struct sta_link_alloc *alloc = NULL;
 	struct link_sta_info *link_sta;
 
-	link_sta = rcu_dereference_protected(sta->link[link_id],
-					     lockdep_is_held(&sta->local->sta_mtx));
+	link_sta = rcu_access_pointer(sta->link[link_id]);
+	if (link_sta != &sta->deflink)
+		lockdep_assert_held(&sta->local->sta_mtx);
 
 	if (WARN_ON(!link_sta))
 		return;


