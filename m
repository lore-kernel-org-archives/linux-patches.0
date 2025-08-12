Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A28C3F9D2;
	Tue, 12 Aug 2025 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022339; cv=none; b=QsLZEBTQYvxjQhXPej9RO6mQHAiwMQXO2V6ypORdz5R8jyi85U4DZ448H7Cl7GUVdURwtLKNMXj0TQB1oSy5y4AIIdYSYG6Fry/K4O6Ls3NjJBfwNQ4U5B/2EwbyQSI93T3oxtbutLNi7O0t24uILb1wjzMh4wAgIebP/+KOwm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022339; c=relaxed/simple;
	bh=a9xPuAXRrM38jt4+YR+FwsmBuVUeXTlZIGjJz1QcJho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXeO/glxeyqjn7j8yPMpYJSFqq5iAauDEY5SPyH5CY9vfLDQyeb+Xg+pWkn8BaeHvNqrROGK6s+JBzLUBTOei2sMy8szvHlOQhEFK6AD7nzuCe+jH5KWdNAjmfrKFDsMekOYlZdQj4eyeEPpItshzlF5eEe1PQ0d54tO9gYS97Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lty3mfo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lty3mfo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B5DC4CEF0;
	Tue, 12 Aug 2025 18:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022339;
	bh=a9xPuAXRrM38jt4+YR+FwsmBuVUeXTlZIGjJz1QcJho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lty3mfo0oMZSzIH9HYBwPnn0fKF1Oh54Qg9gGQYV2HVCE7HcxcI0tqoVL1cXJDXIx
	 qxoNwWzK4DRjP8cswejvaKG5nxMY5Px40a+yd2YwiBCSRtKF/EqT4YGwLcVDa3Fr5w
	 5qkEwnZfyFxbh0vZKPd71BBbzFTl22OhHkPnfHX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/369] wifi: mac80211: Write cnt before copying in ieee80211_copy_rnr_beacon()
Date: Tue, 12 Aug 2025 19:27:03 +0200
Message-ID: <20250812173019.512151398@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit a37192c432adaec9e8ef29e4ddb319ea2f443aa6 ]

While I caught the need for setting cnt early in nl80211_parse_rnr_elems()
in the original annotation of struct cfg80211_rnr_elems with __counted_by,
I missed a similar pattern in ieee80211_copy_rnr_beacon(). Fix this by
moving the cnt assignment to before the loop.

Fixes: 7b6d7087031b ("wifi: cfg80211: Annotate struct cfg80211_rnr_elems with __counted_by")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://patch.msgid.link/20250721182521.work.540-kees@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index cf2b8a05c338..a72c1d9edb4a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1078,13 +1078,13 @@ ieee80211_copy_rnr_beacon(u8 *pos, struct cfg80211_rnr_elems *dst,
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



