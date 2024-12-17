Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3891F76C3;
	Tue, 17 Dec 2024 17:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456616; cv=none; b=R02WY11RAqf65bVq4k+2P5jHE4x2fPuYWBupI7h1VTNNbDzHmkDWRGzrkCANyF2v96TwwtfCAafTAGa+dkPrI/yUxk/Kj+vtAX8MEDZn0BhhvfyhDAyo2TSSsoVw7WtR3uT5O4/puzOl/lKvdpvkQU/GoODT53KrYu+mmG0ubiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456616; c=relaxed/simple;
	bh=hV2vwkCqK/5jiJQQP37Nj4byzqrhkuOyLYqzhRLkr3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrF4O+yUCWaUeCKBO3n/71Gcp0WyyXs1wDjniYf8CWC+iuZfxMuGit9ohFD7JaPsva5TREZ6ft2SJ5MPtJNpdoxq99YVozdOZSQzn7clXq95jzFUhBaZic4mCEvIy86mVP1sSMIuIMPHHHpcvo/jhta9QkSfHC22PcTSzxG0SuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCBDp33P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCBDp33P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C02C4CEDD;
	Tue, 17 Dec 2024 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456616;
	bh=hV2vwkCqK/5jiJQQP37Nj4byzqrhkuOyLYqzhRLkr3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCBDp33PGMwF9ZQ65JlqzWYdMrLraaTDrG6S2CEKvCVVoMBqEQWycSrUU2+jwg6zK
	 0p/nbYdstJwr2QC5IBL0c2VdsCw0Wd9AoY1BhVuEexfBEMvOu6tWYg2dMr3ZlHnp+q
	 +i+5kQws9MvTnkkm9r/5iE1DosETSJ1L1aJ1Nik4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyu Li <lihaoyu499@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/172] wifi: mac80211: init cnt before accessing elem in ieee80211_copy_mbssid_beacon
Date: Tue, 17 Dec 2024 18:07:20 +0100
Message-ID: <20241217170549.773340400@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6dfc61a9acd4..242b718b1cd9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1061,13 +1061,13 @@ ieee80211_copy_mbssid_beacon(u8 *pos, struct cfg80211_mbssid_elems *dst,
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



