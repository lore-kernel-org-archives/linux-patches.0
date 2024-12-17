Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8082E1F7574;
	Tue, 17 Dec 2024 17:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456119; cv=none; b=DJbbVduSSn4kfsnmfJUxQAJd7RArIsBMt3aZ8Of5e9+8xo3uY8z4LDHLfiM5D2u4u0dr0wBc539FiInHlAgQWaoyV49FaZP/ZTAIdX6/yKqIxdXr930IxPNBTjDstzzINJ0wOnKlL7iE0wTXqn+7rb+hQ82j7hWTLyTxhvRG1t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456119; c=relaxed/simple;
	bh=pahjZjCAmm1w/xbMN9/imqVi/xzCu4lYUOTMN6Vene4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVprGFj/OQ1BNIpxjgzSPfGt54XEhG9pEBBdJPjMT/dJkpObkcyspklbx9drSmZFDEFrytINCdQAMkGK6pMy2e9vub4g5ndCQRmQUmEfxzMLTj4mL7hjzHIsR2BkTXi1ZA0zfJuT5NIfjBSaLqPuYHN+K7xeaPPUlryB4ge7wH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMkpbWNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMkpbWNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DFAC4CEDF;
	Tue, 17 Dec 2024 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456119;
	bh=pahjZjCAmm1w/xbMN9/imqVi/xzCu4lYUOTMN6Vene4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMkpbWNQeQCvTKGJtUSZRiMfJjuyaU4tH3Hpt+ZYDcd7oFxdDOh77Jlqx15uqByVO
	 oXFgyAhGbrMn3E2mTmVr7hTW+CBp8bOU/ZWsFyjzUCIVf9cYiDgCYbPQCqS5mJR4wf
	 EE2I8/2BLio3OBggq98L8khxg0b9WA9XibGIL7cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyu Li <lihaoyu499@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/109] wifi: mac80211: init cnt before accessing elem in ieee80211_copy_mbssid_beacon
Date: Tue, 17 Dec 2024 18:07:20 +0100
Message-ID: <20241217170534.882691539@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Haoyu Li <lihaoyu499@gmail.com>

[ Upstream commit 496db69fd860570145f7c266b31f3af85fca5b00 ]

With the new __counted_by annocation in cfg80211_mbssid_elems,
the "cnt" struct member must be set before accessing the "elem"
array. Failing to do so will trigger a runtime warning when enabling
CONFIG_UBSAN_BOUNDS and CONFIG_FORTIFY_SOURCE.

Fixes: c14679d7005a ("wifi: cfg80211: Annotate struct cfg80211_mbssid_elems with __counted_by")
Signed-off-by: Haoyu Li <lihaoyu499@gmail.com>
Link: https://patch.msgid.link/20241123172500.311853-1-lihaoyu499@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3da30c991de8..fe4469af3cc9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1082,13 +1082,13 @@ ieee80211_copy_mbssid_beacon(u8 *pos, struct cfg80211_mbssid_elems *dst,
 {
 	int i, offset = 0;
 
+	dst->cnt = src->cnt;
 	for (i = 0; i < src->cnt; i++) {
 		memcpy(pos + offset, src->elem[i].data, src->elem[i].len);
 		dst->elem[i].len = src->elem[i].len;
 		dst->elem[i].data = pos + offset;
 		offset += dst->elem[i].len;
 	}
-	dst->cnt = src->cnt;
 
 	return offset;
 }
-- 
2.39.5



