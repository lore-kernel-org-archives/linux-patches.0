Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFBF2BF012;
	Tue, 22 Jul 2025 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193540; cv=none; b=BDra6E4kOOAdo1HEmabiy8HkA4rL1S9Zgg+7OLX7hxSieJi/Vy2bZhPZHTKmUoQKWOro4JRZHzhumdO3wGb14hZfNyiA+LxCeSiNtY1iEB2wxw5qAgQTocf9j0mRJsLQ1HdsVcJ+S/KMdx9Lf7nxEM8wcQhC7o40TEsxRbYrYXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193540; c=relaxed/simple;
	bh=9HyXCdm2hhWzn4wCpSoWGkUQ7E+JDV0Lwkb0lJiTguo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFzmggjZEnxqfLhOdHR0mqker7KQZ8t8d9c7Vcum3qiJ32yDhpIpZEVQOm+I5Wal7MZzu9FuyMzdT3zip7vHqsg7nLsLchuyfmfYUi2crJF8t/sdzTnrQLW4eERNbAJEgnJsWYsu5E285p2MtHJLlEkhHEQvnNdOnRCYeNSJ6P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjmZg1bo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjmZg1bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854B2C4CEEB;
	Tue, 22 Jul 2025 14:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193540;
	bh=9HyXCdm2hhWzn4wCpSoWGkUQ7E+JDV0Lwkb0lJiTguo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjmZg1boV22of8BJh2naXZakxi1+N9OpuJyuWcK4XbNlZTKIFnvk/uLZRyMKsT8ES
	 7E3zMtn5ewB+1s2evMJ2XuOOMPUnyd4a7MTy2cATPeYQvpGJDTPFTIfPwdrCk9YRcG
	 b878dN+EfDsSViZ6OeF2xcCZyOJhxUqnZVR/gH0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e834e757bd9b3d3e1251@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 123/187] wifi: cfg80211: remove scan request n_channels counted_by
Date: Tue, 22 Jul 2025 15:44:53 +0200
Message-ID: <20250722134350.330728253@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 444020f4bf06fb86805ee7e7ceec0375485fd94d ]

This reverts commit e3eac9f32ec0 ("wifi: cfg80211: Annotate struct
cfg80211_scan_request with __counted_by").

This really has been a completely failed experiment. There were
no actual bugs found, and yet at this point we already have four
"fixes" to it, with nothing to show for but code churn, and it
never even made the code any safer.

In all of the cases that ended up getting "fixed", the structure
is also internally inconsistent after the n_channels setting as
the channel list isn't actually filled yet. You cannot scan with
such a structure, that's just wrong. In mac80211, the struct is
also reused multiple times, so initializing it once is no good.

Some previous "fixes" (e.g. one in brcm80211) are also just setting
n_channels before accessing the array, under the assumption that the
code is correct and the array can be accessed, further showing that
the whole thing is just pointless when the allocation count and use
count are not separate.

If we really wanted to fix it, we'd need to separately track the
number of channels allocated and the number of channels currently
used, but given that no bugs were found despite the numerous syzbot
reports, that'd just be a waste of time.

Remove the __counted_by() annotation. We really should also remove
a number of the n_channels settings that are setting up a structure
that's inconsistent, but that can wait.

Reported-by: syzbot+e834e757bd9b3d3e1251@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e834e757bd9b3d3e1251
Fixes: e3eac9f32ec0 ("wifi: cfg80211: Annotate struct cfg80211_scan_request with __counted_by")
Link: https://patch.msgid.link/20250714142130.9b0bbb7e1f07.I09112ccde72d445e11348fc2bef68942cb2ffc94@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index efbd79c67be21..75f2e5782887f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2720,7 +2720,7 @@ struct cfg80211_scan_request {
 	s8 tsf_report_link_id;
 
 	/* keep last */
-	struct ieee80211_channel *channels[] __counted_by(n_channels);
+	struct ieee80211_channel *channels[];
 };
 
 static inline void get_random_mask_addr(u8 *buf, const u8 *addr, const u8 *mask)
-- 
2.39.5



