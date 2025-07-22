Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BAC2D130C;
	Tue, 22 Jul 2025 13:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192565; cv=none; b=jJJkNZvbmXafYO7bR4AlPOSP6tjN+7zx9e2Fx37uHwgZpzZS8Yi7g0vql1Jqm1j0Ht07WKE9YYJyVBPLAJWvtiY9qAIIwttml23bazDNhoUm69p/bz6Kuu7UT1ZKzKavyViakBIk3U58sBMmYmib1aCtHmKFK8YJbx8gv/hiaW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192565; c=relaxed/simple;
	bh=PyUd33XSp86hgqj4bMlXgGthcL7qLLIiARBXjy13SrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dn9Cpn394IPbSqz+1sJnTOmEKbB4W6PbLCdtPQFTCm6pZNRJgskn5X/1upm7/3G6onT0w/FFrrWTO/q7P3oA5fsN7trUswGk+YNt+Pln2PFRJa7PyWZh2YcQdq0tz39aM4EdHjt01zpUJfi4O6VVlh89zsGRgri2APaqN0T04K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4eY8id7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4eY8id7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7286C4CEEB;
	Tue, 22 Jul 2025 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192564;
	bh=PyUd33XSp86hgqj4bMlXgGthcL7qLLIiARBXjy13SrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4eY8id7shMhiwuy7RhdHc69PhWFq88BNH3SXKFD6rlAIHjPBG6pynj/hJLaH/n2l
	 HPc9iX5bwDX74JBXtpJaa2CfBSDeHO6xktfe9UvkttxryVLMGD8tmL6uJSBkSNSsc+
	 /a6B+MUpwvuOlLJEer0nQqcZ9KwvXYl0ytkpFkyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e834e757bd9b3d3e1251@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/111] wifi: cfg80211: remove scan request n_channels counted_by
Date: Tue, 22 Jul 2025 15:44:46 +0200
Message-ID: <20250722134336.036965705@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 802ea3080d0b3..2fb3151ea7c9e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2543,7 +2543,7 @@ struct cfg80211_scan_request {
 	struct cfg80211_scan_6ghz_params *scan_6ghz_params;
 
 	/* keep last */
-	struct ieee80211_channel *channels[] __counted_by(n_channels);
+	struct ieee80211_channel *channels[];
 };
 
 static inline void get_random_mask_addr(u8 *buf, const u8 *addr, const u8 *mask)
-- 
2.39.5



